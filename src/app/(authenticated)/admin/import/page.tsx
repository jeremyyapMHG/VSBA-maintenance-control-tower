"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { useAuth } from "@/lib/auth/provider";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Upload, FileText, AlertCircle, CheckCircle2, X } from "lucide-react";
import type { LifecycleStage } from "@/lib/types/database";

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

const VALID_LIFECYCLE_STAGES: LifecycleStage[] = [
  "design",
  "construction",
  "admin_closeout",
  "dlp",
  "final_closure",
];

interface CsvRow {
  rowIndex: number;
  school_name: string;
  region_name: string;
  address: string;
  ramp_name: string;
  ramp_description: string;
  lifecycle_stage: string;
  budget: string;
  actual: string;
  forecast: string;
}

interface ParsedRow extends CsvRow {
  errors: string[];
  isValid: boolean;
}

interface ImportSummary {
  schoolsCreated: number;
  rampsCreated: number;
  errors: number;
}

// ---------------------------------------------------------------------------
// CSV Parser — handles quoted fields
// ---------------------------------------------------------------------------

function parseCSVLine(line: string): string[] {
  const fields: string[] = [];
  let current = "";
  let inQuotes = false;

  for (let i = 0; i < line.length; i++) {
    const ch = line[i];
    if (ch === '"') {
      if (inQuotes && line[i + 1] === '"') {
        current += '"';
        i++;
      } else {
        inQuotes = !inQuotes;
      }
    } else if (ch === "," && !inQuotes) {
      fields.push(current.trim());
      current = "";
    } else {
      current += ch;
    }
  }
  fields.push(current.trim());
  return fields;
}

function parseCSV(text: string): CsvRow[] {
  const lines = text
    .split(/\r?\n/)
    .map((l) => l.trim())
    .filter((l) => l.length > 0);

  if (lines.length < 2) return [];

  // Skip header row
  const rows: CsvRow[] = [];
  for (let i = 1; i < lines.length; i++) {
    const fields = parseCSVLine(lines[i]);
    rows.push({
      rowIndex: i + 1, // 1-based, accounting for header
      school_name: fields[0] ?? "",
      region_name: fields[1] ?? "",
      address: fields[2] ?? "",
      ramp_name: fields[3] ?? "",
      ramp_description: fields[4] ?? "",
      lifecycle_stage: fields[5] ?? "",
      budget: fields[6] ?? "",
      actual: fields[7] ?? "",
      forecast: fields[8] ?? "",
    });
  }
  return rows;
}

// ---------------------------------------------------------------------------
// Validation
// ---------------------------------------------------------------------------

function validateRow(row: CsvRow): ParsedRow {
  const errors: string[] = [];

  if (!row.school_name) errors.push("school_name is required");
  if (!row.region_name) errors.push("region_name is required");
  if (!row.ramp_name) errors.push("ramp_name is required");

  if (
    row.lifecycle_stage &&
    !VALID_LIFECYCLE_STAGES.includes(row.lifecycle_stage as LifecycleStage)
  ) {
    errors.push(
      `lifecycle_stage must be one of: ${VALID_LIFECYCLE_STAGES.join(", ")}`
    );
  }

  if (row.budget && isNaN(parseFloat(row.budget))) {
    errors.push("budget must be a number");
  }
  if (row.actual && isNaN(parseFloat(row.actual))) {
    errors.push("actual must be a number");
  }
  if (row.forecast && isNaN(parseFloat(row.forecast))) {
    errors.push("forecast must be a number");
  }

  return { ...row, errors, isValid: errors.length === 0 };
}

// ---------------------------------------------------------------------------
// Component
// ---------------------------------------------------------------------------

