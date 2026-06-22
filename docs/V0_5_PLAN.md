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

### v0.5.0-ci-runtime-smoke

Goal:

- Strengthen GitHub Actions macOS/Xcode validation while local Mac access is unavailable.
- Keep manual validation explicitly pending.
- Do not add new product functionality.

Scope:

- Print macOS runner and Xcode environment diagnostics.
- List available iOS runtimes and iPhone Simulators.
- List the Xcode project and schemes.
- Build the main app for iOS Simulator.
- Build the `OrbitNoteWidget` target for iOS Simulator.
- Upload Xcode build logs for CI failure triage.

Non-goal:

- No app install.
- No app launch.
- No Widget Gallery validation.
- No notification delivery validation.
- No App Group signing validation.
- No manual validation result recording.
- No Swift, SwiftData schema, UI, entitlement, or Xcode project changes.

Acceptance:

- GitHub Actions iOS Build passes.
- CI fails clearly if no iOS 17+ runtime or available iPhone Simulator is present.
- Documentation states that manual Simulator / real-device validation remains pending.

### v0.5.x-manual-validation-run

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

### v0.5.1-windows-safe-workflow

Goal:

- Harden Windows-based iOS development workflow without requiring local Mac / Simulator visual QA.
- Keep CI useful, explicit, and low-maintenance.
- Keep manual validation explicitly pending.

Scope:

- GitHub Actions official action maintenance.
- CI shell script syntax checks.
- Windows development guide.
- GitHub HTTPS recovery documentation.
- Bundle backup and temporary proxy push workflow.

Non-goal:

- No Swift feature code.
- No SwiftUI UI polish that needs visual QA.
- No SwiftData schema change.
- No Xcode project or entitlement change.
- No Widget, Deep Link, Notification, or App Group behavior change.
- No manual validation result recording.

Acceptance:

- CI passes.
- Modified files are limited to workflow, CI scripts, and documentation.
- `docs/WINDOWS_DEVELOPMENT.md` documents safe Windows workflow and GitHub connectivity recovery.
- Manual validation remains pending.

### v0.5.x-runtime-fixes-after-validation

Goal:

- Fix issues discovered by real Mac / Simulator / device validation or actionable CI failures.

Possible scope:

- Widget layout clipping or readability issues found on Simulator.
- App Group fallback behavior confirmed by runtime testing.
- Snapshot refresh timing issues found on device or Simulator.
- Deep link routing edge cases from cold or warm launch tests.
- Notification scheduling or cancellation issues found through permission and delivery validation.
- Me status copy that is unclear in real use.

Acceptance:

- Every fix maps to a validation finding or CI failure.
- CI passes.
- A focused manual re-test confirms the fix when the finding came from manual validation.

### v0.5.2-polish

Goal:

- Clarify release-state language while development is still Windows-based.
- Keep CI coverage and manual-validation boundaries easy to understand.
- Avoid product behavior changes until Mac / Simulator validation exists.

Scope:

- Release status documentation.
- README status cleanup.
- Manual validation status wording.
- Windows-safe development note alignment.
- Design documentation updates about validation boundaries.

Non-goal:

- No Swift feature code.
- No SwiftUI UI polish that needs visual QA.
- No redesign.
- No new navigation model.
- No new data model.
- No Widget, Deep Link, Notification, App Group, or SwiftData behavior changes.
- No manual validation result recording.

Acceptance:

- CI passes.
- `docs/RELEASE_STATUS.md` exists and clearly separates what CI proves from what manual validation must prove.
- Manual validation remains pending.
- Modified files are limited to documentation unless a specific copy-only Swift change is justified.

### v0.5.3-ci-guardrails

Goal:

- Add static CI guardrails for key iOS architecture boundaries.
- Catch accidental drift in Widget, App Group snapshot, Deep Link, Reminder, and documentation contracts.
- Keep manual validation explicitly pending.

Scope:

- Add `scripts/ci/ios_guardrails.sh`.
- Run guardrails in GitHub Actions before Xcode build steps.
- Verify the Widget target does not directly read SwiftData.
- Verify App Group ID and snapshot filename consistency.
- Verify Deep Link scheme / Widget URL / app URL handler strings.
- Verify reminder keys and notification identifier.
- Verify documentation still states manual validation and CI limits.

Non-goal:

- No Swift feature code.
- No SwiftUI UI changes.
- No Widget, Deep Link, Notification, App Group, or SwiftData behavior changes.
- No Xcode project or entitlement changes.
- No manual validation result recording.

Acceptance:

- CI passes.
- Guardrails fail clearly when expected static boundaries drift.
- Manual validation remains pending.

### v0.5.4-insight-prototype

Goal:

- Prototype a lightweight Today Orbit insight engine using existing local entries.

Scope:

- Use existing `OrbitEntry` data only.
- Add a lightweight `TodayOrbitInsight` value.
- Add a deterministic `TodayOrbitInsightEngine`.
- Keep insight UI deferred.
- Update CI guardrails for local-only insight boundaries.

Scope constraints:

- No cloud.
- No AI generation.
- No network calls.
- No file writes.
- No complex statistics.
- No medical or therapeutic claims.

