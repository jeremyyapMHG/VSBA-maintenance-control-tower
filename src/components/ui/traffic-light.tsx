import { cn } from "@/lib/utils";
import type { TrafficLight } from "@/lib/traffic-lights";

interface TrafficLightIndicatorProps {
  status: TrafficLight;
  size?: "sm" | "md";
}

const colorMap: Record<TrafficLight, string> = {
  green: "bg-emerald-500",
  amber: "bg-amber-500",
  red: "bg-red-500",
};

const sizeMap = {
  sm: "h-2.5 w-2.5",
  md: "h-3.5 w-3.5",
};

export function TrafficLightIndicator({ status, size = "sm" }: TrafficLightIndicatorProps) {
  return (
    <span
      className={cn("inline-block rounded-full", colorMap[status], sizeMap[size])}
      title={status.charAt(0).toUpperCase() + status.slice(1)}
    />
  );
}
