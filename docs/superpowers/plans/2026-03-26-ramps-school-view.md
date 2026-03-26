# Issue #5: Ramps Schema + School View

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create ramps table, build School View page with school header, ramps table, and slide-over panel with lifecycle tracker and editable status/commentary.

**Architecture:** SQL migration for ramps. School View fetches school + ramps via Supabase. Ramps table with sorting. Sheet component for slide-over panel. Lifecycle progress tracker as a visual step indicator. Delivery team users get edit capability.

**Tech Stack:** PostgreSQL, Next.js, shadcn/ui Sheet, Tailwind CSS

---

### Task 1: Ramps Table Migration

**Files:**
- Create: `supabase/migrations/004_ramps.sql`

```sql
-- Lifecycle stage enum
CREATE TYPE lifecycle_stage AS ENUM (
  'design',
  'construction',
  'admin_closeout',
  'dlp',
  'final_closure'
);

-- Ramps table
CREATE TABLE ramps (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  school_id UUID NOT NULL REFERENCES schools(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  lifecycle_stage lifecycle_stage NOT NULL DEFAULT 'design',
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'on_hold', 'completed', 'blocked')),
  commentary TEXT,
  budget_amount NUMERIC(12,2) DEFAULT 0,
  actual_amount NUMERIC(12,2) DEFAULT 0,
  forecast_amount NUMERIC(12,2) DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_ramps_school_id ON ramps(school_id);

ALTER TABLE ramps ENABLE ROW LEVEL SECURITY;

-- Gov/Admin: read all ramps
CREATE POLICY "gov_admin_read_ramps" ON ramps
  FOR SELECT
  USING (public.is_admin() OR public.is_government());

-- Assigned users: read ramps at their schools
CREATE POLICY "assigned_read_ramps" ON ramps
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM schools s
      WHERE s.id = ramps.school_id
      AND public.can_read_school(s.id)
    )
  );

-- Admin: full write
CREATE POLICY "admin_write_ramps" ON ramps
  FOR ALL
  USING (public.is_admin());

-- Delivery team: write ramps at assigned schools
CREATE POLICY "delivery_write_ramps" ON ramps
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM schools s
      WHERE s.id = ramps.school_id
      AND public.can_write_school(s.id)
    )
  );

-- Delivery team: insert ramps at assigned schools
CREATE POLICY "delivery_insert_ramps" ON ramps
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM schools s
      WHERE s.id = ramps.school_id
      AND public.can_write_school(s.id)
    )
  );

CREATE TRIGGER ramps_updated_at
  BEFORE UPDATE ON ramps
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
```

Commit: `git add supabase/migrations/004_ramps.sql && git commit -m "feat: add ramps table with lifecycle stages and RLS policies"`

---

### Task 2: Ramp TypeScript Types + Data Fetching

**Files:**
- Modify: `src/lib/types/database.ts` — add Ramp types
- Create: `src/lib/data/ramps.ts`

Add to `src/lib/types/database.ts`:

```typescript
export type LifecycleStage = "design" | "construction" | "admin_closeout" | "dlp" | "final_closure";
export type RampStatus = "active" | "on_hold" | "completed" | "blocked";

export interface Ramp {
  id: string;
  school_id: string;
  name: string;
  description: string | null;
  lifecycle_stage: LifecycleStage;
  status: RampStatus;
  commentary: string | null;
  budget_amount: number;
  actual_amount: number;
  forecast_amount: number;
  created_at: string;
  updated_at: string;
}
```

Create `src/lib/data/ramps.ts`:

```typescript
import { createClient } from "@/lib/supabase/client";
import type { Ramp } from "@/lib/types/database";

export async function fetchRampsBySchool(schoolId: string): Promise<Ramp[]> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("ramps")
    .select("*")
    .eq("school_id", schoolId)
    .order("name");

  if (error) throw error;
  return data ?? [];
}

export async function updateRamp(
  rampId: string,
  updates: Partial<Pick<Ramp, "status" | "commentary" | "lifecycle_stage">>
): Promise<Ramp> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("ramps")
    .update(updates)
    .eq("id", rampId)
    .select()
    .single();

  if (error) throw error;
  return data;
}
```

