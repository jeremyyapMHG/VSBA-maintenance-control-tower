import { createClient } from "@/lib/supabase/client";
import type { Region, SchoolWithRegion } from "@/lib/types/database";

export async function fetchSchools(): Promise<SchoolWithRegion[]> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("schools")
    .select(`
      *,
      regions (id, name)
    `)
    .order("name");

  if (error) throw error;

  return (data ?? []).map((school: any) => ({
    ...school,
    ramp_count: 0,
  }));
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
