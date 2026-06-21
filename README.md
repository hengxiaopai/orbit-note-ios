# Orbit Note

Orbit Note is a SwiftUI iOS app for spatial life orbit journaling.

It helps users record the people, projects, events, and emotions that orbit around daily life, using distance, energy, and intensity to visualize attention and balance.

## Status

Current release: `v0.5.2-windows-safe-product-polish`

Current implementation track: `v0.5.3-ci-guardrails`

- SwiftUI MVP completed.
- SwiftData local persistence completed.
- GitHub Actions macOS CI build passed.
- PR #2 merged to `master`.
- `v0.3.0` tag pushed.
- `v0.3.0` GitHub pre-release created.
- `v0.3.1` release polish and docs cleanup completed.
- `v0.4.0-notification-spec` completed.
- `v0.4.1-local-notification` completed.
- `v0.4.1-local-notification` tag and GitHub pre-release created.
- `v0.4.2a-widget-snapshot-infra` completed.
- `v0.4.2a-widget-snapshot-infra` tag and GitHub pre-release created.
- `v0.4.2b-widget-extension` completed.
- `v0.4.2b-widget-extension` tag and GitHub pre-release created.
- `v0.4.3-deeplink-polish` completed.
- `v0.4.3-deeplink-polish` tag and GitHub pre-release created.
- `v0.4.4-manual-validation-checklist` completed.
- `v0.4.4-manual-validation-checklist` tag and GitHub pre-release created.
- `v0.5.0-planning` completed.
- `v0.5.0-planning` tag and GitHub pre-release created.
- `v0.5.0-ci-runtime-smoke` completed.
- `v0.5.0-ci-runtime-smoke` tag and GitHub pre-release created.
- `v0.5.1-windows-safe-workflow` completed.
- `v0.5.1-windows-safe-workflow` tag and GitHub pre-release created.
- `v0.5.2-windows-safe-product-polish` completed.
- `v0.5.2-windows-safe-product-polish` tag and GitHub pre-release created.
- Manual Mac / Simulator / real-device validation still pending.

## Pending Manual Mac Validation

There is currently no local Mac available, so these checks are not complete yet:

- Simulator launch.
- First-launch seed manual verification.
- Add / edit / delete / clear / restore manual verification.
- Restart-after-save SwiftData persistence manual verification.
- iPhone SE layout manual verification.

## Current Validation Boundary

GitHub Actions has passed for macOS/Xcode build and limited runtime smoke checks. That means the project can compile in CI and the runner has usable iOS Simulator infrastructure.

It does not mean these are manually validated:

- Simulator launch.
- Widget Gallery insertion.
- Notification permission and delivery.
- App Group real-device signing.
- Widget tap routing.
- iPhone SE layout.

Do not start these areas from Windows-only validation:

- App Intents.
- Interactive Widget.
- Live Activity.
- Share Extension.
- Lottie / Jitter motion.
- TestFlight.
- SwiftData schema expansion.

## Design Direction

**Radium Noir + Aurora Glass**

- OLED near-black background.
- Thin orbit lines.
- Cyan / pink-orange / mist-purple energy colors.
- Glass cards.
- Calm motion.
- Native iPhone-first interaction.

## Current Features

- 4 main tabs: Orbit, Add, Timeline, Me.
- Today orbit visualization.
- Add orbit entries.
- Edit orbit entries.
- Delete orbit entries.
- Recent timeline.
- SwiftData local persistence.
- Clear local data.
- Restore sample data.
- JSON export.
- CSV export.
- System Share Sheet for exports.
- Toast / banner feedback.
- SwiftData error feedback.
- Empty state improvements.
- 3-card onboarding.
- Local evening reminder settings.
- Main app Today Orbit Widget snapshot infrastructure.
- Readonly Today Orbit Widget target.
- Widget deep link routing to Today Orbit.
- Manual validation checklist for v0.4.
- v0.5 validation-first plan.
- GitHub Actions macOS/Xcode CI runtime smoke checks.
- Windows development guide.
- Release status documentation.
- Static iOS architecture guardrails in CI.

## Tech Stack

- SwiftUI.
- SwiftData.
- iOS 17+.
- Local-first data model.
- No backend.
- No login.
- No third-party dependencies.

## Export Format

v0.3 exports local orbit entries as JSON or CSV.

Fields:

- `title`
- `category`
- `energyType`
- `intensity`
- `distance`
- `note`
- `date`
- `createdAt`

File names include the export date, for example:

- `orbit-note-export-2026-06-18.json`
- `orbit-note-export-2026-06-18.csv`

## Version History