Commit: `git add src/lib/types/database.ts src/lib/data/ramps.ts && git commit -m "feat: add ramp types and data fetching functions"`

---

### Task 3: School Data Fetching

**Files:**
- Modify: `src/lib/data/schools.ts` — add fetchSchoolById

Add to `src/lib/data/schools.ts`:

```typescript
export async function fetchSchoolById(id: string) {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("schools")
    .select(`*, regions (id, name)`)
    .eq("id", id)
    .single();

  if (error) throw error;
  return data;
}
```

Commit: `git add src/lib/data/schools.ts && git commit -m "feat: add fetchSchoolById data function"`

---

### Task 4: Lifecycle Progress Tracker Component

**Files:**
- Create: `src/components/ramps/lifecycle-tracker.tsx`

```typescript
import { cn } from "@/lib/utils";
import { Check } from "lucide-react";
import type { LifecycleStage } from "@/lib/types/database";

const stages: { key: LifecycleStage; label: string }[] = [
  { key: "design", label: "Design" },
  { key: "construction", label: "Construction" },
  { key: "admin_closeout", label: "Admin Closeout" },
  { key: "dlp", label: "DLP" },
  { key: "final_closure", label: "Final Closure" },
];

interface LifecycleTrackerProps {
  currentStage: LifecycleStage;
}

export function LifecycleTracker({ currentStage }: LifecycleTrackerProps) {
  const currentIndex = stages.findIndex((s) => s.key === currentStage);

  return (
    <div className="flex items-center gap-1">
      {stages.map((stage, i) => {
        const isComplete = i < currentIndex;
        const isCurrent = i === currentIndex;

        return (
          <div key={stage.key} className="flex items-center">
            <div className="flex flex-col items-center">
              <div
                className={cn(
                  "flex h-8 w-8 items-center justify-center rounded-full border-2 text-xs font-medium",
                  isComplete && "border-vsba-red bg-vsba-red text-white",
                  isCurrent && "border-vsba-red bg-white text-vsba-red",
                  !isComplete && !isCurrent && "border-muted bg-white text-muted-foreground"
                )}
              >
                {isComplete ? <Check className="h-4 w-4" /> : i + 1}
              </div>
              <span
                className={cn(
                  "mt-1 text-[10px] font-medium text-center w-16",
                  isCurrent ? "text-vsba-red" : "text-muted-foreground"
                )}
              >
                {stage.label}
              </span>
            </div>
            {i < stages.length - 1 && (
              <div
                className={cn(
                  "mb-5 h-0.5 w-6",
                  i < currentIndex ? "bg-vsba-red" : "bg-muted"
                )}
              />
            )}
          </div>
        );
      })}
    </div>
  );
}
```

Commit: `git add src/components/ramps/lifecycle-tracker.tsx && git commit -m "feat: add lifecycle progress tracker component"`

---

### Task 5: Ramp Slide-Over Panel

**Files:**
- Create: `src/components/ramps/ramp-slide-over.tsx`

