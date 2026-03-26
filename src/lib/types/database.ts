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
