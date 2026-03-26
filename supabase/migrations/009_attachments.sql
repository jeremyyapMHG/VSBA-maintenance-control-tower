CREATE TYPE file_type AS ENUM ('cfi', 'school_signoff', 'photo', 'other');

CREATE TABLE attachments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ramp_id UUID NOT NULL REFERENCES ramps(id) ON DELETE CASCADE,
  file_name TEXT NOT NULL,
  file_path TEXT NOT NULL,
  file_type file_type NOT NULL DEFAULT 'other',
  file_size INTEGER,
  uploaded_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_attachments_ramp_id ON attachments(ramp_id);

ALTER TABLE attachments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "read_attachments" ON attachments
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM ramps r
      JOIN schools s ON s.id = r.school_id
      WHERE r.id = attachments.ramp_id
      AND (public.is_admin() OR public.is_government() OR public.can_read_school(s.id))
    )
  );

CREATE POLICY "admin_write_attachments" ON attachments
  FOR ALL USING (public.is_admin());

CREATE POLICY "delivery_write_attachments" ON attachments
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM ramps r
      JOIN schools s ON s.id = r.school_id
      WHERE r.id = attachments.ramp_id
      AND public.can_write_school(s.id)
    )
  );
