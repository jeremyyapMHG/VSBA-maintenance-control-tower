import { createClient } from "@/lib/supabase/client";
import type { Attachment, FileType } from "@/lib/types/database";

const BUCKET = "ramp-attachments";
const MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB

export async function fetchAttachmentsByRamp(rampId: string): Promise<Attachment[]> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("attachments")
    .select("*")
    .eq("ramp_id", rampId)
    .order("created_at", { ascending: false });

  if (error) throw error;
  return data ?? [];
}

export async function uploadAttachment(
  rampId: string,
  file: File,
  fileType: FileType
): Promise<Attachment> {
  if (file.size > MAX_FILE_SIZE) {
    throw new Error("File size exceeds 10MB limit");
  }

  const supabase = createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const filePath = `${rampId}/${Date.now()}-${file.name}`;

  // Upload to storage
  const { error: uploadError } = await supabase.storage
    .from(BUCKET)
    .upload(filePath, file);

  if (uploadError) throw uploadError;

  // Create attachment record
  const { data, error } = await supabase
    .from("attachments")
    .insert({
      ramp_id: rampId,
      file_name: file.name,
      file_path: filePath,
      file_type: fileType,
      file_size: file.size,
      uploaded_by: user?.id ?? null,
    })
    .select()
    .single();

  if (error) throw error;
  return data;
}

export async function downloadAttachment(filePath: string): Promise<string> {
  const supabase = createClient();
  const { data, error } = await supabase.storage
    .from(BUCKET)
    .createSignedUrl(filePath, 60);

  if (error) throw error;
  return data.signedUrl;
}

export async function deleteAttachment(id: string, filePath: string): Promise<void> {
  const supabase = createClient();

  // Delete from storage
  await supabase.storage.from(BUCKET).remove([filePath]);

  // Delete record
  const { error } = await supabase.from("attachments").delete().eq("id", id);
  if (error) throw error;
}
