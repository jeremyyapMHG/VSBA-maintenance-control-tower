"use client";

import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { TrafficLightIndicator } from "@/components/ui/traffic-light";
import {
  fetchMilestonesByRamp,
  updateMilestone,
  createInterimMilestone,
  deleteMilestone,
} from "@/lib/data/milestones";
import { getMilestoneTrafficLight } from "@/lib/traffic-lights";
import { Plus, Trash2 } from "lucide-react";
import type { Milestone } from "@/lib/types/database";

interface MilestonesSectionProps {
  rampId: string;
  canEdit: boolean;
}

export function MilestonesSection({ rampId, canEdit }: MilestonesSectionProps) {
  const [milestones, setMilestones] = useState<Milestone[]>([]);
  const [loading, setLoading] = useState(true);
  const [newName, setNewName] = useState("");
  const [newDate, setNewDate] = useState("");
  const [adding, setAdding] = useState(false);

  useEffect(() => {
    const load = async () => {
      try {
        const data = await fetchMilestonesByRamp(rampId);
        setMilestones(data);
      } catch (err) {
        console.error("Failed to load milestones:", err);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, [rampId]);

  const handleDateChange = async (
    milestone: Milestone,
    field: "planned_date" | "actual_date",
    value: string
  ) => {
    try {
      const updated = await updateMilestone(milestone.id, {
        [field]: value || null,
      });
      setMilestones((prev) =>
        prev.map((m) => (m.id === updated.id ? updated : m))
      );
    } catch (err) {
      console.error("Failed to update milestone:", err);
    }
  };

  const handleAddInterim = async () => {
    if (!newName.trim()) return;
    setAdding(true);
    try {
      const created = await createInterimMilestone(rampId, newName, newDate || undefined);
      setMilestones((prev) => [...prev, created]);
      setNewName("");
      setNewDate("");
    } catch (err) {
      console.error("Failed to add milestone:", err);
    } finally {
      setAdding(false);
    }
  };

  const handleDelete = async (id: string) => {
    try {
      await deleteMilestone(id);
      setMilestones((prev) => prev.filter((m) => m.id !== id));
    } catch (err) {
      console.error("Failed to delete milestone:", err);
    }
  };

  if (loading) {
    return <p className="text-sm text-muted-foreground">Loading milestones...</p>;
  }

  return (
    <div className="space-y-3">
      <h3 className="text-sm font-medium text-vsba-charcoal">Milestones</h3>

      <div className="space-y-2">
        {milestones.map((m) => {
          const light = getMilestoneTrafficLight(m.planned_date, m.actual_date);
          return (
            <div
              key={m.id}
              className="flex items-center gap-3 rounded-md border p-3 text-sm"
            >
              <TrafficLightIndicator status={light} />
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2">
                  <span className="font-medium truncate">{m.name}</span>
                  {m.type === "core" && (
                    <Badge variant="outline" className="text-[10px] px-1.5 py-0">
                      Core
                    </Badge>
                  )}
                </div>
              </div>
              <div className="flex items-center gap-2">
                {canEdit ? (
                  <>
                    <Input
                      type="date"
                      value={m.planned_date ?? ""}
                      onChange={(e) => handleDateChange(m, "planned_date", e.target.value)}
                      className="h-7 w-32 text-xs"
                      title="Planned date"
                    />
                    <Input
                      type="date"
                      value={m.actual_date ?? ""}
                      onChange={(e) => handleDateChange(m, "actual_date", e.target.value)}
                      className="h-7 w-32 text-xs"
                      title="Actual date"
                    />
                  </>
                ) : (
                  <>
                    <span className="text-xs text-muted-foreground w-24">
                      P: {m.planned_date ?? "\u2014"}
                    </span>
                    <span className="text-xs text-muted-foreground w-24">
                      A: {m.actual_date ?? "\u2014"}
                    </span>
                  </>
                )}
                {canEdit && m.type === "interim" && (
                  <Button
                    variant="ghost"
                    size="sm"
                    className="h-7 w-7 p-0 text-muted-foreground hover:text-destructive"
                    onClick={() => handleDelete(m.id)}
                  >
                    <Trash2 className="h-3.5 w-3.5" />
                  </Button>
                )}
              </div>
            </div>
          );
        })}
      </div>

      {canEdit && (
        <div className="flex items-end gap-2 pt-2">
          <div className="flex-1">
            <Input
              placeholder="Interim milestone name"
              value={newName}
              onChange={(e) => setNewName(e.target.value)}
              className="h-8 text-sm"
            />
          </div>
          <Input
            type="date"
            value={newDate}
            onChange={(e) => setNewDate(e.target.value)}
            className="h-8 w-36 text-sm"
          />
          <Button
            size="sm"
            className="h-8"
            onClick={handleAddInterim}
            disabled={adding || !newName.trim()}
          >
            <Plus className="mr-1 h-3.5 w-3.5" />
            Add
          </Button>
        </div>
      )}
    </div>
  );
}
