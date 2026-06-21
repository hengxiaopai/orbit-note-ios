# Orbit Note Manual Validation

This checklist covers the manual validation still required for the v0.4 feature chain: local notifications, Today Orbit Widget, App Group snapshot sharing, deep links, and baseline regressions.

GitHub Actions verifies that the Xcode project compiles on macOS. As of `v0.5.0-ci-runtime-smoke`, it also checks runner/Xcode diagnostics, iOS runtime availability, iPhone Simulator availability, the main app build, and the `OrbitNoteWidget` target build. As of `v0.5.1-windows-safe-workflow`, it also syntax-checks CI shell scripts with `bash -n`. It does not replace Simulator launch, Widget Gallery, notification delivery, App Group signing, or real-device validation.

## Validation Status Overview

| Area | Status | Required device | Notes |
| --- | --- | --- | --- |
| GitHub Actions build | Passed | GitHub macOS runner | Confirms project compile. |
| GitHub Actions runtime smoke | Pending latest run | GitHub macOS runner | Checks Xcode diagnostics, iOS 17+ runtime availability, iPhone Simulator availability, app build, and Widget target build. |
| App launch | Pending | Mac + iOS Simulator | Must verify launch and first screen manually. |
| SwiftData seed/load | Pending | Mac + iOS Simulator | Confirm first-launch sample data and subsequent load. |
| Add/edit/delete orbit entry | Pending | Mac + iOS Simulator | Validate CRUD and UI refresh. |
| Local evening reminder permission | Pending | Mac + iOS Simulator or iPhone | Permission prompt cannot be verified in CI. |
| Local evening reminder delivery | Pending | Simulator or iPhone | Delivery timing requires time adjustment or waiting. |
| Widget Gallery appearance | Pending | Mac + iOS Simulator or iPhone | Confirm Orbit Note appears in Widget Gallery. |
| Small widget layout | Pending | Mac + iOS Simulator or iPhone | Check readability and no clipping. |
| Medium widget layout | Pending | Mac + iOS Simulator or iPhone | Check summaries and visual balance. |
| App Group signing | Pending | Apple Developer account + device preferred | Full capability validation requires signing. |
| Snapshot JSON write | Pending | Mac + iOS Simulator | Inspect container and generated file. |
| Widget snapshot read | Pending | Mac + iOS Simulator or iPhone | Confirm Widget reads App Group snapshot. |
| Widget empty state | Pending | Mac + iOS Simulator or iPhone | Confirm `No orbit yet` state. |
| Widget tap deep link | Pending | Mac + iOS Simulator or iPhone | Confirm Widget opens Today Orbit. |
| Cold-start deep link | Pending | Mac + iOS Simulator | Launch app via URL while not running. |
| Warm deep link routing | Pending | Mac + iOS Simulator | Route while app is already running. |
| Export JSON/CSV regression | Pending | Mac + iOS Simulator | Confirm export and Share Sheet still work. |
| Onboarding regression | Pending | Mac + iOS Simulator | Confirm first-run onboarding still appears. |

## Environment Prerequisites

- Mac with Xcode.
- iOS Simulator running iOS 17 or later.
- Optional real iPhone for notification delivery, Widget behavior, and App Group signing confidence.
- Apple Developer account is only required for full App Group capability signing and real-device validation.
- GitHub Actions CI is not a replacement for Widget Gallery, notification delivery, App Group signing, or deep link launch validation.

## CI Smoke Coverage

`v0.5.0-ci-runtime-smoke` strengthens GitHub Actions so Windows-based development can catch more Apple-tooling issues before manual validation is possible.

CI now checks:

- macOS runner and Xcode version.
- Selected Xcode developer directory.
- Available iOS runtimes.
- Available iPhone Simulators.
- Xcode project and scheme listing.
- CI shell script syntax with `bash -n`.
- Main app build for iOS Simulator.
- `OrbitNoteWidget` target build for iOS Simulator.
- Xcode build logs as artifacts.

CI still does not prove:

- The app launches in Simulator.
- SwiftData seed, CRUD, and restart persistence work at runtime.
- Notification permission UI appears correctly.
- Notifications are delivered.
- The Widget appears in Widget Gallery.
- Small or medium Widgets are visually correct.
- App Group signing works on a real device.
- Widget tap deep links route correctly.
- iPhone SE layout is readable.

## Simulator Validation Checklist

- [ ] Open `OrbitNote.xcodeproj` in Xcode.
- [ ] Select the `OrbitNote` scheme.
- [ ] Select an iOS 17+ Simulator.
- [ ] Build and run.
- [ ] Verify the app launches without crashing.
- [ ] Verify onboarding appears on a fresh install.
- [ ] Complete or skip onboarding.
- [ ] Verify sample orbit data appears on first launch.
- [ ] Add a new orbit entry.
- [ ] Edit the new orbit entry.
- [ ] Delete the edited orbit entry.
- [ ] Confirm Orbit and Timeline refresh immediately after data changes.
- [ ] Open Me.
- [ ] Tap `Refresh snapshot`.
- [ ] Confirm Widget snapshot status shows a reasonable state.
- [ ] Confirm Me shows the reminder status row.
- [ ] Confirm Me shows the deep link status row: `orbitnote://today`.

## Notification Validation Checklist

