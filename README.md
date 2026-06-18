# Orbit Note

Orbit Note is a SwiftUI iOS app for spatial life orbit journaling.

It helps users record the people, projects, events, and emotions that orbit around daily life, using distance, energy, and intensity to visualize attention and balance.

## Status

Current release: `v0.3.1`

Current planning track: `v0.4.0-notification-spec`

- SwiftUI MVP completed.
- SwiftData local persistence completed.
- GitHub Actions macOS CI build passed.
- PR #2 merged to `master`.
- `v0.3.0` tag pushed.
- `v0.3.0` GitHub pre-release created.
- `v0.3.1` release polish and docs cleanup completed.
- Manual Simulator CRUD smoke test still pending.

## Pending Manual Mac Validation

There is currently no local Mac available, so these checks are not complete yet:

- Simulator launch.
- First-launch seed manual verification.
- Add / edit / delete / clear / restore manual verification.
- Restart-after-save SwiftData persistence manual verification.
- iPhone SE layout manual verification.

## Do Not Start Yet

Do not implement these areas until their scoped v0.4 sub-version begins:

- Widget target / App Group / deep link implementation.
- App Intents.
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

## Roadmap

- `v0.3` JSON / CSV export and feedback states.
- `v0.4` Evening reminders and readonly Today Orbit Widget.
- `v0.5` App Intents and quick capture.
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
- `v0.4.2-widget-readonly`: App Group JSON snapshot readonly Widget.
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
