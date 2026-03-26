"use client";

import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { TrafficLightIndicator } from "@/components/ui/traffic-light";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  fetchVariationsByRamp,
  createVariation,
  deleteVariation,
} from "@/lib/data/variations";
import { updateRamp } from "@/lib/data/ramps";
import { getFinancialTrafficLight } from "@/lib/traffic-lights";
import { Plus, Trash2 } from "lucide-react";
import type { Ramp, Variation, VariationStatus } from "@/lib/types/database";

interface FinancialsSectionProps {
  ramp: Ramp;
  canEdit: boolean;
  onRampUpdated: (ramp: Ramp) => void;
}

const variationStatusBadge: Record<VariationStatus, "default" | "secondary" | "outline"> = {
  approved: "default",
  pending: "secondary",
  rejected: "outline",
};

export function FinancialsSection({ ramp, canEdit, onRampUpdated }: FinancialsSectionProps) {
  const [variations, setVariations] = useState<Variation[]>([]);
  const [loading, setLoading] = useState(true);
  const [budget, setBudget] = useState(String(ramp.budget_amount));
  const [actual, setActual] = useState(String(ramp.actual_amount));
  const [forecast, setForecast] = useState(String(ramp.forecast_amount));
  const [savingFinancials, setSavingFinancials] = useState(false);

  // New variation form
  const [newDesc, setNewDesc] = useState("");
  const [newAmount, setNewAmount] = useState("");
  const [newStatus, setNewStatus] = useState<VariationStatus>("pending");
  const [adding, setAdding] = useState(false);

  useEffect(() => {
    const load = async () => {
      try {
        const data = await fetchVariationsByRamp(ramp.id);
        setVariations(data);
      } catch (err) {
        console.error("Failed to load variations:", err);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, [ramp.id]);

  useEffect(() => {
    setBudget(String(ramp.budget_amount));
    setActual(String(ramp.actual_amount));
    setForecast(String(ramp.forecast_amount));
  }, [ramp]);

  const totalApproved = variations
    .filter((v) => v.status === "approved")
    .reduce((sum, v) => sum + Number(v.amount), 0);

  const financialLight = getFinancialTrafficLight(
    Number(budget),
    Number(forecast)
  );

  const formatCurrency = (amount: number) =>
    new Intl.NumberFormat("en-AU", { style: "currency", currency: "AUD" }).format(amount);

  const handleSaveFinancials = async () => {
    setSavingFinancials(true);
    try {
      const updated = await updateRamp(ramp.id, {
        budget_amount: Number(budget),
        actual_amount: Number(actual),
        forecast_amount: Number(forecast),
      });
      onRampUpdated(updated);
    } catch (err) {
      console.error("Failed to save financials:", err);
    } finally {
      setSavingFinancials(false);
    }
  };

  const handleAddVariation = async () => {
    if (!newDesc.trim() || !newAmount) return;
    setAdding(true);
    try {
      const created = await createVariation(ramp.id, {
        description: newDesc,
        amount: Number(newAmount),
        status: newStatus,
      });
      setVariations((prev) => [created, ...prev]);
      setNewDesc("");
      setNewAmount("");
      setNewStatus("pending");
    } catch (err) {
      console.error("Failed to add variation:", err);
    } finally {
      setAdding(false);
    }
  };

  const handleDeleteVariation = async (id: string) => {
    try {
      await deleteVariation(id);
      setVariations((prev) => prev.filter((v) => v.id !== id));
    } catch (err) {
      console.error("Failed to delete variation:", err);
    }
  };

  return (
    <div className="space-y-4">
      <div className="flex items-center gap-2">
        <h3 className="text-sm font-medium text-vsba-charcoal">Financials</h3>
        <TrafficLightIndicator status={financialLight} size="md" />
      </div>

      {/* Budget / Actual / Forecast */}
      <div className="grid grid-cols-3 gap-3">
        <div>
          <label className="text-xs text-muted-foreground">Budget</label>
          {canEdit ? (
            <Input
              type="number"
              value={budget}
              onChange={(e) => setBudget(e.target.value)}
              className="mt-1 h-8 text-sm"
            />
          ) : (
            <p className="mt-1 text-sm font-medium">{formatCurrency(ramp.budget_amount)}</p>
          )}
        </div>
        <div>
          <label className="text-xs text-muted-foreground">Actual</label>
          {canEdit ? (
            <Input
              type="number"
              value={actual}
              onChange={(e) => setActual(e.target.value)}
              className="mt-1 h-8 text-sm"
            />
          ) : (
            <p className="mt-1 text-sm font-medium">{formatCurrency(ramp.actual_amount)}</p>
          )}
        </div>
        <div>
          <label className="text-xs text-muted-foreground">Forecast</label>
          {canEdit ? (
            <Input
              type="number"
              value={forecast}
              onChange={(e) => setForecast(e.target.value)}
              className="mt-1 h-8 text-sm"
            />
          ) : (
            <p className="mt-1 text-sm font-medium">{formatCurrency(ramp.forecast_amount)}</p>
          )}
        </div>
      </div>

      {canEdit && (
        <Button
          size="sm"
          variant="outline"
          onClick={handleSaveFinancials}
          disabled={savingFinancials}
        >
          {savingFinancials ? "Saving..." : "Update Financials"}
        </Button>
      )}

      {/* Approved Variations Total */}
      <div className="rounded-md bg-muted/50 p-3">
        <p className="text-xs text-muted-foreground">Total Approved Variations</p>
        <p className="text-lg font-semibold">{formatCurrency(totalApproved)}</p>
      </div>

      {/* Variations List */}
      <div className="space-y-2">
        <h4 className="text-xs font-medium text-muted-foreground uppercase tracking-wide">
          Variations ({variations.length})
        </h4>
        {loading ? (
          <p className="text-sm text-muted-foreground">Loading...</p>
        ) : variations.length === 0 ? (
          <p className="text-sm text-muted-foreground">No variations recorded.</p>
        ) : (
          variations.map((v) => (
            <div key={v.id} className="flex items-center gap-2 rounded-md border p-2 text-sm">
              <div className="flex-1 min-w-0">
                <p className="font-medium truncate">{v.description}</p>
                <p className="text-xs text-muted-foreground">
                  {v.date ? new Date(v.date).toLocaleDateString() : "No date"}
                </p>
              </div>
              <span className={v.amount >= 0 ? "text-red-600" : "text-emerald-600"}>
                {v.amount >= 0 ? "+" : ""}{formatCurrency(v.amount)}
              </span>
              <Badge variant={variationStatusBadge[v.status]}>{v.status}</Badge>
              {canEdit && (
                <Button
                  variant="ghost"
                  size="sm"
                  className="h-7 w-7 p-0 text-muted-foreground hover:text-destructive"
                  onClick={() => handleDeleteVariation(v.id)}
                >
                  <Trash2 className="h-3.5 w-3.5" />
                </Button>
              )}
            </div>
          ))
        )}
      </div>

      {/* Add Variation Form */}
      {canEdit && (
        <div className="space-y-2 rounded-md border p-3">
          <h4 className="text-xs font-medium">Add Variation</h4>
          <Input
            placeholder="Description"
            value={newDesc}
            onChange={(e) => setNewDesc(e.target.value)}
            className="h-8 text-sm"
          />
          <div className="flex gap-2">
            <Input
              type="number"
              placeholder="Amount"
              value={newAmount}
              onChange={(e) => setNewAmount(e.target.value)}
              className="h-8 text-sm flex-1"
            />
            <Select value={newStatus} onValueChange={(v) => setNewStatus(v as VariationStatus)}>
              <SelectTrigger className="h-8 w-28 text-sm">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="pending">Pending</SelectItem>
                <SelectItem value="approved">Approved</SelectItem>
                <SelectItem value="rejected">Rejected</SelectItem>
              </SelectContent>
            </Select>
            <Button size="sm" className="h-8" onClick={handleAddVariation} disabled={adding}>
              <Plus className="h-3.5 w-3.5" />
            </Button>
          </div>
        </div>
      )}
    </div>
  );
}
