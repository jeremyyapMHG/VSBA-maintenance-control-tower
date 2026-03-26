# Issue #2: Project Scaffolding + Supabase Setup + VSBA Theme

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Initialize the Next.js project with TypeScript, Tailwind CSS, shadcn/ui, Supabase client config, VSBA brand theme, and base layout shell.

**Architecture:** Next.js App Router with TypeScript. Tailwind CSS extended with VSBA brand tokens. shadcn/ui for component primitives. Supabase JS client configured via environment variables (placeholder values). Base layout with sidebar navigation shell.

**Tech Stack:** Next.js 14+, TypeScript, Tailwind CSS, shadcn/ui, @supabase/supabase-js, Recharts (installed for later use)

---

### Task 1: Initialize Next.js Project

**Files:**
- Create: `package.json`, `tsconfig.json`, `next.config.js`, `tailwind.config.ts`, `postcss.config.js`, `src/app/layout.tsx`, `src/app/page.tsx`, `src/app/globals.css`

- [ ] **Step 1: Create Next.js app with TypeScript and Tailwind**

```bash
cd /Users/jemyap/Projects/VBSA-maintenance-control-tower
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*" --use-npm
```

Select defaults: no Turbopack for dev. This scaffolds into the current directory.

- [ ] **Step 2: Verify the app builds**

```bash
cd /Users/jemyap/Projects/VBSA-maintenance-control-tower
npm run build
```

Expected: Build succeeds with no errors.

- [ ] **Step 3: Commit scaffolding**

```bash
git add -A
git commit -m "feat: initialize Next.js project with TypeScript and Tailwind CSS"
```

---

### Task 2: Install Dependencies

**Files:**
- Modify: `package.json`

- [ ] **Step 1: Install runtime dependencies**

```bash
npm install @supabase/supabase-js recharts lucide-react clsx tailwind-merge class-variance-authority
```

- [ ] **Step 2: Install dev dependencies**

```bash
npm install -D @types/node
```

- [ ] **Step 3: Create utility function for className merging**

Create `src/lib/utils.ts`:

```typescript
import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

- [ ] **Step 4: Commit dependencies**

```bash
git add package.json package-lock.json src/lib/utils.ts
git commit -m "feat: install core dependencies (Supabase, Recharts, lucide, cn utility)"
```

---

### Task 3: Initialize shadcn/ui

**Files:**
- Create: `components.json`, `src/components/ui/button.tsx`, `src/components/ui/input.tsx`, `src/components/ui/card.tsx`, `src/components/ui/badge.tsx`, `src/components/ui/table.tsx`, `src/components/ui/select.tsx`, `src/components/ui/sheet.tsx`, `src/components/ui/dialog.tsx`, `src/components/ui/dropdown-menu.tsx`, `src/components/ui/tabs.tsx`, `src/components/ui/separator.tsx`, `src/components/ui/avatar.tsx`, `src/components/ui/tooltip.tsx`

- [ ] **Step 1: Initialize shadcn/ui**

```bash
npx shadcn@latest init -d
```

This creates `components.json` and configures paths.

- [ ] **Step 2: Add core UI components**

```bash
npx shadcn@latest add button input card badge table select sheet dialog dropdown-menu tabs separator avatar tooltip -y
```

- [ ] **Step 3: Verify build still passes**

```bash
npm run build
```

- [ ] **Step 4: Commit shadcn/ui setup**

```bash
git add -A
git commit -m "feat: initialize shadcn/ui with core component library"
```

---

### Task 4: Configure VSBA Brand Theme

**Files:**
- Modify: `src/app/globals.css`
- Modify: `tailwind.config.ts`

- [ ] **Step 1: Update Tailwind config with VSBA brand colors**

Replace `tailwind.config.ts` with:

```typescript
import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: ["class"],
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        vsba: {
          red: "#AF272F",
          "dark-red": "#7B1B21",
          teal: "#B9E3E6",
          "focus-teal": "#50D8D0",
          charcoal: "#1A1A1A",
          bg: "#F6F6F9",
          "bg-alt": "#F9FCFC",
        },
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
      backgroundImage: {
        "vsba-gradient-v": "linear-gradient(180deg, #B9E3E6 0%, #F6F6F9 100%)",
        "vsba-gradient-h": "linear-gradient(90deg, #B9E3E6 0%, #F6F6F9 100%)",
      },
    },
  },
  plugins: [require("tailwindcss-animate")],
};

export default config;
```

- [ ] **Step 2: Update CSS variables for VSBA brand**

Replace `src/app/globals.css` with:

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 240 20% 97%; /* #F6F6F9 */
    --foreground: 0 0% 10%; /* #1A1A1A */

    --card: 0 0% 100%;
    --card-foreground: 0 0% 10%;

    --popover: 0 0% 100%;
    --popover-foreground: 0 0% 10%;

    --primary: 357 63% 42%; /* #AF272F */
    --primary-foreground: 0 0% 100%;

    --secondary: 184 44% 81%; /* #B9E3E6 */
    --secondary-foreground: 0 0% 10%;

    --muted: 240 20% 95%;
    --muted-foreground: 0 0% 45%;

    --accent: 184 44% 81%; /* #B9E3E6 */
    --accent-foreground: 0 0% 10%;

    --destructive: 0 84% 60%;
    --destructive-foreground: 0 0% 100%;

    --border: 240 6% 90%;
    --input: 240 6% 90%;
    --ring: 357 63% 42%; /* #AF272F */

    --radius: 0.5rem;
  }
}

@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground;
    font-feature-settings: "rlig" 1, "calt" 1;
  }
}
```