- `v0.1` SwiftUI MVP.
- `v0.1.1` Project stabilization.
- `v0.2.0` SwiftData persistence.
- `v0.2.1` Xcode build preparation.
- `v0.2.2-ci` GitHub Actions macOS CI build passed.
- `v0.3.0` Data export, feedback states, empty-state improvements, and onboarding.
- `v0.3.1` Release polish and documentation cleanup.
- `v0.4.0-notification-spec` Notification and Widget technical plan.
- `v0.4.1-local-notification` UserNotifications local evening reminder.
- `v0.4.2a-widget-snapshot-infra` Main app JSON snapshot infrastructure for the future Widget.
- `v0.4.2b-widget-extension` Readonly small and medium Today Orbit Widget using App Group JSON snapshot.
- `v0.4.3-deeplink-polish` Widget tap opens the app to Today Orbit through `orbitnote://today`.
- `v0.4.4-manual-validation-checklist` Documentation-only manual validation checklist.
- `v0.5.0-planning` Documentation-only validation-first v0.5 plan.
- `v0.5.0-ci-runtime-smoke` Stronger GitHub Actions macOS/Xcode build and simulator availability smoke checks.
- `v0.5.1-windows-safe-workflow` Windows-safe CI maintenance, script syntax checks, and GitHub HTTPS recovery documentation.
- `v0.5.2-windows-safe-product-polish` Release-status copy cleanup and manual-validation boundary clarification.
- `v0.5.3-ci-guardrails` Static CI guardrails for Widget, App Group snapshot, Deep Link, Reminder, and documentation boundaries.

## Roadmap

- `v0.3` JSON / CSV export and feedback states.
- `v0.4` Evening reminders and readonly Today Orbit Widget.
- `v0.5` Validation-first runtime hardening before new quick-capture surfaces.
- `v0.6` Orbit share cards and light motion.
- `v1.0` Public beta.

## v0.4 Technical Plan

v0.4 stays local-first. It does not add a backend, account system, TestFlight, App Intents, Share Extension, Lottie / Jitter, remote push, or SwiftData schema expansion.

Goals:

- Local evening reminder.
- Readonly Today Orbit Widget.
- Widget tap deep link to the Orbit tab.
- Keep all user data local.

Split plan:

- `v0.4.0-notification-spec`: documentation plan only.
- `v0.4.1-local-notification`: `UserNotifications` evening reminder.
- `v0.4.2a-widget-snapshot-infra`: main app JSON snapshot infrastructure.
- `v0.4.2b-widget-extension`: App Group JSON snapshot readonly Widget.
- `v0.4.3-deeplink-polish`: `orbitnote://orbit` routes to the Orbit tab.

Local notification plan:

- Use `UserNotifications`.
- Add Me tab reminder switch and time picker.
- Default reminder time: 21:30.
- Request permission only when the user enables reminders.
- Show clear copy if permission is denied.
- Schedule at most one repeating daily reminder.
- Do not add streaks, check-in pressure, multiple reminders, or notification actions.

Widget plan:

- The Widget should not read SwiftData directly.
- The main app writes `OrbitWidgetSnapshot.json`.
- The Widget reads the JSON snapshot through App Group.
- Small Widget: dominant energy, entry count, closest orbit point.
- Medium Widget: dominant energy, recent orbit points, strongest draining / energizing summaries.
- Empty state: `No orbit yet`.
- Do not build interactive Widget, Live Activity, or complex charts.

Deep link plan:

- URL scheme: `orbitnote`.
- `orbitnote://orbit` opens the Orbit tab.
- `orbitnote://add` may be added later.
- Deep link code starts in `v0.4.3`, not in this spec release.

App Group and snapshot risk:

- Widget needs App Group to reliably read JSON written by the main app.
- App Group shares only the JSON snapshot, not the SwiftData store.
- This avoids SwiftData container, migration, and Widget timeline complexity.
- Manual Widget insertion and visual QA remain pending until a local Mac is available.

v0.4 preconditions:

- `v0.4.1` can start first because local notifications do not need a Widget target.
- `v0.4.2` must be an independent PR because it changes the Xcode project, entitlements, and adds a Widget extension.
- Every sub-version must keep iOS Build green in GitHub Actions.
- Manual validation remains pending until a local Mac is available.

## v0.4.1 Local Notification

Implementation scope:

- `UserNotifications` local evening reminder.
- Me tab reminder switch and time picker.
- Default reminder time: 21:30.
- Permission is requested only when the user enables the reminder.
- Permission denied state shows a lightweight toast.
- At most one repeating daily notification is scheduled.

AppStorage keys:

- `orbitNote.reminderEnabled`
- `orbitNote.reminderHour`
- `orbitNote.reminderMinute`

Notification:

- Identifier: `orbitNote.eveningReminder`
- Title: `Check your orbit`
- Body: `What stayed close to your attention today?`

Still pending without a local Mac or device:

- Permission prompt manual verification.
- Pending notification scheduling verification.
- Daily repeat trigger verification.
- Toggle off cancellation verification.
- Time-change reschedule verification.

