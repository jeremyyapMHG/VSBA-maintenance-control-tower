-- Import communication logs from Status sheet
DO $$
DECLARE v_school_id UUID;
BEGIN
  SELECT id INTO v_school_id FROM schools WHERE name = 'Albert Park College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Alberton Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Alkira Secondary College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Status update sent by Andrew - Final');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'works completed as per john spronget email. sign off and site walk to be arranged.
AG (wrong school. Signoff received awaiting workflow closeout. No comms to school)');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Altona Green Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Status update sent by Andrew - Final');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'PDC visiting next week to review works and seek school sign off.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Hum going out onsite to measure actuals/clearances and work with PDC.');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Altona North Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Hum have advised they are looking to close out the minor defects next week. however the fencing and gate will need to be ordered and may have a lead time of 2-4 weeks just for the gate. Additionally, the planter boxes will need to be costed by Hum so we can provide those as per the concersation and request with the school.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Ramp 2 gate handrail 1m clearance, school wants planter boxes to reduce glare from new ramp, sharp kickrail edges, Cyclone gate design with lower level ambiguous.
Hum going out onsite to measure actuals/clearances and work with PDC.');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Ararat Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Ardeer Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Bacchus Marsh College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Bairnsdale Secondary College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-02-13', 'email', 'Status update sent by PDC - Ross');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Spaces are seeking to attend site to review the defects and school walk through. 4/02/2026');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Barton Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Beaumaris North Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-02-06', 'email', 'Status update sent by H&L');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Works are completed and building surveyor has inspected with the CFI''s expected iminently. H&L Architects and GRN Builder will contact the school to arrange a site walk and ensure defects are completed. School sign off will be sought and 6 months DLP will apply to the works.');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Bellbrae Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Berwick Secondary College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Ramp 1 was attended to this week to ensure accessible to staff and student until the final hand rails and rubber ramp can be installed circa 4th February due to lead times. Ramp 4 has been assessed by the engineer. Ramp 7, 9 and 10 are scheuled to complete by HUM 2nd-9th February when all works should be completed.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Ramp 4 balustrade removed, replaced, but ramp flexing & unsafe. Change of principal & FM.');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Buckley Park College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Cameron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Ramp 17 construction was due for completion 30/01/2026, extreme heat mayhave caused some delay, with the tactiles to be added 6th February as advised by Pirotta and followed by a site inspection, review and sign off.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'New school Principal');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Canadian Lead Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Cameron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'As advised from Pirotta, Ramp 3 moddex intallation of handrails between 29/01/2026 to 13/02/2026. Ramp 1 and Ramp 2 are both pending final design with Moddex. forecast due date for completion of all ramps is 27/02/2026.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Ramp 3 changed to commence 27/1 & expected for about 2wks');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Carnegie Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Carwatha College P-12' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Tim from JMA to respond to Patrick Mulcahy once Bowdens confirm. Patrick has signed off on the Ramp 18 design. Bowdens to finalise quote for approval. Works can commence as per a revised program to be provided by Bowdens. Canopy/posts works and Ramp 17 to progress next week. Engineer has advised the existing concrete footings are suitable for the new posts to replace the rotted ones.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Final design package to go to Dileep for final costing. New construction manager Quentin Greystone');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Chelsea Heights Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by N/R');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'PC Complete this week');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Chilwell Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Clayton South Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Clyde Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Coburn Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Only Ramp 12 works remaining, concrete pour was scheduled 29/01, handrails expected 16/02 and final inspection expected 20th Feb 2026.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'CFI Tues next week (R9)
R12 (demo this week, next week new ramp, complete 11 Feb). School notified of date "happy". David requested shop drawings from Moddex to review');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Colac Secondary College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Cranbourne Carlisle Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Cranbourne East Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Crib Point Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Dandenong West Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by N/R');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'JMA Architects to seek handover and completion documentation from Bowdens.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Doc to close now');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Dromana Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Drouin West Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Eagle Point Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Edithvale Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by N/R');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Ramp 2 Canopy demo was completed. JMA Architects following up on additional school request for additional concrete to remove the uneven areas in the travel space. Please follwo up with Tim Meldrum JMA.');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Elwood Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Footscray Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Gleneagles Secondary College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Grovedale West Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Haddon Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Hamlyn Banks Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Hastings Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Hopetoun P-12 College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Horsham West and Haven Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Inverleigh Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Inverloch Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Keilor Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Kensington Community High School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Kingsley Park Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-02-06', 'email', 'Status update sent by H&L');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Works are completed and building surveyor has inspected with the CFI''s expected iminently. H&L Architects and GRN Builder will contact the school to arrange a site walk and ensure defects are completed. School sign off will be sought and 6 months DLP will apply to the works. The ESM issue has been reviewed and the height appears compliant due to the levels being less than 1m fall risk and complies to the NCC. CFI  to be provided to close out same.');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Kurnai College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Kurunjang Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Status update sent by Andrew - Final');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by N/R');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Defects completed, we were advised the school is happy the defects have been attended to. 1:1 architects and HUM to seek school sign off acklowledgement. There is a six month DLP if any future defects arise in this time.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Landscape slipping issues complete. Nosing for stairs outstanding (20 Jan for install). PCC end of month (School to signoff)
Expect CFI this week');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Lakeview Senior College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Langwarrin Park Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-02-06', 'email', 'Status update sent by H&L');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by JOey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by requested GRN');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Works are completed and building surveyor has inspected with the CFI''s expected iminently. H&L Architects and GRN Builder will contact the school to arrange a site walk and ensure defects are completed. School sign off will be sought and 6 months DLP will apply to the works. The Architect will review the Ramp J and work through the school concerns and any additonal scope would need to be reviewed and approved by VSBA to be able to proceed. The ESM items will be assessed by the architect and confirmed with the building surveyor. Architect to coordinate with the school.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'close');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Langwarrin Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-02-06', 'email', 'Status update sent by H&L');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by requested GRN');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'With the installation of the balustrade this week, works are completed and building surveyor has inspected with the CFI''s expected iminently. H&L Architects and GRN Builder will contact the school to arrange a site walk and ensure defects are completed. School sign off will be sought and 6 months DLP will apply to the works.');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Lara Lake Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Lardner and District Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Lindenow Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Lucknow Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Lyndhurst Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Status update sent by Andrew - Final');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'All works scope has been completed as advised by Chippa Constructions. 1:! Architects to review for defects with the school and seek sign off acknowledgment. A six month DLP applies to works for any defect items that may occur in that period.');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Lyndhurst Secondary College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Malvern Central School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Malvern Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Malvern Valley Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Status update sent by Andrew - Final');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Spaces architects attended the school 30/01/2026 and have advised that the school’s concerns with Ramp 1 have now been addressed by the contractor to the school’s satisfaction.

