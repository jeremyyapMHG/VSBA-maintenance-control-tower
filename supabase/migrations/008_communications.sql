CREATE TYPE comm_method AS ENUM ('email', 'phone', 'in_person', 'other');

CREATE TABLE communications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  school_id UUID NOT NULL REFERENCES schools(id) ON DELETE CASCADE,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  method comm_method NOT NULL,
  summary TEXT NOT NULL,
  logged_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_communications_school_id ON communications(school_id);

ALTER TABLE communications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "read_communications" ON communications
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM schools s
      WHERE s.id = communications.school_id
      AND (public.is_admin() OR public.is_government() OR public.can_read_school(s.id))
    )
  );

CREATE POLICY "admin_write_communications" ON communications
  FOR ALL USING (public.is_admin());

CREATE POLICY "delivery_write_communications" ON communications
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM schools s
      WHERE s.id = communications.school_id
      AND public.can_write_school(s.id)
    )
  );
