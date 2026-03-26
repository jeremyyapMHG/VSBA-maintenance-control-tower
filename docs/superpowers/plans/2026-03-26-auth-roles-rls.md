# Issue #3: Auth - Login, Roles, and Row-Level Security

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement Supabase Auth with email/password + magic link, role-based user profiles, RLS policies, login page, auth middleware, and admin user management.

**Architecture:** Supabase Auth handles authentication. A `user_profiles` table extends auth.users with role and scope assignments. Next.js middleware refreshes sessions and protects routes. RLS policies on all tables enforce role-based data access at the database level.

**Tech Stack:** Supabase Auth, @supabase/ssr, Next.js middleware, PostgreSQL RLS

---

### Task 1: Supabase Auth Middleware

**Files:**
- Create: `src/middleware.ts`

- [ ] **Step 1: Create Next.js middleware for Supabase session refresh**

Create `src/middleware.ts`:

```typescript
import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";

export async function middleware(request: NextRequest) {
  let supabaseResponse = NextResponse.next({
    request,
  });

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value, options }) =>
            request.cookies.set(name, value)
          );
          supabaseResponse = NextResponse.next({
            request,
          });
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          );
        },
      },
    }
  );

  const {
    data: { user },
  } = await supabase.auth.getUser();

  // Redirect unauthenticated users to login (except login page itself)
  if (
    !user &&
    !request.nextUrl.pathname.startsWith("/login") &&
    !request.nextUrl.pathname.startsWith("/auth")
  ) {
    const url = request.nextUrl.clone();
    url.pathname = "/login";
    return NextResponse.redirect(url);
  }

  // Redirect authenticated users away from login
  if (user && request.nextUrl.pathname.startsWith("/login")) {
    const url = request.nextUrl.clone();
    url.pathname = "/";
    return NextResponse.redirect(url);
  }

  return supabaseResponse;
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};
```

- [ ] **Step 2: Verify build**

```bash
npm run build
```

- [ ] **Step 3: Commit**

```bash
git add src/middleware.ts
git commit -m "feat: add Supabase auth middleware with route protection"
```

---

### Task 2: Database Migration — user_profiles Table

**Files:**
- Create: `supabase/migrations/001_user_profiles.sql`

- [ ] **Step 1: Create migrations directory**

```bash
mkdir -p supabase/migrations
```

- [ ] **Step 2: Write user_profiles migration**

Create `supabase/migrations/001_user_profiles.sql`:

```sql
-- Create enum for user roles
CREATE TYPE user_role AS ENUM ('government', 'end_user', 'delivery_team', 'admin');

-- Create user_profiles table extending Supabase Auth
CREATE TABLE user_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_user_id UUID UNIQUE NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role user_role NOT NULL DEFAULT 'end_user',
  organization TEXT,
  assigned_school_ids UUID[] DEFAULT '{}',
  assigned_ramp_ids UUID[] DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Index for fast lookups by auth user
CREATE INDEX idx_user_profiles_auth_user_id ON user_profiles(auth_user_id);

-- Enable RLS
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- RLS policies for user_profiles
-- Admin: full access
CREATE POLICY "admin_full_access" ON user_profiles
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM user_profiles up
      WHERE up.auth_user_id = auth.uid() AND up.role = 'admin'
    )
  );

-- Government: read all profiles
CREATE POLICY "government_read_profiles" ON user_profiles
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM user_profiles up
      WHERE up.auth_user_id = auth.uid() AND up.role = 'government'
    )
  );

-- Users can read their own profile
CREATE POLICY "users_read_own_profile" ON user_profiles
  FOR SELECT
  USING (auth_user_id = auth.uid());

-- Auto-create profile on signup via trigger
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_profiles (auth_user_id, role)
  VALUES (NEW.id, 'end_user');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Updated_at trigger
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER user_profiles_updated_at
  BEFORE UPDATE ON user_profiles
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
```

- [ ] **Step 3: Commit**

