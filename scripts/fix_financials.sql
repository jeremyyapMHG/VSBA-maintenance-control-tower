-- Fix financial data to align with Excel columns
-- budget_amount = TOTAL Approved FUNDING (already correct)
-- actual_amount = 0 (no actual spend data in Excel)
-- forecast_amount = same as budget (Contingency Amount = TOTAL Approved FUNDING)
UPDATE ramps SET actual_amount = 0;
