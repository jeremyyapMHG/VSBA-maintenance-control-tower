"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { getFinancialTrafficLight, getMilestoneTrafficLight } from "@/lib/traffic-lights";
import { AlertTriangle, DollarSign, Clock, Bug } from "lucide-react";
import type { Ramp, Milestone, Variation, Defect } from "@/lib/types/database";

interface RiskSummaryProps {
  ramps: Ramp[];
  milestones: Milestone[];
  variations: Variation[];
  defects: Defect[];
}

export function RiskSummary({ ramps, milestones, variations, defects }: RiskSummaryProps) {
  const openDefects = defects.filter((d) => d.status === "open").length;

  const approvedVariations = variations.filter((v) => v.status === "approved");
  const variationCount = approvedVariations.length;
  const variationTotal = approvedVariations.reduce((s, v) => s + Number(v.amount), 0);

  const overdueMilestones = milestones.filter((m) =>
    getMilestoneTrafficLight(m.planned_date, m.actual_date) === "red"
  ).length;

  const financiallyAtRisk = ramps.filter((r) =>
    getFinancialTrafficLight(Number(r.budget_amount), Number(r.forecast_amount)) === "red"
  ).length;

  const formatCurrency = (amount: number) =>
    new Intl.NumberFormat("en-AU", { style: "currency", currency: "AUD" }).format(amount);

  const items = [
    { label: "Open Defects", value: String(openDefects), icon: Bug, isRisk: openDefects > 0 },
    { label: "Approved Variations", value: `${variationCount} (${formatCurrency(variationTotal)})`, icon: DollarSign, isRisk: variationCount > 0 },
    { label: "Overdue Milestones", value: String(overdueMilestones), icon: Clock, isRisk: overdueMilestones > 0 },
    { label: "Financially At Risk", value: String(financiallyAtRisk), icon: AlertTriangle, isRisk: financiallyAtRisk > 0 },
  ];

  return (
    <Card>
      <CardHeader className="pb-2">
        <CardTitle className="text-base">Risk Summary</CardTitle>
      </CardHeader>
      <CardContent>
        <div className="grid grid-cols-2 gap-4 sm:grid-cols-4">
          {items.map((item) => (
            <div key={item.label} className="text-center">
              <item.icon className={`mx-auto h-5 w-5 ${item.isRisk ? "text-red-500" : "text-muted-foreground"}`} />
              <p className={`mt-1 text-lg font-bold ${item.isRisk ? "text-red-600" : "text-vsba-charcoal"}`}>
                {item.value}
              </p>
              <p className="text-xs text-muted-foreground">{item.label}</p>
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  );
}
