"use client";

import { useEffect, useMemo, useState } from "react";
import { fetchSchools, fetchRegions } from "@/lib/data/schools";
import { SchoolsTable } from "@/components/dashboard/schools-table";
import { FilterBar, type DashboardFilters } from "@/components/dashboard/filter-bar";
import type { Region, SchoolWithRegion } from "@/lib/types/database";

export default function SchoolsListPage() {
  const [schools, setSchools] = useState<SchoolWithRegion[]>([]);
  const [regions, setRegions] = useState<Region[]>([]);
  const [loading, setLoading] = useState(true);
  const [filters, setFilters] = useState<DashboardFilters>({
    region: "all",
    status: "all",
    search: "",
    dateFrom: "",
    dateTo: "",
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
        console.error("Failed to load schools:", err);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, []);

  const filteredSchools = useMemo(() => {
    const searchLower = filters.search.toLowerCase();
    return schools.filter((s) => {
      if (filters.region !== "all" && s.region_id !== filters.region) return false;
      if (filters.status !== "all" && s.status !== filters.status) return false;
      if (searchLower) {
        const match =
          s.name.toLowerCase().includes(searchLower) ||
          (s.regions?.name ?? "").toLowerCase().includes(searchLower);
        if (!match) return false;
      }
      return true;
    });
  }, [schools, filters]);

  if (loading) {
    return (
      <div className="flex h-64 items-center justify-center">
        <p className="text-muted-foreground">Loading schools...</p>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold text-vsba-charcoal">Schools</h2>
        <p className="mt-1 text-muted-foreground">
          {filteredSchools.length} of {schools.length} schools
        </p>
      </div>

      <FilterBar regions={regions} filters={filters} onFilterChange={setFilters} />
      <SchoolsTable schools={filteredSchools} />
    </div>
  );
}
