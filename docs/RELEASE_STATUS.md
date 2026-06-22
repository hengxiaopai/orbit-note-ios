# Orbit Note Release Status

## Current Release

- Current release: `v0.5.8-insight-card-minimal-ui`
- Current development track: `v0.5.9-insight-card-static-safety`
- Latest released tag: `v0.5.8-insight-card-minimal-ui`
- Development environment: Windows
- Manual Mac / Simulator / real-device validation: pending

## Windows-safe Status

Windows remains suitable for scoped documentation, CI maintenance, static checks, release process hardening, and narrowly reviewed copy updates.

Windows does not replace Xcode, iOS Simulator, Widget Gallery, notification delivery, App Group signing, or real-device validation.

## CI Coverage

GitHub Actions currently verifies:

- macOS runner and Xcode diagnostics.
- Xcode project and scheme listing.
- CI shell script syntax with `bash -n`.
- iOS runtime availability.
- Available iPhone Simulator availability.
- Main app build for iOS Simulator.
- `OrbitNoteWidget` target build with the iOS Simulator SDK.
- Static architecture guardrails for Widget, App Group snapshot, Deep Link, Reminder, and documentation boundaries.
- Static guardrails for the local-only Today Orbit insight engine boundary.
- XCTest coverage for the local Today Orbit insight engine.
- XCTest coverage for the readonly OrbitStore insight adapter.
- Documentation-only Insight UI integration plan.
- Minimal Today Insight Card compilation and static guardrails.
- Insight Card manual validation checklist and stronger readonly boundary guardrails.
- Xcode build log artifact upload.

## What CI Proves

- The project can be checked out on a GitHub-hosted macOS runner.
- The Xcode project can be listed.
- The current CI shell scripts parse successfully.
- The runner has a usable iOS runtime and at least one available iPhone Simulator.
- The main app and Widget target compile in CI.
- The Widget boundary, snapshot filename, App Group ID, Deep Link strings, Reminder keys, and documentation boundary strings have not drifted from expected static values.
- The insight engine avoids SwiftData schema annotations, WidgetKit, network calls, and file writes.
- The insight engine handles empty input, filters to the requested day, and selects focus / positive / draining titles deterministically in unit tests.
- The OrbitStore insight adapter delegates to the engine without persistence, network, file writes, WidgetKit, or UI changes.
- The minimal Today Insight Card compiles and stays readonly, local-only, and non-interactive by static guardrail.
- The Today Insight Card avoids score, streak, diagnosis, and prediction wording by static guardrail.

## What CI Does Not Prove

- CI does not prove visual quality.
- The app launches in Simulator.
- SwiftData seed, CRUD, and restart persistence work at runtime.
- Notification permission UI appears correctly.
- Notifications are delivered.
- The Widget appears in Widget Gallery.
- Small or medium Widgets are visually correct.
- App Group signing works on a real device.
- Widget snapshot refresh works in a live Widget.
- Widget tap deep links route correctly.
- iPhone SE layout is readable.
- The Today Insight Card is visually balanced, readable, and correctly positioned on iPhone SE or standard iPhone sizes.

## Manual Validation Pending

- Simulator launch.
- First-launch seed behavior.
- Add / edit / delete / clear / restore flows.
- Restart-after-save SwiftData persistence.
- Notification permission and delivery.
- Widget Gallery insertion.
- Small and medium Widget visual QA.
- App Group real-device signing.
- Widget tap deep link routing.
- iPhone SE layout.
- Today Insight Card visual QA, including empty data, long copy, Dynamic Type, and add / edit / delete refresh.

## Current v0.5 Focus

v0.5 is focused on stability, validation readiness, and developer workflow reliability. It is not a feature-expansion release.

## Next Recommended Milestone

Complete `v0.5.9-insight-card-static-safety` as documentation and guardrails only, then keep visual validation explicitly pending until Mac / Simulator access exists. After that, run the manual validation checklist and convert real findings into focused runtime fixes.