Still not implemented:

- Widget.
- App Group.
- Deep Link.
- App Intents.
- Share Extension.
- Lottie / Jitter.
- TestFlight.
- Remote push.
- Multiple reminders.
- Streaks or check-in pressure.

## v0.4.2a Widget Snapshot Infrastructure

Implementation scope:

- Adds `OrbitWidgetSnapshot`.
- Adds `WidgetSnapshotService`.
- The main app writes a readonly Today Orbit JSON snapshot.
- Me shows Widget snapshot status and a manual refresh action.
- Snapshot data is prepared for the upcoming Widget version.

Snapshot file:

- File name: `OrbitWidgetSnapshot.json`
- Current location: app Application Support directory.
- Future `v0.4.2b` location: App Group container.

Snapshot fields:

- `generatedAt`
- `date`
- `entryCount`
- `dominantEnergy`
- `dominantEnergyLabel`
- `dominantEnergyColorName`
- `closestTitle`
- `strongestPositiveTitle`
- `strongestDrainingTitle`
- `latestEntryTitle`

Refresh timing:

- After store configure / load succeeds.
- After add succeeds.
- After edit succeeds.
- After delete succeeds.
- After clear local data succeeds.
- After sample data restore succeeds.
- When the user taps `Refresh snapshot` in Me.

Important boundaries:

- No Widget target in `v0.4.2a`.
- No App Group entitlement in `v0.4.2a`.
- No URL scheme or Deep Link in `v0.4.2a`.
- No SwiftData schema changes.
- The future Widget must read JSON snapshot data, not SwiftData directly.

Why this split:

- There is currently no local Mac for manual Widget setup and QA.
- Widget target and App Group configuration carry higher Xcode project risk.
- Snapshot data infrastructure can be validated by GitHub Actions first.

## v0.4.2b Readonly Today Orbit Widget

Implementation scope:

- Adds the `OrbitNoteWidget` Widget Extension target.
- Adds App Group entitlements for the main app and Widget.
- Adds a readonly Today Orbit Widget.
- Supports small and medium Widget families.
- Widget reads `OrbitWidgetSnapshot.json` through App Group.
- Widget does not read SwiftData directly.
- Deep Link remains reserved for `v0.4.3-deeplink-polish`.

App Group:

- Identifier: `group.com.codex.orbitnote`
- Main app writes `OrbitWidgetSnapshot.json`.
- Widget reads the same JSON snapshot.
- The SwiftData store is not shared with the Widget.

Snapshot storage:

- Primary: App Group container.
- Fallback: Application Support directory when App Group is unavailable.
- File name remains `OrbitWidgetSnapshot.json`.

Widget display:

- Small: title, dominant energy, entry count, closest orbit point.
- Medium: title, dominant energy, entry count, closest point, strongest positive, strongest draining.
- Empty state: `No orbit yet`.

Important boundaries:

- No URL scheme.
- `widgetURL` was not included in v0.4.2b; it is added in v0.4.3.
- `onOpenURL` was not included in v0.4.2b; it is added in v0.4.3.
- No App Intents.
- No Share Extension.
- No Lottie / Jitter.
- No TestFlight.
- No Live Activity.
- No interactive Widget.
- No SwiftData schema changes.

Validation status:

- GitHub Actions iOS Build must pass.
- Manual Widget insertion and small / medium visual QA remain pending because there is no local Mac / Simulator.

## v0.4.3 Deep Link Polish

Implementation scope:

- Adds the `orbitnote` URL scheme to the main app.
- Adds lightweight deep link routing.
- Widget uses `widgetURL(URL(string: "orbitnote://today"))`.
- Widget taps open the app to Today Orbit / Orbit tab.
- App can route warm deep links to Orbit, Timeline, or Me.

Supported URLs:

- `orbitnote://today`
- `orbitnote://orbit`
- `orbitnote://timeline`
- `orbitnote://me`

Routing:

- `orbitnote://today` -> Orbit tab.
- `orbitnote://orbit` -> Orbit tab.
- `orbitnote://timeline` -> Timeline tab.
- `orbitnote://me` -> Me tab.

Important boundaries:

- No App Intents.
- No Universal Links.
- No Associated Domains.
- No Share Extension.
- No Interactive Widget.
- No Live Activity.
- No SwiftData schema changes.
- No Widget direct SwiftData access.
- No complex route parameters.
- No multi-region Widget links.

Manual validation still pending without local Mac / Simulator:

- Deep link cold launch.
- Deep link warm routing.
- Widget tap routing.
- Widget Gallery validation.
- Small / medium Widget layout.
- App Group real-device signing.
- Snapshot actual Widget read.
- Notification permission and delivery.

## v0.4.4 Manual Validation Checklist

Documentation-only release.

Adds:

