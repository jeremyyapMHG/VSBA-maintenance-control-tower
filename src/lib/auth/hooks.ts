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
