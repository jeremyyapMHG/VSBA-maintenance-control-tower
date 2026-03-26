"use client";

import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { TrafficLightIndicator } from "@/components/ui/traffic-light";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  fetchCommunicationsBySchool,
  createCommunication,
} from "@/lib/data/communications";
import { getCommunicationTrafficLight } from "@/lib/traffic-lights";
import { MessageSquarePlus, Phone, Mail, Users, MessageCircle } from "lucide-react";
import type { Communication, CommMethod } from "@/lib/types/database";

interface CommunicationLogProps {
  schoolId: string;
  canEdit: boolean;
  onLastContactUpdate?: (date: string | null) => void;
}

const methodIcons: Record<CommMethod, typeof Phone> = {
  email: Mail,
  phone: Phone,
  in_person: Users,
  other: MessageCircle,
};

const methodLabels: Record<CommMethod, string> = {
  email: "Email",
  phone: "Phone",
  in_person: "In Person",
  other: "Other",
};

export function CommunicationLog({ schoolId, canEdit, onLastContactUpdate }: CommunicationLogProps) {
  const [comms, setComms] = useState<Communication[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [date, setDate] = useState(new Date().toISOString().split("T")[0]);
  const [method, setMethod] = useState<CommMethod>("email");
  const [summary, setSummary] = useState("");
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    const load = async () => {
      try {
        const data = await fetchCommunicationsBySchool(schoolId);
        setComms(data);
        if (data.length > 0 && onLastContactUpdate) {
          onLastContactUpdate(data[0].date);
        }
      } catch (err) {
        console.error("Failed to load communications:", err);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, [schoolId, onLastContactUpdate]);

  const lastContactDate = comms.length > 0 ? comms[0].date : null;
  const trafficLight = getCommunicationTrafficLight(lastContactDate);

  const handleSubmit = async () => {
    if (!summary.trim()) return;
    setSaving(true);
    try {
      const created = await createCommunication(schoolId, { date, method, summary });
      setComms((prev) => [created, ...prev]);
      setSummary("");
      setShowForm(false);
      if (onLastContactUpdate) {
        onLastContactUpdate(created.date);
      }
    } catch (err) {
      console.error("Failed to log communication:", err);
    } finally {
      setSaving(false);
    }
  };

  return (
    <Card>
      <CardHeader className="pb-3">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <CardTitle className="text-base">Communication Log</CardTitle>
            <TrafficLightIndicator status={trafficLight} size="md" />
          </div>
          {canEdit && (
            <Button size="sm" variant="outline" onClick={() => setShowForm(!showForm)}>
              <MessageSquarePlus className="mr-1 h-4 w-4" />
              Log
            </Button>
          )}
        </div>
      </CardHeader>
      <CardContent className="space-y-3">
        {/* Add Communication Form */}
        {showForm && canEdit && (
          <div className="space-y-2 rounded-md border p-3">
            <div className="flex gap-2">
              <Input
                type="date"
                value={date}
                onChange={(e) => setDate(e.target.value)}
                className="h-8 w-36 text-sm"
              />
              <Select value={method} onValueChange={(v) => setMethod(v as CommMethod)}>
                <SelectTrigger className="h-8 w-32 text-sm">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="email">Email</SelectItem>
                  <SelectItem value="phone">Phone</SelectItem>
                  <SelectItem value="in_person">In Person</SelectItem>
                  <SelectItem value="other">Other</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <textarea
              className="w-full rounded-md border border-input bg-background px-3 py-2 text-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
              rows={2}
              value={summary}
              onChange={(e) => setSummary(e.target.value)}
              placeholder="Communication summary..."
            />
            <div className="flex justify-end gap-2">
              <Button size="sm" variant="ghost" onClick={() => setShowForm(false)}>
                Cancel
              </Button>
              <Button size="sm" onClick={handleSubmit} disabled={saving || !summary.trim()}>
                {saving ? "Saving..." : "Save"}
              </Button>
            </div>
          </div>
        )}

        {/* Communication History */}
        {loading ? (
          <p className="text-sm text-muted-foreground">Loading...</p>
        ) : comms.length === 0 ? (
          <p className="text-sm text-muted-foreground">No communications logged.</p>
        ) : (
          <div className="space-y-2 max-h-64 overflow-y-auto">
            {comms.map((c) => {
              const Icon = methodIcons[c.method];
              return (
                <div key={c.id} className="flex items-start gap-2 rounded-md border p-2 text-sm">
                  <Icon className="h-4 w-4 mt-0.5 text-muted-foreground" />
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2">
                      <span className="text-xs text-muted-foreground">
                        {new Date(c.date).toLocaleDateString()}
                      </span>
                      <Badge variant="outline" className="text-[10px] px-1.5 py-0">
                        {methodLabels[c.method]}
                      </Badge>
                    </div>
                    <p className="mt-0.5">{c.summary}</p>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </CardContent>
    </Card>
  );
}
