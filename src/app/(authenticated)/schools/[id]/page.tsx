"use client";

import { useEffect, useState, use } from "react";
import { useRouter } from "next/navigation";
import { fetchSchoolById } from "@/lib/data/schools";
import { fetchRampsBySchool } from "@/lib/data/ramps";
import { fetchMilestonesBySchool } from "@/lib/data/milestones";
import { fetchVariationsBySchool } from "@/lib/data/variations";
import { fetchDefectsBySchool } from "@/lib/data/defects";
import { useCanWrite } from "@/lib/auth/hooks";
import { RampSlideOver } from "@/components/ramps/ramp-slide-over";
import { CommunicationLog } from "@/components/schools/communication-log";
import { RiskSummary } from "@/components/schools/risk-summary";
import { TrafficLightIndicator } from "@/components/ui/traffic-light";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { ArrowLeft, ArrowUpDown } from "lucide-react";
import { cn } from "@/lib/utils";
import { getFinancialTrafficLight, getCommunicationTrafficLight, getMilestoneTrafficLight, getWorstTrafficLight } from "@/lib/traffic-lights";
import type { Ramp, Milestone, Variation, Defect } from "@/lib/types/database";

type SortKey = "name" | "lifecycle_stage" | "status";
type SortDir = "asc" | "desc";

const stageLabels: Record<string, string> = {
  design: "Design",
  construction: "Construction",
  admin_closeout: "Admin Closeout",
  dlp: "DLP",
  final_closure: "Final Closure",
};

const statusLabels: Record<string, string> = {
  active: "Active",
  on_hold: "On Hold",
  completed: "Completed",
  blocked: "Blocked",
};

const statusBadgeVariant: Record<string, "default" | "secondary" | "outline" | "destructive"> = {
  active: "default",
  on_hold: "secondary",
  completed: "outline",
  blocked: "destructive",
};