export default function AdminImportPage() {
  const { profile } = useAuth();
  const router = useRouter();
  const supabase = createClient();

  const [isDragOver, setIsDragOver] = useState(false);
  const [fileName, setFileName] = useState<string | null>(null);
  const [parsedRows, setParsedRows] = useState<ParsedRow[]>([]);
  const [importing, setImporting] = useState(false);
  const [summary, setSummary] = useState<ImportSummary | null>(null);
  const [importErrors, setImportErrors] = useState<string[]>([]);
  const fileInputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    if (profile && profile.role !== "admin") {
      router.push("/");
    }
  }, [profile, router]);

  const handleFile = useCallback((file: File) => {
    if (!file.name.endsWith(".csv")) {
      alert("Please upload a .csv file");
      return;
    }
    setFileName(file.name);
    setSummary(null);
    setImportErrors([]);

    const reader = new FileReader();
    reader.onload = (e) => {
      const text = e.target?.result as string;
      const rawRows = parseCSV(text);
      const validated = rawRows.map(validateRow);
      setParsedRows(validated);
    };
    reader.readAsText(file);
  }, []);

  const handleDrop = useCallback(
    (e: React.DragEvent<HTMLDivElement>) => {
      e.preventDefault();
      setIsDragOver(false);
      const file = e.dataTransfer.files[0];
      if (file) handleFile(file);
    },
    [handleFile]
  );

  const handleFileInput = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) handleFile(file);
  };

  const clearFile = () => {
    setFileName(null);
    setParsedRows([]);
    setSummary(null);
    setImportErrors([]);
    if (fileInputRef.current) fileInputRef.current.value = "";
  };

  const validRows = parsedRows.filter((r) => r.isValid);
  const invalidRows = parsedRows.filter((r) => !r.isValid);

  const handleImport = async () => {
    if (validRows.length === 0) return;
    setImporting(true);
    setSummary(null);
    setImportErrors([]);

    const errors: string[] = [];
    let schoolsCreated = 0;
    let rampsCreated = 0;

    // Fetch all regions once
    const { data: regions, error: regionsError } = await supabase
      .from("regions")
      .select("id, name");

    if (regionsError || !regions) {
      setImportErrors(["Failed to fetch regions: " + regionsError?.message]);
      setImporting(false);
      return;
    }

    const regionMap = new Map(regions.map((r) => [r.name.toLowerCase(), r.id]));

    // Fetch RAMPS program
    const { data: programs } = await supabase
      .from("programs")
      .select("id, name")
      .eq("name", "RAMPS Program")
      .single();

    const programId = programs?.id ?? null;

    // Group rows by school_name
    const schoolGroups = new Map<string, ParsedRow[]>();
    for (const row of validRows) {
      const key = row.school_name.trim();
      if (!schoolGroups.has(key)) schoolGroups.set(key, []);
      schoolGroups.get(key)!.push(row);
    }

    for (const [schoolName, rows] of schoolGroups.entries()) {
      const firstRow = rows[0];
      const regionId = regionMap.get(firstRow.region_name.trim().toLowerCase());

      if (!regionId) {
        errors.push(
          `Row ${firstRow.rowIndex}: Region "${firstRow.region_name}" not found`
        );
        continue;
      }

      // Upsert school
      const { data: school, error: schoolError } = await supabase
        .from("schools")
        .upsert(
          {
            name: schoolName,
            region_id: regionId,
            program_id: programId,
            address: firstRow.address || null,
            status: "active",
          },
          { onConflict: "name" }
        )
        .select("id")
        .single();

      if (schoolError || !school) {
        errors.push(
          `Failed to upsert school "${schoolName}": ${schoolError?.message}`
        );
        continue;
      }

      schoolsCreated++;

      // Insert ramps for this school
      for (const row of rows) {
        const { error: rampError } = await supabase.from("ramps").insert({
          school_id: school.id,
          name: row.ramp_name.trim(),
          description: row.ramp_description || null,
          lifecycle_stage: (row.lifecycle_stage ||
            "design") as LifecycleStage,
          status: "active",
          budget_amount: row.budget ? parseFloat(row.budget) : 0,
          actual_amount: row.actual ? parseFloat(row.actual) : 0,
          forecast_amount: row.forecast ? parseFloat(row.forecast) : 0,
        });

        if (rampError) {
          errors.push(
            `Row ${row.rowIndex}: Failed to insert ramp "${row.ramp_name}": ${rampError.message}`
          );
        } else {
          rampsCreated++;
        }
      }
    }

    setSummary({ schoolsCreated, rampsCreated, errors: errors.length });
    setImportErrors(errors);
    setImporting(false);
  };

  if (profile?.role !== "admin") return null;

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold text-vsba-charcoal">CSV Import</h2>
        <p className="mt-1 text-muted-foreground">
          Bulk import schools and RAMPS from a CSV file.
        </p>
      </div>

      {/* Format reference */}
      <Card>
        <CardHeader>
          <CardTitle className="text-base">Expected CSV Format</CardTitle>
          <CardDescription>
            Column order must match exactly. Headers are required.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <code className="block rounded bg-muted p-3 text-xs text-muted-foreground">
            school_name, region_name, address, ramp_name, ramp_description,
            lifecycle_stage, budget, actual, forecast
          </code>
          <p className="mt-2 text-xs text-muted-foreground">
            Valid lifecycle_stage values:{" "}
            <span className="font-mono">
              {VALID_LIFECYCLE_STAGES.join(" | ")}
            </span>
          </p>
          <p className="mt-1 text-xs text-muted-foreground">
            region_name must exactly match one of: North-Eastern Victoria,
            North-Western Victoria, South-Eastern Victoria, South-Western
            Victoria
          </p>
        </CardContent>
      </Card>

      {/* Drop zone */}
      <Card>
        <CardHeader>
          <CardTitle className="text-base">Upload CSV File</CardTitle>
        </CardHeader>
        <CardContent>
          {!fileName ? (
            <div
              onDragOver={(e) => {
                e.preventDefault();
                setIsDragOver(true);
              }}
              onDragLeave={() => setIsDragOver(false)}
              onDrop={handleDrop}
              onClick={() => fileInputRef.current?.click()}
              className={`flex cursor-pointer flex-col items-center justify-center gap-3 rounded-lg border-2 border-dashed p-12 transition-colors ${
                isDragOver
                  ? "border-vsba-red bg-vsba-teal/10"
                  : "border-muted-foreground/25 hover:border-vsba-red/50 hover:bg-muted/50"
              }`}
            >
              <Upload className="h-10 w-10 text-muted-foreground" />
              <div className="text-center">
                <p className="text-sm font-medium">
                  Drag and drop your CSV file here
                </p>
                <p className="text-xs text-muted-foreground">
                  or click to browse
                </p>
              </div>
              <input
                ref={fileInputRef}
                type="file"
                accept=".csv"
                className="hidden"
                onChange={handleFileInput}
              />
            </div>
          ) : (
            <div className="flex items-center gap-3 rounded-lg border bg-muted/30 px-4 py-3">
              <FileText className="h-5 w-5 text-vsba-red" />
              <div className="flex-1">
                <p className="text-sm font-medium">{fileName}</p>
                <p className="text-xs text-muted-foreground">
                  {parsedRows.length} row{parsedRows.length !== 1 ? "s" : ""}{" "}
                  parsed &mdash; {validRows.length} valid,{" "}
                  {invalidRows.length} with errors
                </p>
              </div>
              <Button
                variant="ghost"
                size="sm"
                onClick={clearFile}
                className="text-muted-foreground hover:text-destructive"
              >
                <X className="h-4 w-4" />
              </Button>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Validation errors */}
      {invalidRows.length > 0 && (
        <Card className="border-destructive/50">
          <CardHeader>
            <CardTitle className="flex items-center gap-2 text-base text-destructive">
              <AlertCircle className="h-4 w-4" />
              Validation Errors ({invalidRows.length} row
              {invalidRows.length !== 1 ? "s" : ""})
            </CardTitle>
            <CardDescription>
              These rows will be skipped during import. Fix the CSV and
              re-upload to include them.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-2">
              {invalidRows.map((row) => (
                <div
                  key={row.rowIndex}
                  className="rounded bg-destructive/5 px-3 py-2 text-sm"
                >
                  <span className="font-medium text-destructive">
                    Row {row.rowIndex}
                  </span>
                  {row.school_name && (
                    <span className="text-muted-foreground">
                      {" "}
                      ({row.school_name})
                    </span>
                  )}
                  <span className="text-destructive">
                    : {row.errors.join("; ")}
                  </span>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      )}

      {/* Preview table */}
      {validRows.length > 0 && (
        <Card>
          <CardHeader>
            <CardTitle className="text-base">
              Preview ({validRows.length} valid row
              {validRows.length !== 1 ? "s" : ""})
            </CardTitle>
            <CardDescription>
              Review before importing. Only valid rows are shown.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Row</TableHead>
                    <TableHead>School</TableHead>
                    <TableHead>Region</TableHead>
                    <TableHead>RAMP</TableHead>
                    <TableHead>Stage</TableHead>
                    <TableHead className="text-right">Budget</TableHead>
                    <TableHead className="text-right">Actual</TableHead>
                    <TableHead className="text-right">Forecast</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {validRows.map((row) => (
                    <TableRow key={row.rowIndex}>
                      <TableCell className="text-xs text-muted-foreground">
                        {row.rowIndex}
                      </TableCell>
                      <TableCell className="font-medium">
                        {row.school_name}
                      </TableCell>
                      <TableCell className="text-sm text-muted-foreground">
                        {row.region_name}
                      </TableCell>
                      <TableCell>{row.ramp_name}</TableCell>
                      <TableCell>
                        <span className="rounded bg-muted px-1.5 py-0.5 font-mono text-xs">
                          {row.lifecycle_stage || "design"}
                        </span>
                      </TableCell>
                      <TableCell className="text-right text-sm">
                        {row.budget
                          ? `$${parseFloat(row.budget).toLocaleString()}`
                          : "—"}
                      </TableCell>
                      <TableCell className="text-right text-sm">
                        {row.actual
                          ? `$${parseFloat(row.actual).toLocaleString()}`
                          : "—"}
                      </TableCell>
                      <TableCell className="text-right text-sm">
                        {row.forecast
                          ? `$${parseFloat(row.forecast).toLocaleString()}`
                          : "—"}
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>

            <div className="mt-4 flex items-center justify-between">
              <p className="text-sm text-muted-foreground">
                {
                  new Set(validRows.map((r) => r.school_name)).size
                }{" "}
                unique school
                {new Set(validRows.map((r) => r.school_name)).size !== 1
                  ? "s"
                  : ""}{" "}
                will be upserted with {validRows.length} RAMP
                {validRows.length !== 1 ? "s" : ""}
              </p>
              <Button
                onClick={handleImport}
                disabled={importing || validRows.length === 0}
                className="bg-vsba-red hover:bg-vsba-red/90"
              >
                <Upload className="mr-2 h-4 w-4" />
                {importing ? "Importing..." : "Import"}
              </Button>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Import summary */}
      {summary && (
        <Card
          className={
            summary.errors === 0
              ? "border-green-200 bg-green-50/50"
              : "border-amber-200 bg-amber-50/50"
          }
        >
          <CardHeader>
            <CardTitle className="flex items-center gap-2 text-base">
              <CheckCircle2
                className={`h-4 w-4 ${summary.errors === 0 ? "text-green-600" : "text-amber-600"}`}
              />
              Import Complete
            </CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-sm">
              <span className="font-medium text-green-700">
                {summary.schoolsCreated} school
                {summary.schoolsCreated !== 1 ? "s" : ""} created
              </span>
              {", "}
              <span className="font-medium text-green-700">
                {summary.rampsCreated} RAMP
                {summary.rampsCreated !== 1 ? "s" : ""} created
              </span>
              {summary.errors > 0 && (
                <>
                  {", "}
                  <span className="font-medium text-destructive">
                    {summary.errors} error
                    {summary.errors !== 1 ? "s" : ""}
                  </span>
                </>
              )}
            </p>
            {importErrors.length > 0 && (
              <div className="mt-3 space-y-1">
                {importErrors.map((err, i) => (
                  <p key={i} className="text-xs text-destructive">
                    {err}
                  </p>
                ))}
              </div>
            )}
          </CardContent>
        </Card>
      )}
    </div>
  );
}
