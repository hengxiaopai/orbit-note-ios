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

echo "-- Today Orbit insight engine boundary --"
require_file "OrbitNote/Models/TodayOrbitInsight.swift"
require_file "OrbitNote/Data/TodayOrbitInsightEngine.swift"
require_file "OrbitNote/Data/OrbitStore+Insight.swift"
require_file "OrbitNote/Views/Orbit/TodayInsightCard.swift"
require_file "OrbitNoteTests/TodayOrbitInsightEngineTests.swift"
require_file "OrbitNoteTests/OrbitStoreInsightAdapterTests.swift"
require_contains "OrbitNote/Data/TodayOrbitInsightEngine.swift" "TodayOrbitInsightEngine"
require_contains "OrbitNote/Models/TodayOrbitInsight.swift" "TodayOrbitInsight"
require_contains "OrbitNote/Data/OrbitStore+Insight.swift" "makeTodayInsight"
require_contains "OrbitNote/Data/OrbitStore+Insight.swift" "TodayOrbitInsightEngine.makeInsight"
require_contains "OrbitNote/Views/Orbit/TodayInsightCard.swift" "TodayInsightCard"
require_contains "OrbitNote/Views/Orbit/TodayInsightCard.swift" "Today insight"
require_contains "OrbitNote/Views/Orbit/OrbitHomeView.swift" "TodayInsightCard"
require_contains "OrbitNoteTests/TodayOrbitInsightEngineTests.swift" "testEmptyInputReturnsStableEmptyInsight"
require_contains "OrbitNoteTests/TodayOrbitInsightEngineTests.swift" "testOnlyCountsEntriesFromRequestedDay"
require_contains "OrbitNoteTests/TodayOrbitInsightEngineTests.swift" "testSelectsFocusPositiveAndDrainingDeterministically"
require_contains "OrbitNoteTests/OrbitStoreInsightAdapterTests.swift" "testAdapterReturnsEngineInsightForCurrentEntries"
require_contains "OrbitNoteTests/OrbitStoreInsightAdapterTests.swift" "testAdapterIsStableForEmptyStore"
require_contains_ci "docs/INSIGHT_UI_PLAN.md" "manual validation"
require_contains_ci "docs/INSIGHT_UI_PLAN.md" "pending"

if grep -n -E 'import SwiftData|@Model' "OrbitNote/Models/TodayOrbitInsight.swift" "OrbitNote/Data/TodayOrbitInsightEngine.swift" "OrbitNote/Data/OrbitStore+Insight.swift"; then
  fail "Insight engine and model must not use SwiftData schema annotations."
fi

if grep -n -E 'URLSession|http://|https://|WidgetKit|FileManager|Data\(|\.write\(' "OrbitNote/Data/TodayOrbitInsightEngine.swift"; then
  fail "Insight engine must stay local-only, UI-free, and side-effect free."
fi

if grep -n -F \
  -e "save(" \
  -e "delete(" \
  -e "insert(" \
  -e "FileManager" \
  -e "URLSession" \
  -e "http://" \
  -e "https://" \
  -e "WidgetKit" \
  -e ".write(" \
  "OrbitNote/Data/OrbitStore+Insight.swift"; then
  fail "Insight store adapter must stay readonly and side-effect free."
fi

if grep -n -F \
  -e "URLSession" \
  -e "http://" \
  -e "https://" \
  -e "WidgetKit" \
  -e "FileManager" \
  -e "Button(" \
  -e "NavigationLink(" \
  -e "sheet(" \
  "OrbitNote/Views/Orbit/TodayInsightCard.swift"; then
  fail "TodayInsightCard must stay readonly, local-only, and non-interactive."
fi

echo "All iOS architecture guardrails passed."
