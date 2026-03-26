import { createClient } from "@/lib/supabase/client";
import type { Region, SchoolWithRegion } from "@/lib/types/database";

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

export async function fetchRegions(): Promise<Region[]> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("regions")
    .select("*")
    .order("name");

  if (error) throw error;
  return data ?? [];
}
