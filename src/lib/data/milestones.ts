import { createClient } from "@/lib/supabase/client";
import type { Milestone } from "@/lib/types/database";

export async function fetchMilestonesByRamp(rampId: string): Promise<Milestone[]> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("milestones")
    .select("*")
    .eq("ramp_id", rampId)
    .order("sort_order")
    .order("created_at");

  if (error) throw error;
  return data ?? [];
}

export async function updateMilestone(
  id: string,
  updates: Partial<Pick<Milestone, "planned_date" | "actual_date" | "name">>
): Promise<Milestone> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("milestones")
    .update(updates)
    .eq("id", id)
    .select()
    .single();

  if (error) throw error;
  return data;
}

export async function createInterimMilestone(
  rampId: string,
  name: string,
  plannedDate?: string
): Promise<Milestone> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("milestones")
    .insert({
      ramp_id: rampId,
      name,
      type: "interim",
      planned_date: plannedDate || null,
      sort_order: 100, // Interim milestones sort after core
    })
    .select()
    .single();

  if (error) throw error;
  return data;
}

export async function deleteMilestone(id: string): Promise<void> {
  const supabase = createClient();
  const { error } = await supabase
    .from("milestones")
    .delete()
    .eq("id", id);

  if (error) throw error;
}