- [Manual validation checklist](docs/MANUAL_VALIDATION.md)
- Notification validation steps.
- Widget Gallery, small Widget, and medium Widget validation steps.
- App Group snapshot write/read validation steps.
- Deep link cold-start and warm-routing validation steps.
- Export, onboarding, toast, reminder, and data regression checks.

No implementation changes:

- No Swift code changes.
- No SwiftData schema changes.
- No Xcode target changes.
- No entitlement changes.
- No Widget target changes.
- No App Group changes.
- No Deep Link implementation changes.
- No notification implementation changes.
- No v0.5 feature implementation.

Manual Mac / Simulator / real-device validation remains pending.

## v0.5 Planning

Documentation-only planning release.

Adds:

- [v0.5 validation-first plan](docs/V0_5_PLAN.md)
- v0.5 positioning as a validation-first polish release.
- Release gates before new feature expansion.
- Proposed milestones from validation run through focused polish.
- Explicit non-goals.
- Risk register.
- Suggested Codex workflow for v0.5 PRs.

Recommended first v0.5 step:

- `v0.5.0-ci-runtime-smoke`

This strengthens GitHub Actions macOS/Xcode validation while local Mac access is unavailable. It does not replace the core checks from [Manual validation checklist](docs/MANUAL_VALIDATION.md).

No implementation changes:

- No Swift code changes.
- No SwiftData schema changes.
- No Xcode target changes.
- No entitlement changes.
- No Widget changes.
- No Deep Link changes.
- No notification changes.
- No v0.5 feature implementation.

## v0.5.0 CI Runtime Smoke

CI-only validation hardening for Windows-based development.

Adds:

- GitHub Actions runner and Xcode environment diagnostics.
- Project and scheme listing before build.
- Simulator runtime availability smoke check.
- iOS 17+ runtime presence check.
- Available iPhone Simulator presence check.
- Main app build for iOS Simulator.
- `OrbitNoteWidget` target build for iOS Simulator.
- Xcode build log artifact upload.

This release does not add product functionality.

No implementation changes:

- No Swift code changes.
- No SwiftData schema changes.
- No Xcode project changes.
- No entitlement changes.
- No Widget UI changes.
- No Deep Link changes.
- No notification changes.
- No App Group behavior changes.

Manual validation remains pending:

- App launch in Simulator.
- Widget Gallery insertion.
- Widget visual QA.
- Notification permission prompt.
- Notification delivery.
- App Group real-device signing.
- SwiftData CRUD and persistence smoke test.
- iPhone SE layout check.

The CI smoke check improves confidence that macOS/Xcode tooling can build the app and Widget, but it does not replace hands-on Simulator or real-device validation.

## v0.5.1 Windows-safe Workflow

Windows-safe polish and developer workflow hardening.

Adds:

- GitHub Actions official action maintenance:
  - `actions/checkout@v7.0.0`
  - `actions/upload-artifact@v7.0.1`
- CI shell script syntax check with `bash -n`.
- [Windows development guide](docs/WINDOWS_DEVELOPMENT.md).
- Documentation for GitHub HTTPS recovery, bundle backup, and temporary proxy push.

No implementation changes:

- No Swift code changes.
- No SwiftData schema changes.
- No Xcode project changes.
- No entitlement changes.
- No Widget UI changes.
- No Deep Link changes.
- No notification changes.
- No App Group behavior changes.

Manual Mac / Simulator / real-device validation remains pending.

## v0.5.2 Windows-safe Product Polish

Documentation-only release-status polish.

Adds:

- [Release status](docs/RELEASE_STATUS.md).
- Clearer current release and development-track wording.
- Sharper distinction between CI passed and manual validation passed.
- Updated Windows-safe development notes.

No implementation changes:

- No Swift code changes.
- No SwiftData schema changes.
- No Xcode project changes.
- No entitlement changes.
- No Widget UI changes.
- No Deep Link changes.
- No notification changes.
- No App Group behavior changes.

Manual Mac / Simulator / real-device validation remains pending.

## v0.5.3 CI Guardrails

Windows-safe architecture protection for existing iOS boundaries.

Adds:

- `scripts/ci/ios_guardrails.sh`.
- CI step: `Run iOS architecture guardrails`.
- Static check that the Widget target does not directly read SwiftData.
- Static checks for App Group ID and `OrbitWidgetSnapshot.json` consistency.
- Static checks for `orbitnote` scheme, `orbitnote://today`, and app `onOpenURL`.
- Static checks for reminder AppStorage keys and notification identifier.
- Documentation checks that manual validation remains pending and CI boundaries remain explicit.

No implementation changes:

- No Swift feature changes.
- No SwiftData schema changes.
- No Xcode project changes.
- No entitlement changes.
- No Widget UI changes.
- No Deep Link behavior changes.
- No notification behavior changes.
- No App Group behavior changes.

Manual Mac / Simulator / real-device validation remains pending.
