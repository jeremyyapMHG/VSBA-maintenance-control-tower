-- ============================================
-- VSBA RAMPS Data Import from Excel
-- Generated from Ramps_sample_data_1.xlsx
-- ============================================

-- Step 1: Rename regions to abbreviations
UPDATE regions SET name = 'NEV' WHERE name = 'North-Eastern Victoria';
UPDATE regions SET name = 'NWV' WHERE name = 'North-Western Victoria';
UPDATE regions SET name = 'SEV' WHERE name = 'South-Eastern Victoria';
UPDATE regions SET name = 'SWV' WHERE name = 'South-Western Victoria';

-- Step 2: Clear existing seed data
DELETE FROM communications;
DELETE FROM schools;

-- Step 3: Insert schools and ramps
DO $$
DECLARE
  v_program_id UUID;
  v_region_id UUID;
  v_school_id UUID;
  v_ramp_id UUID;
BEGIN
  SELECT id INTO v_program_id FROM programs WHERE name = 'RAMPS Program' LIMIT 1;

  -- Albert Park College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Albert Park College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', NULL, 94279.63, 94279.63, 94279.63)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2024-06-14' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 2', 'admin_closeout', 'active', NULL, 94279.63, 94279.63, 94279.63)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2024-06-14' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 3', 'admin_closeout', 'active', NULL, 94279.63, 94279.63, 94279.63)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2024-06-14' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Alberton Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Alberton Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', NULL, 1000.0, 1000.0, 1000.0)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2024-06-26' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Alkira Secondary College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Alkira Secondary College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', 'Works completed with CFI issued 11/12/2025 with documentation, sign off and handover expected Janaury 2026.', 96920.14, 96920.14, 96920.14)
    RETURNING id INTO v_ramp_id;

  -- Altona Green Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Altona Green Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', 'Hum 1:1 Defects with handrails require 1000mm width. January 2027
Final sign off by RBS required - modifications to the handrail required. LIkely next week 
Ramps accessible  before start of school term
29/01 - CFI achieved, school signoff to be scheduled with PDC (targeting Mon 2 Feb)
05/02 - Outstanding defects. HUM to close workflow
12/02 - Outstanding defects, no progress.
26/02 - Defect rectification on site from tmr
', 103343.4, 103343.4, 103343.4)
    RETURNING id INTO v_ramp_id;

  -- Altona North Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Altona North Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'construction', 'active', 'Hum 1:1 Inspection failed due to changer of foundation by Hum. January 2027

Ramp 3 - planter box to be provided
Ramp 2 - Gate issues. measurement provided to manufacturer. LIkely won''t be an issue with the CFI
Ramps in use
29/01 - Louise said all outstanding issues have a way forward (handrail clearance been re-measured, break in handrail on inner bend, purchase of planter boxes (school acceptance to be sought prior to purchse, cyclone gate installation and design with lower level clarified. Gate install end Feb, other mods done prior. HUM to provide program.
5/02 - Waiting for shop drawings from supplier, wants to get that approved by school first.  Handrails next week. Ashphalt rectification after the fence.
12/02 - No progress Ramp 2, still waiting on shop drawing. Little defects remaining, nothing done yet.
26/02 - Moddex visiting tmr, Awaiting confirmation of dates for gate install (tmr)', 152217.98, 152217.98, 152217.98)
    RETURNING id INTO v_ramp_id;

  -- Ararat Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Ararat Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 154851.13, 154851.13, 154851.13)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-10-20' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Ardeer Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Ardeer Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', NULL, 1175.0, 1175.0, 1175.0)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2024-06-04' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Bacchus Marsh College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Bacchus Marsh College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 378381.16, 378381.16, 378381.16)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-10-29' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Bairnsdale Secondary College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Bairnsdale Secondary College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', 'RBS final inspection identified defects at Ramps 3, 5, 16 and 20. Ramp 5 & 16 to be rectified 
