import { createClient } from "@/lib/supabase/client";
import type { Defect } from "@/lib/types/database";

export async function fetchDefectsByRamp(rampId: string): Promise<Defect[]> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("defects")
    .select("*")
    .eq("ramp_id", rampId)
    .order("identified_date", { ascending: false });

  if (error) throw error;
  return data ?? [];
}

export async function createDefect(
  rampId: string,
  description: string
): Promise<Defect> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("defects")
    .insert({ ramp_id: rampId, description })
    .select()
    .single();

  if (error) throw error;
  return data;
}

export async function toggleDefectStatus(defect: Defect): Promise<Defect> {
  const supabase = createClient();
  const newStatus = defect.status === "open" ? "resolved" : "open";
  const { data, error } = await supabase
    .from("defects")
    .update({
      status: newStatus,
      resolved_date: newStatus === "resolved" ? new Date().toISOString().split("T")[0] : null,
    })
    .eq("id", defect.id)
    .select()
    .single();

  if (error) throw error;
  return data;
}

export async function deleteDefect(id: string): Promise<void> {
  const supabase = createClient();
  const { error } = await supabase.from("defects").delete().eq("id", id);
  if (error) throw error;
}
