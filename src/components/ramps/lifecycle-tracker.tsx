import { cn } from "@/lib/utils";
import { Check } from "lucide-react";
import type { LifecycleStage } from "@/lib/types/database";

const stages: { key: LifecycleStage; label: string }[] = [
  { key: "design", label: "Design" },
  { key: "construction", label: "Construction" },
  { key: "admin_closeout", label: "Admin Closeout" },
  { key: "dlp", label: "DLP" },
  { key: "final_closure", label: "Final Closure" },
];

interface LifecycleTrackerProps {
  currentStage: LifecycleStage;
}

export function LifecycleTracker({ currentStage }: LifecycleTrackerProps) {
  const currentIndex = stages.findIndex((s) => s.key === currentStage);

  return (
    <div className="flex items-center gap-1">
      {stages.map((stage, i) => {
        const isComplete = i < currentIndex;
        const isCurrent = i === currentIndex;

        return (
          <div key={stage.key} className="flex items-center">
            <div className="flex flex-col items-center">
              <div
                className={cn(
                  "flex h-8 w-8 items-center justify-center rounded-full border-2 text-xs font-medium",
                  isComplete && "border-vsba-red bg-vsba-red text-white",
                  isCurrent && "border-vsba-red bg-white text-vsba-red",
                  !isComplete && !isCurrent && "border-muted bg-white text-muted-foreground"
                )}
              >
                {isComplete ? <Check className="h-4 w-4" /> : i + 1}
              </div>
              <span
                className={cn(
                  "mt-1 text-[10px] font-medium text-center w-16",
                  isCurrent ? "text-vsba-red" : "text-muted-foreground"
                )}
              >
                {stage.label}
              </span>
            </div>
            {i < stages.length - 1 && (
              <div
                className={cn(
                  "mb-5 h-0.5 w-6",
                  i < currentIndex ? "bg-vsba-red" : "bg-muted"
                )}
              />
            )}
          </div>
        );
      })}
    </div>
  );
}
