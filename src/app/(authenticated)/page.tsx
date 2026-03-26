"use client";

import { useEffect, useMemo, useState } from "react";
import { fetchSchools, fetchRegions } from "@/lib/data/schools";
import { MetricTile } from "@/components/dashboard/metric-tile";
import { FilterBar, type DashboardFilters } from "@/components/dashboard/filter-bar";
import { SchoolsTable } from "@/components/dashboard/schools-table";
import { School, Building2, Wrench, Activity } from "lucide-react";
import type { Region, SchoolWithRegion } from "@/lib/types/database";

export default function DashboardPage() {
  const [schools, setSchools] = useState<SchoolWithRegion[]>([]);
  const [regions, setRegions] = useState<Region[]>([]);
  const [loading, setLoading] = useState(true);
  const [filters, setFilters] = useState<DashboardFilters>({
    region: "all",
    status: "all",
    search: "",
  });

  useEffect(() => {
    const load = async () => {
      try {
        const [schoolsData, regionsData] = await Promise.all([
          fetchSchools(),
          fetchRegions(),
        ]);
        setSchools(schoolsData);
        setRegions(regionsData);
      } catch (err) {
        console.error("Failed to load dashboard data:", err);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, []);

  const filteredSchools = useMemo(() => {
    return schools.filter((s) => {
      if (filters.region !== "all" && s.region_id !== filters.region) return false;
      if (filters.status !== "all" && s.status !== filters.status) return false;
      if (
        filters.search &&
        !s.name.toLowerCase().includes(filters.search.toLowerCase()) &&
        !(s.regions?.name ?? "").toLowerCase().includes(filters.search.toLowerCase())
      ) {
        return false;
      }
      return true;
    });
  }, [schools, filters]);

  const totalRamps = useMemo(
    () => filteredSchools.reduce((sum, s) => sum + s.ramp_count, 0),
    [filteredSchools]
  );

  const activeSchools = useMemo(
    () => filteredSchools.filter((s) => s.status === "active").length,
    [filteredSchools]
  );

  if (loading) {
    return (
      <div className="flex h-64 items-center justify-center">
        <p className="text-muted-foreground">Loading dashboard...</p>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold text-vsba-charcoal">
          Program Dashboard
        </h2>
        <p className="mt-1 text-muted-foreground">
          Overview of the RAMPS school maintenance program.
        </p>
      </div>

      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <MetricTile
          title="Total Schools"
          value={filteredSchools.length}
          icon={School}
          description="In program"
        />
        <MetricTile
          title="Total Ramps"
          value={totalRamps}
          icon={Wrench}
          description="Work packages"
        />
        <MetricTile
          title="Active Schools"
          value={activeSchools}
          icon={Building2}
          description="Currently active"
        />
        <MetricTile
          title="Regions"
          value={regions.length}
          icon={Activity}
          description="DET regions"
        />
      </div>

      <FilterBar
        regions={regions}
        filters={filters}
        onFilterChange={setFilters}
      />

      <SchoolsTable schools={filteredSchools} />
    </div>
  );
}
