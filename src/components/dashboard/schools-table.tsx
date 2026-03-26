"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { ArrowUpDown } from "lucide-react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";
import type { SchoolWithRegion } from "@/lib/types/database";

type SortKey = "name" | "region" | "ramp_count" | "status" | "last_communication_date";
type SortDir = "asc" | "desc";

interface SchoolsTableProps {
  schools: SchoolWithRegion[];
}

const statusBadgeVariant: Record<string, "default" | "secondary" | "outline"> = {
  active: "default",
  on_hold: "secondary",
  completed: "outline",
};

const statusLabels: Record<string, string> = {
  active: "Active",
  on_hold: "On Hold",
  completed: "Completed",
};

export function SchoolsTable({ schools }: SchoolsTableProps) {
  const router = useRouter();
  const [sortKey, setSortKey] = useState<SortKey>("name");
  const [sortDir, setSortDir] = useState<SortDir>("asc");

  const handleSort = (key: SortKey) => {
    if (sortKey === key) {
      setSortDir(sortDir === "asc" ? "desc" : "asc");
    } else {
      setSortKey(key);
      setSortDir("asc");
    }
  };

  const sorted = [...schools].sort((a, b) => {
    let cmp = 0;
    switch (sortKey) {
      case "name":
        cmp = a.name.localeCompare(b.name);
        break;
      case "region":
        cmp = (a.regions?.name ?? "").localeCompare(b.regions?.name ?? "");
        break;
      case "ramp_count":
        cmp = a.ramp_count - b.ramp_count;
        break;
      case "status":
        cmp = a.status.localeCompare(b.status);
        break;
      case "last_communication_date":
        cmp = (a.last_communication_date ?? "").localeCompare(
          b.last_communication_date ?? ""
        );
        break;
    }
    return sortDir === "asc" ? cmp : -cmp;
  });

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
    <div className="rounded-md border bg-white">
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>
              <SortHeader label="School Name" sortKeyName="name" />
            </TableHead>
            <TableHead>
              <SortHeader label="Region" sortKeyName="region" />
            </TableHead>
            <TableHead>
              <SortHeader label="Ramps" sortKeyName="ramp_count" />
            </TableHead>
            <TableHead>
              <SortHeader label="Status" sortKeyName="status" />
            </TableHead>
            <TableHead>
              <SortHeader label="Last Contact" sortKeyName="last_communication_date" />
            </TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {sorted.length === 0 ? (
            <TableRow>
              <TableCell colSpan={5} className="py-8 text-center text-muted-foreground">
                No schools found matching your filters.
              </TableCell>
            </TableRow>
          ) : (
            sorted.map((school) => (
              <TableRow
                key={school.id}
                className="cursor-pointer hover:bg-vsba-teal/10"
                onClick={() => router.push(`/schools/${school.id}`)}
              >
                <TableCell className="font-medium">{school.name}</TableCell>
                <TableCell>{school.regions?.name ?? "\u2014"}</TableCell>
                <TableCell>{school.ramp_count}</TableCell>
                <TableCell>
                  <Badge variant={statusBadgeVariant[school.status] ?? "outline"}>
                    {statusLabels[school.status] ?? school.status}
                  </Badge>
                </TableCell>
                <TableCell className="text-muted-foreground">
                  {school.last_communication_date
                    ? new Date(school.last_communication_date).toLocaleDateString()
                    : "\u2014"}
                </TableCell>
              </TableRow>
            ))
          )}
        </TableBody>
      </Table>
    </div>
  );
}