- [ ] **Step 3: Verify build**

```bash
npm run build
```

- [ ] **Step 4: Commit theme**

```bash
git add tailwind.config.ts src/app/globals.css
git commit -m "feat: configure VSBA brand theme colors and CSS variables"
```

---

### Task 5: Configure Supabase Client

**Files:**
- Create: `.env.local`
- Create: `.env.example`
- Create: `src/lib/supabase/client.ts`
- Create: `src/lib/supabase/server.ts`
- Modify: `.gitignore`

- [ ] **Step 1: Create environment files**

Create `.env.local`:

```
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

Create `.env.example`:

```
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

- [ ] **Step 2: Ensure .env.local is in .gitignore**

Verify `.gitignore` contains `.env.local`. Next.js scaffolding should include this, but confirm.

- [ ] **Step 3: Create browser Supabase client**

Create `src/lib/supabase/client.ts`:

```typescript
import { createBrowserClient } from "@supabase/ssr";

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );
}
```

- [ ] **Step 4: Create server Supabase client**

Create `src/lib/supabase/server.ts`:

```typescript
import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

export async function createClient() {
  const cookieStore = await cookies();

  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll();
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options)
            );
          } catch {
            // The `setAll` method was called from a Server Component.
            // This can be ignored if you have middleware refreshing sessions.
          }
        },
      },
    }
  );
}
```

- [ ] **Step 5: Install Supabase SSR package**

```bash
npm install @supabase/ssr
```

- [ ] **Step 6: Commit Supabase config**

```bash
git add .env.example src/lib/supabase/ .gitignore
git commit -m "feat: configure Supabase client for browser and server"
```

---

### Task 6: Build Base Layout Shell

**Files:**
- Create: `src/components/layout/sidebar.tsx`
- Create: `src/components/layout/header.tsx`
- Modify: `src/app/layout.tsx`
- Modify: `src/app/page.tsx`
- Create: `src/app/schools/[id]/page.tsx`

- [ ] **Step 1: Create sidebar navigation component**

Create `src/components/layout/sidebar.tsx`:

```typescript
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
        <div className="h-8 w-8 rounded bg-vsba-red" />
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
```

- [ ] **Step 2: Create header component**

Create `src/components/layout/header.tsx`:

```typescript
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
```

- [ ] **Step 3: Update root layout with sidebar + header shell**

Replace `src/app/layout.tsx`:

```typescript
import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { Sidebar } from "@/components/layout/sidebar";
import { Header } from "@/components/layout/header";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "VSBA Maintenance Control Tower",
  description: "School maintenance program delivery tracking dashboard",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <div className="flex h-screen">
          <Sidebar />
          <div className="flex flex-1 flex-col overflow-hidden">
            <Header />
            <main className="flex-1 overflow-y-auto bg-vsba-bg p-6">
              {children}
            </main>
          </div>
        </div>
      </body>
    </html>
  );
}
```

- [ ] **Step 4: Create placeholder dashboard page**

Replace `src/app/page.tsx`:

```typescript
export default function DashboardPage() {
  return (
    <div>
      <h2 className="text-2xl font-bold text-vsba-charcoal">
        Program Dashboard
      </h2>
      <p className="mt-2 text-muted-foreground">
        Overview of the RAMPS school maintenance program.
      </p>
    </div>
  );
}
```

- [ ] **Step 5: Create placeholder school view page**

Create `src/app/schools/[id]/page.tsx`:

```typescript
export default function SchoolViewPage({
  params,
}: {
  params: { id: string };
}) {
  return (
    <div>
      <h2 className="text-2xl font-bold text-vsba-charcoal">School View</h2>
      <p className="mt-2 text-muted-foreground">
        School ID: {params.id}
      </p>
    </div>
  );
}
```

- [ ] **Step 6: Verify build and run dev server**

```bash
npm run build
```

Expected: Build succeeds with no errors.

- [ ] **Step 7: Commit layout shell**

```bash
git add -A
git commit -m "feat: build base layout shell with sidebar navigation and VSBA branding"
```

---

### Task 7: Final Verification and Cleanup

- [ ] **Step 1: Run dev server and verify visually**

```bash
npm run dev
```

Open http://localhost:3000 — verify:
- Sidebar with VSBA red branding
- Teal accent on active nav item
- Light gray background (#F6F6F9)
- Clean professional layout
- Navigation links work

- [ ] **Step 2: Clean up any default Next.js boilerplate**

Remove any leftover default Next.js SVGs or placeholder content (e.g., `public/next.svg`, `public/vercel.svg`).

- [ ] **Step 3: Final commit**

```bash
git add -A
git commit -m "chore: remove Next.js boilerplate assets"
```
