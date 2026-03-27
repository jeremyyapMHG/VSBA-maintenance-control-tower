import { createClient } from "@/lib/supabase/client";
import type { Region, SchoolWithRegion, Ramp, Milestone, Variation, Defect } from "@/lib/types/database";

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

export async function fetchDashboardData() {
  const supabase = createClient();

  const [schoolsRes, rampsRes, milestonesRes, variationsRes, defectsRes] = await Promise.all([
    supabase.from("schools").select("*, regions (id, name)").order("name"),
    supabase.from("ramps").select("*").order("name"),
    supabase.from("milestones").select("*").order("sort_order"),
    supabase.from("variations").select("*"),
    supabase.from("defects").select("*"),
  ]);

  return {
    schools: (schoolsRes.data ?? []).map((s: any) => ({ ...s, ramp_count: 0 })) as SchoolWithRegion[],
    ramps: (rampsRes.data ?? []) as Ramp[],
    milestones: (milestonesRes.data ?? []) as Milestone[],
    variations: (variationsRes.data ?? []) as Variation[],
    defects: (defectsRes.data ?? []) as Defect[],
  };
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
