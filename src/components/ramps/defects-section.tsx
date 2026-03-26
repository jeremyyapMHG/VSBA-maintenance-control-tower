"use client";

import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import {
  fetchDefectsByRamp,
  createDefect,
  toggleDefectStatus,
  deleteDefect,
} from "@/lib/data/defects";
import { Plus, Trash2, Check, AlertCircle } from "lucide-react";
import type { Defect } from "@/lib/types/database";

interface DefectsSectionProps {
  rampId: string;
  canEdit: boolean;
}

export function DefectsSection({ rampId, canEdit }: DefectsSectionProps) {
  const [defects, setDefects] = useState<Defect[]>([]);
  const [loading, setLoading] = useState(true);
  const [newDesc, setNewDesc] = useState("");
  const [adding, setAdding] = useState(false);

  useEffect(() => {
    const load = async () => {
      try {
        const data = await fetchDefectsByRamp(rampId);
        setDefects(data);
      } catch (err) {
        console.error("Failed to load defects:", err);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, [rampId]);

  const openCount = defects.filter((d) => d.status === "open").length;
  const resolvedCount = defects.filter((d) => d.status === "resolved").length;

  const handleAdd = async () => {
    if (!newDesc.trim()) return;
    setAdding(true);
    try {
      const created = await createDefect(rampId, newDesc);
      setDefects((prev) => [created, ...prev]);
      setNewDesc("");
    } catch (err) {
      console.error("Failed to add defect:", err);
    } finally {
      setAdding(false);
    }
  };

  const handleToggle = async (defect: Defect) => {
    try {
      const updated = await toggleDefectStatus(defect);
      setDefects((prev) => prev.map((d) => (d.id === updated.id ? updated : d)));
    } catch (err) {
      console.error("Failed to toggle defect:", err);
    }
  };

  const handleDelete = async (id: string) => {
    try {
      await deleteDefect(id);
      setDefects((prev) => prev.filter((d) => d.id !== id));
    } catch (err) {
      console.error("Failed to delete defect:", err);
    }
  };

  return (
    <div className="space-y-3">
      <div className="flex items-center justify-between">
        <h3 className="text-sm font-medium text-vsba-charcoal">Defects</h3>
        <div className="flex gap-2 text-xs">
          <Badge variant="destructive" className="text-[10px]">
            {openCount} open
          </Badge>
          <Badge variant="outline" className="text-[10px]">
            {resolvedCount} resolved
          </Badge>
        </div>
      </div>

      {loading ? (
        <p className="text-sm text-muted-foreground">Loading...</p>
      ) : defects.length === 0 ? (
        <p className="text-sm text-muted-foreground">No defects recorded.</p>
      ) : (
        <div className="space-y-2">
          {defects.map((d) => (
            <div key={d.id} className="flex items-start gap-2 rounded-md border p-2 text-sm">
              {canEdit ? (
                <Button
                  variant="ghost"
                  size="sm"
                  className="h-6 w-6 p-0 mt-0.5"
                  onClick={() => handleToggle(d)}
                >
                  {d.status === "resolved" ? (
                    <Check className="h-4 w-4 text-emerald-600" />
                  ) : (
                    <AlertCircle className="h-4 w-4 text-red-500" />
                  )}
                </Button>
              ) : d.status === "resolved" ? (
                <Check className="h-4 w-4 text-emerald-600 mt-0.5" />
              ) : (
                <AlertCircle className="h-4 w-4 text-red-500 mt-0.5" />
              )}
              <div className="flex-1 min-w-0">
                <p className={d.status === "resolved" ? "line-through text-muted-foreground" : ""}>
                  {d.description}
                </p>
                <p className="text-[10px] text-muted-foreground">
                  Identified: {d.identified_date}
                  {d.resolved_date && ` | Resolved: ${d.resolved_date}`}
                </p>
              </div>
              {canEdit && (
                <Button
                  variant="ghost"
                  size="sm"
                  className="h-6 w-6 p-0 text-muted-foreground hover:text-destructive"
                  onClick={() => handleDelete(d.id)}
                >
                  <Trash2 className="h-3.5 w-3.5" />
                </Button>
              )}
            </div>
          ))}
        </div>
      )}

      {canEdit && (
        <div className="flex gap-2">
          <Input
            placeholder="Describe defect..."
            value={newDesc}
            onChange={(e) => setNewDesc(e.target.value)}
            className="h-8 text-sm"
            onKeyDown={(e) => e.key === "Enter" && handleAdd()}
          />
          <Button size="sm" className="h-8" onClick={handleAdd} disabled={adding || !newDesc.trim()}>
            <Plus className="mr-1 h-3.5 w-3.5" />
            Add
          </Button>
        </div>
      )}
    </div>
  );
}