Possible output:

- A small "today feels centered / scattered / heavy / energized" local summary.
- A simple dominant-energy or closest-point explanation.

Acceptance:

- CI passes.
- The engine compiles in the app target.
- No SwiftData schema changes are introduced.
- No UI behavior changes are introduced.
- The insight UI remains deferred until after Mac / Simulator validation.

### v0.5.5-insight-engine-tests

Goal:

- Add automated logic coverage for the local Today Orbit insight engine.
- Keep insight UI deferred.
- Keep manual validation explicitly pending.

Scope:

- Add a minimal `OrbitNoteTests` XCTest target.
- Add `TodayOrbitInsightEngineTests`.
- Run insight engine tests in GitHub Actions.
- Keep CI guardrails around the insight engine local-only boundary.

Test scenarios:

- Empty input returns a stable empty insight.
- Only entries from the requested day are counted.
- Focus, strongest positive, and strongest draining titles are selected deterministically.

Non-goal:

- No UI integration.
- No OrbitStore integration.
- No SwiftData schema changes.
- No Widget, Deep Link, Notification, App Group, export, or onboarding behavior changes.
- No AI, network, cloud, or file writes.

Acceptance:

- CI passes.
- `xcodebuild test` runs for the `OrbitNote` scheme.
- Insight engine unit tests pass.
- Manual Mac / Simulator / real-device validation remains pending.

### v0.5.6-insight-store-adapter

Goal:

- Add a readonly OrbitStore adapter for generating a local Today Orbit insight from current entries.
- Keep insight UI deferred.
- Keep manual validation explicitly pending.

Scope:

- Add `OrbitStore+Insight`.
- Add `OrbitStore.makeTodayInsight(on:generatedAt:)`.
- Reuse `TodayOrbitInsightEngine`.
- Add unit coverage for the adapter where possible.
- Update guardrails to keep the adapter readonly and side-effect free.

Non-goal:

- No UI integration.
- No OrbitStore persistence changes.
- No SwiftData schema changes.
- No Widget, Deep Link, Notification, App Group, export, onboarding, or snapshot behavior changes.
- No AI, network, cloud, or file writes.

Acceptance:

- CI passes.
- Adapter compiles in the app target.
- Adapter tests pass.
- Guardrails reject persistence, network, file write, or WidgetKit drift in the adapter.
- Manual Mac / Simulator / real-device validation remains pending.

### v0.5.7-insight-ui-plan

Goal:

- Define a documentation-only plan for future Insight UI integration.
- Choose the safest first UI entry point.
- Keep implementation deferred until Mac / Simulator validation is available.

Scope:

- Add `docs/INSIGHT_UI_PLAN.md`.
- Compare Orbit tab, Me tab, and future Widget entry options.
- Define proposed v0.5.8 UI scope.
- Add copy deck, layout constraints, and future manual validation checklist.

Non-goal:

- No Swift code changes.
- No Xcode project changes.
- No entitlement changes.
- No SwiftData schema changes.
- No Widget, Deep Link, Notification, App Group, test, CI, or product behavior changes.

Acceptance:

- CI passes.
- Modified files are documentation only.
- Insight UI remains deferred.
- Manual Mac / Simulator / real-device validation remains pending.

### v0.5.8-insight-ui-integration

Reserved for a future implementation only when Mac / Simulator validation is available.

Proposed scope:

- Add one compact readonly Today insight card to the Orbit tab.
- Display `headline`, `summary`, and `suggestedPrompt`.
- Reuse `OrbitStore.makeTodayInsight(on:generatedAt:)`.
- Avoid new interactions, sheets, navigation routes, AI, network, Widget snapshot changes, Reminder changes, Deep Link changes, App Group changes, and SwiftData schema changes.

Acceptance should include manual validation on empty data, one entry, multiple entries, long titles, iPhone SE, standard iPhone size, Dynamic Type sanity, dark mode, tab switching, add/edit/delete refresh, restart, and no Widget / Reminder / Deep Link regressions.

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

Current sequence while no local Mac is available:

1. Complete `v0.5.0-ci-runtime-smoke`.
2. Keep `docs/MANUAL_VALIDATION.md` pending.
3. Complete `v0.5.1-windows-safe-workflow` for CI maintenance and developer workflow hardening.
4. Complete `v0.5.2-windows-safe-product-polish` for release-status and validation-boundary copy cleanup.
5. Complete `v0.5.3-ci-guardrails` for static architecture boundary checks.
6. Complete `v0.5.4-insight-engine-prototype` as a local-only logic layer with no UI surface.
7. Complete `v0.5.5-insight-engine-tests` for CI-level insight logic coverage.
8. Complete `v0.5.6-insight-store-adapter` as a readonly internal adapter with no UI surface.
9. Complete `v0.5.7-insight-ui-plan` as documentation-only planning for a future UI pass.
10. Start `v0.5.8-insight-ui-integration` only when Mac / Simulator access exists.
11. Start `v0.5.x-manual-validation-run` only after Mac / Simulator access exists.
12. Start runtime fixes only from real validation findings or actionable CI failures.