```bash
git add supabase/
git commit -m "feat: add user_profiles table migration with RLS policies"
```

---

### Task 3: Auth Context Provider and Hooks

**Files:**
- Create: `src/lib/auth/types.ts`
- Create: `src/lib/auth/provider.tsx`
- Create: `src/lib/auth/hooks.ts`

- [ ] **Step 1: Create auth types**

Create `src/lib/auth/types.ts`:

```typescript
export type UserRole = "government" | "end_user" | "delivery_team" | "admin";

export interface UserProfile {
  id: string;
  auth_user_id: string;
  role: UserRole;
  organization: string | null;
  assigned_school_ids: string[];
  assigned_ramp_ids: string[];
  created_at: string;
  updated_at: string;
}
```

- [ ] **Step 2: Create auth provider**

Create `src/lib/auth/provider.tsx`:

```typescript
"use client";

import { createContext, useContext, useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import type { User } from "@supabase/supabase-js";
import type { UserProfile } from "./types";

interface AuthContext {
  user: User | null;
  profile: UserProfile | null;
  loading: boolean;
  signOut: () => Promise<void>;
}

const AuthContext = createContext<AuthContext>({
  user: null,
  profile: null,
  loading: true,
  signOut: async () => {},
});

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [profile, setProfile] = useState<UserProfile | null>(null);
  const [loading, setLoading] = useState(true);
  const supabase = createClient();

  useEffect(() => {
    const getSession = async () => {
      const {
        data: { user },
      } = await supabase.auth.getUser();
      setUser(user);

      if (user) {
        const { data } = await supabase
          .from("user_profiles")
          .select("*")
          .eq("auth_user_id", user.id)
          .single();
        setProfile(data);
      }

      setLoading(false);
    };

    getSession();

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange(async (_event, session) => {
      setUser(session?.user ?? null);

      if (session?.user) {
        const { data } = await supabase
          .from("user_profiles")
          .select("*")
          .eq("auth_user_id", session.user.id)
          .single();
        setProfile(data);
      } else {
        setProfile(null);
      }

      setLoading(false);
    });

    return () => subscription.unsubscribe();
  }, [supabase]);

  const signOut = async () => {
    await supabase.auth.signOut();
    setUser(null);
    setProfile(null);
  };

  return (
    <AuthContext.Provider value={{ user, profile, loading, signOut }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth must be used within AuthProvider");
  }
  return context;
}
```

- [ ] **Step 3: Create role-checking hooks**

Create `src/lib/auth/hooks.ts`:

```typescript
"use client";

import { useAuth } from "./provider";
import type { UserRole } from "./types";

export function useRole() {
  const { profile } = useAuth();
  return profile?.role ?? null;
}

export function useIsAdmin() {
  return useRole() === "admin";
}

export function useIsGovernment() {
  return useRole() === "government";
}

export function useCanWrite() {
  const role = useRole();
  return role === "admin" || role === "delivery_team";
}

export function useHasRole(...roles: UserRole[]) {
  const role = useRole();
  return role !== null && roles.includes(role);
}
```

- [ ] **Step 4: Verify build**

```bash
npm run build
```

- [ ] **Step 5: Commit**

```bash
git add src/lib/auth/
git commit -m "feat: add auth context provider with role-checking hooks"
```

---

### Task 4: Login Page

**Files:**
- Create: `src/app/login/page.tsx`

- [ ] **Step 1: Create login page**

Create `src/app/login/page.tsx`:

