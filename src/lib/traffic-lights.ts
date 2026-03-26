export type TrafficLight = "green" | "amber" | "red";

/**
 * Milestone traffic light:
 * - Green: actual date exists (completed) OR planned date > 14 days away
 * - Amber: planned date within 14 days and no actual date
 * - Red: planned date passed and no actual date
 */
export function getMilestoneTrafficLight(
  plannedDate: string | null,
  actualDate: string | null,
  now: Date = new Date()
): TrafficLight {
  if (actualDate) return "green";
  if (!plannedDate) return "green"; // No planned date = not tracked

  const planned = new Date(plannedDate);
  const diffMs = planned.getTime() - now.getTime();
  const diffDays = diffMs / (1000 * 60 * 60 * 24);

  if (diffDays < 0) return "red";
  if (diffDays <= 14) return "amber";
  return "green";
}

/**
 * Communication traffic light:
 * - Green: last contact within 2 weeks
 * - Amber: last contact 2-4 weeks ago
 * - Red: no contact in 4+ weeks (or never)
 */
export function getCommunicationTrafficLight(
  lastContactDate: string | null,
  now: Date = new Date()
): TrafficLight {
  if (!lastContactDate) return "red";

  const lastContact = new Date(lastContactDate);
  const diffMs = now.getTime() - lastContact.getTime();
  const diffDays = diffMs / (1000 * 60 * 60 * 24);

  if (diffDays <= 14) return "green";
  if (diffDays <= 28) return "amber";
  return "red";
}

/**
 * Financial traffic light:
 * - Green: forecast <= budget
 * - Amber: forecast exceeds budget by up to 10%
 * - Red: forecast exceeds budget by >10%
 */
export function getFinancialTrafficLight(
  budget: number,
  forecast: number
): TrafficLight {
  if (budget <= 0) return "green"; // No budget set
  if (forecast <= budget) return "green";

  const overagePercent = ((forecast - budget) / budget) * 100;
  if (overagePercent <= 10) return "amber";
  return "red";
}

/**
 * Get the worst traffic light from a set of lights
 */
export function getWorstTrafficLight(lights: TrafficLight[]): TrafficLight {
  if (lights.includes("red")) return "red";
  if (lights.includes("amber")) return "amber";
  return "green";
}