```typescript
"use client";

import { useState } from "react";
import {
  Sheet,
  SheetContent,
  SheetHeader,
  SheetTitle,
} from "@/components/ui/sheet";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { LifecycleTracker } from "./lifecycle-tracker";
import { updateRamp } from "@/lib/data/ramps";
import type { Ramp, RampStatus, LifecycleStage } from "@/lib/types/database";

interface RampSlideOverProps {
  ramp: Ramp | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
  canEdit: boolean;
  onRampUpdated: (ramp: Ramp) => void;
}

const statusOptions: { value: RampStatus; label: string }[] = [
  { value: "active", label: "Active" },
  { value: "on_hold", label: "On Hold" },
  { value: "completed", label: "Completed" },
  { value: "blocked", label: "Blocked" },
];

const stageOptions: { value: LifecycleStage; label: string }[] = [
  { value: "design", label: "Design" },
  { value: "construction", label: "Construction" },
  { value: "admin_closeout", label: "Admin Closeout" },
  { value: "dlp", label: "DLP" },
  { value: "final_closure", label: "Final Closure" },
];

const statusBadgeVariant: Record<string, "default" | "secondary" | "outline" | "destructive"> = {
  active: "default",
  on_hold: "secondary",
  completed: "outline",
  blocked: "destructive",
};

export function RampSlideOver({
  ramp,
  open,
  onOpenChange,
  canEdit,
  onRampUpdated,
}: RampSlideOverProps) {
  const [status, setStatus] = useState<RampStatus>(ramp?.status ?? "active");
  const [stage, setStage] = useState<LifecycleStage>(ramp?.lifecycle_stage ?? "design");
  const [commentary, setCommentary] = useState(ramp?.commentary ?? "");
  const [saving, setSaving] = useState(false);

  // Reset form when ramp changes
  if (ramp && (status !== ramp.status || stage !== ramp.lifecycle_stage) && !saving) {
    setStatus(ramp.status);
    setStage(ramp.lifecycle_stage);
    setCommentary(ramp.commentary ?? "");
  }

  const handleSave = async () => {
    if (!ramp) return;
    setSaving(true);
    try {
      const updated = await updateRamp(ramp.id, {
        status,
        lifecycle_stage: stage,
        commentary,
      });
      onRampUpdated(updated);
    } catch (err) {
      console.error("Failed to update ramp:", err);
    } finally {
      setSaving(false);
    }
  };

  if (!ramp) return null;

  const formatCurrency = (amount: number) =>
    new Intl.NumberFormat("en-AU", { style: "currency", currency: "AUD" }).format(amount);

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent className="w-full sm:max-w-lg overflow-y-auto">
        <SheetHeader>
          <SheetTitle className="text-vsba-charcoal">{ramp.name}</SheetTitle>
          {ramp.description && (
            <p className="text-sm text-muted-foreground">{ramp.description}</p>
          )}
        </SheetHeader>

        <div className="mt-6 space-y-6">
          {/* Lifecycle Progress */}
          <div>
            <h3 className="mb-3 text-sm font-medium text-vsba-charcoal">
              Lifecycle Progress
            </h3>
            <LifecycleTracker currentStage={canEdit ? stage : ramp.lifecycle_stage} />
          </div>

          <Separator />

          {/* Status & Stage */}
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="text-sm font-medium">Status</label>
              {canEdit ? (
                <Select value={status} onValueChange={(v) => setStatus(v as RampStatus)}>
                  <SelectTrigger className="mt-1">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {statusOptions.map((opt) => (
                      <SelectItem key={opt.value} value={opt.value}>
                        {opt.label}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              ) : (
                <div className="mt-1">
                  <Badge variant={statusBadgeVariant[ramp.status]}>
                    {statusOptions.find((o) => o.value === ramp.status)?.label}
                  </Badge>
                </div>
              )}
            </div>
            <div>
              <label className="text-sm font-medium">Lifecycle Stage</label>
              {canEdit ? (
                <Select value={stage} onValueChange={(v) => setStage(v as LifecycleStage)}>
                  <SelectTrigger className="mt-1">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {stageOptions.map((opt) => (
                      <SelectItem key={opt.value} value={opt.value}>
                        {opt.label}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              ) : (
                <p className="mt-1 text-sm">
                  {stageOptions.find((o) => o.value === ramp.lifecycle_stage)?.label}
                </p>
              )}
            </div>
          </div>

          <Separator />

          {/* Financials (read-only summary for now) */}
          <div>
            <h3 className="mb-3 text-sm font-medium text-vsba-charcoal">Financials</h3>
            <div className="grid grid-cols-3 gap-4 text-sm">
              <div>
                <p className="text-muted-foreground">Budget</p>
                <p className="font-medium">{formatCurrency(ramp.budget_amount)}</p>
              </div>
              <div>
                <p className="text-muted-foreground">Actual</p>
                <p className="font-medium">{formatCurrency(ramp.actual_amount)}</p>
              </div>
              <div>
                <p className="text-muted-foreground">Forecast</p>
                <p className="font-medium">{formatCurrency(ramp.forecast_amount)}</p>
              </div>
            </div>
          </div>

          <Separator />

          {/* Commentary */}
          <div>
            <label className="text-sm font-medium">Commentary</label>
            {canEdit ? (
              <textarea
                className="mt-1 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
                rows={4}
                value={commentary}
                onChange={(e) => setCommentary(e.target.value)}
                placeholder="Add status commentary..."
              />
            ) : (
              <p className="mt-1 text-sm text-muted-foreground">
                {ramp.commentary || "No commentary."}
              </p>
            )}
          </div>

          {/* Save Button */}
          {canEdit && (
            <Button onClick={handleSave} disabled={saving} className="w-full">
              {saving ? "Saving..." : "Save Changes"}
            </Button>
          )}
        </div>
      </SheetContent>
    </Sheet>
  );
}
```