28/01 - Inspection done but BS won''t issue CFI - waiting on payment for additional inspections (in discussion with Pattersons & Spaces). Defects still remain (no ETA yet)
4/02 - No change.  Pattersons won''t pay BS. 10% construction value is still being held by PDC. (About 5 or 6 additional inspections done, BS wants to be paid for this).
4/03 - Still awaiting Pattersons to advise of delivery (from Alex) to fix defects. Andy and Dileep attended this site (see email)', 495400.36, 495400.36, 495400.36)
    RETURNING id INTO v_ramp_id;

  -- Barton Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Barton Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 351958.5, 351958.5, 351958.5)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-12-12' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Beaumaris North Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Beaumaris North Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', '
CFI Paperwork expect Tues/Wed 21 Jan. RBS has now been paid
Defects inspection to be scheduled next week
GRN demob from site', 200486.07, 200486.07, 200486.07)
    RETURNING id INTO v_ramp_id;

  -- Bellbrae Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Bellbrae Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', NULL, 647.5, 647.5, 647.5)
    RETURNING id INTO v_ramp_id;

  -- Berwick Secondary College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Berwick Secondary College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'construction', 'active', 'Agreed to get out RBS for CFI of all completed ramps asap to reduce distruption to school, ramp R4 & likely R1 won''t be done in time. Recently new Principal & FM.
Ramp 1: Completion 04.02.26
•	Landing poured yesterday
•	Rubber ramp to be measured today (23.01.26) lead time 5-7 days manufacture. 4 Feb forecast
•	Install of temp ramp & handrail, completed 29.01.2026 to allow access. Final
Ramp 4: ON HOLD. awaiting engineers'' advice 29/01.
Balustrade been replaced but now all ramp is flexing & could be unsafe, struc engineer to inspect 23/01. Handrails to be removed 
Ramp 7: Completion 29.01.2026
•	Asphalts poured, Bollard footings poured, Install of bollards & line marking - Wednesday 28.01.2026 (now 2nd Feb)
Ramp 9: Completion 09.02.26 Carpentry to be book in conjunction with ramps 1 & 7 as it''s a day visit.
Ramp 10: Completion 09.02.26	Carpentry to be book in conjunction with ramps 1 & 7 as it''s a day visit.
Final Inspection on 10 Feb.
5/02 - Works finished except R4 end next week 13/02
26/02 - Carpentry done R1,4,7,10. R4 handrails removed and made good, R1 rubber done. R9 new issues. R10 Done. Awaiting updated modex shop drawings.  Maybe mid 15/03.', 436050.96, 436050.96, 436050.96)
    RETURNING id INTO v_ramp_id;

  -- Buckley Park College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Buckley Park College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'construction', 'active', 'Pirotta 1:1 Ramp 17 remaining handrails by Moddex by 23/01/2026
21/01 - Ramp 17 frame to be installed this week. Decking and cladding next week and nosing/handrails the following week. target completion 30 Jan. Final Inspection Jan 30
29/01 - Slipped by one week Ramp 17 (hot weather), ramp to complete this week, nosing next week.
5/02 - Cleanup next week, signoff next week.
26/02 - Seeking signoff on Mon 2/03', 315891.55, 315891.55, 315891.55)
    RETURNING id INTO v_ramp_id;

  -- Canadian Lead Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Canadian Lead Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'construction', 'active', 'Pirotta 1:1 Ramp 3 23/01/2026 and Ramps 1 and 2 by 27th February 2026.
