#!/usr/bin/env bash
set -euo pipefail

echo "== Orbit Note iOS architecture guardrails =="

fail() {
  echo "Guardrail failed: $1" >&2
  exit 1
}

require_file() {
  local file="$1"
  [[ -f "$file" ]] || fail "Missing required file: $file"
}

require_contains() {
  local file="$1"
  local text="$2"
  require_file "$file"
  grep -Fq "$text" "$file" || fail "Expected '$text' in $file"
}

require_contains_ci() {
  local file="$1"
  local text="$2"
  require_file "$file"
  grep -iq "$text" "$file" || fail "Expected case-insensitive '$text' in $file"
}

require_tree_absent() {
  local dir="$1"
  local pattern="$2"
  local reason="$3"
  [[ -d "$dir" ]] || fail "Missing required directory: $dir"

  if grep -R -n -E "$pattern" "$dir"; then
    fail "$reason"
  fi
}

echo "-- Widget boundary: no direct SwiftData access --"
require_tree_absent \
  "OrbitNoteWidget" \
  'import SwiftData|ModelContainer|ModelContext|@Model|OrbitStore' \
  "Widget must read snapshot JSON only."

echo "-- App Group ID consistency --"
app_group_id="group.com.codex.orbitnote"
require_contains "OrbitNote/OrbitNote.entitlements" "$app_group_id"
require_contains "OrbitNoteWidget/OrbitNoteWidget.entitlements" "$app_group_id"
require_contains "OrbitNote/Data/WidgetSnapshotService.swift" "$app_group_id"
require_contains "OrbitNoteWidget/OrbitWidgetSnapshotReader.swift" "$app_group_id"

echo "-- Widget snapshot file consistency --"
snapshot_file="OrbitWidgetSnapshot.json"
require_contains "OrbitNote/Data/WidgetSnapshotService.swift" "$snapshot_file"
require_contains "OrbitNoteWidget/OrbitWidgetSnapshotReader.swift" "$snapshot_file"

echo "-- Deep Link consistency --"
require_contains "OrbitNote/Info.plist" "orbitnote"
require_contains "OrbitNote/Routing/DeepLinkRouter.swift" "today"
require_contains "OrbitNote/Routing/DeepLinkRouter.swift" "orbit"
require_contains "OrbitNote/Routing/DeepLinkRouter.swift" "timeline"
require_contains "OrbitNote/Routing/DeepLinkRouter.swift" "me"
require_contains "OrbitNoteWidget/OrbitWidgetView.swift" "orbitnote://today"
require_contains "OrbitNote/RootView.swift" "onOpenURL"

echo "-- Reminder key consistency --"
require_contains "OrbitNote/Data/ReminderService.swift" "orbitNote.eveningReminder"
require_contains "OrbitNote/Views/Me/MeView.swift" "orbitNote.reminderEnabled"
require_contains "OrbitNote/Views/Me/MeView.swift" "orbitNote.reminderHour"
require_contains "OrbitNote/Views/Me/MeView.swift" "orbitNote.reminderMinute"

echo "-- Documentation boundary --"
require_contains_ci "docs/RELEASE_STATUS.md" "manual validation"
require_contains_ci "docs/RELEASE_STATUS.md" "pending"
require_contains_ci "docs/RELEASE_STATUS.md" "ci does not prove"

echo "All iOS architecture guardrails passed."
