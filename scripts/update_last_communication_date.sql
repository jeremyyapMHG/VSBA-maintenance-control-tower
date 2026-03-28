-- Update last_communication_date on schools based on most recent communication record
UPDATE schools SET last_communication_date = sub.max_date
FROM (
  SELECT school_id, MAX(date) as max_date
  FROM communications
  GROUP BY school_id
) sub
WHERE schools.id = sub.school_id;
