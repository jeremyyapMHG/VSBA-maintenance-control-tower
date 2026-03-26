export interface Program {
  id: string;
  name: string;
  description: string | null;
  created_at: string;
}

export interface Region {
  id: string;
  name: string;
  created_at: string;
}

export type SchoolStatus = "active" | "on_hold" | "completed";

export interface School {
  id: string;
  program_id: string | null;
  region_id: string;
  name: string;
  address: string | null;
  status: SchoolStatus;
  last_communication_date: string | null;
  created_at: string;
  updated_at: string;
}

export interface SchoolWithRegion extends School {
  regions: Region;
  ramp_count: number;
}

export type LifecycleStage = "design" | "construction" | "admin_closeout" | "dlp" | "final_closure";
export type RampStatus = "active" | "on_hold" | "completed" | "blocked";

export interface Ramp {
  id: string;
  school_id: string;
  name: string;
  description: string | null;
  lifecycle_stage: LifecycleStage;
  status: RampStatus;
  commentary: string | null;
  budget_amount: number;
  actual_amount: number;
  forecast_amount: number;
  created_at: string;
  updated_at: string;
}

export type VariationStatus = "pending" | "approved" | "rejected";

export interface Variation {
  id: string;
  ramp_id: string;
  description: string;
  amount: number;
  status: VariationStatus;
  date: string | null;
  created_at: string;
}

export type MilestoneType = "core" | "interim";

export interface Milestone {
  id: string;
  ramp_id: string;
  name: string;
  type: MilestoneType;
  planned_date: string | null;
  actual_date: string | null;
  sort_order: number;
  created_at: string;
}

export type DefectStatus = "open" | "resolved";

export interface Defect {
  id: string;
  ramp_id: string;
  description: string;
  status: DefectStatus;
  identified_date: string;
  resolved_date: string | null;
  created_at: string;
}

export type CommMethod = "email" | "phone" | "in_person" | "other";

export interface Communication {
  id: string;
  school_id: string;
  date: string;
  method: CommMethod;
  summary: string;
  logged_by: string | null;
  created_at: string;
}

export type FileType = "cfi" | "school_signoff" | "photo" | "other";

export interface Attachment {
  id: string;
  ramp_id: string;
  file_name: string;
  file_path: string;
  file_type: FileType;
  file_size: number | null;
  uploaded_by: string | null;
  created_at: string;
}
