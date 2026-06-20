# Orbit Note v0.5 Plan

v0.5 is a validation-first polish release.

The goal is not to add a large new feature set. The goal is to move the v0.4 notification, Widget, deep link, and App Group snapshot work from "CI-compiles" to "verified on Mac / Simulator / real device."

## 1. v0.5 Positioning

**v0.5 = Validation-first polish release**

Core goal:

- Validate v0.4 behavior on real Apple tooling.
- Fix only the issues discovered by validation.
- Improve small points of UI, copy, and empty states where validation shows friction.
- Avoid expanding the product into account, cloud, AI, monetization, or social surfaces.

Success for v0.5 means Orbit Note feels locally usable and technically trustworthy before the project starts another feature layer.

## 2. Release Gates

Before v0.5 implementation work starts, confirm:

- `docs/MANUAL_VALIDATION.md` exists.
- Local Mac / Simulator access is available, or the validation work is explicitly marked pending.
- Core validation from `docs/MANUAL_VALIDATION.md` is run as soon as Mac / Simulator access exists.
- Widget Gallery can show the Orbit Note Widget.
- Small and medium Widgets can be added.
- Notification permission flow can be verified.
- Notification delivery can be verified on Simulator or real iPhone.
- App Group snapshot write/read can be inspected.
- Widget can read `OrbitWidgetSnapshot.json`.
- `widgetURL` deep link opens the app to Today Orbit.
- No SwiftData schema migration is introduced unless validation proves it is unavoidable.

## 3. Proposed Milestones

### v0.5.0-validation-run

Goal:

- Execute the core checks in `docs/MANUAL_VALIDATION.md`.
- Record real results.
- Do not add new features.

Scope:

- App launch.
- SwiftData seed/load.
- Add/edit/delete.
- Reminder permission and delivery.
- Widget Gallery.
- Small / medium Widget layout.
- App Group snapshot write/read.
- Widget tap deep link.
- JSON / CSV export regression.
- Onboarding regression.

Acceptance:

- Results are recorded with date, tester, device, OS, Xcode, result, and notes.
- Failures are converted into small follow-up issues or a v0.5.1 fix list.

### v0.5.1-runtime-fixes

Goal:

- Fix issues discovered in validation.

Possible scope:

- Widget layout clipping or readability issues.
- App Group fallback behavior.
- Snapshot refresh timing.
- Deep link routing edge cases.
- Notification scheduling or cancellation issues.
- Me status copy that is unclear in real use.

Non-goal:

- No feature expansion.

Acceptance:

- Every fix maps to a validation finding.
- CI passes.
- A focused manual re-test confirms the fix.

### v0.5.2-polish

Goal:

- Improve small UI and copy details after runtime behavior is trustworthy.

Possible scope:

- Small / medium Widget spacing, labels, and empty state copy.
- Me status rows for reminder, snapshot, and deep link.
- Toast wording for validation-discovered ambiguity.
- Small-screen readability refinements.

Non-goal:

- No redesign.
- No new navigation model.
- No new data model.

Acceptance:

- Visual polish remains consistent with Radium Noir + Aurora Glass.
- iPhone portrait and Widget readability are preserved.
- No new schema or target changes unless separately justified.

### v0.5.3-insight-prototype

Goal:

- Optionally prototype a lightweight Today Orbit insight using existing local entries.

Scope constraints:

- Use existing `OrbitEntry` data only.
- No cloud.
- No AI generation.
- No complex statistics.
- No medical or therapeutic claims.

Possible output:

- A small "today feels centered / scattered / heavy / energized" local summary.
- A simple dominant-energy or closest-point explanation.

Acceptance:

- Can be removed or deferred if validation/fixes need more time.
- Does not block v0.5 if not implemented.

## 4. Explicit Non-goals

v0.5 does not include:

- Cloud sync.
- Account system.
- AI generation.
- Subscription or monetization.
- Social sharing.
- App Intents.
- Interactive Widget.
- Live Activity.
- Share Extension.
- Push notification.
- SwiftData schema migration unless validation forces it.
- Large redesign.
- Large navigation refactor.
- New backend.

## 5. Risk Register

| Risk | Impact | Mitigation | Owner / status |
| --- | --- | --- | --- |
| No local Mac validation yet | Runtime behavior may differ from CI assumptions. | Run `docs/MANUAL_VALIDATION.md` as soon as Mac access exists. | Pending |
| App Group signing on real device | Widget snapshot may fail outside unsigned CI builds. | Validate with Apple Developer capability and real signing. | Pending |
| Widget Gallery availability | Widget may compile but not appear correctly. | Test Widget Gallery on Simulator and real iPhone. | Pending |
| Notification delivery reliability | Reminder may schedule but not deliver as expected. | Validate permission, pending request, cancellation, and delivery. | Pending |
| Deep link cold-start behavior | Widget tap may not route correctly from killed state. | Test `orbitnote://today` cold and warm. | Pending |
| GitHub HTTPS instability on Windows | Local sync/tag/push flow can be interrupted. | Verify with `gh`, retry Git operations, keep remote state explicit. | Active |
| SwiftData persistence unverified on Simulator | Data may not survive restart as expected. | Run restart-after-save manual test. | Pending |
| iPhone SE layout not manually checked | Small screens may clip controls or Widget copy. | Include iPhone SE Simulator in validation pass. | Pending |

## 6. Decision Log

- v0.5 first priority is validation, not feature expansion.
- Keep Widget readonly.
- Keep notification local-only.
- Keep Deep Link scheme-only; do not add Universal Links yet.
- Keep data local-first.
- Keep app iPhone portrait-first.
- Keep SwiftData schema stable unless validation exposes a blocking issue.
- Keep PRs small and scoped to a validation result or documentation plan.

## 7. Suggested Codex Workflow

For each v0.5 turn:

- Run git preflight: status, current branch, recent log, latest CI, current tag.
- Sync local `master` before branching.
- Create an isolated branch.
- Keep the PR small.
- Do not mix validation findings with unrelated polish.
- Run GitHub Actions.
- Merge only after CI passes.
- Tag only after merge.
- Keep manual validation status explicit.
- If a manual test is still pending, state the exact device or environment needed.
