CREATE TYPE variation_status AS ENUM ('pending', 'approved', 'rejected');

CREATE TABLE variations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ramp_id UUID NOT NULL REFERENCES ramps(id) ON DELETE CASCADE,
  description TEXT NOT NULL,
  amount NUMERIC(12,2) NOT NULL DEFAULT 0,
  status variation_status NOT NULL DEFAULT 'pending',
  date DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_variations_ramp_id ON variations(ramp_id);

ALTER TABLE variations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "read_variations" ON variations
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM ramps r
      JOIN schools s ON s.id = r.school_id
      WHERE r.id = variations.ramp_id
      AND (public.is_admin() OR public.is_government() OR public.can_read_school(s.id))
    )
  );

CREATE POLICY "admin_write_variations" ON variations
  FOR ALL
  USING (public.is_admin());

CREATE POLICY "delivery_write_variations" ON variations
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM ramps r
      JOIN schools s ON s.id = r.school_id
      WHERE r.id = variations.ramp_id
      AND public.can_write_school(s.id)
    )
  );
