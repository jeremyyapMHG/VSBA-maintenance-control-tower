"use client";

import { useState } from "react";
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, Cell } from "recharts";

/* ── Info tooltip ── */

function InfoTooltip({ text }: { text: string }) {
  return (
    <span className="group relative ml-1 inline-flex cursor-help">
      <svg className="h-3.5 w-3.5 text-muted-foreground" viewBox="0 0 16 16" fill="currentColor">
        <path d="M8 0a8 8 0 110 16A8 8 0 018 0zm0 1.5a6.5 6.5 0 100 13 6.5 6.5 0 000-13zM8 5a.75.75 0 01.75.75v4.5a.75.75 0 01-1.5 0v-4.5A.75.75 0 018 5zm0-2a.75.75 0 110 1.5.75.75 0 010-1.5z" />
      </svg>
      <span className="pointer-events-none absolute bottom-full left-1/2 z-50 mb-1.5 w-48 -translate-x-1/2 rounded-md bg-vsba-charcoal px-3 py-2 text-xs text-white opacity-0 shadow-lg transition-opacity group-hover:opacity-100">
        {text}
      </span>
    </span>
  );
}

const lifecycleDescriptions: Record<string, string> = {
  "Design": "Design phase — scope, drawings, and approvals being finalised before construction begins.",
  "Construction": "Physical construction works are underway on site.",
  "Admin Closeout": "Construction complete — awaiting CFI, school signoff, and administrative closure.",
  "DLP": "Defects Liability Period — monitoring and rectifying defects post-construction.",
  "Final Closure": "All works, defects, and administration fully closed out.",
};

/* ── Lifecycle Distribution: horizontal bar chart ── */

interface LifecycleBarChartProps {
  data: { name: string; value: number; color: string }[];
  total: number;
}

const lifecycleOrder = ["Design", "Construction", "Admin Closeout", "DLP", "Final Closure"];

export function LifecycleBarChart({ data, total }: LifecycleBarChartProps) {
  if (data.length === 0) return <p className="text-sm text-muted-foreground">No data</p>;

  const sorted = [...data].sort(
    (a, b) => lifecycleOrder.indexOf(a.name) - lifecycleOrder.indexOf(b.name)
  );

  return (
    <div className="space-y-3">
      {sorted.map((item) => {
        const pct = total > 0 ? Math.round((item.value / total) * 100) : 0;
        return (
          <div key={item.name}>
            <div className="mb-1 flex items-center justify-between text-sm">
              <span className="flex items-center text-vsba-charcoal">
                {item.name}
                {lifecycleDescriptions[item.name] && (
                  <InfoTooltip text={lifecycleDescriptions[item.name]} />
                )}
              </span>
              <span className="text-muted-foreground">
                {item.value} ({pct}%)
              </span>
            </div>
            <div className="h-3 w-full rounded-full bg-gray-100">
              <div
                className="h-3 rounded-full transition-all"
                style={{ width: `${pct}%`, backgroundColor: item.color }}
              />
            </div>
          </div>
        );
      })}
    </div>
  );
}

/* ── Completion Progress: donut with count label ── */

interface CompletionDonutProps {
  percentage: number;
  count: number;
  total: number;
  label: string;
  color?: string;
}

const completionDescriptions: Record<string, string> = {
  "Practical Completion": "Ramps where construction is complete — CFI issued, school signoff obtained, and workflow closed.",
  "Admin Completion": "Ramps where all administrative tasks are finalised — documentation, financial reconciliation, and formal closure.",
};

