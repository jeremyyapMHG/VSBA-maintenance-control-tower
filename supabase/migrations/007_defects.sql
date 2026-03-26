CREATE TABLE defects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ramp_id UUID NOT NULL REFERENCES ramps(id) ON DELETE CASCADE,
  description TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'resolved')),
  identified_date DATE NOT NULL DEFAULT CURRENT_DATE,
  resolved_date DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_defects_ramp_id ON defects(ramp_id);

ALTER TABLE defects ENABLE ROW LEVEL SECURITY;

CREATE POLICY "read_defects" ON defects
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM ramps r
      JOIN schools s ON s.id = r.school_id
      WHERE r.id = defects.ramp_id
      AND (public.is_admin() OR public.is_government() OR public.can_read_school(s.id))
    )
  );

CREATE POLICY "admin_write_defects" ON defects
  FOR ALL USING (public.is_admin());

CREATE POLICY "delivery_write_defects" ON defects
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM ramps r
      JOIN schools s ON s.id = r.school_id
      WHERE r.id = defects.ramp_id
      AND public.can_write_school(s.id)
    )
  );