Commit: `git add src/components/ramps/ramp-slide-over.tsx && git commit -m "feat: add ramp slide-over panel with lifecycle tracker and editing"`

---

### Task 6: School View Page

**Files:**
- Replace: `src/app/(authenticated)/schools/[id]/page.tsx`

```typescript
"use client";

import { useEffect, useState, use } from "react";
import { useRouter } from "next/navigation";
import { fetchSchoolById } from "@/lib/data/schools";
import { fetchRampsBySchool } from "@/lib/data/ramps";
import { useAuth } from "@/lib/auth/provider";
import { useCanWrite } from "@/lib/auth/hooks";
import { RampSlideOver } from "@/components/ramps/ramp-slide-over";
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
import type { Ramp, SchoolWithRegion } from "@/lib/types/database";

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
  const [loading, setLoading] = useState(true);
  const [selectedRamp, setSelectedRamp] = useState<Ramp | null>(null);
  const [slideOverOpen, setSlideOverOpen] = useState(false);
  const [sortKey, setSortKey] = useState<SortKey>("name");
  const [sortDir, setSortDir] = useState<SortDir>("asc");

  useEffect(() => {
    const load = async () => {
      try {
        const [schoolData, rampsData] = await Promise.all([
          fetchSchoolById(id),
          fetchRampsBySchool(id),
        ]);
        setSchool(schoolData);
        setRamps(rampsData);
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
      {/* Back navigation */}
      <Button variant="ghost" size="sm" onClick={() => router.push("/")}>
        <ArrowLeft className="mr-2 h-4 w-4" />
        Back to Dashboard
      </Button>

      {/* School Header */}
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
            <Badge variant={statusBadgeVariant[school.status] ?? "outline"}>
              {statusLabels[school.status] ?? school.status}
            </Badge>
          </div>
        </CardContent>
      </Card>

      {/* Ramps Table */}
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
                    className="cursor-pointer hover:bg-vsba-teal/10"
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

      {/* Ramp Slide-Over */}
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
```

Commit: `git add src/app/\(authenticated\)/schools/\[id\]/page.tsx && git commit -m "feat: build School View with ramps table and slide-over panel"`

---

### Task 7: Update Dashboard ramp_count

**Files:**
- Modify: `src/lib/data/schools.ts` — update fetchSchools to include ramp count

Update the `fetchSchools` function to get actual ramp counts:

```typescript
export async function fetchSchools(): Promise<SchoolWithRegion[]> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("schools")
    .select(`
      *,
      regions (id, name),
      ramps (id)
    `)
    .order("name");

  if (error) throw error;

  return (data ?? []).map((school: any) => ({
    ...school,
    ramp_count: school.ramps?.length ?? 0,
    ramps: undefined,
  }));
}
```

Commit: `git add src/lib/data/schools.ts && git commit -m "feat: include ramp count in schools query"`
