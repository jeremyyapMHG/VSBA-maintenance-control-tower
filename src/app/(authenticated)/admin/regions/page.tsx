"use client";

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { useAuth } from "@/lib/auth/provider";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Card, CardContent, CardDescription, CardHeader, CardTitle,
} from "@/components/ui/card";
import {
  Table, TableBody, TableCell, TableHead, TableHeader, TableRow,
} from "@/components/ui/table";
import {
  Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle,
} from "@/components/ui/dialog";
import { Plus, Pencil, Trash2, Check, X } from "lucide-react";
import type { Region } from "@/lib/types/database";

interface RegionWithCount extends Region {
  school_count: number;
}

export default function AdminRegionsPage() {
  const { profile } = useAuth();
  const router = useRouter();
  const supabase = createClient();
  const [regions, setRegions] = useState<RegionWithCount[]>([]);
  const [loading, setLoading] = useState(true);
  const [newName, setNewName] = useState("");
  const [adding, setAdding] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editName, setEditName] = useState("");
  const [deleteRegion, setDeleteRegion] = useState<RegionWithCount | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (profile && profile.role !== "admin") {
      router.push("/");
    }
  }, [profile, router]);

  const fetchRegions = async () => {
    // Fetch regions with school counts
    const { data: regionsData, error: regError } = await supabase
      .from("regions")
      .select("*, schools(id)")
      .order("name");

    if (regError) {
      setError(regError.message);
      setLoading(false);
      return;
    }

    const mapped = (regionsData ?? []).map((r: any) => ({
      ...r,
      school_count: r.schools?.length ?? 0,
      schools: undefined,
    }));
    setRegions(mapped);
    setLoading(false);
  };

  useEffect(() => {
    fetchRegions();
  }, []);

  const handleAdd = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newName.trim()) return;
    setError(null);
    setAdding(true);

    const { error: insertError } = await supabase
      .from("regions")
      .insert({ name: newName.trim() });

    if (insertError) {
      setError(insertError.message);
      setAdding(false);
      return;
    }

    setNewName("");
    setAdding(false);
    fetchRegions();
  };

  const handleEdit = async (id: string) => {
    if (!editName.trim()) return;
    setError(null);

    const { error: updateError } = await supabase
      .from("regions")
      .update({ name: editName.trim() })
      .eq("id", id);

    if (updateError) {
      setError(updateError.message);
      return;
    }

    setEditingId(null);
    fetchRegions();
  };

  const handleDelete = async () => {
    if (!deleteRegion) return;
    setError(null);

    const { error: deleteError } = await supabase
      .from("regions")
      .delete()
      .eq("id", deleteRegion.id);

    if (deleteError) {
      setError(deleteError.message);
      setDeleteRegion(null);
      return;
    }

    setDeleteRegion(null);
    fetchRegions();
  };

  if (profile?.role !== "admin") return null;

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold text-vsba-charcoal">Regions Management</h2>
        <p className="mt-1 text-muted-foreground">Manage Victorian DET regions.</p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle className="text-base">Add Region</CardTitle>
          <CardDescription>Create a new region for school assignment</CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleAdd} className="flex items-end gap-3">
            <div className="flex-1">
              <label htmlFor="region-name" className="text-sm font-medium">Region Name</label>
              <Input
                id="region-name"
                placeholder="e.g. Inner Melbourne"
                value={newName}
                onChange={(e) => setNewName(e.target.value)}
                required
              />
            </div>
            <Button type="submit" disabled={adding}>
              <Plus className="mr-2 h-4 w-4" />
              {adding ? "Adding..." : "Add Region"}
            </Button>
          </form>
          {error && <p className="mt-2 text-sm text-destructive">{error}</p>}
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle className="text-base">Regions</CardTitle>
          <CardDescription>{regions.length} region{regions.length !== 1 ? "s" : ""}</CardDescription>
        </CardHeader>
        <CardContent>
          {loading ? (
            <p className="text-sm text-muted-foreground">Loading regions...</p>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Region Name</TableHead>
                  <TableHead>Schools</TableHead>
                  <TableHead>Created</TableHead>
                  <TableHead className="text-right">Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {regions.map((r) => (
                  <TableRow key={r.id}>
                    <TableCell>
                      {editingId === r.id ? (
                        <div className="flex items-center gap-2">
                          <Input
                            value={editName}
                            onChange={(e) => setEditName(e.target.value)}
                            className="h-8 w-64"
                            autoFocus
                            onKeyDown={(e) => {
                              if (e.key === "Enter") handleEdit(r.id);
                              if (e.key === "Escape") setEditingId(null);
                            }}
                          />
                          <Button size="sm" variant="ghost" onClick={() => handleEdit(r.id)}>
                            <Check className="h-4 w-4" />
                          </Button>
                          <Button size="sm" variant="ghost" onClick={() => setEditingId(null)}>
                            <X className="h-4 w-4" />
                          </Button>
                        </div>
                      ) : (
                        <span className="font-medium">{r.name}</span>
                      )}
                    </TableCell>
                    <TableCell>{r.school_count}</TableCell>
                    <TableCell className="text-sm text-muted-foreground">
                      {new Date(r.created_at).toLocaleDateString()}
                    </TableCell>
                    <TableCell className="text-right">
                      {editingId !== r.id && (
                        <div className="flex justify-end gap-1">
                          <Button
                            size="sm"
                            variant="ghost"
                            onClick={() => { setEditingId(r.id); setEditName(r.name); }}
                          >
                            <Pencil className="h-4 w-4" />
                          </Button>
                          <Button
                            size="sm"
                            variant="ghost"
                            onClick={() => setDeleteRegion(r)}
                            disabled={r.school_count > 0}
                            title={r.school_count > 0 ? "Cannot delete: region has schools" : "Delete region"}
                          >
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        </div>
                      )}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </CardContent>
      </Card>

      {/* Delete confirmation dialog */}
      <Dialog open={!!deleteRegion} onOpenChange={(open) => !open && setDeleteRegion(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Delete Region</DialogTitle>
            <DialogDescription>
              Are you sure you want to delete &quot;{deleteRegion?.name}&quot;? This action cannot be undone.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDeleteRegion(null)}>Cancel</Button>
            <Button variant="destructive" onClick={handleDelete}>Delete</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
