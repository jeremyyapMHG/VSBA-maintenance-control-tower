-- Helper function: get current user's role
CREATE OR REPLACE FUNCTION public.get_user_role()
RETURNS user_role AS $$
  SELECT role FROM public.user_profiles
  WHERE auth_user_id = auth.uid()
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Helper function: check if current user is admin
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_profiles
    WHERE auth_user_id = auth.uid() AND role = 'admin'
  )
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Helper function: check if current user is government
CREATE OR REPLACE FUNCTION public.is_government()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_profiles
    WHERE auth_user_id = auth.uid() AND role = 'government'
  )
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Helper function: check if current user has read access to a school
CREATE OR REPLACE FUNCTION public.can_read_school(school_id UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_profiles
    WHERE auth_user_id = auth.uid()
    AND (
      role IN ('admin', 'government')
      OR school_id = ANY(assigned_school_ids)
    )
  )
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Helper function: check if current user has write access to a school
CREATE OR REPLACE FUNCTION public.can_write_school(school_id UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_profiles
    WHERE auth_user_id = auth.uid()
    AND (
      role = 'admin'
      OR (role = 'delivery_team' AND school_id = ANY(assigned_school_ids))
    )
  )
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Helper function: check if current user has read access to a ramp
CREATE OR REPLACE FUNCTION public.can_read_ramp(ramp_id UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_profiles
    WHERE auth_user_id = auth.uid()
    AND (
      role IN ('admin', 'government')
      OR ramp_id = ANY(assigned_ramp_ids)
    )
  )
$$ LANGUAGE sql SECURITY DEFINER STABLE;
