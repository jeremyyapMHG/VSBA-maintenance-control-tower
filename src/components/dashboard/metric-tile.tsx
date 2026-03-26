import { Card, CardContent } from "@/components/ui/card";
import type { LucideIcon } from "lucide-react";

interface MetricTileProps {
  title: string;
  value: number | string;
  icon: LucideIcon;
  description?: string;
}

export function MetricTile({ title, value, icon: Icon, description }: MetricTileProps) {
  return (
    <Card>
      <CardContent className="p-6">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-sm font-medium text-muted-foreground">{title}</p>
            <p className="mt-1 text-3xl font-bold text-vsba-charcoal">{value}</p>
            {description && (
              <p className="mt-1 text-xs text-muted-foreground">{description}</p>
            )}
          </div>
          <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-vsba-teal/20">
            <Icon className="h-6 w-6 text-vsba-red" />
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
