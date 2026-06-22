# Orbit Note Insight UI Plan

Status: v0.5.8 minimal UI integration in progress. Manual visual validation remains pending.

This document defines how the local Today Orbit insight can later enter the app without changing Orbit Note's product direction. It does not mark manual validation as complete.

## Current Architecture

The insight chain is local, deterministic, and already covered by CI:

- `OrbitEntry`: existing UI-facing value model for orbit points.
- `TodayOrbitInsightEngine`: pure local logic that derives an insight from `[OrbitEntry]`.
- `TodayOrbitInsight`: lightweight `Codable` / `Equatable` value containing `headline`, `summary`, titles, and `suggestedPrompt`.
- `OrbitStore.makeTodayInsight(on:generatedAt:)`: readonly adapter that reads current in-memory `entries` and delegates to the engine.
- XCTest coverage: empty input, date filtering, deterministic title selection, and adapter output.
- CI guardrails: keep the engine and adapter local-only, side-effect free, and away from SwiftData schema, network, file writes, and WidgetKit.

Current boundary:

- Insight is shown only as one compact readonly Orbit tab card in v0.5.8.
- Insight is not connected to Widget, Reminder, Deep Link, App Group, export, onboarding, or notifications.
- Manual Mac / Simulator / real-device validation remains pending.

## UI Entry Options

| Option | Pros | Risks | Manual validation required | Recommendation |
| --- | --- | --- | --- | --- |
| Orbit tab top card | Closest to the user's daily question: "What is orbiting me today?" Uses existing Orbit context and can update naturally after add/edit/delete. | Could crowd the Orbit header and push the canvas down on iPhone SE. Needs careful copy so it does not feel diagnostic or like AI fortune-telling. | Empty data, one entry, multiple entries, long titles, iPhone SE, Dynamic Type, add/edit/delete refresh. | Recommended first UI entry. Add one compact readonly card only. |
| Me tab status/developer area | Low product risk. Useful for debugging whether insight generation works. Does not disturb the core Orbit screen. | Weak user value as a primary feature. Me is already settings-heavy and should not become a dashboard. | Copy clarity, no false implication that insight UI is fully launched. | Use only as optional debug/status copy, not as the main insight entry. |
| Future Widget medium expansion | Could make insight glanceable and share the Today Orbit story outside the app. | Widget visual and App Group validation are still pending. Widget space is tight and could overpromise live insight behavior. | Widget Gallery, small/medium layout, App Group signed read, refresh cadence, tap routing. | Defer until after Orbit tab UI is validated. |

Recommended conclusion:

- First choice: Orbit tab top card.
- Me tab: debug/status only, not a primary insight surface.
- Widget expansion: later, after manual Widget and Orbit UI validation.

## Proposed v0.5.8 Implementation Scope

Only implement the smallest useful insight UI pass:

- Add one lightweight Today insight card inside the Orbit tab.
- Read `store.makeTodayInsight()` from the existing environment store.
- Display only:
  - `headline`
  - `summary`
  - `suggestedPrompt`
- Use readonly presentation.
- Keep the Orbit canvas visible on first screen as much as possible.
- Keep the existing add/edit/delete data flow unchanged.

Do not add in v0.5.8:

- New interactions.
- New sheets.
- New navigation routes.
- New settings.
- AI generation.
- Network calls.
- Cloud sync.
- Widget snapshot changes.
- Reminder copy changes.
- Deep Link changes.
- App Group changes.
- SwiftData schema changes.

## Copy Deck

Copy principles:

- Quiet, restrained, and observational.
- No streaks, no scoring, no productivity pressure.
- No diagnosis, prediction, or therapeutic claims.
- No "AI says" framing.
- No astrology or fortune-telling tone.

Suggested copy:

- Section title: `Today signal`
- Prompt label: `Gentle prompt`
- Empty state headline: `No orbit yet`
- Empty state summary: `Add one point to see what stayed close to your attention today.`
- Non-empty headline pattern: use `TodayOrbitInsight.headline`
- Non-empty summary pattern: use `TodayOrbitInsight.summary`
- Prompt pattern: use `TodayOrbitInsight.suggestedPrompt`
- Accessibility label: `Today insight`
- Accessibility hint: `A short local summary based on today's orbit points.`

Avoid:

- `Your score`
- `You should`
- `Diagnosis`
- `Prediction`
- `Streak`
- `Optimize`
- `AI insight`
- `Mental health assessment`

## Layout Constraints

The first UI pass must satisfy:

- iPhone portrait-first.
- iPhone SE must not horizontally overflow.
- Dark-first styling.
- One compact card only.
- No nested cards.
- No animation in the first UI pass.
- No horizontal scrolling.
- No hero-sized typography inside the card.
- Keep Orbit canvas visible and avoid pushing it too far below the fold.
- Avoid layout shifts when add/edit/delete changes the insight text.
- Support basic Dynamic Type sanity with wrapping and line limits where needed.

Suggested placement:

- Below the existing header and above the Orbit canvas.
- If iPhone SE feels crowded in manual validation, move it below the Orbit canvas and above the summary card.

## v0.5.8 Minimal Implementation Notes

Implemented scope:

- `TodayInsightCard` renders `headline`, `summary`, and `suggestedPrompt`.
- `OrbitHomeView` reads `store.makeTodayInsight()` and places the card below the existing header.
- The card is readonly and has no buttons, navigation links, sheets, network calls, file access, WidgetKit import, AI framing, score, or streak language.
- CI guardrails require the card to remain present and non-interactive.

Still pending:

- Manual Mac / Simulator visual QA.
- iPhone SE fit.
- Dynamic Type readability.
- Add / edit / delete runtime refresh confirmation.
- Widget, Reminder, Deep Link, and App Group regression checks.

## Future Manual Validation Checklist

Run on Mac / Simulator before marking the insight UI as validated:

- Empty data.
- One entry.
- Multiple entries.
- Long title wrapping.
- iPhone SE.
- Standard iPhone size.
- Dynamic Type basic sanity.
- Dark mode.
- Tab switching.
- Add updates insight.
- Edit updates insight.
- Delete updates insight.
- Restart restores data and insight remains correct.
- No Widget regression.
- No Reminder regression.
- No Deep Link regression.
- No App Group regression.
- Orbit canvas remains visible and usable.
- CTA remains reachable.

## Non-goals

Do not include:

- AI insight.
- Cloud sync.
- Scoring.
- Streaks.
- Social sharing.
- Widget insight UI in the same release.
- Notification insight text.
- Complex charts.
- New data model.
- New persistence fields.
- Medical, therapeutic, or diagnostic claims.

## v0.5.8 Exit Criteria

The v0.5.8 implementation should be considered complete only when:

- CI passes.
- The UI change is limited to a compact readonly Orbit insight card.
- No SwiftData schema, Widget, Reminder, Deep Link, App Group, or export behavior changes are introduced.
- Manual Mac / Simulator validation is either completed with real notes or explicitly remains pending.
