# Orbit Note

Orbit Note is a SwiftUI iOS app for spatial life orbit journaling.

It helps users record the people, projects, events, and emotions that orbit around daily life, using distance, energy, and intensity to visualize attention and balance.

## Status

Current version: `v0.2.2-ci`

- SwiftUI MVP completed.
- SwiftData local persistence completed.
- GitHub Actions macOS CI build passed.
- `v0.2.2-ci` tag pushed.
- `v0.2.2-ci` GitHub pre-release created.
- Manual Simulator CRUD smoke test still pending.

## Pending Manual Mac Validation

There is currently no local Mac available, so these checks are not complete yet:

- Simulator launch.
- First-launch seed manual verification.
- Add / edit / delete / clear / restore manual verification.
- Restart-after-save SwiftData persistence manual verification.
- iPhone SE layout manual verification.

## Do Not Start Yet

Do not start these areas until manual Simulator validation is complete:

- Widget.
- Notifications.
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
- v0.3 local export foundation: JSON / CSV export via system Share Sheet.
- Lightweight local action feedback.
- Simple first-launch onboarding.

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

## Roadmap

- `v0.3` JSON / CSV export and feedback states.
- `v0.4` Evening reminders and Widget.
- `v0.5` App Intents and quick capture.
- `v0.6` Orbit share cards and light motion.
- `v1.0` Public beta.
