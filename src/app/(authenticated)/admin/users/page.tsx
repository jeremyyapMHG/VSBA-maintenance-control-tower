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

  useEffect(() => {
    if (profile && profile.role !== "admin") {
      router.push("/");
    }
  }, [profile, router]);

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
                    <TableCell>{u.organization ?? "\u2014"}</TableCell>
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
