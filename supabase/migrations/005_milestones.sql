-- Milestones table
CREATE TABLE milestones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ramp_id UUID NOT NULL REFERENCES ramps(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  type TEXT NOT NULL DEFAULT 'core' CHECK (type IN ('core', 'interim')),
  planned_date DATE,
  actual_date DATE,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_milestones_ramp_id ON milestones(ramp_id);

ALTER TABLE milestones ENABLE ROW LEVEL SECURITY;

CREATE POLICY "read_milestones" ON milestones
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM ramps r
      JOIN schools s ON s.id = r.school_id
      WHERE r.id = milestones.ramp_id
      AND (public.is_admin() OR public.is_government() OR public.can_read_school(s.id))
    )
  );

CREATE POLICY "admin_write_milestones" ON milestones
  FOR ALL
  USING (public.is_admin());

CREATE POLICY "delivery_write_milestones" ON milestones
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM ramps r
      JOIN schools s ON s.id = r.school_id
      WHERE r.id = milestones.ramp_id
      AND public.can_write_school(s.id)
    )
  );

-- Auto-seed core milestones when a ramp is created
CREATE OR REPLACE FUNCTION public.seed_core_milestones()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO milestones (ramp_id, name, type, sort_order) VALUES
    (NEW.id, 'Design Signoff', 'core', 1),
    (NEW.id, 'Practical Completion', 'core', 2),
    (NEW.id, 'Administrative Completion', 'core', 3),
    (NEW.id, 'DLP Complete', 'core', 4),
    (NEW.id, 'Final Closure', 'core', 5);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_ramp_created_seed_milestones
  AFTER INSERT ON ramps
  FOR EACH ROW EXECUTE FUNCTION public.seed_core_milestones();
