-- =============================================================================
-- VSBA Maintenance Control Tower — Seed Data
-- =============================================================================
-- Run with: psql $DATABASE_URL -f supabase/seed.sql
-- =============================================================================

DO $$
DECLARE
  -- Region IDs
  r_ne UUID;
  r_nw UUID;
  r_se UUID;
  r_sw UUID;

  -- Program ID
  prog_id UUID;

  -- School IDs
  s_ballarat      UUID;
  s_bendigo       UUID;
  s_geelong       UUID;
  s_wodonga       UUID;
  s_shepparton    UUID;
  s_warrnambool   UUID;
  s_mildura       UUID;
  s_horsham       UUID;
  s_ararat        UUID;
  s_hamilton      UUID;
  s_wangaratta    UUID;
  s_albury        UUID;
  s_echuca        UUID;
  s_swan_hill     UUID;
  s_sunbury       UUID;
  s_frankston     UUID;
  s_dandenong     UUID;
  s_pakenham      UUID;
  s_cranbourne    UUID;
  s_traralgon     UUID;
  s_bairnsdale    UUID;
  s_sale          UUID;
  s_warragul      UUID;
  s_moe           UUID;
  s_torquay       UUID;

  -- Ramp IDs (named by school abbreviation + sequence)
  r_bal1 UUID; r_bal2 UUID;
  r_ben1 UUID; r_ben2 UUID; r_ben3 UUID;
  r_gee1 UUID; r_gee2 UUID;
  r_wod1 UUID; r_wod2 UUID; r_wod3 UUID;
  r_she1 UUID;
  r_war1 UUID; r_war2 UUID;
  r_mil1 UUID; r_mil2 UUID; r_mil3 UUID;
  r_hor1 UUID;
  r_ara1 UUID; r_ara2 UUID;
  r_ham1 UUID;
  r_wan1 UUID; r_wan2 UUID;
  r_alb1 UUID;
  r_ech1 UUID; r_ech2 UUID;
  r_swh1 UUID;
  r_sun1 UUID; r_sun2 UUID;
  r_fra1 UUID; r_fra2 UUID; r_fra3 UUID;
  r_dan1 UUID; r_dan2 UUID;
  r_pak1 UUID;
  r_cra1 UUID; r_cra2 UUID;
  r_tra1 UUID; r_tra2 UUID; r_tra3 UUID;
  r_bai1 UUID;
  r_sal1 UUID; r_sal2 UUID;
  r_wrg1 UUID;
  r_moe1 UUID; r_moe2 UUID;
  r_tor1 UUID;

