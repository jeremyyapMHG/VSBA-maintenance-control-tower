export type UserRole = "government" | "end_user" | "delivery_team" | "admin";

export interface UserProfile {
  id: string;
  auth_user_id: string;
  role: UserRole;
  organization: string | null;
  assigned_school_ids: string[];
  assigned_ramp_ids: string[];
  created_at: string;
  updated_at: string;
}