21/01 - Ramp 3 will commence 27-Janby Moddex. Ramp 1 & 2 fabrication on-going. Potential delay for Ramp 1
29/01 - Ramp 3 starting today (hot weather delay).  R1&2 shop design awaiting from Moddex, maybe Building Permit amendment. Forecast date 27/2 is likely at risk with R1&2.
5/02 - Cameron/David/Grymbos plan to submit BP amendment this week.  Anticipate 2 weeks for approval, then commence onsite (say 1 after). In parallel moddex manufacture.  Say 2 weeks construct, 1 week moddex & clean up (eta 20/03 for complete), CFI signoff probably week after.
12/02 - Ramp 3 frame approved, next week concrete, nosing & temp fence.  R1&2 still in shop drawings, manufacturing yet to start, building permit mod required.
26/02 - R3 delayed (probably 1week work).  R1&2 Amended BP not achieved, need update from Pirotta, last PC date 20/3 very unlikely.', 414221.64, 414221.64, 414221.64)
    RETURNING id INTO v_ramp_id;

  -- Carnegie Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Carnegie Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 10000.0, 10000.0, 10000.0)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-08-12' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Carwatha College P-12
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Carwatha College P-12', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'construction', 'active', '27/01: Ramp 12 to be maintained. non-DDA accessible ramp sign, removable bollards and map showing alternate DDA access route to be installed. Transfer cost to Ramp 18 - school :endorsed
29/01 - Principal sent recent email, please review. Letter of Completion received from RBS (to Tim Meldrum).  Need school endorsement of re-design of Ramp 18 (school entrance access).
5/02 - Currently doing 17 forecasting completion 9/2, Ramp 18 still needs approval from VSBA (Dileep awaiting final costs (action with JMA).  Carpark disruption required for R18 construction, builder wants help/support from school. R24 needs approval (coupled with ramp 18 proximity), will be constructed together.
26/02 - Costings need reviews, much much higher than previous ramps done.', 751300.0, 751300.0, 751300.0)
    RETURNING id INTO v_ramp_id;

  -- Chelsea Heights Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Chelsea Heights Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', 'DLP Period', 146792.44, 146792.44, 146792.44)
    RETURNING id INTO v_ramp_id;

  -- Chilwell Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Chilwell Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 191005.5, 191005.5, 191005.5)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-08-06' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Clayton South Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Clayton South Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', NULL, 2000.0, 2000.0, 2000.0)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2024-07-09' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Clyde Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Clyde Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 47227.02, 47227.02, 47227.02)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-12-12' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Coburn Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Coburn Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'construction', 'active', 'Hum 1:1 Ramp 12 5/01/2026 but likely February PCC.
R10 CFI received
R12 - demo complete
29/01 - demo delayed (done yesterday). Concrete pour for today. Forecasting all done 20/2
2/02 - Louise advised of permit issue causing delay to concrete and carpentry. awaiting update
5/02 - Concrete pour forecast 14/02, hopefully all complete this same week. School unhappy with work during term - want weekday only.
12/02 - 27th forecast completion. Demo and concrete works not to happy during the week
26/02 - Demo complete, concrete pour tmr. 11/03 forecast completion, proposing walkthru on same day with school', 692825.98, 692825.98, 692825.98)
    RETURNING id INTO v_ramp_id;

  -- Colac Secondary College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Colac Secondary College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', NULL, 135466.6, 135466.6, 135466.6)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-07-15' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Cranbourne Carlisle Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Cranbourne Carlisle Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 28183.0, 28183.0, 28183.0)
    RETURNING id INTO v_ramp_id;

  -- Cranbourne East Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Cranbourne East Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 119004.62, 119004.62, 119004.62)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-12-12' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Crib Point Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Crib Point Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 156095.13, 156095.13, 156095.13)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-10-10' WHERE ramp_id = v_ramp_id AND name = 'Design Signoff';
  UPDATE milestones SET actual_date = '2025-04-22' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Dandenong West Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Dandenong West Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', 'PC Docs required
29/01 - No progress on paperwork, Tim to follow, still holding 10% payment', 0, 0, 0)
    RETURNING id INTO v_ramp_id;

  -- Dromana Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Dromana Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', 'Awaiting VSBA to approve variations', 315674.71, 315674.71, 315674.71)
    RETURNING id INTO v_ramp_id;

  -- Drouin West Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Drouin West Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 149400.0, 149400.0, 149400.0)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-06-02' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Eagle Point Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Eagle Point Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 120658.63, 120658.63, 120658.63)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-12-02' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Edithvale Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Edithvale Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', 'Variation 4 canopy demolition Ramp 2