export function CompletionDonut({ percentage, count, total, label, color = "#AF272F" }: CompletionDonutProps) {
  return (
    <div className="flex flex-col items-center">
      <div className="relative h-24 w-24">
        <svg viewBox="0 0 100 100" className="h-full w-full -rotate-90">
          <circle cx="50" cy="50" r="38" fill="none" stroke="#E5E5E8" strokeWidth="10" />
          <circle
            cx="50"
            cy="50"
            r="38"
            fill="none"
            stroke={color}
            strokeWidth="10"
            strokeDasharray={`${percentage * 2.388} ${238.8 - percentage * 2.388}`}
            strokeLinecap="round"
          />
        </svg>
        <div className="absolute inset-0 flex items-center justify-center">
          <span className="text-lg font-bold text-vsba-charcoal">{percentage}%</span>
        </div>
      </div>
      <span className="mt-2 flex items-center text-xs font-medium text-vsba-charcoal">
        {label}
        {completionDescriptions[label] && (
          <InfoTooltip text={completionDescriptions[label]} />
        )}
      </span>
      <span className="text-xs text-muted-foreground">
        {count} of {total} ramps
      </span>
    </div>
  );
}

/* ── Financial Summary: clean stat cards ── */

interface FinancialSummaryProps {
  totalApprovedFunding: number;
  contingencyAmount: number;
  variations: number;
}

export function FinancialSummary({ totalApprovedFunding, contingencyAmount, variations }: FinancialSummaryProps) {
  const formatCurrency = (value: number) => {
    if (value >= 1_000_000) return `$${(value / 1_000_000).toFixed(1)}M`;
    if (value >= 1_000) return `$${(value / 1_000).toFixed(0)}K`;
    return `$${value.toFixed(0)}`;
  };

  return (
    <div className="space-y-4">
      {/* Summary cards */}
      <div className="grid grid-cols-3 gap-4">
        <div className="rounded-md border p-4 text-center">
          <p className="text-xs text-muted-foreground">Total Approved Funding</p>
          <p className="mt-1 text-xl font-bold text-vsba-charcoal">{formatCurrency(totalApprovedFunding)}</p>
        </div>
        <div className="rounded-md border p-4 text-center">
          <p className="text-xs text-muted-foreground">Contingency Amount</p>
          <p className="mt-1 text-xl font-bold text-vsba-charcoal">{formatCurrency(contingencyAmount)}</p>
        </div>
        <div className="rounded-md border p-4 text-center">
          <p className="text-xs text-muted-foreground">Variations</p>
          <p className="mt-1 text-xl font-bold text-vsba-charcoal">{formatCurrency(variations)}</p>
        </div>
      </div>

      {/* Waterfall chart */}
      <WaterfallChart
        totalApprovedFunding={totalApprovedFunding}
        contingencyAmount={contingencyAmount}
        variations={variations}
        formatCurrency={formatCurrency}
      />
    </div>
  );
}

/* ── Waterfall chart sub-component ── */