```typescript
"use client";

import { useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [message, setMessage] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const router = useRouter();
  const supabase = createClient();

  const handlePasswordLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);

    const { error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (error) {
      setError(error.message);
      setLoading(false);
      return;
    }

    router.push("/");
    router.refresh();
  };

  const handleMagicLink = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setMessage(null);
    setLoading(true);

    const { error } = await supabase.auth.signInWithOtp({
      email,
    });

    if (error) {
      setError(error.message);
      setLoading(false);
      return;
    }

    setMessage("Check your email for a magic link to sign in.");
    setLoading(false);
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-vsba-bg">
      <div className="w-full max-w-md px-4">
        <div className="mb-8 text-center">
          <div className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-vsba-red">
            <span className="text-lg font-bold text-white">V</span>
          </div>
          <h1 className="text-2xl font-bold text-vsba-charcoal">
            Maintenance Control Tower
          </h1>
          <p className="mt-1 text-sm text-muted-foreground">
            Victorian School Building Authority
          </p>
        </div>

        <Card>
          <CardHeader>
            <CardTitle>Sign in</CardTitle>
            <CardDescription>
              Access your school maintenance dashboard
            </CardDescription>
          </CardHeader>
          <CardContent>
            <Tabs defaultValue="password">
              <TabsList className="mb-4 w-full">
                <TabsTrigger value="password" className="flex-1">
                  Password
                </TabsTrigger>
                <TabsTrigger value="magic-link" className="flex-1">
                  Magic Link
                </TabsTrigger>
              </TabsList>

              <TabsContent value="password">
                <form onSubmit={handlePasswordLogin} className="space-y-4">
                  <div>
                    <label htmlFor="email-pw" className="text-sm font-medium">
                      Email
                    </label>
                    <Input
                      id="email-pw"
                      type="email"
                      placeholder="you@example.com"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      required
                    />
                  </div>
                  <div>
                    <label htmlFor="password" className="text-sm font-medium">
                      Password
                    </label>
                    <Input
                      id="password"
                      type="password"
                      placeholder="Your password"
                      value={password}
                      onChange={(e) => setPassword(e.target.value)}
                      required
                    />
                  </div>
                  <Button type="submit" className="w-full" disabled={loading}>
                    {loading ? "Signing in..." : "Sign in"}
                  </Button>
                </form>
              </TabsContent>

              <TabsContent value="magic-link">
                <form onSubmit={handleMagicLink} className="space-y-4">
                  <div>
                    <label htmlFor="email-ml" className="text-sm font-medium">
                      Email
                    </label>
                    <Input
                      id="email-ml"
                      type="email"
                      placeholder="you@example.com"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      required
                    />
                  </div>
                  <Button type="submit" className="w-full" disabled={loading}>
                    {loading ? "Sending..." : "Send magic link"}
                  </Button>
                </form>
              </TabsContent>
            </Tabs>

            {error && (
              <p className="mt-4 text-sm text-destructive">{error}</p>
            )}
            {message && (
              <p className="mt-4 text-sm text-vsba-focus-teal">{message}</p>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Create login layout (no sidebar/header)**

Create `src/app/login/layout.tsx`:

```typescript
export default function LoginLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <>{children}</>;
}
```

- [ ] **Step 3: Update root layout to conditionally show sidebar**

The login page should NOT show the sidebar/header. Update `src/app/layout.tsx` to wrap the authenticated layout in a separate layout group.

Restructure to:
- `src/app/layout.tsx` — bare root layout (html, body, AuthProvider)
- `src/app/(authenticated)/layout.tsx` — sidebar + header layout
- `src/app/(authenticated)/page.tsx` — dashboard (move from src/app/page.tsx)
- `src/app/(authenticated)/schools/[id]/page.tsx` — school view (move from current location)
- `src/app/login/page.tsx` — login page (no sidebar)
- `src/app/login/layout.tsx` — bare layout

The root `src/app/layout.tsx` becomes:

```typescript
import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";
import { AuthProvider } from "@/lib/auth/provider";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "VSBA Maintenance Control Tower",
  description: "School maintenance program delivery tracking dashboard",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className={`${geistSans.variable} ${geistMono.variable}`}>
      <body>
        <AuthProvider>{children}</AuthProvider>
      </body>
    </html>
  );
}
```

The authenticated layout `src/app/(authenticated)/layout.tsx`:

```typescript
import { Sidebar } from "@/components/layout/sidebar";
import { Header } from "@/components/layout/header";