It was noted the new defect (the small section of kerb railing at Ramp 3 which has snapped off) will be rectified by JLG by Friday 6th February. Please let us know if this does not occur.');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Maribyrnong Secondary College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-02-13', 'email', 'Status update sent by Pirotta - Guliano 12/2');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Cameron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'All Ramps except Ramp 9 are completed and accessible by the school. Ramp 9 progressing woith boxing and steel by 30/01 with concrete pour expected 3/02 and moddex steel to be completed by 27/02/2026 at the latest.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Ramp 9 restumping end next week, excav/geotech done. Expect end Feb.
CFI expected 14/01 for all other ramps and then for the final');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Melton Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Mentone Girls Secondary College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'All Ramps other than Ramp 4 are completed. JMA Architects following up on additional school request for additional concrete to remove the uneven areas in the travel space. Please follow up with Tim Meldrum JMA.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Roof works to Ramp see forecast for end next week (23/1). CFI for all completed ramps. Ramp for large effort');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Mentone Park Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'All works completed, builder has been requested to rectify defect drain strip. Please follow up with TIm Meldrum if this is yet to occur.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Variation/Defect to submit to Dileep ($1k)');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Miners Rest Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Cameron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'All works completed, builder has been requested to rectify Ramp 5. All ramps are open and CFI has been received. 1:1 Architects and Pirotta to seek school sign off and endorsement, noting that there is a six month defect liabilty period to cover any issues that may arise in this time. We appreciate that the Principal is away until the 29th February 2026 but we cannot delay closing out these works. The school acklowledgement is only to say the scope of works as agree has been completed. Any concerns or comments can be noted on the sign off form as a record. Happy to discuss.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'CFI 13/1 - Ramp7 failed (reduced width, could be pedantic, 1:1 to follow). 
Ramp 5 at 90% to complete this week (tactiles & handrail). 
Rebooking inspection for next Wed 21/1. PCC 27/02/26');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Mirboo North Secondary College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Moorooduc Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Moriac Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Morwell Central Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Morwell Park Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Mossgiel Park Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Status update sent by Andrew - Final');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'All works are completed. A site inspection and school acknowledgement will be sought from 1:1 Architects and Chippa. There is a six month defect liability period to cover any issues that may arise in this time.');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Mount Clear Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Mount Eliza Secondary College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Nar Nar Goon Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Newington Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Niddrie Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Nossal High School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-02-13', 'email', 'Status update sent by PDC - Raschid');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-02-06', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'We understand that there are some defect and planter works to be completed, we are awaiting HUM program to complete these remaining works. Works are however expected to be completed by 16th February 2026. Please advise if this does not occur.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'CFI inspection done but paperwork not received.  Hum to chase. Variation of planter box before progressing defect rectification ($3k). Hum wont fix defects until variations done. CFI to be book indepently.');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Overport Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-02-06', 'email', 'Status update sent by H&L');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by requested GRN');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Works are completed and building surveyor has inspected with the CFI''s expected iminently. H&L Architects and GRN Builder will contact the school to arrange a site walk and ensure defects are completed. School sign off will be sought and 6 months DLP will apply to the works.');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Pakenham Lakeside Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Parktone Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Parkwood Green Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Patterson River Secondary College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-02-06', 'email', 'Status update sent by H&L');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by requested GRN');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Works are completed and building surveyor has inspected with the CFI''s expected iminently. H&L Architects and GRN Builder will contact the school to arrange a site walk and ensure defects are completed. School sign off will be sought and 6 months DLP will apply to the works.');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Pentland Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Point Cook Senior Secondary College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Portland North Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Portland Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Roslyn Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Sandringham Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Somerville Secondary College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Sorrento Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Springside Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'St Albans East Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'St Arnaud Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Status update sent by Jordan has advised via email (30/1) to Melissa of the Monday 2nd recommencement.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Jordan');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Jordan');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'As advised, due to extreme heat and forecasted weather predicted to be over 35 degrees. Domain National will unfortunately not be on site at this stage until Monday 2nd February. Jordan and Alex will advise of any changes to the expceted completion dates.');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Tarneit Senior College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Teesdale Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Timbarra P-9 College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-02-13', 'email', 'Status update sent by PDC - Raschid');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-02-06', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'HUM and JMA Architects have advised Ramp 15 concrete pour was scheduled 30/01/2026 and completion is due by 12th February 2026. Please advise if this does not occur.');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Toolern Vale and District Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Toorak Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Toorloo Arm Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Traralgon (Liddiard Road) Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Traralgon College (Ramps)' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-02-13', 'email', 'Status update sent by Andrew - Final');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Status update sent by NA, recent email sent by Aaron 27/1');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Ramps and RFE works across East and West Campuses are forecast to be inspected for defects and sign off acknowledgement by the school on the 9th of February 2026. Noting there is a six month defect liability period to cover any issues within that time. Spaces architects have advised they have scheduled a site inspection on the 4th February 2026 to review progress. Please advise if this does not occur.');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Traralgon College (RFE)' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-02-13', 'email', 'Status update sent by Andrew - Final');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'See above');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Tulliallan Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'University High School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Warragul Regional College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Wendouree Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Status update sent by Andrew - Final');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Cameron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', '1:1 Architects and Pirotta advised that all works are now completed, CFI has been recieved for all ramps and all ramps are open to the school. An inspection will be arranged for first week of February and school sign off acknowledgement will be sought noting that there is a six month defect liability period to cover any issues that may arise in this time. Please advise if this does not occur.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'CFI today 15/1. Ramp 1 & 2 PCC by 23 Jan');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Werribee Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Status update sent by Andrew - Final');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Cameron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', '1:1 Architects and Pirotta advised that all works are now completed, CFI has been recieved for all ramps and all ramps are open to the school. An inspection will be arranged for first week of February and school sign off acknowledgement will be sought noting that there is a six month defect liability period to cover any issues that may arise in this time. Please advise if this does not occur.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'CFI passed awaiting docs, defects done tmr (soon). Cyclone fence to be installed (this week or next). Pirotta to reach out and book inspection.');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Westall Secondary College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'JMA advised that all scoped works have been completed. JMA to meet with the school regarding Ramp 14 Service Ramp for a solution. Please advise if this does not occur.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Build complete/ Defect inspection report done last week, to rectify before 27/1. Ramp 14 deviation sighted by school.');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Williamstown High School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Woodlands Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-02-13', 'email', 'Status update sent by GRN - Drean');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-02-06', 'email', 'Status update sent by H&L');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'Status update sent by requested GRN');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Works are completed and building surveyor has inspected with the CFI''s expected iminently. H&L Architects and GRN Builder will contact the school to arrange a site walk and ensure defects are completed. School sign off will be sought and 6 months DLP will apply to the works.');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Wyndham Vale Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Yarraman Oaks Primary School' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-23', 'email', 'Status update sent by Joey');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-09', 'email', 'Status update sent by Andrew');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2024-12-19', 'email', 'Status update sent by Aaron');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'JMA has advised that all works are completed and will seek sign off acknowledgement following the defect inspection the first week of February 2026. Noting that there is a six month defect liabiltiy period to cover any issues that may occur in this period. Please advise if this does not occur.');
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-16', 'email', 'As updated');
  END IF;

  SELECT id INTO v_school_id FROM schools WHERE name = 'Yuille Park P-8 Community College' LIMIT 1;
  IF v_school_id IS NOT NULL THEN
    INSERT INTO communications (school_id, date, method, summary)
      VALUES (v_school_id, '2025-01-30', 'email', 'Closed for Comms');
  END IF;

END $$;