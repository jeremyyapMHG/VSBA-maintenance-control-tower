# Issue #4: Schools Schema + Program Dashboard

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create programs/regions/schools database tables, RLS policies, and build the Program Dashboard with summary tiles, filterable/sortable schools table, and navigation to school detail.

**Architecture:** SQL migrations for schema. Server-side data fetching via Supabase server client. Client-side filtering and sorting for POC-scale data. Dashboard page uses shadcn/ui components with VSBA theme.

**Tech Stack:** PostgreSQL (Supabase), Next.js App Router, shadcn/ui, Tailwind CSS

---

### Task 1: Database Migration — programs, regions, schools

**Files:**
- Create: `supabase/migrations/003_programs_regions_schools.sql`

- [ ] **Step 1: Write migration**

Create `supabase/migrations/003_programs_regions_schools.sql`:

```sql
-- Programs table (single program for this POC)
CREATE TABLE programs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE programs ENABLE ROW LEVEL SECURITY;

-- All authenticated users can read programs
CREATE POLICY "authenticated_read_programs" ON programs
  FOR SELECT TO authenticated
  USING (true);

-- Only admins can modify programs
CREATE POLICY "admin_write_programs" ON programs
  FOR ALL
  USING (public.is_admin());

-- Regions table
CREATE TABLE regions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE regions ENABLE ROW LEVEL SECURITY;

-- All authenticated users can read regions
CREATE POLICY "authenticated_read_regions" ON regions
  FOR SELECT TO authenticated
  USING (true);

-- Only admins can modify regions
CREATE POLICY "admin_write_regions" ON regions
  FOR ALL
  USING (public.is_admin());

-- Pre-seed Victorian DET regions
INSERT INTO regions (name) VALUES
  ('North-Eastern Victoria'),
  ('North-Western Victoria'),
  ('South-Eastern Victoria'),
  ('South-Western Victoria');

-- Schools table
CREATE TABLE schools (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  program_id UUID REFERENCES programs(id) ON DELETE CASCADE,
  region_id UUID NOT NULL REFERENCES regions(id) ON DELETE RESTRICT,
  name TEXT NOT NULL,
  address TEXT,
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'on_hold', 'completed')),
  last_communication_date TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_schools_region_id ON schools(region_id);
CREATE INDEX idx_schools_program_id ON schools(program_id);

ALTER TABLE schools ENABLE ROW LEVEL SECURITY;

-- Government and Admin: read all schools
CREATE POLICY "gov_admin_read_schools" ON schools
  FOR SELECT
  USING (
    public.is_admin() OR public.is_government()
  );

-- End User and Delivery Team: read assigned schools only
CREATE POLICY "assigned_read_schools" ON schools
  FOR SELECT
  USING (
    public.can_read_school(id)
  );

-- Admin: full write on schools
CREATE POLICY "admin_write_schools" ON schools
  FOR ALL
  USING (public.is_admin());

-- Delivery Team: update assigned schools
CREATE POLICY "delivery_write_schools" ON schools
  FOR UPDATE
  USING (public.can_write_school(id));

-- Updated_at trigger for schools
CREATE TRIGGER schools_updated_at
  BEFORE UPDATE ON schools
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- Seed the default program
INSERT INTO programs (name, description) VALUES
  ('RAMPS Program', 'Routine and Annual Maintenance Program for Schools');
```

- [ ] **Step 2: Commit**

```bash
git add supabase/migrations/003_programs_regions_schools.sql
git commit -m "feat: add programs, regions, schools tables with RLS and seed data"
```

---

### Task 2: TypeScript Types for Database Models

**Files:**
- Create: `src/lib/types/database.ts`

- [ ] **Step 1: Create database types**

Create `src/lib/types/database.ts`:

```typescript
export interface Program {
  id: string;
  name: string;
  description: string | null;
  created_at: string;
}

export interface Region {
  id: string;
  name: string;
  created_at: string;
}

export type SchoolStatus = "active" | "on_hold" | "completed";

export interface School {
  id: string;
  program_id: string | null;
  region_id: string;
  name: string;
  address: string | null;
  status: SchoolStatus;
  last_communication_date: string | null;
  created_at: string;
  updated_at: string;
}

export interface SchoolWithRegion extends School {
  regions: Region;
  ramp_count: number;
}
```

- [ ] **Step 2: Verify build**

```bash
npm run build
```

- [ ] **Step 3: Commit**

```bash
git add src/lib/types/database.ts
git commit -m "feat: add TypeScript types for database models"
```

---

### Task 3: Dashboard Data Fetching

**Files:**
- Create: `src/lib/data/schools.ts`

- [ ] **Step 1: Create data fetching functions**

Create `src/lib/data/schools.ts`:

```typescript
import { createClient } from "@/lib/supabase/client";
import type { Region, SchoolWithRegion } from "@/lib/types/database";

export async function fetchSchools(): Promise<SchoolWithRegion[]> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("schools")
    .select(`
      *,
      regions (id, name)
    `)
    .order("name");

  if (error) throw error;

  // Add placeholder ramp_count (will be replaced when ramps table exists)
  return (data ?? []).map((school: any) => ({
    ...school,
    ramp_count: 0,
  }));
}

export async function fetchRegions(): Promise<Region[]> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("regions")
    .select("*")
    .order("name");

  if (error) throw error;
  return data ?? [];
}
```

- [ ] **Step 2: Verify build**

```bash
npm run build
```

- [ ] **Step 3: Commit**