21/01 - CFI not received? School funded works have been completed?
22//01 - All ramps completed. JMA still awaiting confirmation from RBS on CFI. School request concreted/pavement works, builder quoted ~$20k, school agreed and works completed by builder but formal PO was not provded to builder from the school.  New principal not committing to funds despite email trail from previous principal. In dispute.
29/01 - No change', 558497.27, 558497.27, 558497.27)
    RETURNING id INTO v_ramp_id;

  -- Elwood Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Elwood Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 151438.08, 151438.08, 151438.08)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-05-02' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Footscray Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Footscray Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 165614.82, 165614.82, 165614.82)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-06-30' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Gleneagles Secondary College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Gleneagles Secondary College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 159701.64, 159701.64, 159701.64)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-12-12' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Grovedale West Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Grovedale West Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 319633.0, 319633.0, 319633.0)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-08-06' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Haddon Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Haddon Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 68371.41, 68371.41, 68371.41)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-10-20' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Hamlyn Banks Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Hamlyn Banks Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 171711.34, 171711.34, 171711.34)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-08-06' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Hastings Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Hastings Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 377241.37, 377241.37, 377241.37)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-12-12' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Hopetoun P-12 College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Hopetoun P-12 College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 335680.08, 335680.08, 335680.08)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-12-02' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Horsham West and Haven Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Horsham West and Haven Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 242119.37, 242119.37, 242119.37)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-11-20' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Inverleigh Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Inverleigh Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 134470.67, 134470.67, 134470.67)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-09-23' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Inverloch Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Inverloch Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 103704.85, 103704.85, 103704.85)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-07-21' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Keilor Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Keilor Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 83981.11, 83981.11, 83981.11)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-07-17' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Kensington Community High School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Kensington Community High School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 60000.0, 60000.0, 60000.0)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2024-06-24' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Kingsley Park Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Kingsley Park Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', 'Ramp K - internal ramp balustrade  rectified
Ramp E - tactiles 
Defects inspection to be scheduled
CFI expected this week
29/01 - Matt (Principal) sent thru recent ESM non-compliant audit. Please check this', 483842.02, 483842.02, 483842.02)
    RETURNING id INTO v_ramp_id;

  -- Kurnai College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Kurnai College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', 'Removed from program ???', 0.0, 0.0, 0.0)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2024-07-10' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Kurunjang Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Kurunjang Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', 'Canopy Posts installed. Defects to be completed. Prior term 1 2026
29/01 - Anticipating School signoff end of this week (30/1)
12/02 - Principal not happy with stair nosing. HUM don''t see any issue with the work at all. See photo email (Louise 12/2, nose caping).
26/02 - Going back tmr to secure screws', 79158.44, 79158.44, 79158.44)
    RETURNING id INTO v_ramp_id;

  -- Lakeview Senior College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Lakeview Senior College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', NULL, 0.0, 0.0, 0.0)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2024-07-04' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Langwarrin Park Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Langwarrin Park Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', 'Ramp A & C - photo of rectification required. Stormwater issue raised by the principal
Ramp J - rails rectified and accepted 
Ramp F - Concreting works done.Handrails installed as per design and signed off by RBS. 
Ramp J - School request to modify handrail to pool access via footpath - H&L advised ramp will need to be fully demolished and reconstructed to accomdate the request
Photo of tactiles required
Expect CFI this week', 252186.87, 252186.87, 252186.87)
    RETURNING id INTO v_ramp_id;

  -- Langwarrin Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Langwarrin Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', 'Ramp C signed off by RBS. 
All ramps complete. 
Balustrade to Ramp L - school request still needs to be done. Will not affect CFI
Tactiles to ramps - photo to be provided to RBS
CFI expected this week', 396409.09, 396409.09, 396409.09)
    RETURNING id INTO v_ramp_id;

  -- Lara Lake Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Lara Lake Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 253992.63, 253992.63, 253992.63)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-10-06' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Lardner and District Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Lardner and District Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 193011.66, 193011.66, 193011.66)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-09-08' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Lindenow Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Lindenow Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 217599.43, 217599.43, 217599.43)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-12-02' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Lucknow Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Lucknow Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 60939.5, 60939.5, 60939.5)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-12-02' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Lyndhurst Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Lyndhurst Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', '19/01FHR has been relocated, tactiles installed and carpet tiles adjusted. Grab rail to be re-installed this week
