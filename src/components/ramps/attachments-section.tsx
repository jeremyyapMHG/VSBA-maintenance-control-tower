"use client";

import { useEffect, useState, useRef } from "react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  fetchAttachmentsByRamp,
  uploadAttachment,
  downloadAttachment,
  deleteAttachment,
} from "@/lib/data/attachments";
import { Upload, Download, Trash2, FileText, Image, Check, X } from "lucide-react";
import type { Attachment, FileType } from "@/lib/types/database";

interface AttachmentsSectionProps {
  rampId: string;
  canEdit: boolean;
}

const fileTypeLabels: Record<FileType, string> = {
  cfi: "CFI",
  school_signoff: "School Signoff",
  photo: "Photo",
  other: "Other",
};

const fileTypeBadge: Record<FileType, "default" | "secondary" | "outline"> = {
  cfi: "default",
  school_signoff: "default",
  photo: "secondary",
  other: "outline",
};

export function AttachmentsSection({ rampId, canEdit }: AttachmentsSectionProps) {
  const [attachments, setAttachments] = useState<Attachment[]>([]);
  const [loading, setLoading] = useState(true);
  const [uploading, setUploading] = useState(false);
  const [fileType, setFileType] = useState<FileType>("other");
  const [error, setError] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    const load = async () => {
      try {
        const data = await fetchAttachmentsByRamp(rampId);
        setAttachments(data);
      } catch (err) {
        console.error("Failed to load attachments:", err);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, [rampId]);

  const hasCfi = attachments.some((a) => a.file_type === "cfi");
  const hasSignoff = attachments.some((a) => a.file_type === "school_signoff");

  const handleUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    setError(null);
    setUploading(true);
    try {
      const created = await uploadAttachment(rampId, file, fileType);
      setAttachments((prev) => [created, ...prev]);
    } catch (err: any) {
      setError(err.message ?? "Upload failed");
    } finally {
      setUploading(false);
      if (fileInputRef.current) fileInputRef.current.value = "";
    }
  };

  const handleDownload = async (filePath: string) => {
    try {
      const url = await downloadAttachment(filePath);
      window.open(url, "_blank");
    } catch (err) {
      console.error("Download failed:", err);
    }
  };

  const handleDelete = async (attachment: Attachment) => {
    try {
      await deleteAttachment(attachment.id, attachment.file_path);
      setAttachments((prev) => prev.filter((a) => a.id !== attachment.id));
    } catch (err) {
      console.error("Delete failed:", err);
    }
  };

  const formatSize = (bytes: number | null) => {
    if (!bytes) return "";
    if (bytes < 1024) return `${bytes}B`;
    if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)}KB`;
    return `${(bytes / (1024 * 1024)).toFixed(1)}MB`;
  };

  return (
    <div className="space-y-3">
      <h3 className="text-sm font-medium text-vsba-charcoal">Attachments</h3>

      {/* Admin Closeout Checklist */}
      <div className="rounded-md bg-muted/50 p-3 space-y-1">
        <p className="text-xs font-medium text-muted-foreground uppercase tracking-wide">
          Admin Closeout
        </p>
        <div className="flex items-center gap-4 text-sm">
          <div className="flex items-center gap-1.5">
            {hasCfi ? (
              <Check className="h-4 w-4 text-emerald-600" />
            ) : (
              <X className="h-4 w-4 text-red-400" />
            )}
            <span>CFI</span>
          </div>
          <div className="flex items-center gap-1.5">
            {hasSignoff ? (
              <Check className="h-4 w-4 text-emerald-600" />
            ) : (
              <X className="h-4 w-4 text-red-400" />
            )}
            <span>School Signoff</span>
          </div>
        </div>
      </div>

      {/* Upload Form */}
      {canEdit && (
        <div className="flex items-center gap-2">
          <Select value={fileType} onValueChange={(v) => setFileType(v as FileType)}>
            <SelectTrigger className="h-8 w-36 text-sm">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="cfi">CFI</SelectItem>
              <SelectItem value="school_signoff">School Signoff</SelectItem>
              <SelectItem value="photo">Photo</SelectItem>
              <SelectItem value="other">Other</SelectItem>
            </SelectContent>
          </Select>
          <input
            ref={fileInputRef}
            type="file"
            className="hidden"
            onChange={handleUpload}
          />
          <Button
            size="sm"
            variant="outline"
            className="h-8"
            onClick={() => fileInputRef.current?.click()}
            disabled={uploading}
          >
            <Upload className="mr-1 h-3.5 w-3.5" />
            {uploading ? "Uploading..." : "Upload"}
          </Button>
        </div>
      )}

      {error && <p className="text-sm text-destructive">{error}</p>}

      {/* Attachments List */}
      {loading ? (
        <p className="text-sm text-muted-foreground">Loading...</p>
      ) : attachments.length === 0 ? (
        <p className="text-sm text-muted-foreground">No attachments.</p>
      ) : (
        <div className="space-y-1">
          {attachments.map((a) => (
            <div key={a.id} className="flex items-center gap-2 rounded-md border p-2 text-sm">
              {a.file_type === "photo" ? (
                <Image className="h-4 w-4 text-muted-foreground" />
              ) : (
                <FileText className="h-4 w-4 text-muted-foreground" />
              )}
              <div className="flex-1 min-w-0">
                <p className="truncate font-medium">{a.file_name}</p>
                <p className="text-[10px] text-muted-foreground">
                  {formatSize(a.file_size)} | {new Date(a.created_at).toLocaleDateString()}
                </p>
              </div>
              <Badge variant={fileTypeBadge[a.file_type]} className="text-[10px]">
                {fileTypeLabels[a.file_type]}
              </Badge>
              <Button
                variant="ghost"
                size="sm"
                className="h-7 w-7 p-0"
                onClick={() => handleDownload(a.file_path)}
              >
                <Download className="h-3.5 w-3.5" />
              </Button>
              {canEdit && (
                <Button
                  variant="ghost"
                  size="sm"
                  className="h-7 w-7 p-0 text-muted-foreground hover:text-destructive"
                  onClick={() => handleDelete(a)}
                >
                  <Trash2 className="h-3.5 w-3.5" />
                </Button>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
