"use client";

import { PieChart, Pie, Cell, ResponsiveContainer, BarChart, Bar, XAxis, YAxis, Tooltip, Legend } from "recharts";

interface DonutChartProps {
  percentage: number;
  label: string;
  color?: string;
}

export function DonutChart({ percentage, label, color = "#AF272F" }: DonutChartProps) {
  const data = [
    { value: percentage },
    { value: 100 - percentage },
  ];

  return (
    <div className="flex flex-col items-center">
      <div className="relative h-24 w-24">
        <ResponsiveContainer>
          <PieChart>
            <Pie
              data={data}
              dataKey="value"
              innerRadius={30}
              outerRadius={42}
              startAngle={90}
              endAngle={-270}
              strokeWidth={0}
            >
              <Cell fill={color} />
              <Cell fill="#E5E5E8" />
            </Pie>
          </PieChart>
        </ResponsiveContainer>
        <div className="absolute inset-0 flex items-center justify-center">
          <span className="text-lg font-bold text-vsba-charcoal">{percentage}%</span>
        </div>
      </div>
      <span className="mt-1 text-xs text-muted-foreground text-center">{label}</span>
    </div>
  );
}

interface LifecyclePieChartProps {
  data: { name: string; value: number; color: string }[];
}

export function LifecyclePieChart({ data }: LifecyclePieChartProps) {
  if (data.length === 0) return <p className="text-sm text-muted-foreground">No data</p>;

  return (
    <ResponsiveContainer width="100%" height={200}>
      <PieChart>
        <Pie
          data={data}
          dataKey="value"
          nameKey="name"
          cx="50%"
          cy="50%"
          outerRadius={80}
          label={({ name, percent }: { name?: string; percent?: number }) => `${name ?? ""} ${((percent ?? 0) * 100).toFixed(0)}%`}
          labelLine={false}
          fontSize={10}
        >
          {data.map((entry, i) => (
            <Cell key={i} fill={entry.color} />
          ))}
        </Pie>
        <Tooltip />
      </PieChart>
    </ResponsiveContainer>
  );
}

interface FinancialBarChartProps {
  budget: number;
  actual: number;
  forecast: number;
  variations: number;
}

export function FinancialBarChart({ budget, actual, forecast, variations }: FinancialBarChartProps) {
  const data = [
    { name: "Budget", amount: budget },
    { name: "Actual", amount: actual },
    { name: "Forecast", amount: forecast },
    { name: "Variations", amount: variations },
  ];

  const formatCurrency = (value: number) => {
    if (value >= 1_000_000) return `$${(value / 1_000_000).toFixed(1)}M`;
    if (value >= 1_000) return `$${(value / 1_000).toFixed(0)}K`;
    return `$${value}`;
  };

  return (
    <ResponsiveContainer width="100%" height={200}>
      <BarChart data={data}>
        <XAxis dataKey="name" fontSize={11} />
        <YAxis tickFormatter={formatCurrency} fontSize={10} />
        <Tooltip formatter={(value) => formatCurrency(Number(value))} />
        <Bar dataKey="amount" radius={[4, 4, 0, 0]}>
          {data.map((_, i) => (
            <Cell key={i} fill={["#B9E3E6", "#50D8D0", "#AF272F", "#7B1B21"][i]} />
          ))}
        </Bar>
      </BarChart>
    </ResponsiveContainer>
  );
}

interface CommHealthChartProps {
  green: number;
  amber: number;
  red: number;
}

export function CommHealthChart({ green, amber, red }: CommHealthChartProps) {
  const total = green + amber + red;
  if (total === 0) return <p className="text-sm text-muted-foreground">No data</p>;
  const data = [
    { name: "On Track", value: green, color: "#10B981" },
    { name: "At Risk", value: amber, color: "#F59E0B" },
    { name: "Overdue", value: red, color: "#EF4444" },
  ].filter((d) => d.value > 0);

  return (
    <div className="flex items-center gap-4">
      <div className="h-20 w-20">
        <ResponsiveContainer>
          <PieChart>
            <Pie data={data} dataKey="value" innerRadius={22} outerRadius={35} strokeWidth={0}>
              {data.map((d, i) => (
                <Cell key={i} fill={d.color} />
              ))}
            </Pie>
          </PieChart>
        </ResponsiveContainer>
      </div>
      <div className="space-y-1 text-xs">
        {data.map((d) => (
          <div key={d.name} className="flex items-center gap-1.5">
            <span className="inline-block h-2 w-2 rounded-full" style={{ backgroundColor: d.color }} />
            <span>{d.name}: {d.value} ({Math.round((d.value / total) * 100)}%)</span>
          </div>
        ))}
      </div>
    </div>
  );
}