29/01- All complete', 178986.04, 178986.04, 178986.04)
    RETURNING id INTO v_ramp_id;

  -- Lyndhurst Secondary College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Lyndhurst Secondary College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 152161.62, 152161.62, 152161.62)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-11-20' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Malvern Central School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Malvern Central School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 516264.0, 516264.0, 516264.0)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-07-29' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Malvern Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Malvern Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 147237.6, 147237.6, 147237.6)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-08-26' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Malvern Valley Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Malvern Valley Primary School', 'completed')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'final_closure', 'completed', 'CFI done, awaiting School signoff. Hand Rails and Retaining Wall defects to rectify the week of the 19th January prior term 1 2026
17/01 - Contractor conifrmed works complete as of 16/01 but School not happy with completed works. Defects inspection to be scheduled next week. All ramps accessible
Dileep will not approve workflow until defects rectified
Ross (Spaces) advised defect walkthru with Principal scheduled for 30/1 ', 139022.13, 139022.13, 139022.13)
    RETURNING id INTO v_ramp_id;

  -- Maribyrnong Secondary College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Maribyrnong Secondary College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'construction', 'active', '21/10 - Ramp 9  restumping works completed. Updated program to be provided. End of Feb target.
Ramp works to commence next week.
All other ramps - CFI this week
29/01 - Framing this week & concreting next week. Lightweigh cladding proposed. Moddex week after next. Still tracking to 27/2
5/02 - Concrete is poured, moddex may have some delay with fabrication (Pirotta to followup). Needs 2 weeks to install, it will arrive onsite on 20th Feb.
12/02 - Ramps schedule for next week (delivery 7am Mon), hopefully 27th finish.
26/02 - Weather delay, working Saturday and Monday for moddex & bitumen, final defect inspection Monday 2/03 (hopefully).', 166040.65, 166040.65, 166040.65)
    RETURNING id INTO v_ramp_id;

  -- Melton Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Melton Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', NULL, 333538.8, 333538.8, 333538.8)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2024-07-17' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Mentone Girls Secondary College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Mentone Girls Secondary College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'construction', 'active', 'Ramp 6 - complete
Ramp 4 - Feb 2026 - Re-design requiring approval - variation $ 20,672.83 for DS approval. $5k contribution by the school
Intent for RBS to issue letter to allow use of completed ramps
29/01 - Still awaiting approval from VSBA, then need program from Builder.', 728758.565, 728758.565, 728758.565)
    RETURNING id INTO v_ramp_id;

  -- Mentone Park Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Mentone Park Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', 'Small variation outstanding.
29/01 - Builder caused defect, needs rectification', 351967.206, 351967.206, 351967.206)
    RETURNING id INTO v_ramp_id;

  -- Miners Rest Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Miners Rest Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', 'Expected CFI by 31/12/2025 with remedial works in January 2026 80m2 turf, handrail adjustments, backfill wall and clean up.
21/01 - Ramp 1 completed and compliant, All works expected to be completed this week. 
Ramp 5 kick rails to be installed 21/01. Final inspection this week
Ramp 7 completed
Defects inspection and final inspection to be scheduled. School request for a Yarning Circle to be discussed - committed by Pirotta
RBS inspection 23/01/2016 (PDC attended)
29/01 - Kylie Principal on personal leave back in Feb (require her signoff)
12/02 - awaiting Kylie return and RBS return', 299300.69, 299300.69, 299300.69)
    RETURNING id INTO v_ramp_id;

  -- Mirboo North Secondary College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Mirboo North Secondary College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 232000.0, 232000.0, 232000.0)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-08-29' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Moorooduc Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Moorooduc Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 42139.95, 42139.95, 42139.95)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-04-22' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Moriac Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Moriac Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 56567.8, 56567.8, 56567.8)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-08-06' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Morwell Central Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Morwell Central Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 65530.8, 65530.8, 65530.8)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-08-21' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Morwell Park Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Morwell Park Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 149236.75, 149236.75, 149236.75)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-08-21' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Mossgiel Park Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Mossgiel Park Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', 'failed final inspection, rectification eta? Clearance between handrail to be added to Performance Solution.', 105367.33, 105367.33, 105367.33)
    RETURNING id INTO v_ramp_id;

  -- Mount Clear Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Mount Clear Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 113217.77, 113217.77, 113217.77)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-07-29' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Mount Eliza Secondary College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Mount Eliza Secondary College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 394738.81, 394738.81, 394738.81)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-08-28' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Nar Nar Goon Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Nar Nar Goon Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', NULL, 2000.0, 2000.0, 2000.0)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2024-07-10' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Newington Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Newington Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 128938.31, 128938.31, 128938.31)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-04-29' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Niddrie Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Niddrie Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', NULL, 1587.5, 1587.5, 1587.5)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2024-07-18' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Nossal High School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Nossal High School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', 'Planter box lid variation and defect works to complete. 
