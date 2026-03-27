import { createClient } from "@/lib/supabase/client";
import type { Variation, VariationStatus } from "@/lib/types/database";

export async function fetchVariationsByRamp(rampId: string): Promise<Variation[]> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("variations")
    .select("*")
    .eq("ramp_id", rampId)
    .order("created_at", { ascending: false });

  if (error) throw error;
  return data ?? [];
}

export async function createVariation(
  rampId: string,
  variation: { description: string; amount: number; status: VariationStatus; date?: string }
): Promise<Variation> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("variations")
    .insert({
      ramp_id: rampId,
      ...variation,
      date: variation.date || null,
    })
    .select()
    .single();

  if (error) throw error;
  return data;
}

export async function updateVariation(
  id: string,
  updates: Partial<Pick<Variation, "description" | "amount" | "status" | "date">>
): Promise<Variation> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("variations")
    .update(updates)
    .eq("id", id)
    .select()
    .single();

  if (error) throw error;
  return data;
}

export async function deleteVariation(id: string): Promise<void> {
  const supabase = createClient();
  const { error } = await supabase.from("variations").delete().eq("id", id);
  if (error) throw error;
}

export async function fetchVariationsBySchool(schoolId: string): Promise<Variation[]> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("variations")
    .select("*, ramps!inner(school_id)")
    .eq("ramps.school_id", schoolId);

  if (error) throw error;
  return (data ?? []).map((v: any) => ({ ...v, ramps: undefined }));
}
