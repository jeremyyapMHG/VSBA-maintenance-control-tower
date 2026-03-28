import type { SchoolWithRegion, Ramp, Milestone, Variation, Defect } from "@/lib/types/database";
import { getCommunicationTrafficLight } from "@/lib/traffic-lights";

export interface DashboardMetrics {
  totalSchools: number;
  totalRamps: number;
  activeSchools: number;
  // Lifecycle distribution
  lifecycleDistribution: { name: string; value: number; color: string }[];
  // Completion counts + %
  practicalCompletionPct: number;
  practicalCompletionCount: number;
  adminCompletionPct: number;
  adminCompletionCount: number;
  // Defects & variations
  defectsPct: number;
  variationsPct: number;
  schoolsWithDefects: number;
  schoolsWithVariations: number;
  // Financials
  totalBudget: number;
  totalActual: number;
  totalForecast: number;
  totalVariations: number;
  // Communication health
  commGreen: number;
  commAmber: number;
  commRed: number;
  overdueSchools: { name: string; daysSince: number }[];
}

const stageColors: Record<string, string> = {
  design: "#B9E3E6",
  construction: "#50D8D0",
  admin_closeout: "#AF272F",
  dlp: "#7B1B21",
  final_closure: "#1A1A1A",
};

const stageLabels: Record<string, string> = {
  design: "Design",
  construction: "Construction",
  admin_closeout: "Admin Closeout",
  dlp: "DLP",
  final_closure: "Final Closure",
};

export function computeDashboardMetrics(
  schools: SchoolWithRegion[],
  ramps: Ramp[],
  milestones: Milestone[],
  variations: Variation[],
  defects: Defect[]
): DashboardMetrics {
  const totalRamps = ramps.length;

  // Lifecycle distribution
  const stageCounts: Record<string, number> = {};
  for (const r of ramps) {
    stageCounts[r.lifecycle_stage] = (stageCounts[r.lifecycle_stage] || 0) + 1;
  }
  const lifecycleDistribution = Object.entries(stageCounts).map(([key, value]) => ({
    name: stageLabels[key] || key,
    value,
    color: stageColors[key] || "#999",
  }));

  // Practical Completion % — ramps with "Practical Completion" milestone having actual_date
  const pcMilestones = milestones.filter((m) => m.name === "Practical Completion");
  const pcComplete = pcMilestones.filter((m) => m.actual_date).length;
  const practicalCompletionPct = totalRamps > 0 ? Math.round((pcComplete / totalRamps) * 100) : 0;

  // Admin Completion %
  const acMilestones = milestones.filter((m) => m.name === "Administrative Completion");
  const acComplete = acMilestones.filter((m) => m.actual_date).length;
  const adminCompletionPct = totalRamps > 0 ? Math.round((acComplete / totalRamps) * 100) : 0;

  // Defects % — ramps with at least one open defect
  const rampIdsWithDefects = new Set(
    defects.filter((d) => d.status === "open").map((d) => d.ramp_id)
  );
  const defectsPct = totalRamps > 0 ? Math.round((rampIdsWithDefects.size / totalRamps) * 100) : 0;

  // Variations % — ramps with at least one approved variation
  const rampIdsWithVariations = new Set(
    variations.filter((v) => v.status === "approved").map((v) => v.ramp_id)
  );
  const variationsPct = totalRamps > 0 ? Math.round((rampIdsWithVariations.size / totalRamps) * 100) : 0;

  // Financials
  const totalBudget = ramps.reduce((s, r) => s + Number(r.budget_amount), 0);
  const totalActual = ramps.reduce((s, r) => s + Number(r.actual_amount), 0);
  const totalForecast = ramps.reduce((s, r) => s + Number(r.forecast_amount), 0);
  const totalVariations = variations
    .filter((v) => v.status === "approved")
    .reduce((s, v) => s + Number(v.amount), 0);

  // Communication health
  let commGreen = 0, commAmber = 0, commRed = 0;
  for (const s of schools) {
    const light = getCommunicationTrafficLight(s.last_communication_date);
    if (light === "green") commGreen++;
    else if (light === "amber") commAmber++;
    else commRed++;
  }

  // Overdue schools list (sorted by stalest first)
  const overdueSchools: { name: string; daysSince: number }[] = [];
  const now = new Date();
  for (const s of schools) {
    const light = getCommunicationTrafficLight(s.last_communication_date);
    if (light === "red") {
      const daysSince = s.last_communication_date
        ? Math.floor((now.getTime() - new Date(s.last_communication_date).getTime()) / 86400000)
        : 999;
      overdueSchools.push({ name: s.name, daysSince });
    }
  }
  overdueSchools.sort((a, b) => b.daysSince - a.daysSince);

  return {
    totalSchools: schools.length,
    totalRamps,
    activeSchools: schools.filter((s) => s.status === "active").length,
    lifecycleDistribution,
    practicalCompletionPct,
    practicalCompletionCount: pcComplete,
    adminCompletionPct,
    adminCompletionCount: acComplete,
    defectsPct,
    variationsPct,
    schoolsWithDefects: rampIdsWithDefects.size,
    schoolsWithVariations: rampIdsWithVariations.size,
    totalBudget,
    totalActual,
    totalForecast,
    totalVariations,
    commGreen,
    commAmber,
    commRed,
    overdueSchools,
  };
}