22/01 - Lid variation approved by Dileep/VSBA. Awaiting CFI with Hum.  Defect inspections to be conducted thereafter
29/01 - Awaiting HUM program.  
3/02 - Received Email from school (via Tim M) advising of final re-keying costs (~$13k).
05/02 - End of next week forecast completion
10/02 - Email received from school, Contractor illegal entry into school on Saturday (cut padlock), filled planter box & didn''t address defects.
26/02 - Asphalt outstanding, school was thinking pit lid was also being done.', 109059.3, 109059.3, 109059.3)
    RETURNING id INTO v_ramp_id;

  -- Overport Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Overport Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', 'Completed June. Bella to advise why PCC not yet issued  - URGENT. Defects inspection not done', 139855.98, 139855.98, 139855.98)
    RETURNING id INTO v_ramp_id;

  -- Pakenham Lakeside Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Pakenham Lakeside Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 127939.01, 127939.01, 127939.01)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-08-22' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Parktone Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Parktone Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 263495.13, 263495.13, 263495.13)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-10-08' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Parkwood Green Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Parkwood Green Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 202249.64, 202249.64, 202249.64)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-09-15' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Patterson River Secondary College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Patterson River Secondary College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', 'Work scope complete', 255207.7, 255207.7, 255207.7)
    RETURNING id INTO v_ramp_id;

  -- Pentland Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Pentland Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 439502.5, 439502.5, 439502.5)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-11-24' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Point Cook Senior Secondary College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Point Cook Senior Secondary College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', NULL, 2000.0, 2000.0, 2000.0)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2024-06-17' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Portland North Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Portland North Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 178367.29, 178367.29, 178367.29)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-09-18' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Portland Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Portland Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 83407.83, 83407.83, 83407.83)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-09-18' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Roslyn Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Roslyn Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 69509.5, 69509.5, 69509.5)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-08-06' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Sandringham Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Sandringham Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', 'Removed from scope', 54636.74, 54636.74, 54636.74)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2024-07-23' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Somerville Secondary College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Somerville Secondary College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 88711.6, 88711.6, 88711.6)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-08-18' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Sorrento Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Sorrento Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 93682.9, 93682.9, 93682.9)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-07-31' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Springside Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Springside Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 95765.17, 95765.17, 95765.17)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-03-20' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- St Albans East Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'St Albans East Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 82.02564102564102, 82.02564102564102, 82.02564102564102)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-06-30' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- St Arnaud Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'St Arnaud Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'construction', 'active', 'Hazardous Materials. December Holidays works commence 6th January 2026. program pending from Domain.', 273386.45, 273386.45, 273386.45)
    RETURNING id INTO v_ramp_id;

  -- Tarneit Senior College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Tarneit Senior College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 213191.37, 213191.37, 213191.37)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-07-29' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Teesdale Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Teesdale Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 148082.94, 148082.94, 148082.94)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-09-25' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Timbarra P-9 College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Timbarra P-9 College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'construction', 'active', 'Ramp 15 TBC Expected PC 27/02/2026 (program to be submitted by Hum)
