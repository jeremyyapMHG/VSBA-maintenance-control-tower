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
