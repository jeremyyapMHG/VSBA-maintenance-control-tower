-- Seed forecast costs and variations for ramps
-- Contingency = 10% of approved funding (budget_amount)
-- Forecast Cost flags red when > budget_amount * 1.1

-- Step 1: Set forecast costs with realistic distribution
DO $$
DECLARE
  r RECORD;
  v_forecast NUMERIC(12,2);
  v_rand DOUBLE PRECISION;
BEGIN
  FOR r IN SELECT id, budget_amount, lifecycle_stage FROM ramps LOOP
    v_rand := random();

    IF v_rand < 0.15 THEN
      -- 15%: forecast exceeds budget + contingency (will flag red)
      v_forecast := r.budget_amount * (1.12 + random() * 0.13);
    ELSIF v_rand < 0.40 THEN
      -- 25%: forecast between budget and budget + contingency (amber zone)
      v_forecast := r.budget_amount * (1.01 + random() * 0.09);
    ELSE
      -- 60%: forecast at or below budget (green)
      v_forecast := r.budget_amount * (0.80 + random() * 0.20);
    END IF;

    UPDATE ramps SET forecast_amount = ROUND(v_forecast, 2) WHERE id = r.id;
  END LOOP;
END $$;

-- Step 2: Seed variations for ~30% of ramps
DO $$
DECLARE
  r RECORD;
  v_count INTEGER;
  v_i INTEGER;
  v_amount NUMERIC(12,2);
  v_status TEXT;
  v_desc TEXT;
  v_descriptions TEXT[] := ARRAY[
    'Asbestos removal - unexpected discovery during demolition',
    'Additional handrail modifications for compliance',
    'Structural rectification - foundation issues',
    'Acoustic upgrade to meet BCA requirements',
    'Drainage remediation - stormwater redirection',
    'Additional concrete works - subgrade failure',
    'Electrical upgrade - switchboard replacement',
    'Fire services upgrade - hydrant relocation',
    'Roof repair - water ingress during construction',
    'Accessibility ramp extension - gradient non-compliance',
    'Tree root removal and protection zone works',
    'Additional painting and finishing works',
    'Fencing modification for site safety',
    'Plumbing rectification - hot water system',
    'Additional landscaping and reinstatement',
    'Temporary access ramp during construction',
    'Balustrade upgrade to current standards',
    'Waterproofing membrane replacement',
    'Bollard installation for vehicle protection',
    'Signage and line marking modifications'
  ];
  v_statuses TEXT[] := ARRAY['approved', 'approved', 'approved', 'pending', 'rejected'];
BEGIN
  FOR r IN SELECT id, budget_amount FROM ramps ORDER BY random() LIMIT 35 LOOP
    -- 1 to 3 variations per ramp
    v_count := 1 + floor(random() * 3)::INTEGER;

    FOR v_i IN 1..v_count LOOP
      v_amount := ROUND((random() * 0.08 * r.budget_amount + 2000)::NUMERIC, 2);
      v_status := v_statuses[1 + floor(random() * array_length(v_statuses, 1))::INTEGER];
      v_desc := v_descriptions[1 + floor(random() * array_length(v_descriptions, 1))::INTEGER];

      INSERT INTO variations (ramp_id, description, amount, status, date)
      VALUES (
        r.id,
        v_desc,
        v_amount,
        v_status::variation_status,
        CURRENT_DATE - (floor(random() * 180)::INTEGER || ' days')::INTERVAL
      );
    END LOOP;
  END LOOP;
END $$;
