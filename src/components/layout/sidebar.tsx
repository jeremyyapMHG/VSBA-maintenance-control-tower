"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { LayoutDashboard, School, Settings, Map } from "lucide-react";
import { cn } from "@/lib/utils";

const navigation = [
  { name: "Dashboard", href: "/", icon: LayoutDashboard },
  { name: "Schools", href: "/", icon: School },
  { name: "Regions", href: "/admin/regions", icon: Map },
  { name: "Settings", href: "/admin/settings", icon: Settings },
];

export function Sidebar() {
  const pathname = usePathname();

  return (
    <aside className="flex h-full w-64 flex-col border-r bg-white">
      <div className="flex h-16 items-center gap-2 border-b px-6">
        <div className="flex h-8 w-8 items-center justify-center rounded bg-vsba-red">
          <span className="text-xs font-bold text-white">V</span>
        </div>
        <div>
          <p className="text-sm font-semibold text-vsba-charcoal">VSBA</p>
          <p className="text-xs text-muted-foreground">Maintenance Control Tower</p>
        </div>
      </div>
      <nav className="flex-1 space-y-1 p-4">
        {navigation.map((item) => {
          const isActive =
            item.href === "/"
              ? pathname === "/"
              : pathname.startsWith(item.href);
          return (
            <Link
              key={item.name}
              href={item.href}
              className={cn(
                "flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors",
                isActive
                  ? "bg-vsba-teal/30 text-vsba-red"
                  : "text-muted-foreground hover:bg-muted hover:text-foreground"
              )}
            >
              <item.icon className="h-4 w-4" />
              {item.name}
            </Link>
          );
        })}
      </nav>
    </aside>
  );
}