BEGIN
  -- =========================================================================
  -- 1. Fetch region IDs
  -- =========================================================================
  SELECT id INTO r_ne FROM regions WHERE name = 'North-Eastern Victoria';
  SELECT id INTO r_nw FROM regions WHERE name = 'North-Western Victoria';
  SELECT id INTO r_se FROM regions WHERE name = 'South-Eastern Victoria';
  SELECT id INTO r_sw FROM regions WHERE name = 'South-Western Victoria';

  -- =========================================================================
  -- 2. Fetch RAMPS Program ID
  -- =========================================================================
  SELECT id INTO prog_id FROM programs WHERE name = 'RAMPS Program';

  -- =========================================================================
  -- 3. Insert schools
  -- =========================================================================

  -- North-Western Victoria
  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_nw, 'Ballarat Primary School',     '23 Lydiard St North, Ballarat VIC 3350',     'active')
    RETURNING id INTO s_ballarat;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_nw, 'Bendigo Secondary College',   '14 King Street, Bendigo VIC 3550',           'active')
    RETURNING id INTO s_bendigo;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_nw, 'Mildura Primary School',      '88 Deakin Avenue, Mildura VIC 3500',         'active')
    RETURNING id INTO s_mildura;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_nw, 'Horsham College',             '1 Baillie Street, Horsham VIC 3400',         'on_hold')
    RETURNING id INTO s_horsham;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_nw, 'Ararat Primary School',       '7 High Street, Ararat VIC 3377',             'active')
    RETURNING id INTO s_ararat;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_nw, 'Echuca Secondary College',    '15 Pakenham Street, Echuca VIC 3564',        'active')
    RETURNING id INTO s_echuca;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_nw, 'Swan Hill College',           '125 Beveridge Street, Swan Hill VIC 3585',   'completed')
    RETURNING id INTO s_swan_hill;

  -- North-Eastern Victoria
  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_ne, 'Wodonga Senior Secondary College', '83 Brockley Street, Wodonga VIC 3690',  'active')
    RETURNING id INTO s_wodonga;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_ne, 'Shepparton High School',      '6200 Goulburn Valley Hwy, Shepparton VIC 3630', 'active')
    RETURNING id INTO s_shepparton;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_ne, 'Wangaratta Primary School',   '18 Ovens Street, Wangaratta VIC 3677',      'active')
    RETURNING id INTO s_wangaratta;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_ne, 'Albury-Wodonga Grammar School', '4 Townsend Street, Albury NSW 2640',      'on_hold')
    RETURNING id INTO s_albury;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_ne, 'Sunbury Primary School',      '42 Station Road, Sunbury VIC 3429',         'active')
    RETURNING id INTO s_sunbury;

  -- South-Western Victoria
  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_sw, 'Geelong Grammar School',      '50 Biddlecombe Avenue, Corio VIC 3214',     'active')
    RETURNING id INTO s_geelong;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_sw, 'Warrnambool College',         '132 Grafton Road, Warrnambool VIC 3280',    'active')
    RETURNING id INTO s_warrnambool;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_sw, 'Hamilton Secondary College',  '24 Park Road, Hamilton VIC 3300',           'active')
    RETURNING id INTO s_hamilton;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_sw, 'Torquay College',             '45 Grossmans Road, Torquay VIC 3228',       'active')
    RETURNING id INTO s_torquay;

  -- South-Eastern Victoria
  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_se, 'Frankston High School',       '31 Foot Street, Frankston VIC 3199',        'active')
    RETURNING id INTO s_frankston;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_se, 'Dandenong Primary School',    '10 Mason Street, Dandenong VIC 3175',       'active')
    RETURNING id INTO s_dandenong;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_se, 'Pakenham Secondary College',  '100 Princes Highway, Pakenham VIC 3810',    'active')
    RETURNING id INTO s_pakenham;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_se, 'Cranbourne East Primary School', '90 Tuckers Road, Cranbourne East VIC 3977', 'active')
    RETURNING id INTO s_cranbourne;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_se, 'Traralgon Secondary College', '40 Breed Street, Traralgon VIC 3844',       'active')
    RETURNING id INTO s_traralgon;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_se, 'Bairnsdale Secondary College','100 Dalmahoy Street, Bairnsdale VIC 3875',  'on_hold')
    RETURNING id INTO s_bairnsdale;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_se, 'Sale College',                '141 York Street, Sale VIC 3850',            'active')
    RETURNING id INTO s_sale;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_se, 'Warragul Regional College',   '16 Burke Street, Warragul VIC 3820',        'active')
    RETURNING id INTO s_warragul;

  INSERT INTO schools (program_id, region_id, name, address, status)
    VALUES (prog_id, r_se, 'Moe Secondary College',       '65 Albert Street, Moe VIC 3825',            'completed')
    RETURNING id INTO s_moe;

  -- =========================================================================
  -- 4. Insert RAMPS (milestone trigger fires automatically)
  -- =========================================================================

  -- Ballarat Primary — 2 ramps
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_ballarat, 'BAL-001', 'Roof replacement and guttering upgrade', 'construction', 'active', 280000, 195000, 275000)
    RETURNING id INTO r_bal1;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_ballarat, 'BAL-002', 'Electrical switchboard replacement', 'design', 'active', 95000, 12000, 95000)
    RETURNING id INTO r_bal2;

  -- Bendigo Secondary — 3 ramps
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_bendigo, 'BEN-001', 'Science block refurbishment', 'admin_closeout', 'active', 450000, 448000, 452000)
    RETURNING id INTO r_ben1;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_bendigo, 'BEN-002', 'HVAC system upgrade — Building B', 'dlp', 'active', 120000, 118500, 118500)
    RETURNING id INTO r_ben2;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_bendigo, 'BEN-003', 'Carpark resurfacing and line marking', 'design', 'active', 75000, 5000, 75000)
    RETURNING id INTO r_ben3;

  -- Geelong Grammar — 2 ramps
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_geelong, 'GEE-001', 'Library building external painting', 'construction', 'active', 180000, 130000, 178000)
    RETURNING id INTO r_gee1;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_geelong, 'GEE-002', 'Accessible toilet upgrade — Block C', 'final_closure', 'completed', 65000, 63200, 63200)
    RETURNING id INTO r_gee2;

  -- Wodonga — 3 ramps
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_wodonga, 'WOD-001', 'Gymnasium floor replacement', 'construction', 'active', 320000, 210000, 325000)
    RETURNING id INTO r_wod1;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_wodonga, 'WOD-002', 'Administration building re-roofing', 'design', 'active', 155000, 18000, 155000)
    RETURNING id INTO r_wod2;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_wodonga, 'WOD-003', 'Plumbing upgrade — kitchen and amenities', 'dlp', 'active', 88000, 87000, 87000)
    RETURNING id INTO r_wod3;

  -- Shepparton — 1 ramp
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_shepparton, 'SHE-001', 'Oval drainage and irrigation works', 'construction', 'on_hold', 200000, 45000, 210000)
    RETURNING id INTO r_she1;

  -- Warrnambool — 2 ramps
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_warrnambool, 'WAR-001', 'Performing arts centre refurbishment', 'admin_closeout', 'active', 500000, 495000, 503000)
    RETURNING id INTO r_war1;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_warrnambool, 'WAR-002', 'External paving and drainage', 'design', 'active', 110000, 8000, 110000)
    RETURNING id INTO r_war2;

  -- Mildura — 3 ramps
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_mildura, 'MIL-001', 'Solar panel installation — main building', 'construction', 'active', 275000, 150000, 270000)
    RETURNING id INTO r_mil1;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_mildura, 'MIL-002', 'Toilet block replacement', 'dlp', 'active', 145000, 142000, 142000)
    RETURNING id INTO r_mil2;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_mildura, 'MIL-003', 'Security fencing upgrade', 'design', 'active', 55000, 4500, 55000)
    RETURNING id INTO r_mil3;

  -- Horsham — 1 ramp
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_horsham, 'HOR-001', 'Art room refurbishment', 'design', 'on_hold', 120000, 0, 120000)
    RETURNING id INTO r_hor1;

  -- Ararat — 2 ramps
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_ararat, 'ARA-001', 'Asphalt playground resurfacing', 'construction', 'active', 85000, 60000, 85000)
    RETURNING id INTO r_ara1;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_ararat, 'ARA-002', 'Portable building electrical upgrade', 'admin_closeout', 'active', 50000, 49800, 50200)
    RETURNING id INTO r_ara2;

  -- Hamilton — 1 ramp
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_hamilton, 'HAM-001', 'Canteen kitchen fitout', 'construction', 'active', 195000, 100000, 200000)
    RETURNING id INTO r_ham1;

  -- Wangaratta — 2 ramps
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_wangaratta, 'WAN-001', 'Roof restoration — B Block', 'final_closure', 'completed', 90000, 88000, 88000)
    RETURNING id INTO r_wan1;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_wangaratta, 'WAN-002', 'Staff room refurbishment', 'construction', 'active', 140000, 80000, 142000)
    RETURNING id INTO r_wan2;

  -- Albury — 1 ramp
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_albury, 'ALB-001', 'Window replacement programme', 'design', 'on_hold', 160000, 5000, 165000)
    RETURNING id INTO r_alb1;

  -- Echuca — 2 ramps
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_echuca, 'ECH-001', 'Oval lighting installation', 'construction', 'active', 215000, 175000, 218000)
    RETURNING id INTO r_ech1;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_echuca, 'ECH-002', 'Library fit-out upgrade', 'design', 'active', 130000, 12000, 130000)
    RETURNING id INTO r_ech2;

  -- Swan Hill — 1 ramp
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_swan_hill, 'SWH-001', 'Classroom wing refurbishment', 'final_closure', 'completed', 380000, 376000, 376000)
    RETURNING id INTO r_swh1;

  -- Sunbury — 2 ramps
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_sunbury, 'SUN-001', 'Multipurpose courts resurfacing', 'admin_closeout', 'active', 175000, 172000, 174000)
    RETURNING id INTO r_sun1;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_sunbury, 'SUN-002', 'Shade structure installation', 'construction', 'active', 95000, 50000, 95000)
    RETURNING id INTO r_sun2;

  -- Frankston — 3 ramps
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_frankston, 'FRA-001', 'Senior building refurbishment', 'construction', 'active', 490000, 320000, 495000)
    RETURNING id INTO r_fra1;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_frankston, 'FRA-002', 'Portable classrooms — new connections', 'design', 'active', 80000, 6000, 80000)
    RETURNING id INTO r_fra2;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_frankston, 'FRA-003', 'Perimeter fencing replacement', 'dlp', 'active', 115000, 113000, 113000)
    RETURNING id INTO r_fra3;

  -- Dandenong — 2 ramps
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_dandenong, 'DAN-001', 'Science lab upgrade — Blocks 3 & 4', 'construction', 'active', 350000, 200000, 355000)
    RETURNING id INTO r_dan1;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_dandenong, 'DAN-002', 'Canopy and walkway installation', 'design', 'active', 65000, 0, 65000)
    RETURNING id INTO r_dan2;

  -- Pakenham — 1 ramp
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_pakenham, 'PAK-001', 'Technology wing refurbishment', 'admin_closeout', 'active', 420000, 416000, 420000)
    RETURNING id INTO r_pak1;

  -- Cranbourne — 2 ramps
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_cranbourne, 'CRA-001', 'Covered outdoor learning area', 'construction', 'active', 230000, 140000, 235000)
    RETURNING id INTO r_cra1;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_cranbourne, 'CRA-002', 'Stormwater management upgrade', 'design', 'active', 105000, 9000, 105000)
    RETURNING id INTO r_cra2;

  -- Traralgon — 3 ramps
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_traralgon, 'TRA-001', 'Gymnasium HVAC replacement', 'dlp', 'active', 185000, 183000, 183000)
    RETURNING id INTO r_tra1;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_traralgon, 'TRA-002', 'Toilet block refurbishment — Block A', 'construction', 'active', 155000, 80000, 158000)
    RETURNING id INTO r_tra2;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_traralgon, 'TRA-003', 'Covered walkway — admin to classrooms', 'design', 'active', 70000, 4000, 70000)
    RETURNING id INTO r_tra3;

  -- Bairnsdale — 1 ramp
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_bairnsdale, 'BAI-001', 'External painting programme', 'on_hold', 'blocked', 145000, 10000, 155000)
    RETURNING id INTO r_bai1;

  -- Sale — 2 ramps
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_sale, 'SAL-001', 'Performing arts floor replacement', 'construction', 'active', 260000, 160000, 262000)
    RETURNING id INTO r_sal1;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_sale, 'SAL-002', 'Canteen equipment replacement', 'admin_closeout', 'active', 95000, 93000, 93500)
    RETURNING id INTO r_sal2;

  -- Warragul — 1 ramp
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_warragul, 'WRG-001', 'Library and resource centre upgrade', 'construction', 'active', 310000, 190000, 315000)
    RETURNING id INTO r_wrg1;

  -- Moe — 2 ramps
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_moe, 'MOE-001', 'Main building re-roofing', 'final_closure', 'completed', 340000, 336500, 336500)
    RETURNING id INTO r_moe1;
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_moe, 'MOE-002', 'Carpark resurfacing', 'final_closure', 'completed', 78000, 76800, 76800)
    RETURNING id INTO r_moe2;

  -- Torquay — 1 ramp
  INSERT INTO ramps (school_id, name, description, lifecycle_stage, status, budget_amount, actual_amount, forecast_amount)
    VALUES (s_torquay, 'TOR-001', 'New science and technology wing', 'design', 'active', 480000, 25000, 480000)
    RETURNING id INTO r_tor1;

  -- =========================================================================
  -- 5. Update milestone dates
  -- Design Signoff=1, Practical Completion=2, Administrative Completion=3,
  -- DLP Complete=4, Final Closure=5
  -- =========================================================================

  -- BAL-001 construction: Design done, PC amber (10 days out), rest future
  UPDATE milestones SET planned_date = '2024-11-15', actual_date = '2024-11-18' WHERE ramp_id = r_bal1 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 10)                       WHERE ramp_id = r_bal1 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 40)                       WHERE ramp_id = r_bal1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 130)                      WHERE ramp_id = r_bal1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 160)                      WHERE ramp_id = r_bal1 AND sort_order = 5;

  -- BAL-002 design: Design Signoff upcoming (future)
  UPDATE milestones SET planned_date = (CURRENT_DATE + 45) WHERE ramp_id = r_bal2 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 120) WHERE ramp_id = r_bal2 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 150) WHERE ramp_id = r_bal2 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 240) WHERE ramp_id = r_bal2 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 270) WHERE ramp_id = r_bal2 AND sort_order = 5;

  -- BEN-001 admin_closeout: first 3 done, Admin Completion overdue (no actual)
  UPDATE milestones SET planned_date = '2024-07-10', actual_date = '2024-07-12' WHERE ramp_id = r_ben1 AND sort_order = 1;
  UPDATE milestones SET planned_date = '2024-10-20', actual_date = '2024-10-25' WHERE ramp_id = r_ben1 AND sort_order = 2;
  UPDATE milestones SET planned_date = '2025-01-15'                             WHERE ramp_id = r_ben1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 90)                      WHERE ramp_id = r_ben1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 120)                     WHERE ramp_id = r_ben1 AND sort_order = 5;

  -- BEN-002 dlp: first 3 complete, DLP overdue
  UPDATE milestones SET planned_date = '2024-04-01', actual_date = '2024-04-03' WHERE ramp_id = r_ben2 AND sort_order = 1;
  UPDATE milestones SET planned_date = '2024-07-15', actual_date = '2024-07-20' WHERE ramp_id = r_ben2 AND sort_order = 2;
  UPDATE milestones SET planned_date = '2024-09-01', actual_date = '2024-09-05' WHERE ramp_id = r_ben2 AND sort_order = 3;
  UPDATE milestones SET planned_date = '2025-09-01'                             WHERE ramp_id = r_ben2 AND sort_order = 4;
  UPDATE milestones SET planned_date = '2025-10-01'                             WHERE ramp_id = r_ben2 AND sort_order = 5;

  -- BEN-003 design: all future
  UPDATE milestones SET planned_date = (CURRENT_DATE + 60)  WHERE ramp_id = r_ben3 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 150) WHERE ramp_id = r_ben3 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 180) WHERE ramp_id = r_ben3 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 270) WHERE ramp_id = r_ben3 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 300) WHERE ramp_id = r_ben3 AND sort_order = 5;

  -- GEE-001 construction: Design done, PC amber (8 days)
  UPDATE milestones SET planned_date = '2025-01-20', actual_date = '2025-01-22' WHERE ramp_id = r_gee1 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 8)                        WHERE ramp_id = r_gee1 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 38)                       WHERE ramp_id = r_gee1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 128)                      WHERE ramp_id = r_gee1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 158)                      WHERE ramp_id = r_gee1 AND sort_order = 5;

  -- GEE-002 final_closure: all complete
  UPDATE milestones SET planned_date = '2024-03-01', actual_date = '2024-03-04' WHERE ramp_id = r_gee2 AND sort_order = 1;
  UPDATE milestones SET planned_date = '2024-06-01', actual_date = '2024-06-10' WHERE ramp_id = r_gee2 AND sort_order = 2;
  UPDATE milestones SET planned_date = '2024-08-01', actual_date = '2024-08-05' WHERE ramp_id = r_gee2 AND sort_order = 3;
  UPDATE milestones SET planned_date = '2025-08-01', actual_date = '2025-08-12' WHERE ramp_id = r_gee2 AND sort_order = 4;
  UPDATE milestones SET planned_date = '2025-09-01', actual_date = '2025-09-15' WHERE ramp_id = r_gee2 AND sort_order = 5;

  -- WOD-001 construction: Design done, PC overdue (past, no actual)
  UPDATE milestones SET planned_date = '2025-02-10', actual_date = '2025-02-14' WHERE ramp_id = r_wod1 AND sort_order = 1;
  UPDATE milestones SET planned_date = '2026-02-28'                              WHERE ramp_id = r_wod1 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 60)                       WHERE ramp_id = r_wod1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 150)                      WHERE ramp_id = r_wod1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 180)                      WHERE ramp_id = r_wod1 AND sort_order = 5;

  -- WOD-002 design: all future
  UPDATE milestones SET planned_date = (CURRENT_DATE + 30)  WHERE ramp_id = r_wod2 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 110) WHERE ramp_id = r_wod2 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 140) WHERE ramp_id = r_wod2 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 230) WHERE ramp_id = r_wod2 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 260) WHERE ramp_id = r_wod2 AND sort_order = 5;

  -- WOD-003 dlp: first 3 complete
  UPDATE milestones SET planned_date = '2024-06-05', actual_date = '2024-06-07' WHERE ramp_id = r_wod3 AND sort_order = 1;
  UPDATE milestones SET planned_date = '2024-10-15', actual_date = '2024-10-18' WHERE ramp_id = r_wod3 AND sort_order = 2;
  UPDATE milestones SET planned_date = '2024-12-01', actual_date = '2024-12-03' WHERE ramp_id = r_wod3 AND sort_order = 3;
  UPDATE milestones SET planned_date = '2025-12-01'                              WHERE ramp_id = r_wod3 AND sort_order = 4;
  UPDATE milestones SET planned_date = '2026-01-01'                              WHERE ramp_id = r_wod3 AND sort_order = 5;

  -- SHE-001 construction on_hold: Design signoff overdue
  UPDATE milestones SET planned_date = '2025-11-01'                             WHERE ramp_id = r_she1 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 90)                      WHERE ramp_id = r_she1 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 120)                     WHERE ramp_id = r_she1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 210)                     WHERE ramp_id = r_she1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 240)                     WHERE ramp_id = r_she1 AND sort_order = 5;

  -- WAR-001 admin_closeout: first 2 done, Admin Completion amber (12 days)
  UPDATE milestones SET planned_date = '2024-09-10', actual_date = '2024-09-12' WHERE ramp_id = r_war1 AND sort_order = 1;
  UPDATE milestones SET planned_date = '2025-01-20', actual_date = '2025-01-28' WHERE ramp_id = r_war1 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 12)                       WHERE ramp_id = r_war1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 100)                      WHERE ramp_id = r_war1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 130)                      WHERE ramp_id = r_war1 AND sort_order = 5;

  -- WAR-002 design: all future
  UPDATE milestones SET planned_date = (CURRENT_DATE + 55)  WHERE ramp_id = r_war2 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 135) WHERE ramp_id = r_war2 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 165) WHERE ramp_id = r_war2 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 255) WHERE ramp_id = r_war2 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 285) WHERE ramp_id = r_war2 AND sort_order = 5;

  -- MIL-001 construction: Design done, PC future
  UPDATE milestones SET planned_date = '2025-03-15', actual_date = '2025-03-18' WHERE ramp_id = r_mil1 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 25)                       WHERE ramp_id = r_mil1 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 55)                       WHERE ramp_id = r_mil1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 145)                      WHERE ramp_id = r_mil1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 175)                      WHERE ramp_id = r_mil1 AND sort_order = 5;

  -- MIL-002 dlp: first 3 complete, DLP future
  UPDATE milestones SET planned_date = '2024-05-10', actual_date = '2024-05-14' WHERE ramp_id = r_mil2 AND sort_order = 1;
  UPDATE milestones SET planned_date = '2024-09-20', actual_date = '2024-09-22' WHERE ramp_id = r_mil2 AND sort_order = 2;
  UPDATE milestones SET planned_date = '2024-11-10', actual_date = '2024-11-15' WHERE ramp_id = r_mil2 AND sort_order = 3;
  UPDATE milestones SET planned_date = '2025-11-10'                              WHERE ramp_id = r_mil2 AND sort_order = 4;
  UPDATE milestones SET planned_date = '2025-12-10'                              WHERE ramp_id = r_mil2 AND sort_order = 5;

  -- MIL-003 design: all future
  UPDATE milestones SET planned_date = (CURRENT_DATE + 50)  WHERE ramp_id = r_mil3 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 130) WHERE ramp_id = r_mil3 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 160) WHERE ramp_id = r_mil3 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 250) WHERE ramp_id = r_mil3 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 280) WHERE ramp_id = r_mil3 AND sort_order = 5;

  -- HOR-001 design on_hold: future dates pushed
  UPDATE milestones SET planned_date = (CURRENT_DATE + 90)  WHERE ramp_id = r_hor1 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 170) WHERE ramp_id = r_hor1 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 200) WHERE ramp_id = r_hor1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 290) WHERE ramp_id = r_hor1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 320) WHERE ramp_id = r_hor1 AND sort_order = 5;

  -- ARA-001 construction: Design done, PC future
  UPDATE milestones SET planned_date = '2025-04-01', actual_date = '2025-04-03' WHERE ramp_id = r_ara1 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 20)                       WHERE ramp_id = r_ara1 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 50)                       WHERE ramp_id = r_ara1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 140)                      WHERE ramp_id = r_ara1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 170)                      WHERE ramp_id = r_ara1 AND sort_order = 5;

  -- ARA-002 admin_closeout: all done bar Final Closure
  UPDATE milestones SET planned_date = '2024-10-01', actual_date = '2024-10-03' WHERE ramp_id = r_ara2 AND sort_order = 1;
  UPDATE milestones SET planned_date = '2025-01-10', actual_date = '2025-01-14' WHERE ramp_id = r_ara2 AND sort_order = 2;
  UPDATE milestones SET planned_date = '2025-03-01', actual_date = '2025-03-04' WHERE ramp_id = r_ara2 AND sort_order = 3;
  UPDATE milestones SET planned_date = '2026-03-01'                              WHERE ramp_id = r_ara2 AND sort_order = 4;
  UPDATE milestones SET planned_date = '2026-04-01'                              WHERE ramp_id = r_ara2 AND sort_order = 5;

  -- HAM-001 construction: Design done, PC amber (7 days)
  UPDATE milestones SET planned_date = '2025-02-20', actual_date = '2025-02-25' WHERE ramp_id = r_ham1 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 7)                        WHERE ramp_id = r_ham1 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 37)                       WHERE ramp_id = r_ham1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 127)                      WHERE ramp_id = r_ham1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 157)                      WHERE ramp_id = r_ham1 AND sort_order = 5;

  -- WAN-001 final_closure completed
  UPDATE milestones SET planned_date = '2023-11-01', actual_date = '2023-11-05' WHERE ramp_id = r_wan1 AND sort_order = 1;
  UPDATE milestones SET planned_date = '2024-02-28', actual_date = '2024-03-05' WHERE ramp_id = r_wan1 AND sort_order = 2;
  UPDATE milestones SET planned_date = '2024-04-15', actual_date = '2024-04-18' WHERE ramp_id = r_wan1 AND sort_order = 3;
  UPDATE milestones SET planned_date = '2025-04-15', actual_date = '2025-04-20' WHERE ramp_id = r_wan1 AND sort_order = 4;
  UPDATE milestones SET planned_date = '2025-05-30', actual_date = '2025-06-02' WHERE ramp_id = r_wan1 AND sort_order = 5;

  -- WAN-002 construction: Design done, PC future
  UPDATE milestones SET planned_date = '2025-05-01', actual_date = '2025-05-06' WHERE ramp_id = r_wan2 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 35)                       WHERE ramp_id = r_wan2 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 65)                       WHERE ramp_id = r_wan2 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 155)                      WHERE ramp_id = r_wan2 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 185)                      WHERE ramp_id = r_wan2 AND sort_order = 5;

  -- ALB-001 design on_hold: future dates
  UPDATE milestones SET planned_date = (CURRENT_DATE + 75)  WHERE ramp_id = r_alb1 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 155) WHERE ramp_id = r_alb1 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 185) WHERE ramp_id = r_alb1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 275) WHERE ramp_id = r_alb1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 305) WHERE ramp_id = r_alb1 AND sort_order = 5;

  -- ECH-001 construction: Design done, PC amber (13 days)
  UPDATE milestones SET planned_date = '2025-01-15', actual_date = '2025-01-20' WHERE ramp_id = r_ech1 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 13)                       WHERE ramp_id = r_ech1 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 43)                       WHERE ramp_id = r_ech1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 133)                      WHERE ramp_id = r_ech1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 163)                      WHERE ramp_id = r_ech1 AND sort_order = 5;

  -- ECH-002 design: all future
  UPDATE milestones SET planned_date = (CURRENT_DATE + 40)  WHERE ramp_id = r_ech2 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 120) WHERE ramp_id = r_ech2 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 150) WHERE ramp_id = r_ech2 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 240) WHERE ramp_id = r_ech2 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 270) WHERE ramp_id = r_ech2 AND sort_order = 5;

  -- SWH-001 final_closure completed
  UPDATE milestones SET planned_date = '2023-06-01', actual_date = '2023-06-05' WHERE ramp_id = r_swh1 AND sort_order = 1;
  UPDATE milestones SET planned_date = '2023-10-15', actual_date = '2023-10-20' WHERE ramp_id = r_swh1 AND sort_order = 2;
  UPDATE milestones SET planned_date = '2023-12-01', actual_date = '2023-12-06' WHERE ramp_id = r_swh1 AND sort_order = 3;
  UPDATE milestones SET planned_date = '2024-12-01', actual_date = '2024-12-10' WHERE ramp_id = r_swh1 AND sort_order = 4;
  UPDATE milestones SET planned_date = '2025-01-15', actual_date = '2025-01-20' WHERE ramp_id = r_swh1 AND sort_order = 5;

  -- SUN-001 admin_closeout: first 3 done, Admin overdue
  UPDATE milestones SET planned_date = '2024-08-20', actual_date = '2024-08-22' WHERE ramp_id = r_sun1 AND sort_order = 1;
  UPDATE milestones SET planned_date = '2024-12-10', actual_date = '2024-12-15' WHERE ramp_id = r_sun1 AND sort_order = 2;
  UPDATE milestones SET planned_date = '2025-02-01'                              WHERE ramp_id = r_sun1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 80)                       WHERE ramp_id = r_sun1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 110)                      WHERE ramp_id = r_sun1 AND sort_order = 5;

  -- SUN-002 construction: Design done, PC future
  UPDATE milestones SET planned_date = '2025-06-01', actual_date = '2025-06-04' WHERE ramp_id = r_sun2 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 30)                       WHERE ramp_id = r_sun2 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 60)                       WHERE ramp_id = r_sun2 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 150)                      WHERE ramp_id = r_sun2 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 180)                      WHERE ramp_id = r_sun2 AND sort_order = 5;

  -- FRA-001 construction: Design done, PC future
  UPDATE milestones SET planned_date = '2025-04-10', actual_date = '2025-04-14' WHERE ramp_id = r_fra1 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 50)                       WHERE ramp_id = r_fra1 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 80)                       WHERE ramp_id = r_fra1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 170)                      WHERE ramp_id = r_fra1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 200)                      WHERE ramp_id = r_fra1 AND sort_order = 5;

  -- FRA-002 design: all future
  UPDATE milestones SET planned_date = (CURRENT_DATE + 65)  WHERE ramp_id = r_fra2 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 145) WHERE ramp_id = r_fra2 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 175) WHERE ramp_id = r_fra2 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 265) WHERE ramp_id = r_fra2 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 295) WHERE ramp_id = r_fra2 AND sort_order = 5;

  -- FRA-003 dlp: first 3 complete
  UPDATE milestones SET planned_date = '2024-07-01', actual_date = '2024-07-04' WHERE ramp_id = r_fra3 AND sort_order = 1;
  UPDATE milestones SET planned_date = '2024-11-01', actual_date = '2024-11-06' WHERE ramp_id = r_fra3 AND sort_order = 2;
  UPDATE milestones SET planned_date = '2024-12-15', actual_date = '2024-12-18' WHERE ramp_id = r_fra3 AND sort_order = 3;
  UPDATE milestones SET planned_date = '2025-12-15'                              WHERE ramp_id = r_fra3 AND sort_order = 4;
  UPDATE milestones SET planned_date = '2026-01-15'                              WHERE ramp_id = r_fra3 AND sort_order = 5;

  -- DAN-001 construction: Design done, PC overdue
  UPDATE milestones SET planned_date = '2025-03-01', actual_date = '2025-03-05' WHERE ramp_id = r_dan1 AND sort_order = 1;
  UPDATE milestones SET planned_date = '2026-02-15'                              WHERE ramp_id = r_dan1 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 70)                       WHERE ramp_id = r_dan1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 160)                      WHERE ramp_id = r_dan1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 190)                      WHERE ramp_id = r_dan1 AND sort_order = 5;

  -- DAN-002 design: all future
  UPDATE milestones SET planned_date = (CURRENT_DATE + 80)  WHERE ramp_id = r_dan2 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 160) WHERE ramp_id = r_dan2 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 190) WHERE ramp_id = r_dan2 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 280) WHERE ramp_id = r_dan2 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 310) WHERE ramp_id = r_dan2 AND sort_order = 5;

  -- PAK-001 admin_closeout: first 2 done, Admin Completion amber (5 days)
  UPDATE milestones SET planned_date = '2024-11-01', actual_date = '2024-11-04' WHERE ramp_id = r_pak1 AND sort_order = 1;
  UPDATE milestones SET planned_date = '2025-03-10', actual_date = '2025-03-14' WHERE ramp_id = r_pak1 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 5)                        WHERE ramp_id = r_pak1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 95)                       WHERE ramp_id = r_pak1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 125)                      WHERE ramp_id = r_pak1 AND sort_order = 5;

  -- CRA-001 construction: Design done, PC future
  UPDATE milestones SET planned_date = '2025-05-20', actual_date = '2025-05-23' WHERE ramp_id = r_cra1 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 45)                       WHERE ramp_id = r_cra1 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 75)                       WHERE ramp_id = r_cra1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 165)                      WHERE ramp_id = r_cra1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 195)                      WHERE ramp_id = r_cra1 AND sort_order = 5;

  -- CRA-002 design: all future
  UPDATE milestones SET planned_date = (CURRENT_DATE + 70)  WHERE ramp_id = r_cra2 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 150) WHERE ramp_id = r_cra2 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 180) WHERE ramp_id = r_cra2 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 270) WHERE ramp_id = r_cra2 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 300) WHERE ramp_id = r_cra2 AND sort_order = 5;

  -- TRA-001 dlp: first 3 done
  UPDATE milestones SET planned_date = '2024-08-15', actual_date = '2024-08-19' WHERE ramp_id = r_tra1 AND sort_order = 1;
  UPDATE milestones SET planned_date = '2024-12-20', actual_date = '2024-12-23' WHERE ramp_id = r_tra1 AND sort_order = 2;
  UPDATE milestones SET planned_date = '2025-02-15', actual_date = '2025-02-18' WHERE ramp_id = r_tra1 AND sort_order = 3;
  UPDATE milestones SET planned_date = '2026-02-15'                              WHERE ramp_id = r_tra1 AND sort_order = 4;
  UPDATE milestones SET planned_date = '2026-03-15'                              WHERE ramp_id = r_tra1 AND sort_order = 5;

  -- TRA-002 construction: Design done, PC amber (11 days)
  UPDATE milestones SET planned_date = '2025-06-10', actual_date = '2025-06-12' WHERE ramp_id = r_tra2 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 11)                       WHERE ramp_id = r_tra2 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 41)                       WHERE ramp_id = r_tra2 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 131)                      WHERE ramp_id = r_tra2 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 161)                      WHERE ramp_id = r_tra2 AND sort_order = 5;

  -- TRA-003 design: all future
  UPDATE milestones SET planned_date = (CURRENT_DATE + 55)  WHERE ramp_id = r_tra3 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 135) WHERE ramp_id = r_tra3 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 165) WHERE ramp_id = r_tra3 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 255) WHERE ramp_id = r_tra3 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 285) WHERE ramp_id = r_tra3 AND sort_order = 5;

  -- BAI-001 on_hold/blocked: Design overdue
  UPDATE milestones SET planned_date = '2025-10-01'                              WHERE ramp_id = r_bai1 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 100)                      WHERE ramp_id = r_bai1 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 130)                      WHERE ramp_id = r_bai1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 220)                      WHERE ramp_id = r_bai1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 250)                      WHERE ramp_id = r_bai1 AND sort_order = 5;

  -- SAL-001 construction: Design done, PC future
  UPDATE milestones SET planned_date = '2025-05-01', actual_date = '2025-05-07' WHERE ramp_id = r_sal1 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 55)                       WHERE ramp_id = r_sal1 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 85)                       WHERE ramp_id = r_sal1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 175)                      WHERE ramp_id = r_sal1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 205)                      WHERE ramp_id = r_sal1 AND sort_order = 5;

  -- SAL-002 admin_closeout: all complete
  UPDATE milestones SET planned_date = '2024-10-05', actual_date = '2024-10-08' WHERE ramp_id = r_sal2 AND sort_order = 1;
  UPDATE milestones SET planned_date = '2025-01-25', actual_date = '2025-01-28' WHERE ramp_id = r_sal2 AND sort_order = 2;
  UPDATE milestones SET planned_date = '2025-03-15', actual_date = '2025-03-18' WHERE ramp_id = r_sal2 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 85)                       WHERE ramp_id = r_sal2 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 115)                      WHERE ramp_id = r_sal2 AND sort_order = 5;

  -- WRG-001 construction: Design done, PC future
  UPDATE milestones SET planned_date = '2025-04-20', actual_date = '2025-04-24' WHERE ramp_id = r_wrg1 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 40)                       WHERE ramp_id = r_wrg1 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 70)                       WHERE ramp_id = r_wrg1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 160)                      WHERE ramp_id = r_wrg1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 190)                      WHERE ramp_id = r_wrg1 AND sort_order = 5;

  -- MOE-001 final_closure completed
  UPDATE milestones SET planned_date = '2023-08-01', actual_date = '2023-08-05' WHERE ramp_id = r_moe1 AND sort_order = 1;
  UPDATE milestones SET planned_date = '2023-12-15', actual_date = '2023-12-19' WHERE ramp_id = r_moe1 AND sort_order = 2;
  UPDATE milestones SET planned_date = '2024-02-01', actual_date = '2024-02-06' WHERE ramp_id = r_moe1 AND sort_order = 3;
  UPDATE milestones SET planned_date = '2025-02-01', actual_date = '2025-02-08' WHERE ramp_id = r_moe1 AND sort_order = 4;
  UPDATE milestones SET planned_date = '2025-03-15', actual_date = '2025-03-20' WHERE ramp_id = r_moe1 AND sort_order = 5;

  -- MOE-002 final_closure completed
  UPDATE milestones SET planned_date = '2024-03-01', actual_date = '2024-03-04' WHERE ramp_id = r_moe2 AND sort_order = 1;
  UPDATE milestones SET planned_date = '2024-06-30', actual_date = '2024-07-04' WHERE ramp_id = r_moe2 AND sort_order = 2;
  UPDATE milestones SET planned_date = '2024-08-15', actual_date = '2024-08-19' WHERE ramp_id = r_moe2 AND sort_order = 3;
  UPDATE milestones SET planned_date = '2025-08-15', actual_date = '2025-08-22' WHERE ramp_id = r_moe2 AND sort_order = 4;
  UPDATE milestones SET planned_date = '2025-09-30', actual_date = '2025-10-02' WHERE ramp_id = r_moe2 AND sort_order = 5;

  -- TOR-001 design: all future
  UPDATE milestones SET planned_date = (CURRENT_DATE + 100) WHERE ramp_id = r_tor1 AND sort_order = 1;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 220) WHERE ramp_id = r_tor1 AND sort_order = 2;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 260) WHERE ramp_id = r_tor1 AND sort_order = 3;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 380) WHERE ramp_id = r_tor1 AND sort_order = 4;
  UPDATE milestones SET planned_date = (CURRENT_DATE + 420) WHERE ramp_id = r_tor1 AND sort_order = 5;

  -- =========================================================================
  -- 6. Insert variations
  -- =========================================================================
  INSERT INTO variations (ramp_id, description, amount, status, date) VALUES
    -- BAL-001
    (r_bal1, 'Additional flashing works to parapet walls', 12500, 'approved', '2025-01-15'),
    (r_bal1, 'Replacement of unexpected rotted fascia boards', 8200, 'pending', CURRENT_DATE - 5),
    -- BEN-001
    (r_ben1, 'Hazardous material removal — asbestos found in wall cavity', 32000, 'approved', '2024-09-20'),
    (r_ben1, 'Extended supervision period due to contractor delay', 9500, 'approved', '2024-11-10'),
    (r_ben1, 'Additional structural rectification works', 18000, 'pending', CURRENT_DATE - 8),
    -- GEE-001
    (r_gee1, 'Revised paint spec to low-VOC product', 4200, 'approved', '2025-02-10'),
    -- WOD-001
    (r_wod1, 'Subfloor moisture barrier installation', 22000, 'approved', '2025-03-01'),
    (r_wod1, 'Upgraded sprung floor system', 35000, 'rejected', '2025-03-15'),
    -- WAR-001
    (r_war1, 'Upgraded acoustic panel specification', 28000, 'approved', '2024-10-05'),
    (r_war1, 'Additional fire suppression upgrade', 45000, 'approved', '2024-12-12'),
    (r_war1, 'Delay claim — contractor extended programme', 15000, 'pending', CURRENT_DATE - 3),
    -- MIL-001
    (r_mil1, 'Upgraded inverter specification', 14000, 'approved', '2025-04-01'),
    (r_mil1, 'Additional panel cleaning system', 6500, 'pending', CURRENT_DATE - 10),
    -- FRA-001
    (r_fra1, 'Subfloor rectification — unexpected pier failure', 27500, 'approved', '2025-05-10'),
    (r_fra1, 'Additional concrete works — cracked slab', 19000, 'pending', CURRENT_DATE - 6),
    -- DAN-001
    (r_dan1, 'Laboratory fume hood specification upgrade', 22000, 'approved', '2025-04-15'),
    -- CRA-001
    (r_cra1, 'Extended drainage easement works', 18500, 'approved', '2025-06-10'),
    -- TRA-001
    (r_tra1, 'Refrigerant recovery and disposal', 5500, 'approved', '2024-10-01'),
    -- SAL-001
    (r_sal1, 'Upgraded spring floor system specification', 31000, 'pending', CURRENT_DATE - 2),
    -- WRG-001
    (r_wrg1, 'Additional joinery scope — study carrels', 16000, 'approved', '2025-05-20'),
    -- PAK-001
    (r_pak1, 'Additional power outlets for technology equipment', 7800, 'approved', '2024-12-05'),
    (r_pak1, 'Asbestos encapsulation works', 24000, 'approved', '2024-12-20');

  -- =========================================================================
  -- 7. Insert defects
  -- =========================================================================
  INSERT INTO defects (ramp_id, description, status, identified_date, resolved_date) VALUES
    -- Construction ramps with open defects
    (r_bal1, 'Ridge capping not fully sealed at east gable end', 'open', CURRENT_DATE - 15, NULL),
    (r_gee1, 'Paint peeling on south elevation soffit — adhesion failure', 'open', CURRENT_DATE - 8, NULL),
    (r_wod1, 'Expansion joint filler missing in NW quadrant', 'open', CURRENT_DATE - 20, NULL),
    (r_ham1, 'Splashback grout incomplete behind cooking stations', 'open', CURRENT_DATE - 5, NULL),
    (r_fra1, 'Skirting board gaps at partition walls B2-B4', 'open', CURRENT_DATE - 12, NULL),
    (r_dan1, 'Bench top laminate lifting at lab bench 6', 'open', CURRENT_DATE - 18, NULL),
    (r_cra1, 'Downpipe bracket loose on north elevation', 'open', CURRENT_DATE - 7, NULL),
    (r_tra2, 'Floor drain cover misaligned in cubicle 3', 'open', CURRENT_DATE - 3, NULL),
    (r_sal1, 'Stage lighting bar not centred — 150mm offset', 'open', CURRENT_DATE - 22, NULL),
    (r_wrg1, 'Shelf pin holes misaligned on bay 4 shelving', 'open', CURRENT_DATE - 10, NULL),
    -- DLP ramps with open defects
    (r_ben2, 'HVAC condensate drain blocked — room 12', 'open', CURRENT_DATE - 35, NULL),
    (r_wod3, 'Hot water tempering valve drifting — fluctuating temperature', 'open', CURRENT_DATE - 42, NULL),
    (r_mil2, 'Cistern slow to fill in accessible toilet', 'open', CURRENT_DATE - 28, NULL),
    (r_fra3, 'Gate latch stiff on western entry', 'open', CURRENT_DATE - 19, NULL),
    (r_tra1, 'HVAC noise — rattling in duct above gym stage', 'open', CURRENT_DATE - 14, NULL),
    -- Resolved defects
    (r_bal1, 'Gutter outlet blocked by construction debris', 'resolved', CURRENT_DATE - 40, CURRENT_DATE - 25),
    (r_ben2, 'Thermostat calibration incorrect — Room 8', 'resolved', CURRENT_DATE - 90, CURRENT_DATE - 70),
    (r_gee2, 'Flush button stiff — accessible toilet', 'resolved', '2025-10-15', '2025-10-28'),
    (r_wan1, 'Skylight leak at north rafter junction', 'resolved', '2024-05-10', '2024-05-20'),
    (r_moe1, 'Downpipe disconnected at base — block C', 'resolved', '2024-04-01', '2024-04-08'),
    (r_swh1, 'Door closer mechanism failed — Room 14', 'resolved', '2024-01-15', '2024-01-22'),
    (r_mil2, 'Blocked stormwater pit — east carpark', 'resolved', CURRENT_DATE - 60, CURRENT_DATE - 45),
    (r_sun1, 'Court line markings faded within 3 months', 'resolved', CURRENT_DATE - 55, CURRENT_DATE - 30),
    (r_pak1, 'Power point cover loose — Room T4', 'resolved', CURRENT_DATE - 80, CURRENT_DATE - 65);

  -- =========================================================================
  -- 8. Insert communications
  -- =========================================================================
  INSERT INTO communications (school_id, date, method, summary) VALUES
    -- Recent — green (within 14 days)
    (s_ballarat,    CURRENT_DATE - 2,  'email',     'Weekly progress update — roof 85% complete, tracking for PC next week'),
    (s_bendigo,     CURRENT_DATE - 5,  'phone',     'Discussion with principal re access arrangements for admin closeout inspection'),
    (s_geelong,     CURRENT_DATE - 1,  'in_person', 'Site visit — painting works progressing well, minor touch-ups identified'),
    (s_wodonga,     CURRENT_DATE - 3,  'email',     'Confirmation of PC inspection date with principal and contractor'),
    (s_warrnambool, CURRENT_DATE - 7,  'email',     'Draft admin completion checklist sent to school for review'),
    (s_mildura,     CURRENT_DATE - 4,  'phone',     'Solar installation on track, inverter delivery confirmed'),
    (s_frankston,   CURRENT_DATE - 6,  'in_person', 'Programme review meeting — contractor confirmed 8 week forecast to PC'),
    (s_dandenong,   CURRENT_DATE - 2,  'email',     'Structural report reviewed, subfloor works approved to proceed'),
    (s_pakenham,    CURRENT_DATE - 8,  'email',     'Admin closeout documentation reviewed — final items listed'),
    (s_cranbourne,  CURRENT_DATE - 3,  'phone',     'Site meeting to review drainage scope — amended drawings issued'),
    (s_traralgon,   CURRENT_DATE - 5,  'in_person', 'DLP inspection completed — 3 items identified for rectification'),
    (s_sale,        CURRENT_DATE - 9,  'email',     'Principal confirmed dates for performing arts floor installation'),
    (s_warragul,    CURRENT_DATE - 4,  'email',     'Joinery variation approved, updated programme provided'),
    (s_wangaratta,  CURRENT_DATE - 6,  'phone',     'Canteen fitout progressing — tiles completed, joinery commencing'),
    (s_ararat,      CURRENT_DATE - 10, 'email',     'Playground surface 90% complete, final coat scheduled next week'),
    (s_echuca,      CURRENT_DATE - 7,  'in_person', 'Oval lighting poles installed, cabling in progress'),
    (s_sunbury,     CURRENT_DATE - 5,  'email',     'Admin closeout sign-off documents prepared for principal review'),
    (s_torquay,     CURRENT_DATE - 3,  'email',     'Design brief review with principal — concept drawings approved'),

    -- Amber — 15-28 days ago
    (s_shepparton,  CURRENT_DATE - 18, 'email',     'Hold order confirmation issued — wet weather delays'),
    (s_moe,         CURRENT_DATE - 22, 'phone',     'Final closure documentation complete — file transferred to archive'),
    (s_swan_hill,   CURRENT_DATE - 25, 'email',     'Project complete — school signed off all retention release documents'),

    -- Red — stale > 28 days
    (s_horsham,     CURRENT_DATE - 35, 'email',     'Awaiting budget approval from VSBA to recommence design scope'),
    (s_albury,      CURRENT_DATE - 42, 'phone',     'Window schedule review deferred — school unavailable until Term 2'),
    (s_bairnsdale,  CURRENT_DATE - 50, 'email',     'External painting scope placed on hold — contractor capacity issue'),
    (s_hamilton,    CURRENT_DATE - 30, 'in_person', 'Site inspection — canteen rough-in complete, tiling to commence');

  -- =========================================================================
  -- 9. Update schools' last_communication_date
  -- =========================================================================
  UPDATE schools SET last_communication_date = CURRENT_DATE - 2  WHERE id = s_ballarat;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 5  WHERE id = s_bendigo;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 1  WHERE id = s_geelong;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 3  WHERE id = s_wodonga;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 18 WHERE id = s_shepparton;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 7  WHERE id = s_warrnambool;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 35 WHERE id = s_horsham;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 4  WHERE id = s_mildura;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 42 WHERE id = s_albury;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 30 WHERE id = s_hamilton;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 6  WHERE id = s_wangaratta;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 7  WHERE id = s_echuca;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 25 WHERE id = s_swan_hill;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 5  WHERE id = s_sunbury;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 6  WHERE id = s_frankston;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 2  WHERE id = s_dandenong;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 8  WHERE id = s_pakenham;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 3  WHERE id = s_cranbourne;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 5  WHERE id = s_traralgon;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 50 WHERE id = s_bairnsdale;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 9  WHERE id = s_sale;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 4  WHERE id = s_warragul;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 22 WHERE id = s_moe;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 10 WHERE id = s_ararat;
  UPDATE schools SET last_communication_date = CURRENT_DATE - 3  WHERE id = s_torquay;

END $$;
