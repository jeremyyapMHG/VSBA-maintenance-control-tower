import { Avatar, AvatarFallback } from "@/components/ui/avatar";

export function Header() {
  return (
    <header className="flex h-16 items-center justify-between border-b bg-white px-6">
      <div>
        <h1 className="text-lg font-semibold text-vsba-charcoal">
          Maintenance Control Tower
        </h1>
      </div>
      <div className="flex items-center gap-4">
        <Avatar className="h-8 w-8">
          <AvatarFallback className="bg-vsba-teal text-vsba-charcoal text-xs">
            U
          </AvatarFallback>
        </Avatar>
      </div>
    </header>
  );
}