29/01 - Demo occurred today, pouring next week. Still tracking mid Feb
05/02 - R15 concrete pour done, handrails next week, 12/02 forecast completion
26/02 - Awaiting program to closeout. Small demo, removal handrails, removal concrete, pour and set, re-inspect. Hoping to finish by 7/03.', 198029.71, 198029.71, 198029.71)
    RETURNING id INTO v_ramp_id;

  -- Toolern Vale and District Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Toolern Vale and District Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 123787.16, 123787.16, 123787.16)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-07-31' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Toorak Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Toorak Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 191343.26, 191343.26, 191343.26)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-10-06' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Toorloo Arm Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Toorloo Arm Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 78026.63, 78026.63, 78026.63)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-12-02' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Traralgon (Liddiard Road) Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Traralgon (Liddiard Road) Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 322258.75, 322258.75, 322258.75)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-11-07' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Traralgon College (Ramps)
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Traralgon College (Ramps)', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', 'waiting on school sign-off', 2178875.51, 2178875.51, 2178875.51)
    RETURNING id INTO v_ramp_id;

  -- Traralgon College (RFE)
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Traralgon College (RFE)', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'construction', 'active', 'Ramp work complete. RFE Roof December Holidays, The steel installation will occur between 5th and 23rd Jan 2026 exclusion zone required. Structural steel works are scheduled to occur between 8th January and 15th January 
14/01 - PCC walkthru 9 Feb with School. CFI next week (hopefully)
21/01 - completion 6 Feb. Defects inspection 8 Feb
28/01 - New forecast 9 Feb.
04/02 - Still tracking.  Awaiting Dileep approval for absestos removal (Jul 2025)
12/02 - Roof works completed yesterday', 2178876.51, 2178876.51, 2178876.51)
    RETURNING id INTO v_ramp_id;

  -- Tulliallan Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Tulliallan Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 168439.97, 168439.97, 168439.97)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-10-20' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- University High School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'University High School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 45497.19, 45497.19, 45497.19)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-06-30' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Warragul Regional College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Warragul Regional College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 547164.82, 547164.82, 547164.82)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-11-10' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Wendouree Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Wendouree Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', 'Ramps 2 and 1 Final inspection this week
21/01 - All works completedand currently safe to occupy. 
Ramp 3 CFI received
29/01 - Defects complete yesterday 28/01', 150509.35, 150509.35, 150509.35)
    RETURNING id INTO v_ramp_id;

  -- Werribee Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Werribee Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', 'CFI received 18/12/2025
21/01 - defects rectification to be completed this week. cyclone fence scheduled 22/10 - Pirotta to provide temp fencing if cyclone fence not reworked. Fake turf  between water tank lsab and new paving gap. FInal defects inspection by Friday.', 253536.46, 253536.46, 253536.46)
    RETURNING id INTO v_ramp_id;

  -- Westall Secondary College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Westall Secondary College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', '
Ramp 14 - non-DDA ramp, school request ramp over step to be treated as school defect. Will seek CFI with RBS to be issued next week', 763521.8, 763521.8, 763521.8)
    RETURNING id INTO v_ramp_id;

  -- Williamstown High School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Williamstown High School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 503693.85, 503693.85, 503693.85)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-08-06' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Woodlands Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Woodlands Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'construction', 'active', 'CFI expected this week', 159965.71, 159965.71, 159965.71)
    RETURNING id INTO v_ramp_id;

  -- Wyndham Vale Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Wyndham Vale Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 58188.94, 58188.94, 58188.94)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-07-29' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

  -- Yarraman Oaks Primary School
  SELECT id INTO v_region_id FROM regions WHERE name = 'SEV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Yarraman Oaks Primary School', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'admin_closeout', 'active', 'Covered way roof works completd. Defects inspection to be scheduled next week
26/02 - Asphalt work done yesterday.', 97358.45, 97358.45, 97358.45)
    RETURNING id INTO v_ramp_id;

  -- Yuille Park P-8 Community College
  SELECT id INTO v_region_id FROM regions WHERE name = 'SWV' LIMIT 1;
  INSERT INTO schools (id, program_id, region_id, name, status)
    VALUES (gen_random_uuid(), v_program_id, v_region_id, 'Yuille Park P-8 Community College', 'active')
    RETURNING id INTO v_school_id;
  INSERT INTO ramps (id, school_id, name, lifecycle_stage, status, commentary, budget_amount, actual_amount, forecast_amount)
    VALUES (gen_random_uuid(), v_school_id, 'Ramp 1', 'dlp', 'active', NULL, 24573.6, 24573.6, 24573.6)
    RETURNING id INTO v_ramp_id;
  UPDATE milestones SET actual_date = '2025-07-29' WHERE ramp_id = v_ramp_id AND name = 'Practical Completion';

END $$;

-- Import complete: 112 schools