function WaterfallChart({
  totalApprovedFunding,
  contingencyAmount,
  variations,
  formatCurrency,
}: {
  totalApprovedFunding: number;
  contingencyAmount: number;
  variations: number;
  formatCurrency: (v: number) => string;
}) {
  const netPosition = totalApprovedFunding + variations;
  const data = [
    { name: "Approved\nFunding", value: totalApprovedFunding, base: 0, fill: "#B9E3E6" },
    { name: "Variations", value: variations, base: totalApprovedFunding, fill: variations >= 0 ? "#EF4444" : "#10B981" },
    { name: "Net\nPosition", value: netPosition, base: 0, fill: "#AF272F" },
  ];

  return (
    <div className="h-48">
      <ResponsiveContainer width="100%" height="100%">
        <BarChart data={data} barCategoryGap="25%">
          <XAxis dataKey="name" fontSize={11} tickLine={false} />
          <YAxis
            tickFormatter={formatCurrency}
            fontSize={10}
            tickLine={false}
            axisLine={false}
          />
          <Tooltip
            formatter={(value) => formatCurrency(Number(value))}
            labelFormatter={(label) => label}
          />
          <Bar dataKey="base" stackId="waterfall" fill="transparent" />
          <Bar dataKey="value" stackId="waterfall" radius={[4, 4, 0, 0]}>
            {data.map((entry, i) => (
              <Cell key={i} fill={entry.fill} />
            ))}
          </Bar>
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}

/* ── Communication Health: traffic light stats + overdue list ── */

interface CommHealthProps {
  green: number;
  amber: number;
  red: number;
  overdueSchools: { name: string; daysSince: number }[];
}

export function CommHealthSection({ green, amber, red, overdueSchools }: CommHealthProps) {
  const [sortAsc, setSortAsc] = useState(false);
  const total = green + amber + red;
  if (total === 0) return <p className="text-sm text-muted-foreground">No data</p>;

  const sorted = [...overdueSchools].sort((a, b) =>
    sortAsc ? a.daysSince - b.daysSince : b.daysSince - a.daysSince
  );

  return (
    <div className="space-y-4">
      {/* Traffic light summary */}
      <div className="grid grid-cols-3 gap-3">
        <div className="flex items-center gap-2 rounded-md border border-green-200 bg-green-50 p-3">
          <span className="h-3 w-3 rounded-full bg-green-500" />
          <div>
            <p className="text-lg font-bold text-green-700">{green}</p>
            <p className="text-xs text-green-600">On Track</p>
          </div>
        </div>
        <div className="flex items-center gap-2 rounded-md border border-amber-200 bg-amber-50 p-3">
          <span className="h-3 w-3 rounded-full bg-amber-500" />
          <div>
            <p className="text-lg font-bold text-amber-700">{amber}</p>
            <p className="text-xs text-amber-600">At Risk</p>
          </div>
        </div>
        <div className="flex items-center gap-2 rounded-md border border-red-200 bg-red-50 p-3">
          <span className="h-3 w-3 rounded-full bg-red-500" />
          <div>
            <p className="text-lg font-bold text-red-700">{red}</p>
            <p className="text-xs text-red-600">Overdue</p>
          </div>
        </div>
      </div>

      {/* Overdue schools list */}
      {overdueSchools.length > 0 && (
        <div>
          <div className="mb-2 flex items-center justify-between">
            <p className="text-xs font-medium text-muted-foreground">
              Overdue schools ({overdueSchools.length})
            </p>
            <button
              onClick={() => setSortAsc(!sortAsc)}
              className="flex items-center gap-1 text-xs text-muted-foreground hover:text-vsba-charcoal"
            >
              Days overdue {sortAsc ? "↑" : "↓"}
            </button>
          </div>
          <div className="max-h-64 space-y-1 overflow-y-auto">
            {sorted.map((s) => (
              <div key={s.name} className="flex items-center justify-between rounded px-2 py-1.5 text-sm hover:bg-gray-50">
                <span className="truncate text-vsba-charcoal">{s.name}</span>
                <span className="ml-2 shrink-0 text-xs text-red-500">
                  {s.daysSince >= 999 ? "Never contacted" : `${s.daysSince}d ago`}
                </span>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

/* ── Quality & Variations: school-level counts ── */

interface QualityCardProps {
  schoolsWithDefects: number;
  schoolsWithVariations: number;
  totalSchools: number;
  totalRamps: number;
}

export function QualityCard({ schoolsWithDefects, schoolsWithVariations, totalSchools, totalRamps }: QualityCardProps) {
  return (
    <div className="grid grid-cols-2 gap-4">
      <div className="flex flex-col items-center rounded-md border p-4">
        <p className="text-2xl font-bold text-red-600">{schoolsWithDefects}</p>
        <p className="mt-1 text-xs text-muted-foreground text-center">
          {schoolsWithDefects === 1 ? "ramp" : "ramps"} with open defects
        </p>
      </div>
      <div className="flex flex-col items-center rounded-md border p-4">
        <p className="text-2xl font-bold text-amber-600">{schoolsWithVariations}</p>
        <p className="mt-1 text-xs text-muted-foreground text-center">
          {schoolsWithVariations === 1 ? "ramp" : "ramps"} with approved variations
        </p>
      </div>
    </div>
  );
}