```bash
git add src/lib/data/schools.ts
git commit -m "feat: add data fetching functions for schools and regions"
```

---

### Task 4: Summary Metric Tiles Component

**Files:**
- Create: `src/components/dashboard/metric-tile.tsx`

- [ ] **Step 1: Create metric tile component**

Create `src/components/dashboard/metric-tile.tsx`:

```typescript
import { Card, CardContent } from "@/components/ui/card";
import type { LucideIcon } from "lucide-react";

interface MetricTileProps {
  title: string;
  value: number | string;
  icon: LucideIcon;
  description?: string;
}

export function MetricTile({ title, value, icon: Icon, description }: MetricTileProps) {
  return (
    <Card>
      <CardContent className="p-6">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-sm font-medium text-muted-foreground">{title}</p>
            <p className="mt-1 text-3xl font-bold text-vsba-charcoal">{value}</p>
            {description && (
              <p className="mt-1 text-xs text-muted-foreground">{description}</p>
            )}
          </div>
          <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-vsba-teal/20">
            <Icon className="h-6 w-6 text-vsba-red" />
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
```

- [ ] **Step 2: Verify build**

```bash
npm run build
```

- [ ] **Step 3: Commit**

```bash
git add src/components/dashboard/metric-tile.tsx
git commit -m "feat: add metric tile component for dashboard summary"
```

---

### Task 5: Filter Bar Component

**Files:**
- Create: `src/components/dashboard/filter-bar.tsx`

- [ ] **Step 1: Create filter bar**

Create `src/components/dashboard/filter-bar.tsx`:

```typescript
"use client";

import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { X, Search } from "lucide-react";
import type { Region } from "@/lib/types/database";

export interface DashboardFilters {
  region: string;
  status: string;
  search: string;
}

interface FilterBarProps {
  regions: Region[];
  filters: DashboardFilters;
  onFilterChange: (filters: DashboardFilters) => void;
}

const statusOptions = [
  { value: "all", label: "All Statuses" },
  { value: "active", label: "Active" },
  { value: "on_hold", label: "On Hold" },
  { value: "completed", label: "Completed" },
];

export function FilterBar({ regions, filters, onFilterChange }: FilterBarProps) {
  const hasFilters = filters.region !== "all" || filters.status !== "all" || filters.search !== "";

  const clearFilters = () => {
    onFilterChange({ region: "all", status: "all", search: "" });
  };

  return (
    <div className="flex flex-wrap items-center gap-3">
      <div className="relative flex-1 min-w-[200px] max-w-sm">
        <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
        <Input
          placeholder="Search schools..."
          value={filters.search}
          onChange={(e) =>
            onFilterChange({ ...filters, search: e.target.value })
          }
          className="pl-9"
        />
      </div>

      <Select
        value={filters.region}
        onValueChange={(v) => onFilterChange({ ...filters, region: v })}
      >
        <SelectTrigger className="w-52">
          <SelectValue placeholder="All Regions" />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="all">All Regions</SelectItem>
          {regions.map((r) => (
            <SelectItem key={r.id} value={r.id}>
              {r.name}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>

      <Select
        value={filters.status}
        onValueChange={(v) => onFilterChange({ ...filters, status: v })}
      >
        <SelectTrigger className="w-40">
          <SelectValue placeholder="All Statuses" />
        </SelectTrigger>
        <SelectContent>
          {statusOptions.map((opt) => (
            <SelectItem key={opt.value} value={opt.value}>
              {opt.label}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>

      {hasFilters && (
        <Button variant="ghost" size="sm" onClick={clearFilters}>
          <X className="mr-1 h-4 w-4" />
          Clear
        </Button>
      )}
    </div>
  );
}
```

- [ ] **Step 2: Verify build**

```bash
npm run build
```

- [ ] **Step 3: Commit**

```bash
git add src/components/dashboard/filter-bar.tsx
git commit -m "feat: add filter bar component with region, status, and search"
```

---

### Task 6: Schools Data Table Component

**Files:**
- Create: `src/components/dashboard/schools-table.tsx`

- [ ] **Step 1: Create schools table**

Create `src/components/dashboard/schools-table.tsx`:

```typescript
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
                <TableCell>{school.regions?.name ?? "—"}</TableCell>
                <TableCell>{school.ramp_count}</TableCell>
                <TableCell>
                  <Badge variant={statusBadgeVariant[school.status] ?? "outline"}>
                    {statusLabels[school.status] ?? school.status}
                  </Badge>
                </TableCell>
                <TableCell className="text-muted-foreground">
                  {school.last_communication_date
                    ? new Date(school.last_communication_date).toLocaleDateString()
                    : "—"}
                </TableCell>
              </TableRow>
            ))
          )}
        </TableBody>
      </Table>
    </div>
  );
}
```

- [ ] **Step 2: Verify build**

```bash
npm run build
```

- [ ] **Step 3: Commit**

```bash
git add src/components/dashboard/schools-table.tsx
git commit -m "feat: add sortable schools data table with row navigation"
```

---

### Task 7: Program Dashboard Page — Assemble Everything

**Files:**
- Modify: `src/app/(authenticated)/page.tsx`

- [ ] **Step 1: Replace dashboard page with full implementation**

Replace `src/app/(authenticated)/page.tsx`:

```typescript
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
```

- [ ] **Step 2: Verify build**

```bash
npm run build
```

- [ ] **Step 3: Commit**

```bash
git add src/app/\(authenticated\)/page.tsx
git commit -m "feat: build Program Dashboard with metrics tiles, filters, and schools table"
```
