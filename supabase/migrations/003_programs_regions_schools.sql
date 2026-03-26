-- Programs table (single program for this POC)
CREATE TABLE programs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE programs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "authenticated_read_programs" ON programs
  FOR SELECT TO authenticated
  USING (true);

CREATE POLICY "admin_write_programs" ON programs
  FOR ALL
  USING (public.is_admin());

-- Regions table
CREATE TABLE regions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE regions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "authenticated_read_regions" ON regions
  FOR SELECT TO authenticated
  USING (true);

CREATE POLICY "admin_write_regions" ON regions
  FOR ALL
  USING (public.is_admin());

-- Pre-seed Victorian DET regions
INSERT INTO regions (name) VALUES
  ('North-Eastern Victoria'),
  ('North-Western Victoria'),
  ('South-Eastern Victoria'),
  ('South-Western Victoria');

-- Schools table
CREATE TABLE schools (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  program_id UUID REFERENCES programs(id) ON DELETE CASCADE,
  region_id UUID NOT NULL REFERENCES regions(id) ON DELETE RESTRICT,
  name TEXT NOT NULL,
  address TEXT,
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'on_hold', 'completed')),
  last_communication_date TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_schools_region_id ON schools(region_id);
CREATE INDEX idx_schools_program_id ON schools(program_id);

ALTER TABLE schools ENABLE ROW LEVEL SECURITY;

CREATE POLICY "gov_admin_read_schools" ON schools
  FOR SELECT
  USING (public.is_admin() OR public.is_government());

CREATE POLICY "assigned_read_schools" ON schools
  FOR SELECT
  USING (public.can_read_school(id));

CREATE POLICY "admin_write_schools" ON schools
  FOR ALL
  USING (public.is_admin());

CREATE POLICY "delivery_write_schools" ON schools
  FOR UPDATE
  USING (public.can_write_school(id));

CREATE TRIGGER schools_updated_at
  BEFORE UPDATE ON schools
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- Seed the default program
INSERT INTO programs (name, description) VALUES
  ('RAMPS Program', 'Routine and Annual Maintenance Program for Schools');
