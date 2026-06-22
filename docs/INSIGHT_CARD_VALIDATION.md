# Orbit Note Insight Card Validation

Purpose:

This checklist exists for the minimal Today Insight Card added in `v0.5.8-insight-card-minimal-ui`. It keeps the release boundary honest while development is still Windows-based.

The card is already compiled and statically guarded in CI. It is not visually validated until someone runs the app on a Mac / Simulator or real iPhone.

## What CI Proves

- `TodayInsightCard.swift` exists and is included in the app target.
- `OrbitHomeView` still calls `TodayInsightCard` and `makeTodayInsight`.
- The card compiles in the main app build.
- The insight engine and store adapter tests pass.
- Guardrails reject network, file access, WidgetKit, App Intents, buttons, navigation links, sheets, full-screen covers, timers, tasks, and animation calls in the card.
- Guardrails reject score, streak, diagnosis, and prediction wording in the card.

## What CI Does Not Prove

- CI does not prove visual quality.
- CI does not prove iPhone SE fit.
- CI does not prove Dynamic Type readability.
- CI does not prove long text wrapping in the live app.
- CI does not prove the card feels balanced above the Orbit canvas.
- CI does not prove add / edit / delete refresh behavior at runtime.
- CI does not prove Widget, Reminder, Deep Link, or App Group runtime behavior.

## Manual Validation Scenarios

- Empty data.
- One entry.
- Multiple entries.
- Long headline.
- Long summary.
- Long suggested prompt.
- iPhone SE.
- Standard iPhone.
- Dynamic Type.
- Dark mode.
- Add / edit / delete refresh.
- Restart persistence.
- Tab switching.
- No Widget regression.
- No Reminder regression.
- No Deep Link regression.

## Pass / Fail Table

| Date | Tester | Device | OS | Xcode | Scenario | Result | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| YYYY-MM-DD |  |  |  |  | Empty data | Pass / Fail |  |
| YYYY-MM-DD |  |  |  |  | One entry | Pass / Fail |  |
| YYYY-MM-DD |  |  |  |  | Multiple entries | Pass / Fail |  |
| YYYY-MM-DD |  |  |  |  | Long headline | Pass / Fail |  |
| YYYY-MM-DD |  |  |  |  | Long summary | Pass / Fail |  |
| YYYY-MM-DD |  |  |  |  | Long suggested prompt | Pass / Fail |  |
| YYYY-MM-DD |  |  |  |  | iPhone SE | Pass / Fail |  |
| YYYY-MM-DD |  |  |  |  | Standard iPhone | Pass / Fail |  |
| YYYY-MM-DD |  |  |  |  | Dynamic Type | Pass / Fail |  |
| YYYY-MM-DD |  |  |  |  | Dark mode | Pass / Fail |  |
| YYYY-MM-DD |  |  |  |  | Add / edit / delete refresh | Pass / Fail |  |
| YYYY-MM-DD |  |  |  |  | Restart persistence | Pass / Fail |  |
| YYYY-MM-DD |  |  |  |  | Tab switching | Pass / Fail |  |
| YYYY-MM-DD |  |  |  |  | Widget regression check | Pass / Fail |  |
| YYYY-MM-DD |  |  |  |  | Reminder regression check | Pass / Fail |  |
| YYYY-MM-DD |  |  |  |  | Deep Link regression check | Pass / Fail |  |

## Notes

- Do not mark any scenario as passed from CI alone.
- Record the exact Simulator or device used.
- If the card crowds the Orbit canvas on iPhone SE, record the finding before changing layout.
- If long copy wraps poorly, record the failing text and Dynamic Type size before changing copy or layout.