export default function AuthenticatedLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex h-screen">
      <Sidebar />
      <div className="flex flex-1 flex-col overflow-hidden">
        <Header />
        <main className="flex-1 overflow-y-auto bg-vsba-bg p-6">
          {children}
        </main>
      </div>
    </div>
  );
}
```

- [ ] **Step 4: Verify build**

```bash
npm run build
```

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "feat: add login page with email/password and magic link, restructure layouts"
```

---

### Task 5: Auth Callback Route

**Files:**
- Create: `src/app/auth/callback/route.ts`

- [ ] **Step 1: Create auth callback for magic link**

Create `src/app/auth/callback/route.ts`:

```typescript
import { createClient } from "@/lib/supabase/server";
import { NextResponse } from "next/server";

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url);
  const code = searchParams.get("code");
  const next = searchParams.get("next") ?? "/";

  if (code) {
    const supabase = await createClient();
    const { error } = await supabase.auth.exchangeCodeForSession(code);
    if (!error) {
      return NextResponse.redirect(`${origin}${next}`);
    }
  }

  return NextResponse.redirect(`${origin}/login?error=auth`);
}
```

- [ ] **Step 2: Verify build**

```bash
npm run build
```

- [ ] **Step 3: Commit**

```bash
git add src/app/auth/
git commit -m "feat: add auth callback route for magic link flow"
```

---

### Task 6: Header with User Menu and Logout

**Files:**
- Modify: `src/components/layout/header.tsx`

- [ ] **Step 1: Update header with user info and logout**

Replace `src/components/layout/header.tsx`:

```typescript
"use client";

import { useAuth } from "@/lib/auth/provider";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { LogOut, User } from "lucide-react";
import { useRouter } from "next/navigation";
import { Badge } from "@/components/ui/badge";

const roleLabels: Record<string, string> = {
  government: "Government",
  end_user: "End User",
  delivery_team: "Delivery Team",
  admin: "Admin",
};

export function Header() {
  const { user, profile, signOut } = useAuth();
  const router = useRouter();

  const handleSignOut = async () => {
    await signOut();
    router.push("/login");
    router.refresh();
  };

  const initials = user?.email
    ? user.email.substring(0, 2).toUpperCase()
    : "U";

  return (
    <header className="flex h-16 items-center justify-between border-b bg-white px-6">
      <div>
        <h1 className="text-lg font-semibold text-vsba-charcoal">
          Maintenance Control Tower
        </h1>
      </div>
      <div className="flex items-center gap-3">
        {profile?.role && (
          <Badge variant="secondary" className="text-xs">
            {roleLabels[profile.role] ?? profile.role}
          </Badge>
        )}
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" className="relative h-8 w-8 rounded-full">
              <Avatar className="h-8 w-8">
                <AvatarFallback className="bg-vsba-teal text-vsba-charcoal text-xs">
                  {initials}
                </AvatarFallback>
              </Avatar>
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <div className="px-2 py-1.5">
              <p className="text-sm font-medium">{user?.email}</p>
              {profile?.organization && (
                <p className="text-xs text-muted-foreground">
                  {profile.organization}
                </p>
              )}
            </div>
            <DropdownMenuSeparator />
            <DropdownMenuItem onClick={handleSignOut}>
              <LogOut className="mr-2 h-4 w-4" />
              Sign out
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
    </header>
  );
}
```

- [ ] **Step 2: Verify build**

```bash
npm run build
```

- [ ] **Step 3: Commit**

```bash
git add src/components/layout/header.tsx
git commit -m "feat: add user menu with role badge and logout to header"
```

---

### Task 7: Admin User Management Page

**Files:**
- Create: `src/app/(authenticated)/admin/users/page.tsx`

- [ ] **Step 1: Create admin user management page**

Create `src/app/(authenticated)/admin/users/page.tsx`:

