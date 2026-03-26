"use client";

import { useState, useEffect } from "react";
import {
  Sheet,
  SheetContent,
  SheetHeader,
  SheetTitle,
} from "@/components/ui/sheet";
import { Button } from "@/components/ui/button";
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
import { MilestonesSection } from "./milestones-section";
import { FinancialsSection } from "./financials-section";
import { DefectsSection } from "./defects-section";
import { AttachmentsSection } from "./attachments-section";
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

  useEffect(() => {
    if (ramp) {
      setStatus(ramp.status);
      setStage(ramp.lifecycle_stage);
      setCommentary(ramp.commentary ?? "");
    }
  }, [ramp]);

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
          <div>
            <h3 className="mb-3 text-sm font-medium text-vsba-charcoal">
              Lifecycle Progress
            </h3>
            <LifecycleTracker currentStage={canEdit ? stage : ramp.lifecycle_stage} />
          </div>

          <Separator />

          {/* Milestones */}
          <MilestonesSection rampId={ramp.id} canEdit={canEdit} />

          <Separator />

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

          <FinancialsSection ramp={ramp} canEdit={canEdit} onRampUpdated={onRampUpdated} />

          <Separator />

          <DefectsSection rampId={ramp.id} canEdit={canEdit} />

          <Separator />

          <AttachmentsSection rampId={ramp.id} canEdit={canEdit} />

          <Separator />

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