export default function SchoolViewPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = use(params);
  const router = useRouter();
  const canEdit = useCanWrite();
  const [school, setSchool] = useState<any>(null);
  const [ramps, setRamps] = useState<Ramp[]>([]);
  const [milestones, setMilestones] = useState<Milestone[]>([]);
  const [variations, setVariations] = useState<Variation[]>([]);
  const [defects, setDefects] = useState<Defect[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedRamp, setSelectedRamp] = useState<Ramp | null>(null);
  const [slideOverOpen, setSlideOverOpen] = useState(false);
  const [sortKey, setSortKey] = useState<SortKey>("name");
  const [sortDir, setSortDir] = useState<SortDir>("asc");
  const [lastContact, setLastContact] = useState<string | null>(null);

  useEffect(() => {
    const load = async () => {
      try {
        const [schoolData, rampsData, milestonesData, variationsData, defectsData] = await Promise.all([
          fetchSchoolById(id),
          fetchRampsBySchool(id),
          fetchMilestonesBySchool(id),
          fetchVariationsBySchool(id),
          fetchDefectsBySchool(id),
        ]);
        setSchool(schoolData);
        setRamps(rampsData);
        setMilestones(milestonesData);
        setVariations(variationsData);
        setDefects(defectsData);
      } catch (err) {
        console.error("Failed to load school:", err);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, [id]);

  const handleSort = (key: SortKey) => {
    if (sortKey === key) {
      setSortDir(sortDir === "asc" ? "desc" : "asc");
    } else {
      setSortKey(key);
      setSortDir("asc");
    }
  };

  const sorted = [...ramps].sort((a, b) => {
    let cmp = 0;
    switch (sortKey) {
      case "name":
        cmp = a.name.localeCompare(b.name);
        break;
      case "lifecycle_stage":
        cmp = a.lifecycle_stage.localeCompare(b.lifecycle_stage);
        break;
      case "status":
        cmp = a.status.localeCompare(b.status);
        break;
    }
    return sortDir === "asc" ? cmp : -cmp;
  });

  const handleRampClick = (ramp: Ramp) => {
    setSelectedRamp(ramp);
    setSlideOverOpen(true);
  };

  const handleRampUpdated = (updated: Ramp) => {
    setRamps((prev) => prev.map((r) => (r.id === updated.id ? updated : r)));
    setSelectedRamp(updated);
  };

  if (loading) {
    return (
      <div className="flex h-64 items-center justify-center">
        <p className="text-muted-foreground">Loading school...</p>
      </div>
    );
  }

  if (!school) {
    return (
      <div className="flex h-64 items-center justify-center">
        <p className="text-muted-foreground">School not found.</p>
      </div>
    );
  }

  const SortHeader = ({ label, sortKeyName }: { label: string; sortKeyName: SortKey }) => (
    <Button
      variant="ghost"
      size="sm"
      className="-ml-3 h-8 font-medium"
      onClick={() => handleSort(sortKeyName)}
    >
      {label}
      <ArrowUpDown className={cn("ml-1 h-3 w-3", sortKey === sortKeyName && "text-vsba-red")} />
    </Button>
  );

  return (
    <div className="space-y-6">
      <Button variant="ghost" size="sm" onClick={() => router.push("/schools")}>
        <ArrowLeft className="mr-2 h-4 w-4" />
        Back to Schools
      </Button>

      <Card>
        <CardContent className="p-6">
          <div className="flex items-start justify-between">
            <div>
              <h2 className="text-2xl font-bold text-vsba-charcoal">
                {school.name}
              </h2>
              <div className="mt-2 flex items-center gap-3 text-sm text-muted-foreground">
                <span>{school.regions?.name ?? "No region"}</span>
                <span>|</span>
                <span>{school.address ?? "No address"}</span>
              </div>
              <div className="mt-2 flex items-center gap-2 text-sm text-muted-foreground">
                <span>Last contact:</span>
                <span>
                  {school.last_communication_date
                    ? new Date(school.last_communication_date).toLocaleDateString()
                    : "Never"}
                </span>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <div className="flex items-center gap-2 text-xs text-muted-foreground">
                <span>Milestone</span>
                <TrafficLightIndicator status={getWorstTrafficLight(milestones.map((m) => getMilestoneTrafficLight(m.planned_date, m.actual_date)))} size="md" />
                <span>Financial</span>
                <TrafficLightIndicator status={getWorstTrafficLight(ramps.map((r) => getFinancialTrafficLight(Number(r.budget_amount), Number(r.forecast_amount))))} size="md" />
                <span>Comms</span>
                <TrafficLightIndicator status={getCommunicationTrafficLight(lastContact ?? school.last_communication_date)} size="md" />
              </div>
              <Badge variant={statusBadgeVariant[school.status] ?? "outline"}>
                {statusLabels[school.status] ?? school.status}
              </Badge>
            </div>
          </div>
        </CardContent>
      </Card>

      <RiskSummary ramps={ramps} milestones={milestones} variations={variations} defects={defects} />

      <div>
        <h3 className="mb-3 text-lg font-semibold text-vsba-charcoal">
          Ramps ({ramps.length})
        </h3>
        <div className="rounded-md border bg-white">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>
                  <SortHeader label="Ramp Name" sortKeyName="name" />
                </TableHead>
                <TableHead>
                  <SortHeader label="Lifecycle Stage" sortKeyName="lifecycle_stage" />
                </TableHead>
                <TableHead>
                  <SortHeader label="Status" sortKeyName="status" />
                </TableHead>
                <TableHead>Budget</TableHead>
                <TableHead>Forecast</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {sorted.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={5} className="py-8 text-center text-muted-foreground">
                    No ramps found for this school.
                  </TableCell>
                </TableRow>
              ) : (
                sorted.map((ramp) => (
                  <TableRow
                    key={ramp.id}
                    className={cn(
                      "cursor-pointer hover:bg-vsba-teal/10",
                      (ramp.status === "blocked" || getFinancialTrafficLight(Number(ramp.budget_amount), Number(ramp.forecast_amount)) === "red") && "bg-red-50"
                    )}
                    onClick={() => handleRampClick(ramp)}
                  >
                    <TableCell className="font-medium">{ramp.name}</TableCell>
                    <TableCell>
                      <Badge variant="outline">
                        {stageLabels[ramp.lifecycle_stage] ?? ramp.lifecycle_stage}
                      </Badge>
                    </TableCell>
                    <TableCell>
                      <Badge variant={statusBadgeVariant[ramp.status] ?? "outline"}>
                        {statusLabels[ramp.status] ?? ramp.status}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-muted-foreground">
                      {new Intl.NumberFormat("en-AU", { style: "currency", currency: "AUD" }).format(ramp.budget_amount)}
                    </TableCell>
                    <TableCell className="text-muted-foreground">
                      {new Intl.NumberFormat("en-AU", { style: "currency", currency: "AUD" }).format(ramp.forecast_amount)}
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </div>
      </div>

      {/* Status / Commentary */}
      {ramps.some((r) => r.commentary) && (
        <Card>
          <CardContent className="p-6">
            <h3 className="mb-4 text-lg font-semibold text-vsba-charcoal">
              Status / Commentary
            </h3>
            <div className="space-y-4">
              {ramps
                .filter((r) => r.commentary)
                .map((ramp) => (
                  <div key={ramp.id} className="rounded-md border p-4">
                    <div className="mb-2 flex items-center gap-2">
                      <span className="text-sm font-medium text-vsba-charcoal">{ramp.name}</span>
                      <Badge variant="outline" className="text-xs">
                        {stageLabels[ramp.lifecycle_stage] ?? ramp.lifecycle_stage}
                      </Badge>
                    </div>
                    <p className="whitespace-pre-wrap text-sm text-muted-foreground">
                      {ramp.commentary}
                    </p>
                  </div>
                ))}
            </div>
          </CardContent>
        </Card>
      )}

      {/* Communication Log */}
      <CommunicationLog
        schoolId={id}
        canEdit={canEdit}
        onLastContactUpdate={setLastContact}
      />

      <RampSlideOver
        ramp={selectedRamp}
        open={slideOverOpen}
        onOpenChange={setSlideOverOpen}
        canEdit={canEdit}
        onRampUpdated={handleRampUpdated}
      />
    </div>
  );
}