```typescript
"use client";

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { useAuth } from "@/lib/auth/provider";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import { UserPlus } from "lucide-react";
import type { UserProfile, UserRole } from "@/lib/auth/types";

const roleOptions: { value: UserRole; label: string }[] = [
  { value: "government", label: "Government" },
  { value: "end_user", label: "End User" },
  { value: "delivery_team", label: "Delivery Team" },
  { value: "admin", label: "Admin" },
];

const roleBadgeVariant: Record<UserRole, "default" | "secondary" | "outline" | "destructive"> = {
  admin: "destructive",
  government: "default",
  delivery_team: "secondary",
  end_user: "outline",
};

export default function AdminUsersPage() {
  const { profile } = useAuth();
  const router = useRouter();
  const supabase = createClient();
  const [users, setUsers] = useState<UserProfile[]>([]);
  const [loading, setLoading] = useState(true);
  const [inviteEmail, setInviteEmail] = useState("");
  const [inviteRole, setInviteRole] = useState<UserRole>("end_user");
  const [inviting, setInviting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Redirect non-admins
  useEffect(() => {
    if (profile && profile.role !== "admin") {
      router.push("/");
    }
  }, [profile, router]);

  // Fetch all user profiles
  useEffect(() => {
    const fetchUsers = async () => {
      const { data, error } = await supabase
        .from("user_profiles")
        .select("*")
        .order("created_at", { ascending: false });

      if (data) setUsers(data);
      if (error) setError(error.message);
      setLoading(false);
    };

    fetchUsers();
  }, [supabase]);

  const handleInvite = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setInviting(true);

    // Invite user via Supabase Auth (sends magic link)
    const { error: inviteError } = await supabase.auth.signInWithOtp({
      email: inviteEmail,
    });

    if (inviteError) {
      setError(inviteError.message);
      setInviting(false);
      return;
    }

    setInviteEmail("");
    setInviting(false);
  };

  const handleRoleChange = async (userId: string, newRole: UserRole) => {
    const { error } = await supabase
      .from("user_profiles")
      .update({ role: newRole })
      .eq("id", userId);

    if (error) {
      setError(error.message);
      return;
    }

    setUsers((prev) =>
      prev.map((u) => (u.id === userId ? { ...u, role: newRole } : u))
    );
  };

  if (profile?.role !== "admin") return null;

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold text-vsba-charcoal">
          User Management
        </h2>
        <p className="mt-1 text-muted-foreground">
          Invite users and manage role assignments.
        </p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle className="text-base">Invite User</CardTitle>
          <CardDescription>
            Send an invitation email to a new user
          </CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleInvite} className="flex items-end gap-3">
            <div className="flex-1">
              <label htmlFor="invite-email" className="text-sm font-medium">
                Email
              </label>
              <Input
                id="invite-email"
                type="email"
                placeholder="user@example.com"
                value={inviteEmail}
                onChange={(e) => setInviteEmail(e.target.value)}
                required
              />
            </div>
            <div className="w-48">
              <label htmlFor="invite-role" className="text-sm font-medium">
                Role
              </label>
              <Select
                value={inviteRole}
                onValueChange={(v) => setInviteRole(v as UserRole)}
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {roleOptions.map((opt) => (
                    <SelectItem key={opt.value} value={opt.value}>
                      {opt.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <Button type="submit" disabled={inviting}>
              <UserPlus className="mr-2 h-4 w-4" />
              {inviting ? "Sending..." : "Invite"}
            </Button>
          </form>
          {error && (
            <p className="mt-2 text-sm text-destructive">{error}</p>
          )}
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle className="text-base">Users</CardTitle>
          <CardDescription>
            {users.length} user{users.length !== 1 ? "s" : ""} registered
          </CardDescription>
        </CardHeader>
        <CardContent>
          {loading ? (
            <p className="text-sm text-muted-foreground">Loading users...</p>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>User ID</TableHead>
                  <TableHead>Organization</TableHead>
                  <TableHead>Role</TableHead>
                  <TableHead>Joined</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {users.map((u) => (
                  <TableRow key={u.id}>
                    <TableCell className="font-mono text-xs">
                      {u.auth_user_id.slice(0, 8)}...
                    </TableCell>
                    <TableCell>{u.organization ?? "—"}</TableCell>
                    <TableCell>
                      <Select
                        value={u.role}
                        onValueChange={(v) =>
                          handleRoleChange(u.id, v as UserRole)
                        }
                      >
                        <SelectTrigger className="w-40">
                          <Badge variant={roleBadgeVariant[u.role]}>
                            {roleOptions.find((r) => r.value === u.role)?.label}
                          </Badge>
                        </SelectTrigger>
                        <SelectContent>
                          {roleOptions.map((opt) => (
                            <SelectItem key={opt.value} value={opt.value}>
                              {opt.label}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    </TableCell>
                    <TableCell className="text-sm text-muted-foreground">
                      {new Date(u.created_at).toLocaleDateString()}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
```