- [ ] Confirm default reminder time is 21:30.
- [ ] Fresh install: confirm Orbit Note does not request notification permission on first launch.
- [ ] Open Me.
- [ ] Turn on `Evening orbit reminder`.
- [ ] Confirm the permission prompt appears only after enabling the toggle.
- [ ] Choose Allow.
- [ ] Confirm reminder schedules and success feedback appears.
- [ ] Change reminder time.
- [ ] Confirm the reminder reschedules and success feedback appears.
- [ ] Turn reminder off.
- [ ] Confirm pending notification is cancelled and success feedback appears.
- [ ] Repeat on a fresh install or reset permissions.
- [ ] Choose Deny.
- [ ] Confirm toggle returns to off.
- [ ] Confirm feedback explains notifications are disabled.
- [ ] Validate actual delivery by adjusting Simulator time or waiting on a real device.

## Widget Validation Checklist

- [ ] Build and run the app once.
- [ ] Open Widget Gallery.
- [ ] Confirm Orbit Note / Today Orbit Widget appears.
- [ ] Add the small Widget.
- [ ] Confirm the small Widget renders without clipping.
- [ ] Add the medium Widget.
- [ ] Confirm the medium Widget renders without clipping.
- [ ] Clear local data.
- [ ] Refresh snapshot from Me.
- [ ] Confirm Widget empty state shows `No orbit yet`.
- [ ] Restore sample data or add today's entries.
- [ ] Refresh snapshot from Me.
- [ ] Reload or wait for Widget refresh.
- [ ] Confirm Widget displays Today Orbit data.
- [ ] Confirm `dominantEnergy` display is reasonable.
- [ ] Confirm `entryCount` matches today's entries.
- [ ] Confirm `closestTitle` is visible when present.
- [ ] Confirm medium Widget displays `strongestPositiveTitle` when present.
- [ ] Confirm medium Widget displays `strongestDrainingTitle` when present.
- [ ] Confirm Widget does not require direct SwiftData access.
- [ ] Confirm Widget data comes from App Group JSON snapshot.

## App Group / Snapshot Validation Checklist

- [ ] Confirm App Group ID is `group.com.codex.orbitnote`.
- [ ] Confirm the main app has the App Group entitlement.
- [ ] Confirm the Widget target has the same App Group entitlement.
- [ ] Build with a signing team that supports the App Group capability.
- [ ] Run the app.
- [ ] Add or edit a today's orbit entry.
- [ ] Refresh snapshot from Me.
- [ ] Inspect the App Group container.
- [ ] Confirm `OrbitWidgetSnapshot.json` exists.
- [ ] Decode the JSON and confirm it is valid.
- [ ] Confirm `entryCount` matches today's entries.
- [ ] Confirm `dominantEnergy`, `closestTitle`, `strongestPositiveTitle`, and `strongestDrainingTitle` match expected data.
- [ ] Confirm data changes refresh the snapshot.
- [ ] Reload or wait for Widget timeline refresh.
- [ ] Confirm Widget reads the new snapshot.
- [ ] Confirm Application Support fallback is used only when App Group is unavailable.
- [ ] Validate real-device signing with Apple Developer capability before treating App Group as production-ready.

## Deep Link Validation Checklist

Validate each URL in both cold-start and warm-routing states.

| URL | Cold start | Warm routing | Expected result |
| --- | --- | --- | --- |
| `orbitnote://today` | [ ] | [ ] | Opens Orbit tab / Today Orbit. |
| `orbitnote://orbit` | [ ] | [ ] | Opens Orbit tab. |
| `orbitnote://timeline` | [ ] | [ ] | Opens Timeline tab. |
| `orbitnote://me` | [ ] | [ ] | Opens Me tab. |

Additional checks:

- [ ] Tap the small Widget and confirm it opens `orbitnote://today`.
- [ ] Tap the medium Widget and confirm it opens `orbitnote://today`.
- [ ] Confirm unknown URLs are ignored without crashing.
- [ ] Confirm deep links do not bypass onboarding in a confusing way on fresh install.
- [ ] Confirm ordinary tab switching still works after deep link routing.

## Regression Checklist

- [ ] SwiftData schema is unchanged.
- [ ] First-launch seed data still works.
- [ ] App restart preserves saved data.
- [ ] Add entry still works.
- [ ] Edit entry still works.
- [ ] Delete entry still works.
- [ ] Clear local data still works.
- [ ] Restore sample data still works.
- [ ] JSON export still works.
- [ ] CSV export still works.
- [ ] Share Sheet still opens for exports.
- [ ] Onboarding still appears on fresh install.
- [ ] ToastBanner still appears and dismisses.
- [ ] Reminder settings persist after restart.
- [ ] Widget snapshot refresh does not block add/edit/delete/clear/restore.
- [ ] Deep link routing does not break normal tab switching.
- [ ] Timeline remains readable on small screens.
- [ ] Orbit home CTA remains reachable on small screens.

## Known Pending Items

- No local Mac validation yet.
- No Simulator Widget Gallery validation yet.
- No real-device App Group signing validation yet.
- No notification delivery validation yet.
- No TestFlight validation yet.
- No App Store review validation yet.

## Pass / Fail Template

| Date | Tester | Device | OS | Xcode | Result | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| YYYY-MM-DD |  |  |  |  | Pass / Fail |  |
