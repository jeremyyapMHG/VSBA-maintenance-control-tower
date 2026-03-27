"use client";

import { Badge } from "@/components/ui/badge";
import { TrafficLightIndicator } from "@/components/ui/traffic-light";
import { getMilestoneTrafficLight } from "@/lib/traffic-lights";
import type { Milestone } from "@/lib/types/database";

interface UpcomingMilestonesProps {
  milestones: Milestone[];
}

export function UpcomingMilestones({ milestones }: UpcomingMilestonesProps) {
  const now = new Date();
  const fourWeeks = new Date(now.getTime() + 28 * 24 * 60 * 60 * 1000);

  const upcoming = milestones
    .filter((m) => {
      if (m.actual_date) return false; // Already completed
      if (!m.planned_date) return false;
      const planned = new Date(m.planned_date);
      return planned <= fourWeeks;
    })
    .sort((a, b) => (a.planned_date! > b.planned_date! ? 1 : -1))
    .slice(0, 10);

  if (upcoming.length === 0) {
    return <p className="text-sm text-muted-foreground">No upcoming milestones in the next 4 weeks.</p>;
  }

  return (
    <div className="space-y-2">
      {upcoming.map((m) => {
        const light = getMilestoneTrafficLight(m.planned_date, m.actual_date);
        return (
          <div key={m.id} className="flex items-center gap-3 rounded-md border p-2 text-sm">
            <TrafficLightIndicator status={light} />
            <span className="flex-1 font-medium truncate">{m.name}</span>
            <Badge variant="outline" className="text-[10px]">
              {m.planned_date}
            </Badge>
          </div>
        );
      })}
    </div>
  );
}
