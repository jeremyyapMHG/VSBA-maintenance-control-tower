"use client";

import { useEffect, useMemo, useState } from "react";
import { fetchDashboardData, fetchRegions } from "@/lib/data/schools";
import { computeDashboardMetrics } from "@/lib/metrics";
import { MetricTile } from "@/components/dashboard/metric-tile";
import { FilterBar, type DashboardFilters } from "@/components/dashboard/filter-bar";
import { SchoolsTable } from "@/components/dashboard/schools-table";
import { LifecycleBarChart, CompletionDonut, FinancialSummary, CommHealthSection, QualityCard } from "@/components/dashboard/charts";
import { UpcomingMilestones } from "@/components/dashboard/upcoming-milestones";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { School, Building2, Wrench, Activity } from "lucide-react";
import type { Region, SchoolWithRegion, Ramp, Milestone, Variation, Defect } from "@/lib/types/database";

export default function DashboardPage() {
  const [schools, setSchools] = useState<SchoolWithRegion[]>([]);
  const [ramps, setRamps] = useState<Ramp[]>([]);
  const [milestones, setMilestones] = useState<Milestone[]>([]);
  const [variations, setVariations] = useState<Variation[]>([]);
  const [defects, setDefects] = useState<Defect[]>([]);
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
        const [dashData, regionsData] = await Promise.all([
          fetchDashboardData(),
          fetchRegions(),
        ]);
        setSchools(dashData.schools);
        setRamps(dashData.ramps);
        setMilestones(dashData.milestones);
        setVariations(dashData.variations);
        setDefects(dashData.defects);
        setRegions(regionsData);
      } catch (err) {
        console.error("Failed to load dashboard:", err);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, []);

  // Filter schools
  const filteredSchools = useMemo(() => {
    const searchLower = filters.search.toLowerCase();
    return schools.filter((s) => {
      if (filters.region !== "all" && s.region_id !== filters.region) return false;
      if (filters.status !== "all" && s.status !== filters.status) return false;
      if (searchLower) {
        const schoolMatch =
          s.name.toLowerCase().includes(searchLower) ||
          (s.regions?.name ?? "").toLowerCase().includes(searchLower);
        const schoolRamps = ramps.filter((r) => r.school_id === s.id);
        const rampMatch = schoolRamps.some(
          (r) =>
            r.name.toLowerCase().includes(searchLower) ||
            (r.description ?? "").toLowerCase().includes(searchLower)
        );
        if (!schoolMatch && !rampMatch) return false;
      }
      // Date range: keep school only if it has ramps with milestones in range
      if (filters.dateFrom || filters.dateTo) {
        const schoolRampIds = new Set(
          ramps.filter((r) => r.school_id === s.id).map((r) => r.id)
        );
        const hasMatchingMilestone = milestones.some((m) => {
          if (!schoolRampIds.has(m.ramp_id)) return false;
          const dates = [m.planned_date, m.actual_date].filter(Boolean) as string[];
          return dates.some((d) => {
            if (filters.dateFrom && d < filters.dateFrom) return false;
            if (filters.dateTo && d > filters.dateTo) return false;
            return true;
          });
        });
        if (!hasMatchingMilestone) return false;
      }
      return true;
    });
  }, [schools, ramps, milestones, filters]);

  // Filter ramps to only those belonging to filtered schools
  const filteredSchoolIds = useMemo(
    () => new Set(filteredSchools.map((s) => s.id)),
    [filteredSchools]
  );

  const filteredRamps = useMemo(
    () => ramps.filter((r) => filteredSchoolIds.has(r.school_id)),
    [ramps, filteredSchoolIds]
  );

  const filteredMilestones = useMemo(
    () => milestones.filter((m) => filteredRamps.some((r) => r.id === m.ramp_id)),
    [milestones, filteredRamps]
  );

  const filteredVariations = useMemo(
    () => variations.filter((v) => filteredRamps.some((r) => r.id === v.ramp_id)),
    [variations, filteredRamps]
  );

  const filteredDefects = useMemo(
    () => defects.filter((d) => filteredRamps.some((r) => r.id === d.ramp_id)),
    [defects, filteredRamps]
  );

  // Compute metrics from filtered data
  const metrics = useMemo(
    () => computeDashboardMetrics(filteredSchools, filteredRamps, filteredMilestones, filteredVariations, filteredDefects),
    [filteredSchools, filteredRamps, filteredMilestones, filteredVariations, filteredDefects]
  );

  // Update school ramp counts
  const schoolsWithCounts = useMemo(() => {
    const countMap: Record<string, number> = {};
    for (const r of filteredRamps) {
      countMap[r.school_id] = (countMap[r.school_id] || 0) + 1;
    }
    return filteredSchools.map((s) => ({ ...s, ramp_count: countMap[s.id] || 0 }));
  }, [filteredSchools, filteredRamps]);

  const formatCurrency = (amount: number) =>
    new Intl.NumberFormat("en-AU", { style: "currency", currency: "AUD", maximumFractionDigits: 0 }).format(amount);

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
        <h2 className="text-2xl font-bold text-vsba-charcoal">Program Dashboard</h2>
        <p className="mt-1 text-muted-foreground">Overview of the RAMPS school maintenance program.</p>
      </div>

      {/* Summary Tiles */}
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <MetricTile title="Total Schools" value={metrics.totalSchools} icon={School} description="In program" />
        <MetricTile title="Total Ramps" value={metrics.totalRamps} icon={Wrench} description="Work packages" />
        <MetricTile title="Active Schools" value={metrics.activeSchools} icon={Building2} description="Currently active" />
        <MetricTile title="Regions" value={regions.length} icon={Activity} description="DET regions" />
      </div>

      {/* Charts Row 1: Lifecycle + Completion + Quality */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        <Card className="lg:col-span-1">
          <CardHeader className="pb-2">
            <CardTitle className="text-sm">Lifecycle Distribution</CardTitle>
          </CardHeader>
          <CardContent>
            <LifecycleBarChart data={metrics.lifecycleDistribution} total={metrics.totalRamps} />
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm">Completion Progress</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="flex justify-around py-4">
              <CompletionDonut
                percentage={metrics.practicalCompletionPct}
                count={metrics.practicalCompletionCount}
                total={metrics.totalRamps}
                label="Practical Completion"
              />
              <CompletionDonut
                percentage={metrics.adminCompletionPct}
                count={metrics.adminCompletionCount}
                total={metrics.totalRamps}
                label="Admin Completion"
                color="#7B1B21"
              />
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm">Quality & Variations</CardTitle>
          </CardHeader>
          <CardContent>
            <QualityCard
              schoolsWithDefects={metrics.schoolsWithDefects}
              schoolsWithVariations={metrics.schoolsWithVariations}
              totalSchools={metrics.totalSchools}
              totalRamps={metrics.totalRamps}
            />
          </CardContent>
        </Card>
      </div>

      {/* Charts Row 2: Financials + Communication Health */}
      <div className="grid gap-4 md:grid-cols-2">
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm">Financial Summary</CardTitle>
          </CardHeader>
          <CardContent>
            <FinancialSummary
              totalApprovedFunding={metrics.totalBudget}
              contingencyAmount={metrics.totalForecast}
              variations={metrics.totalVariations}
            />
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm">Communication Health</CardTitle>
          </CardHeader>
          <CardContent>
            <CommHealthSection
              green={metrics.commGreen}
              amber={metrics.commAmber}
              red={metrics.commRed}
              overdueSchools={metrics.overdueSchools}
            />
          </CardContent>
        </Card>
      </div>

      {/* Upcoming Milestones */}
      <Card>
        <CardHeader className="pb-2">
          <CardTitle className="text-sm">Upcoming Milestones (Next 4 Weeks)</CardTitle>
        </CardHeader>
        <CardContent>
          <UpcomingMilestones milestones={filteredMilestones} />
        </CardContent>
      </Card>

      {/* Filters + Schools Table */}
      <FilterBar regions={regions} filters={filters} onFilterChange={setFilters} />
      <SchoolsTable schools={schoolsWithCounts} />
    </div>
  );
}
