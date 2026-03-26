CREATE TYPE lifecycle_stage AS ENUM (
  'design',
  'construction',
  'admin_closeout',
  'dlp',
  'final_closure'
);

CREATE TABLE ramps (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  school_id UUID NOT NULL REFERENCES schools(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  lifecycle_stage lifecycle_stage NOT NULL DEFAULT 'design',
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'on_hold', 'completed', 'blocked')),
  commentary TEXT,
  budget_amount NUMERIC(12,2) DEFAULT 0,
  actual_amount NUMERIC(12,2) DEFAULT 0,
  forecast_amount NUMERIC(12,2) DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_ramps_school_id ON ramps(school_id);

ALTER TABLE ramps ENABLE ROW LEVEL SECURITY;

CREATE POLICY "gov_admin_read_ramps" ON ramps
  FOR SELECT
  USING (public.is_admin() OR public.is_government());

CREATE POLICY "assigned_read_ramps" ON ramps
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM schools s
      WHERE s.id = ramps.school_id
      AND public.can_read_school(s.id)
    )
  );

CREATE POLICY "admin_write_ramps" ON ramps
  FOR ALL
  USING (public.is_admin());

CREATE POLICY "delivery_write_ramps" ON ramps
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM schools s
      WHERE s.id = ramps.school_id
      AND public.can_write_school(s.id)
    )
  );

CREATE POLICY "delivery_insert_ramps" ON ramps
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM schools s
      WHERE s.id = ramps.school_id
      AND public.can_write_school(s.id)
    )
  );

CREATE TRIGGER ramps_updated_at
  BEFORE UPDATE ON ramps
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
