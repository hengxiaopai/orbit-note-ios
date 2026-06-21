# Orbit Note Release Status

## Current Release

- Current release: `v0.5.1-windows-safe-workflow`
- Current development track: `v0.5.2-windows-safe-product-polish`
- Latest released tag: `v0.5.1-windows-safe-workflow`
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
- Xcode build log artifact upload.

## What CI Proves

- The project can be checked out on a GitHub-hosted macOS runner.
- The Xcode project can be listed.
- The current CI shell scripts parse successfully.
- The runner has a usable iOS runtime and at least one available iPhone Simulator.
- The main app and Widget target compile in CI.

## What CI Does Not Prove

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

## Current v0.5 Focus

v0.5 is focused on stability, validation readiness, and developer workflow reliability. It is not a feature-expansion release.

## Next Recommended Milestone

Continue with Windows-safe documentation or CI polish only while no local Mac is available. Start the manual validation run once Mac / Simulator access exists, then convert real findings into focused runtime fixes.
