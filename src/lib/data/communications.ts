import { createClient } from "@/lib/supabase/client";
import type { Communication, CommMethod } from "@/lib/types/database";

export async function fetchCommunicationsBySchool(
  schoolId: string
): Promise<Communication[]> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("communications")
    .select("*")
    .eq("school_id", schoolId)
    .order("date", { ascending: false });

  if (error) throw error;
  return data ?? [];
}

export async function createCommunication(
  schoolId: string,
  comm: { date: string; method: CommMethod; summary: string }
): Promise<Communication> {
  const supabase = createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const { data, error } = await supabase
    .from("communications")
    .insert({
      school_id: schoolId,
      ...comm,
      logged_by: user?.id ?? null,
    })
    .select()
    .single();

  if (error) throw error;
  return data;
}