- [ ] **Step 2: Add Users link to sidebar navigation**

Update the navigation array in `src/components/layout/sidebar.tsx` to add a Users item:

```typescript
import { LayoutDashboard, School, Settings, Map, Users } from "lucide-react";

const navigation = [
  { name: "Dashboard", href: "/", icon: LayoutDashboard },
  { name: "Schools", href: "/", icon: School },
  { name: "Regions", href: "/admin/regions", icon: Map },
  { name: "Users", href: "/admin/users", icon: Users },
  { name: "Settings", href: "/admin/settings", icon: Settings },
];
```

- [ ] **Step 3: Verify build**

```bash
npm run build
```

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "feat: add admin user management page with role assignment"
```

---

### Task 8: RLS Policy Migration for Future Tables

**Files:**
- Create: `supabase/migrations/002_rls_helper_functions.sql`

- [ ] **Step 1: Create reusable RLS helper functions**

These helper functions will be used by all future table RLS policies. Creating them now establishes the pattern.

Create `supabase/migrations/002_rls_helper_functions.sql`:

```sql
-- Helper function: get current user's role
CREATE OR REPLACE FUNCTION public.get_user_role()
RETURNS user_role AS $$
  SELECT role FROM public.user_profiles
  WHERE auth_user_id = auth.uid()
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Helper function: check if current user is admin
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_profiles
    WHERE auth_user_id = auth.uid() AND role = 'admin'
  )
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Helper function: check if current user is government
CREATE OR REPLACE FUNCTION public.is_government()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_profiles
    WHERE auth_user_id = auth.uid() AND role = 'government'
  )
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Helper function: check if current user has read access to a school
CREATE OR REPLACE FUNCTION public.can_read_school(school_id UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_profiles
    WHERE auth_user_id = auth.uid()
    AND (
      role IN ('admin', 'government')
      OR school_id = ANY(assigned_school_ids)
    )
  )
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Helper function: check if current user has write access to a school
CREATE OR REPLACE FUNCTION public.can_write_school(school_id UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_profiles
    WHERE auth_user_id = auth.uid()
    AND (
      role = 'admin'
      OR (role = 'delivery_team' AND school_id = ANY(assigned_school_ids))
    )
  )
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Helper function: check if current user has read access to a ramp
CREATE OR REPLACE FUNCTION public.can_read_ramp(ramp_id UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_profiles
    WHERE auth_user_id = auth.uid()
    AND (
      role IN ('admin', 'government')
      OR ramp_id = ANY(assigned_ramp_ids)
      -- Also allow if user has school access (ramp's school)
    )
  )
$$ LANGUAGE sql SECURITY DEFINER STABLE;
```

- [ ] **Step 2: Commit**

```bash
git add supabase/migrations/002_rls_helper_functions.sql
git commit -m "feat: add reusable RLS helper functions for role-based access"
```
