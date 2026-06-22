# Orbit Note / 轨迹札记

## 一、产品体验定义

1. **一句话定位**  
   Orbit Note 是一个用空间轨道记录生活重心的 iPhone App，让用户每天看见“什么正在围绕着我，以及它在给我能量还是消耗我”。

2. **目标用户**  
   创作者、自由职业者、学生、项目负责人、敏感但不想写长日记的人；他们需要轻量复盘注意力和能量分布，但不希望进入心理咨询、任务管理或数据仪表盘语境。

3. **高频使用场景**  
   晚上睡前 2 分钟复盘一天；工作结束后记录最占据注意力的人或项目；周末回看最近 7 天生活重心是否偏移；在压力过高时快速标记一个消耗源。

4. **每天打开 App 的理由**  
   用户不是来“完成任务”，而是来确认今天的生活重心：哪些点离自己太近，哪些点值得继续靠近，哪些点只是短暂经过。

5. **与日记 / Todo / 情绪记录的区别**  
   - 不是日记：不以长文本叙述为核心，而以空间距离、亮度、大小和颜色表达关系。
   - 不是 Todo：不追踪完成度，不催促执行，不把生活拆成任务清单。
   - 不是情绪记录：不诊断心理状态，也不贴情绪标签；它记录的是“注意力与能量关系”。
   - 不是 dashboard：不把用户放进复杂图表，而是提供一张可感知、可回看的生活轨道。

6. **MVP 核心闭环**  
   打开今日轨道 → 看见 3-6 个轨道点 → 添加一个新轨道点 → 回到轨道中看到新点进入位置 → 查看点详情与建议 → 在 Timeline 回看 7 天变化。

## 二、信息架构

### 1. Orbit / 今日轨道

- 今日中心点：屏幕中央的“Me”核心，周围有三层细线轨道。
- 轨道图：通过距离、大小、亮度、颜色表达每个条目的影响。
- 今日 3-6 个轨道点：可点击打开详情页。
- 底部 CTA：添加轨道点。
- 今日摘要卡：最靠近我的事、最消耗我的事、最给我能量的事。

### 2. Add / 添加记录

- 输入轨道点名称。
- 选择类型：人、工作、项目、身体、创作、金钱、其他。
- 选择能量方向：给我能量 / 消耗我 / 中性。
- 选择影响强度 1-5。
- 选择距离中心：近 / 中 / 远。
- 写一句备注。
- 保存后回到今日轨道，新点从中心扩散到轨道。

### 3. Timeline / 时间线

- 最近 7 天纵向列表。
- 每天一张 Mini Orbit Card。
- 显示当天主导能量。
- 点击进入当天详情式轨道页面。
- 不使用表格或横向滚动。

### 4. Me / 设置

- 主题设置。
- 提醒设置。
- 数据隐私说明。
- 导出记录占位。

## 三、核心页面设计

### 今日轨道首页

- 顶部显示日期与一句状态文案，例如“Your attention is clustered, but not crowded.”
- 中央为 Orbit Canvas，近黑空间、低透明细线轨道、冷青蓝/粉橙/雾紫轨道点。
- 底部摘要卡包含：
  - 最靠近我的事
  - 最消耗我的事
  - 最给我能量的事
- CTA 使用玻璃层按钮与 SF Symbol `plus`，避免廉价大渐变按钮。

### 添加轨道点页

- 使用 full screen modal，顶部保留关闭按钮。
- 输入区像一句短记录，而不是传统表单。
- 类别、能量、距离使用 pill / segmented control。
- 强度使用 1-5 slider，配合刻度文字。
- 保存后回到今日轨道，并触发新增点扩散动效。

### 轨道点详情页

- 顶部显示发光点、名称、类型。
- 显示能量方向、影响强度、距离。
- 备注以引用式短卡呈现。
- 建议文案：
  - 消耗强：建议明天把它放远一点。
  - 正向强：建议保留一点时间给它。
  - 中性：观察它是否持续靠近。

### 时间线页

- 最近 7 天纵向列表。
- 每天一张 Mini Orbit Card，内含简化三层轨道和当天点位。
- 卡片右侧显示主导能量与数量，不做表格。
- 点击卡片进入当天 Orbit 详情。

## 四、数据模型

```swift
struct OrbitEntry: Identifiable, Hashable {
    let id: UUID
    var title: String
    var category: OrbitCategory
    var energyType: EnergyType
    var intensity: Int
    var distance: OrbitDistance
    var note: String
    var date: Date
    var createdAt: Date
}

enum OrbitCategory: String, CaseIterable, Identifiable {
    case relationship, work, project, body, creation, money, unknown
}

enum EnergyType: String, CaseIterable, Identifiable {
    case positive, draining, neutral
}

enum OrbitDistance: String, CaseIterable, Identifiable {
    case near, middle, far
}
```

Mock 数据覆盖最近 7 天，每天 3-6 条，内容使用真实生活语境：产品评审、母亲电话、睡眠不足、跑步、租房预算、自由写作、客户改稿等。

## 五、设计系统

### 颜色

- `background`: `#030407`，OLED 近黑。
- `surface`: `#0D1016`，卡片黑。
- `glassSurface`: 白色 8%-14% 透明叠层。
- `orbitLine`: 青白 14% 透明细线。
- `positive`: `#63E8FF`，冷青蓝。
- `draining`: `#FF7A66`，粉橙。
- `neutral`: `#A99CFF`，雾紫。
- `textPrimary`: `#F3F7FA`。
- `textSecondary`: `#8B94A7`。
- `borderSubtle`: `#FFFFFF` 12%。

### 字体

- 大标题：`.system(size: 34, weight: .semibold, design: .rounded)`。
- 页面标题：`.system(size: 22, weight: .semibold, design: .default)`。
- 正文：`.system(size: 16, weight: .regular)`。
- Caption：`.system(size: 12, weight: .medium)`。
- 数字/刻度：`.system(size: 13, weight: .medium, design: .monospaced)`。

### 组件

- `OrbitCanvas`: 轨道图容器，负责轨道线、中心点、轨道点布局。
- `OrbitPoint`: 单个发光轨道点。
- `OrbitSummaryCard`: 今日三项摘要。
- `EnergyPill`: 能量方向选择/展示。
- `CategoryPill`: 类型选择/展示。
- `IntensitySlider`: 1-5 强度选择。
- `DistanceSelector`: 近/中/远选择。
- `MiniOrbitCard`: 时间线轨道卡。
- `GlassTabBar`: 基于系统 TabView 的暗色玻璃化 tab 外观。
- `EmptyState`: 无轨道点时的静态空状态与未来动效占位。

## 六、动效策略

### SwiftUI 原生实现

- 轨道线轻微呼吸：`TimelineView` 或 repeatForever opacity/scale。
- 轨道点缓慢漂浮：基于时间的少量 offset，幅度不超过 4pt。
- 新增点从中心扩散到轨道：保存后设置 `recentlyAddedID`，点位 scale/opacity transition。
- 卡片 press 缩放 0.98：buttonStyle。
- 页面切换淡入：局部 opacity + offset。

### Jitter / Lottie 预留

- Onboarding logo reveal。
- 空状态“无轨道点”动效。
- 周报生成完成动效。
- 分享卡片生成动效。

主轨道页不使用长视频背景。若未来使用视频，只放在 onboarding 或品牌介绍页，并提供静态 fallback，避免影响可读性与电量。

## 七、素材策略

- 真实图片：暂不需要，避免把产品拉向社交/相册语境。
- AI 生图：可用于未来 App Store 截图背景或 onboarding 品牌图，不进入主功能页。
- 抽象渐变/光效/纹理：适合主背景的微弱 Aurora 光晕，SwiftUI 原生绘制即可。
- Icon / Symbol：使用 SF Symbols，如 `orbit`、`plus`、`timeline.selection`、`person.crop.circle`、`sparkles`、`lock.shield`。
- 轻量视频或 Lottie：只用于 onboarding、空状态、分享生成完成。
- 静态图：分享卡片默认静态 PNG，优先保证高级、清晰和可传播。
## v0.1 / Implemented Scope

- Native SwiftUI app shell with four tabs: Orbit, Add, Timeline, Me.
- Local in-memory `OrbitStore` with 7 days of realistic mock data.
- Today orbit screen with animated orbit lines, tappable orbit points, summary card, and add CTA.
- Add flow with title, category, energy direction, intensity, distance, note, disabled empty save state, and immediate return to today's orbit.
- Orbit point detail sheet with metrics, note, and recommendation copy.
- Timeline screen with a vertical 7-day list and mini orbit cards.
- Settings screen with theme/reminder/privacy/export placeholders that clearly read as roadmap items.
- Dark-mode-first visual system: OLED background, glass surfaces, subtle orbit lines, cyan/peach/violet energy states.

## v0.1.1 / Engineering Acceptance Items

- Verified `OrbitNote.xcodeproj` has 18 Swift file references and all 18 Swift files are included in the target Sources phase.
- Added `Assets.xcassets` to the Resources phase and restored `ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon`.
- Added a generated 1024x1024 placeholder app icon at `OrbitNote/Assets.xcassets/AppIcon.appiconset/OrbitNoteIcon.png`.
- Confirmed bundle identifier is `com.codex.orbitnote`.
- Confirmed deployment target is iOS 17.0.
- Confirmed generated Info.plist is enabled and iPhone orientation is portrait-only.
- Confirmed no horizontal `ScrollView` or `LazyHStack` is used.
- Adjusted `OrbitCanvas` geometry so far orbit points stay inside the canvas on small screens and mini cards.
- Added compact rendering for `OrbitPoint` inside mini orbit cards.
- Added small-screen text stability via `lineLimit` and `minimumScaleFactor` in summary and timeline cards.
- Changed settings export from a disabled button to a clearly labelled planned item.
- Rewrote enum computed properties with explicit `return` statements to reduce Swift syntax compatibility risk.

## Not Yet Verified

- This workspace is on Windows and does not include `xcodebuild`, Swift CLI, Xcode, or an iOS Simulator.
- The project has not yet been compiled in real Xcode.
- SwiftUI previews have not been rendered in Xcode.
- Simulator interaction, sheet presentation, tab bar rendering, and AppIcon asset compilation still need macOS validation.

## Run On macOS

1. Copy or open the project folder on a Mac.
2. Open `OrbitNote.xcodeproj` in Xcode.
3. Select the `OrbitNote` scheme.
4. Select an iPhone simulator, preferably iPhone SE and one modern full-size iPhone.
5. Build with `Cmd+B`.
6. Run with `Cmd+R`.
7. Smoke test: add an orbit point, tap a point detail, open Timeline, open a day, and visit Me.

## If Xcode Compile Fails, Check First

- `OrbitNote.xcodeproj/project.pbxproj`: confirm `Assets.xcassets` and all Swift files are present in the target.
- `OrbitNote/Assets.xcassets/AppIcon.appiconset/Contents.json`: confirm `OrbitNoteIcon.png` is found by Xcode.
- `OrbitNote/Components/OrbitCanvas.swift`: check `TimelineView`, `sin`, `cos`, and geometry expressions.
- `OrbitNote/Views/Add/AddEntryView.swift`: check `TextField(..., axis: .vertical)` availability if deployment target changes below iOS 16.
- `OrbitNote/Views/Orbit/OrbitHomeView.swift`: check the iOS 17 `onChange(of:)` two-argument closure if deployment target changes below iOS 17.
- `OrbitNote/DesignSystem/OrbitTheme.swift`: check `UIColor(Color)` if building with an older Xcode.

## v0.1.1 Forward Plan Note

v0.1.1 identified SwiftData local persistence as the next step. That step is now covered by the v0.2 scope below.

## v0.2 / SwiftData Persistence Scope

- Added SwiftData local persistence through `OrbitEntryModel`.
- Kept `OrbitEntry` as the UI-facing value type so existing Orbit, Timeline, and detail components remain stable.
- Kept `OrbitCategory`, `EnergyType`, and `OrbitDistance` as enums in `OrbitEntry.swift`.
- Persisted enum values as raw strings in SwiftData and convert safely back to enums with fallbacks:
  - unknown category -> `.unknown`
  - unknown energy type -> `.neutral`
  - unknown distance -> `.middle`
- Injected the SwiftData model container at app launch with `.modelContainer(for: OrbitEntryModel.self)`.
- `OrbitStore` now owns local fetch/add/update/delete/clear operations through the injected `ModelContext`.

## v0.2 Data Model

`OrbitEntryModel` stores:

- `id: UUID`
- `title: String`
- `categoryRawValue: String`
- `energyTypeRawValue: String`
- `intensity: Int`
- `distanceRawValue: String`
- `note: String`
- `date: Date`
- `createdAt: Date`

The app maps `OrbitEntryModel` to `OrbitEntry` before rendering UI. This keeps persistence concerns out of `OrbitCanvas`, cards, and screen components.

## v0.2 Seed Logic

- Seed data lives in `OrbitSeedData`.
- On first launch, `OrbitStore.configure(modelContext:)` checks the SwiftData store.
- If the database is empty and `UserDefaults` has not recorded a prior seed, the app inserts the recent 7-day sample orbit.
- After seeding, `orbitNote.didSeedSampleData.v1` is set in `UserDefaults`.
- If the user clears local data, the app stays empty on later launches unless the user taps Restore sample data.

## v0.2 Data Flows

- Add: `AddEntryView` creates an `OrbitEntry`, `OrbitStore.add(_:)` inserts `OrbitEntryModel`, saves, refreshes entries, and marks the new id for the orbit animation.
- Edit: `OrbitDetailView` opens `AddEntryView` in edit mode, then `OrbitStore.update(_:)` mutates the matching SwiftData model.
- Delete: `OrbitDetailView` shows a destructive confirmation, then `OrbitStore.delete(_:)` removes the model and refreshes UI.
- Clear: `MeView` shows a confirmation before `OrbitStore.clearLocalData(reseed: false)`.
- Restore sample data: `MeView` exposes a restore action when local data is empty.

## Still Out Of Scope After v0.2

- Widget
- Notifications
- Share Extension
- App Intents
- Jitter / Lottie motion assets
- Sync, login, backend, subscription, or cloud storage

## v0.2.1 / Xcode Compatibility Fixes

- Added `import Combine` to `OrbitStore.swift` for `ObservableObject` and `@Published`.
- Removed class-wide `@MainActor` from `OrbitStore` to avoid `@StateObject` initializer isolation issues at app launch.
- Kept `ModelContext` reads/writes on `@MainActor` methods.
- Updated `RootView.task` to `await store.configure(modelContext:)` for main-actor crossing.
- Changed the SwiftData sort descriptor to `SortDescriptor(\.createdAt, order: .forward)`.
- Replaced `OrbitEntryModel` convenience initializer with a normal initializer to reduce `@Model` macro expansion risk.
- No data schema fields were added, removed, or renamed in v0.2.1.

## v0.2.2-ci / CI Validation

- Current version marker: `v0.2.2-ci`.
- GitHub Actions macOS CI build passed.
- `v0.2.2-ci` tag has been pushed.
- `v0.2.2-ci` GitHub pre-release has been created.
- This confirms the Xcode project can compile on a macOS runner.
- Manual Simulator CRUD smoke test is still pending because there is no local Mac available.

Manual validation still pending:

- Simulator launch.
- First-launch seed manual verification.
- Add / edit / delete / clear / restore manual verification.
- Restart-after-save SwiftData persistence manual verification.
- iPhone SE layout manual verification.

Do not start before manual validation:

- Widget.
- Notifications.
- App Intents.
- Share Extension.
- Lottie / Jitter.
- TestFlight.
- SwiftData schema expansion.

## v0.3 / Data Quality And Export

Scope:

- JSON export for local orbit entries.
- CSV export for local orbit entries.
- System Share Sheet for exported files.
- Lightweight glass feedback for add, edit, delete, clear, restore, export success, and export failure.
- SwiftData save/delete/export errors are surfaced through non-blocking feedback instead of silent failure.
- Empty states are clearer on Orbit, Timeline, and Me.
- Simple first-launch onboarding explains the orbit metaphor in three short cards.

Export fields:

- `title`
- `category`
- `energyType`
- `intensity`
- `distance`
- `note`
- `date`
- `createdAt`

Export filenames:

- `orbit-note-export-yyyy-MM-dd.json`
- `orbit-note-export-yyyy-MM-dd.csv`

JSON format:

- Array of records.
- Dates are ISO 8601 strings.
- Enum values use raw values: `relationship`, `work`, `project`, `body`, `creation`, `money`, `unknown`; `positive`, `draining`, `neutral`; `near`, `middle`, `far`.

CSV format:

- Header row followed by one row per orbit entry.
- Text fields are CSV-escaped.
- Dates are ISO 8601 strings.

Out of scope for v0.3:

- Widget.
- Notifications.
- App Intents.
- Share Extension.
- Lottie / Jitter.
- SwiftData schema changes.

## v0.3.0 / Release Status

- PR #2 has been merged to `master`.
- GitHub Actions macOS CI build passed.
- `v0.3.0` tag has been pushed.
- `v0.3.0` GitHub pre-release has been created.
- This release includes JSON export, CSV export, system Share Sheet, toast/banner feedback, SwiftData error feedback, empty-state improvements, and 3-card onboarding.
- No SwiftData schema changes were made for v0.3.0.

## v0.3.0 / Validation Status

Validated:

- macOS CI Xcode build passed on GitHub Actions.
- Project files compile in CI.
- New v0.3 source files are included in the Xcode target.

Still not manually verified because there is no local Mac available:

- Simulator launch.
- First-launch seed.
- Add / edit / delete / clear / restore CRUD flow.
- Restart-after-save SwiftData persistence.
- iPhone SE layout.
- Share Sheet presentation on device or Simulator.
- Onboarding first-launch presentation and skip behavior.

## v0.4 Preconditions

Do not start v0.4 Widget or notification work until:

- Manual Simulator launch succeeds.
- First-launch seed is manually verified.
- Add / edit / delete / clear / restore flows are manually verified.
- SwiftData persistence after app restart is manually verified.
- iPhone SE layout is manually checked.
- v0.3 export Share Sheet is manually checked.
- Any v0.3 CI regressions are fixed.

## v0.4.0-notification-spec / Technical Plan

Status:

- `v0.3.1` release polish and docs cleanup is complete.
- GitHub Actions macOS CI build passed.
- There is no local Mac available.
- Manual Simulator CRUD smoke test is still pending.
- This version is documentation-only. It does not add code, change SwiftData schema, add a Widget target, or modify Xcode project settings.

### v0.4 Goals

- Local evening reminder.
- Readonly Today Orbit Widget.
- Widget tap deep link to the Orbit tab.
- Keep Orbit Note local-first.
- No backend.
- No account system.
- No TestFlight work in v0.4.

### v0.4 Split Plan

- `v0.4.0-notification-spec`: documentation and technical plan only.
- `v0.4.1-local-notification`: add `UserNotifications` local evening reminder.
- `v0.4.2-widget-readonly`: add App Group JSON snapshot and readonly Today Orbit Widget.
- `v0.4.3-deeplink-polish`: add `orbitnote://orbit` routing to the Orbit tab.

### Local Notification Plan

- Use `UserNotifications`.
- Add reminder controls in Me:
  - reminder enabled switch
  - reminder time picker
  - permission status copy
- Default reminder time: 21:30.
- Request notification permission only after the user actively enables reminders.
- If permission is denied, show explanatory copy and avoid repeated permission prompts.
- Schedule at most one daily repeating reminder.
- Reminder copy should stay calm and non-coercive.
- Do not add:
  - streaks
  - check-in pressure
  - multiple reminders
  - notification actions
  - remote push notifications

### Widget Plan

- Do not let the Widget directly read SwiftData.
- The main app should generate `OrbitWidgetSnapshot.json`.
- The Widget should read that JSON snapshot through App Group.
- The App Group shares only the JSON snapshot, not the SwiftData store.

Small Widget:

- Today's dominant energy.
- Today's entry count.
- Closest orbit point.

Medium Widget:

- Today's dominant energy.
- Recent orbit points.
- Strongest draining summary.
- Strongest energizing summary.

Empty Widget state:

- `No orbit yet`

Do not add:

- interactive Widget
- Live Activity
- complex charts
- animated Widget content

### Deep Link Plan

- URL scheme: `orbitnote`.
- `orbitnote://orbit` routes to the Orbit tab.
- Future extension: `orbitnote://add`.
- Deep link implementation belongs to `v0.4.3-deeplink-polish`, not `v0.4.0-notification-spec`.

### App Group And Snapshot Risk

- A Widget needs App Group to reliably read data written by the main app.
- The recommended v0.4 MVP shares a JSON snapshot only.
- The Widget should not open or migrate the main SwiftData store.
- This reduces SwiftData container, migration, and Widget timeline risks.
- Because there is no local Mac, manual Widget insertion and visual QA will remain pending after CI until a Mac is available.

### v0.4 Preconditions And Sequencing

- `v0.4.1-local-notification` can start before Widget work because it does not require a Widget target.
- `v0.4.2-widget-readonly` must be an independent PR because it changes:
  - Xcode project
  - entitlements
  - Widget extension target
  - App Group configuration
- Every v0.4 sub-version must keep GitHub Actions iOS Build green.
- Manual validation must remain explicitly documented as pending while no local Mac is available.

### Explicitly Out Of Scope For v0.4.0

- Widget direct SwiftData access.
- Interactive Widget.
- Live Activity.
- App Intents.
- Share Extension.
- Lottie / Jitter.
- TestFlight.
- Remote push notifications.
- Multiple reminders.
- Streaks or check-in pressure.
- SwiftData schema expansion.

## v0.4.1-local-notification / Implementation Scope

Status:

- Implements local evening reminder only.
- Does not add Widget target.
- Does not add App Group.
- Does not add Deep Link.
- Does not modify SwiftData schema.
- Does not add App Intents, Share Extension, Lottie / Jitter, TestFlight, Focus Mode, remote push, multiple reminders, streaks, or notification actions.

### ReminderService

- Uses `UserNotifications`.
- Fixed notification identifier: `orbitNote.eveningReminder`.
- Reads current notification permission status.
- Requests notification permission only after the user enables the reminder.
- Schedules one daily repeating reminder with `UNCalendarNotificationTrigger`.
- Cancels the pending reminder when the user turns the setting off.

Default notification copy:

- Title: `Check your orbit`
- Body: `What stayed close to your attention today?`

### Reminder Settings

Settings live in Me.

Controls:

- Toggle: `Evening orbit reminder`
- DatePicker: reminder time
- Permission status row: `Not requested` / `Allowed` / `Not allowed`

AppStorage keys:

- `orbitNote.reminderEnabled`
- `orbitNote.reminderHour`
- `orbitNote.reminderMinute`

Default time:

- 21:30

Behavior:

- Enabling the toggle requests permission if status is not requested.
- If permission is allowed, schedule the daily reminder.
- If permission is denied, turn the toggle back off and show: `Notifications are disabled. You can enable them in Settings.`
- Changing the time while enabled reschedules the single daily reminder.
- Turning the toggle off cancels the pending reminder.

### Feedback

Uses existing ToastBanner style:

- Reminder scheduled.
- Reminder turned off.
- Could not schedule reminder.
- Notifications disabled / permission denied.

### Validation Status

GitHub Actions:

- Must keep iOS Build passing.

Manual validation still pending without local Mac / device:

- Permission prompt.
- Allowed permission flow.
- Denied permission flow.
- Pending notification exists after enabling.
- Pending notification removed after disabling.
- Time change reschedules the reminder.
- Daily repeat delivery behavior.

### v0.4.2 Handoff

Widget remains unimplemented and is reserved for `v0.4.2-widget-readonly`.

Before `v0.4.2`, keep the Widget plan unchanged:

- Widget should not directly read SwiftData.
- Main app should write `OrbitWidgetSnapshot.json`.
- Widget should read snapshot JSON through App Group.
- App Group should not share the SwiftData store.

## v0.4.2a-widget-snapshot-infra / Implementation Scope

Status:

- Adds the main app data infrastructure for the future Today Orbit Widget.
- Does not add a Widget target.
- Does not add App Group entitlements.
- Does not add URL scheme or Deep Link routing.
- Does not modify SwiftData schema.
- Does not add App Intents, Share Extension, Lottie / Jitter, TestFlight, Live Activity, or interactive Widget behavior.

### Snapshot Model

`OrbitWidgetSnapshot` is a lightweight `Codable` value written by the main app.

Fields:

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

The snapshot intentionally stores display-ready strings and simple counts so the future Widget can stay readonly and avoid touching SwiftData.

### Snapshot Service

`WidgetSnapshotService` is responsible for:

- Building today's snapshot from `[OrbitEntry]`.
- Writing `OrbitWidgetSnapshot.json`.
- Reading `OrbitWidgetSnapshot.json`.
- Clearing `OrbitWidgetSnapshot.json` when needed.

Current storage:

- Uses `FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)`.
- File name: `OrbitWidgetSnapshot.json`.

Future `v0.4.2b` storage:

- Move the container behind `containerURL()` to `FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:)`.
- Keep sharing JSON only.
- Do not share the SwiftData store with the Widget.

### Store Refresh Points

`OrbitStore` refreshes the snapshot after:

- configure / load succeeds.
- add succeeds.
- edit succeeds.
- delete succeeds.
- clear local data succeeds.
- restore sample data succeeds.

Snapshot write failures are non-blocking. They should not roll back or block SwiftData changes.

### Me Status UI

Me includes a readonly Widget snapshot status section:

- `Ready` when a generated snapshot has today's entries.
- `Empty` when a generated snapshot has no entries.
- `Not generated` when no snapshot exists yet.
- Shows last generated time when available.
- Includes `Refresh snapshot`.

Required copy:

- `Widget snapshot is prepared for the upcoming widget version.`

This UI must not imply that the Widget itself is already implemented.

### Why v0.4.2a Is Split From Widget Work

- There is currently no local Mac for manual Widget target setup, Widget Gallery insertion, or visual QA.
- Widget target and App Group setup are higher-risk Xcode project changes.
- Snapshot infrastructure can be CI-validated first without entitlements.
- `v0.4.2b-widget-extension` will add the Widget target and App Group in a separate PR.

### Validation Status

GitHub Actions:

- Must keep iOS Build passing.

Manual validation still pending without local Mac / device:

- Snapshot file path inspection in Simulator container.
- Me snapshot status visual QA.
- Widget Extension read path after App Group is introduced.
- Widget Gallery insertion and small / medium Widget visual QA.

## v0.4.2b-widget-extension / Implementation Scope

Status:

- Adds readonly Today Orbit Widget.
- Adds `OrbitNoteWidget` Widget Extension target.
- Adds App Group entitlements to the main app and Widget target.
- Supports small and medium Widget families.
- Keeps Deep Link for `v0.4.3-deeplink-polish`.
- Does not modify SwiftData schema.
- Does not add App Intents, Share Extension, Lottie / Jitter, TestFlight, Live Activity, interactive Widget behavior, remote notifications, complex charts, or weekly insights.

### App Group

Identifier:

- `group.com.codex.orbitnote`

Files:

- Main app entitlement: `OrbitNote/OrbitNote.entitlements`
- Widget entitlement: `OrbitNoteWidget/OrbitNoteWidget.entitlements`

Purpose:

- Main app writes `OrbitWidgetSnapshot.json`.
- Widget reads `OrbitWidgetSnapshot.json`.
- App Group shares JSON snapshot data only.
- App Group does not share the SwiftData store.

### Snapshot Storage

`WidgetSnapshotService.containerURL()` now prefers:

- `FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.codex.orbitnote")`

Fallback:

- Application Support directory.

The fallback keeps app data operations non-blocking if App Group access is unavailable in CI or a local unsigned build.

### Widget Reader

`OrbitWidgetSnapshotReader` lives inside the Widget extension.

Rules:

- Reads `OrbitWidgetSnapshot.json` from App Group.
- Returns nil when the file is missing or decode fails.
- Does not import SwiftData.
- Does not use `OrbitStore`.
- Does not access main app data directly.

Shared model:

- `OrbitWidgetSnapshot.swift` is included in both the app target and Widget target.
- The model stays lightweight and `Codable`.

### Widget Provider

Timeline:

- Simple readonly timeline.
- Refreshes every 45 minutes.
- Uses snapshot data when available.
- Falls back to empty state when unavailable.

Families:

- `.systemSmall`
- `.systemMedium`

### Widget UI

Visual direction:

- Radium Noir + Aurora Glass, reduced for Widget constraints.
- Near-black background.
- High-contrast text.
- Small amounts of cyan, pink-orange, and mist-purple.
- No animation.
- No complex Material stack.

Small Widget:

- `Today Orbit`
- Dominant energy.
- Today's record count.
- Closest orbit point.
- Empty state: `No orbit yet`.

Medium Widget:

- `Today Orbit`
- Dominant energy.
- Today's record count.
- Closest orbit point.
- Strongest positive point.
- Strongest draining point.
- Minimal orbit-line / point visual atmosphere.

### Explicitly Not Included

- URL scheme.
- `widgetURL` was not included in v0.4.2b; it is added in v0.4.3.
- `orbitnote://orbit` was not included in v0.4.2b; deep links are added in v0.4.3.
- App `onOpenURL` was not included in v0.4.2b; it is added in v0.4.3.
- `DeepLinkRouter` was not included in v0.4.2b; it is added in v0.4.3.
- App Intents.
- Share Extension.
- Lottie / Jitter.
- TestFlight.
- Remote notifications.
- Interactive Widget.
- Live Activity.
- Complex charts.
- Weekly insights.
- SwiftData schema changes.

### CI Notes

The GitHub Actions iOS build may use:

- `CODE_SIGNING_ALLOWED=NO`
- `CODE_SIGNING_REQUIRED=NO`

This avoids blocking CI on Apple Developer App Group signing while still validating that the project, app target, and Widget extension compile.

### Manual Validation Status

Still pending without local Mac / Simulator:

- Widget target appears in Xcode.
- App Group entitlement capability is accepted by a real signing team.
- Main app writes snapshot into the App Group container.
- Widget reads snapshot from the App Group container.
- Small Widget layout.
- Medium Widget layout.
- Widget Gallery insertion.
- Device refresh cadence.

## v0.4.3-deeplink-polish / Implementation Scope

Status:

- Adds minimal Widget-to-app deep link routing.
- Adds the `orbitnote` URL scheme to the main app.
- Adds `DeepLinkRouter`.
- Adds `.widgetURL(URL(string: "orbitnote://today"))` to the Widget root view.
- Keeps routing centralized in `RootView`.
- Does not modify SwiftData schema.
- Does not add App Intents, Universal Links, Associated Domains, Share Extension, Interactive Widget, Live Activity, TestFlight, Lottie / Jitter, remote notifications, or large navigation refactors.

### URL Scheme

Scheme:

- `orbitnote`

Supported URLs:

- `orbitnote://today`
- `orbitnote://orbit`
- `orbitnote://timeline`
- `orbitnote://me`

Not included:

- Universal Links.
- Associated Domains.
- External web routing.
- Complex route parameters.

### DeepLinkRouter

`DeepLinkRouter` is intentionally small.

Responsibilities:

- Validate the URL scheme.
- Normalize the host or path route.
- Map known URLs to lightweight destinations.
- Return nil for unknown URLs.
- Avoid SwiftData, Widget target dependencies, and large router state.

Destination mapping:

- `.today` -> Orbit tab.
- `.orbit` -> Orbit tab.
- `.timeline` -> Timeline tab.
- `.me` -> Me tab.

### RootView Integration

`RootView` owns `selectedTab`, so it is the single deep link handling point.

Behavior:

- `.onOpenURL` receives incoming URLs.
- `DeepLinkRouter.destination(for:)` parses the URL.
- Recognized destinations update `selectedTab`.
- Unknown URLs are ignored without alerts.

This keeps cold launch and warm routing on the same parsing path while avoiding a larger navigation system.

### Widget Integration

`OrbitWidgetView` sets:

- `widgetURL(URL(string: "orbitnote://today"))`

Behavior:

- Small Widget tap opens Today Orbit.
- Medium Widget tap opens Today Orbit.
- No `Link` controls.
- No multi-region Widget tap targets.
- No App Intents.
- No Interactive Widget behavior.

### Me Status Copy

Me shows a readonly status row:

- `Deep link`
- `orbitnote://today`

Supporting copy:

- `Widget taps open Today Orbit through orbitnote://today.`

This is informational only and not a test button.

### Manual Validation Status

Still pending without local Mac / Simulator:

- `orbitnote://today` cold launch.
- `orbitnote://orbit` warm routing.
- `orbitnote://timeline` warm routing.
- `orbitnote://me` warm routing.
- Widget tap opens Today Orbit.
- Widget Gallery validation.
- Small / medium Widget layout.
- App Group real-device signing.
- Snapshot actual Widget read.
- Notification permission and delivery.

## v0.4.4-manual-validation-checklist / Validation Strategy

Status:

- Documentation-only release.
- Adds `docs/MANUAL_VALIDATION.md`.
- Does not change Swift code.
- Does not change Xcode project settings.
- Does not change entitlements.
- Does not change SwiftData schema.
- Does not add v0.5 functionality.

### Why This Exists

The v0.4 chain now has several iOS surfaces that compile in GitHub Actions but still require hands-on validation:

- Local notification permission and delivery.
- Widget Gallery discovery.
- Small Widget layout.
- Medium Widget layout.
- App Group capability signing.
- App Group JSON snapshot write/read.
- Widget tap deep link.
- Deep link cold launch and warm routing.

GitHub Actions macOS CI has validated that the app and Widget extension compile. It cannot validate Widget Gallery behavior, notification delivery, signed App Group capability behavior, real Widget refresh behavior, or user-visible Simulator layout.

### Manual Validation Source Of Truth

Use:

- `docs/MANUAL_VALIDATION.md`

Coverage:

- Validation status overview.
- Environment prerequisites.
- Simulator validation checklist.
- Notification validation checklist.
- Widget validation checklist.
- App Group / snapshot validation checklist.
- Deep link validation checklist.
- Regression checklist.
- Known pending items.
- Pass / fail template.

### Recommendation Before v0.5

Before implementing v0.5 features, complete at least one manual validation pass on:

- iOS 17+ Simulator.
- Small Widget.
- Medium Widget.
- `orbitnote://today` deep link.
- Notification permission flow.

For production confidence, also complete a real-device pass with:

- Apple Developer signing.
- App Group capability enabled.
- Notification delivery.
- Widget snapshot read from the App Group container.

## v0.5 Planning / Validation-First Strategy

Status:

- Documentation-only planning release.
- Adds `docs/V0_5_PLAN.md`.
- Does not change Swift code.
- Does not change Xcode project settings.
- Does not change entitlements.
- Does not change SwiftData schema.
- Does not implement v0.5 features.

### Strategic Direction

v0.5 should be a validation-first polish release.

The priority is to move Orbit Note from "CI-compiles" to "Mac / Simulator / real-device verified" for the v0.4 feature chain:

- Local notifications.
- Today Orbit Widget.
- App Group snapshot sharing.
- Widget deep link routing.
- SwiftData persistence and CRUD regression.
- Export and onboarding regression.

### Why Not Expand Yet

Orbit Note should not enter account, cloud sync, AI generation, subscription, or social expansion before v0.4 runtime behavior is validated.

The current product promise is local-first, quiet, and iPhone-native. v0.5 should protect that promise by proving the foundation before adding another layer.

### Proposed v0.5 Shape

- `v0.5.0-validation-run`: run `docs/MANUAL_VALIDATION.md` and record real results.
- `v0.5.1-runtime-fixes`: fix only validation-discovered runtime issues.
- `v0.5.2-polish`: small UI, copy, Widget, and empty-state polish.
- `v0.5.3-insight-prototype`: optional lightweight local insight prototype using existing `OrbitEntry` data only.

### Non-goals

Do not start these in v0.5 unless the plan is explicitly revised:

- Account system.
- Cloud sync.
- AI generation.
- Subscription or monetization.
- Social sharing.
- App Intents.
- Interactive Widget.
- Live Activity.
- Share Extension.
- Push notification.
- Large redesign.
- SwiftData schema migration unless validation forces it.

### Next Recommended Step

Start with:

- `v0.5.0-ci-runtime-smoke`

Because there is no local Mac available, that release should first strengthen GitHub Actions macOS/Xcode smoke coverage. It should not mark manual validation as passed.

After a Mac / Simulator is available, run the manual checklist, record findings, and produce a focused fix list for `v0.5.1-runtime-fixes`.

## v0.5.0-ci-runtime-smoke / CI Validation Hardening

Status:

- CI-only release for Windows-based development.
- Does not change Swift code.
- Does not change Xcode project settings.
- Does not change entitlements.
- Does not change SwiftData schema.
- Does not change Widget UI.
- Does not change Deep Link behavior.
- Does not change notification behavior.
- Does not change App Group behavior.

### CI Coverage

GitHub Actions now checks:

- macOS runner version.
- Xcode version and selected developer directory.
- Available iOS runtimes.
- Available iPhone Simulators.
- Xcode project and scheme listing.
- Main app build for iOS Simulator.
- `OrbitNoteWidget` target build for iOS Simulator.
- Xcode build log artifacts for easier CI failure triage.

The smoke script lives at:

- `scripts/ci/ios_runtime_smoke.sh`

The script intentionally checks runtime and device availability without installing or launching the app. This keeps CI useful and stable while avoiding a fragile substitute for manual Simulator QA.

### What CI Still Does Not Prove

Manual validation remains required for:

- Simulator launch.
- SwiftData seed, CRUD, and restart persistence.
- Notification permission prompt.
- Notification delivery.
- Widget Gallery insertion.
- Small and medium Widget visual QA.
- App Group signed container behavior.
- Widget snapshot refresh in a live Widget.
- Widget tap deep link behavior.
- iPhone SE layout.

### v0.5 Sequencing Update

While no local Mac is available:

- Prefer CI hardening and documentation work.
- Do not record manual validation results.
- Do not start App Intents, Interactive Widget, Live Activity, Share Extension, TestFlight, or SwiftData schema expansion.

When Mac access becomes available:

- Run `docs/MANUAL_VALIDATION.md`.
- Record real device, OS, Xcode, result, and notes.
- Convert failures into focused `v0.5.1-runtime-fixes` issues.

## v0.5.1-windows-safe-workflow / Development Reliability

Status:

- Windows-safe workflow and documentation release.
- Does not change Swift code.
- Does not change Xcode project settings.
- Does not change entitlements.
- Does not change SwiftData schema.
- Does not change Widget UI.
- Does not change Deep Link behavior.
- Does not change notification behavior.
- Does not change App Group behavior.

### Development Strategy

Orbit Note can continue moving from Windows for scoped work that does not require visual Simulator confirmation.

Windows is appropriate for:

- Documentation.
- CI workflow maintenance.
- Shell script checks.
- Static project inspection.
- Small release process hardening.

GitHub Actions remains the macOS/Xcode verification layer for:

- Project listing.
- iOS runtime availability.
- iPhone Simulator availability.
- Main app build.
- Widget target build.
- CI log artifacts.

Manual Mac / Simulator / real-device validation remains deferred and must not be recorded as passed from Windows.

### CI Maintenance

The `iOS Build` workflow now includes:

- Official action maintenance for checkout and artifact upload.
- `bash -n` syntax checks for scripts in `scripts/ci/*.sh`.

The script syntax check is intentionally lightweight. It avoids extra package managers, third-party actions, or brittle dependencies.

### Windows Guide

Windows development guidance lives in:

- `docs/WINDOWS_DEVELOPMENT.md`

It documents:

- What Windows can safely edit.
- What still requires Mac / Simulator / device.
- GitHub Actions verification boundaries.
- GitHub HTTPS recovery with bundle backup.
- Temporary proxy push using one-command `git -c` configuration.

### Manual Validation Boundary

Still pending:

- Simulator launch.
- SwiftData seed, CRUD, and restart persistence.
- Notification permission prompt.
- Notification delivery.
- Widget Gallery insertion.
- Small and medium Widget visual QA.
- App Group signed container behavior.
- Widget tap deep link behavior.
- iPhone SE layout.

## v0.5.2-windows-safe-product-polish / Release-status Clarity

Status:

- Documentation and copy-alignment release.
- Does not change Swift code.
- Does not change Xcode project settings.
- Does not change entitlements.
- Does not change SwiftData schema.
- Does not change Widget UI.
- Does not change Deep Link behavior.
- Does not change notification behavior.
- Does not change App Group behavior.

### Product Communication Goal

v0.5.2 keeps Orbit Note's product direction stable while making release status easier to understand.

The documentation should consistently say:

- CI passed means macOS/Xcode build plus limited smoke checks passed.
- CI passed does not mean the app was manually launched in Simulator.
- CI passed does not validate Widget Gallery, notification delivery, App Group signing, or real-device behavior.
- Windows can continue supporting scoped development work.
- Manual Mac / Simulator / real-device validation remains pending.

### Release Status Source

The compact status source is:

- `docs/RELEASE_STATUS.md`

It should be used when deciding whether the project is ready for manual validation, runtime fixes, or another Windows-safe documentation / CI pass.

### v0.5 Product Boundary

The current v0.5 theme remains:

- Stability.
- Validation readiness.
- Developer workflow reliability.
- Local-first behavior preservation.

Do not use v0.5.2 as a reason to start:

- UI redesign.
- Layout polish that requires visual QA.
- App Intents.
- Interactive Widget.
- Live Activity.
- Share Extension.
- TestFlight.
- SwiftData schema expansion.

## v0.5.3-ci-guardrails / Architecture Guardrails

Status:

- CI-only static architecture protection release.
- Does not change Swift feature behavior.
- Does not change SwiftUI UI.
- Does not change Xcode project settings.
- Does not change entitlements.
- Does not change SwiftData schema.
- Does not change Widget behavior.
- Does not change Deep Link behavior.
- Does not change notification behavior.
- Does not change App Group behavior.

### Guardrail Purpose

The CI guardrails protect fragile v0.4/v0.5 architecture boundaries while development continues from Windows.

They check:

- The Widget target does not import SwiftData or reference `OrbitStore`.
- The Widget reads `OrbitWidgetSnapshot.json` rather than opening the main app data store.
- The App Group ID stays consistent between the app, Widget, snapshot writer, and snapshot reader.
- The Deep Link URL scheme and Widget `widgetURL` stay aligned.
- Reminder AppStorage keys and notification identifier stay stable.
- Documentation still states that manual validation is pending and CI has limits.

### What This Does Not Prove

These checks do not prove runtime behavior:

- Widget Gallery insertion.
- Widget refresh cadence.
- App Group signed container behavior.
- Notification permission prompt or delivery.
- Deep Link cold launch.
- iPhone SE layout.

Manual Mac / Simulator / real-device validation remains required.

## v0.5.4-insight-engine-prototype / Today Orbit Insight Engine

Status:

- Local-only pure logic prototype.
- Adds no UI surface.
- Does not use AI generation.
- Does not use network calls.
- Does not write files.
- Does not change SwiftData schema.
- Does not change Widget, Deep Link, Notification, App Group, export, or onboarding behavior.

### Insight Model

`TodayOrbitInsight` is a lightweight `Codable` and `Equatable` value.

Fields:

- `generatedAt`
- `date`
- `entryCount`
- `headline`
- `summary`
- `focusTitle`
- `positiveTitle`
- `drainingTitle`
- `suggestedPrompt`

### Insight Engine

`TodayOrbitInsightEngine` reads existing `[OrbitEntry]` values and returns a deterministic summary for one day.

It derives:

- Today's entry count.
- Closest orbit point.
- Strongest positive point.
- Strongest draining point.
- Dominant energy by total intensity.
- A short headline.
- A restrained one-sentence summary.
- A gentle reflection prompt.

The engine intentionally has no side effects. It does not mutate `OrbitStore`, refresh Widget snapshots, schedule reminders, export data, call external services, or decide any UI placement.

### Future UI Decision

The insight remains a logic layer until Mac / Simulator validation is available. A later release can decide whether to show it on Orbit, Timeline, or a weekly review surface after the current runtime checks are complete.

## v0.5.5-insight-engine-tests / Insight Engine Validation

Status:

- Adds unit-level validation for `TodayOrbitInsightEngine`.
- Adds no insight UI surface.
- Does not connect insight output to Orbit, Timeline, Me, Widget, notification, export, or App Group flows.
- Does not change SwiftData schema.

### Test Target

`OrbitNoteTests` is a minimal XCTest target for local logic coverage.

The target currently covers:

- Empty input.
- Filtering to the requested day.
- Deterministic focus / strongest positive / strongest draining selection.

### Deterministic Time

`TodayOrbitInsightEngine.makeInsight` accepts an injectable `generatedAt` date so tests can assert stable output without depending on wall-clock time. The parameter has a default value, so existing app behavior remains unchanged.

### CI Coverage

GitHub Actions runs the app build, Widget target build, guardrails, and `xcodebuild test` for the `OrbitNote` scheme on an available iPhone Simulator.

This proves the insight engine tests compile and pass in CI. It does not prove app launch, Simulator interaction, Widget Gallery behavior, notification delivery, App Group signing, or visual layout.

### Deferred

Insight UI remains deferred until Mac / Simulator validation is available. The engine should stay local-only and side-effect free until a validated product surface is selected.

## v0.5.6-insight-store-adapter / Readonly Store Adapter

Status:

- Adds a thin `OrbitStore` extension for generating a `TodayOrbitInsight` from current entries.
- Adds no visible product surface.
- Does not connect insight output to Orbit, Timeline, Me, Widget, notification, export, onboarding, or App Group flows.
- Does not change SwiftData schema.

### Adapter Design

`OrbitStore.makeTodayInsight(on:generatedAt:)` is intentionally tiny:

- Reads the store's current `entries`.
- Calls `TodayOrbitInsightEngine.makeInsight`.
- Returns the generated `TodayOrbitInsight`.

It does not mutate store state, save data, delete data, insert data, write files, refresh Widget snapshots, publish feedback, or schedule work.

### Purpose

This creates a safe internal seam for a future insight UI without deciding where the insight should appear. The product surface remains deferred until Mac / Simulator validation is available.

### Validation

XCTest covers:

- Adapter output matches direct engine output for the same entries.
- Empty store output remains stable.

CI guardrails also reject adapter drift toward persistence, file writes, network calls, or WidgetKit.

## v0.5.7-insight-ui-plan / Insight UI Strategy

Status:

- Documentation-only strategy release.
- Adds no SwiftUI implementation.
- Does not change Xcode project settings, entitlements, SwiftData schema, CI, Widget, Reminder, Deep Link, or App Group behavior.

### Recommended Entry

The first insight UI should be a compact readonly card in the Orbit tab.

Reasoning:

- The Orbit tab already answers the core product question: what is orbiting me today?
- The insight can sit near the existing daily context without becoming a dashboard.
- The card can update from the existing store adapter after add/edit/delete without new data flow.

Me should remain a settings/status area. It may describe insight readiness later, but should not be the main insight surface.

Widget insight expansion should be deferred until Widget Gallery, App Group signing, and medium Widget layout are manually validated.

### UI Constraints

Future implementation must keep:

- One compact card only.
- No nested cards.
- No first-pass animation.
- No new interactions, sheets, or routes.
- No AI framing, scoring, streaks, diagnosis, prediction, or productivity pressure.
- iPhone portrait-first and iPhone SE-safe layout.
- Orbit canvas visible and CTA reachable.

### Source Of Truth

Detailed planning lives in:

- `docs/INSIGHT_UI_PLAN.md`

The insight UI remains visually unvalidated until Mac / Simulator validation is available.

## v0.5.8-insight-card-minimal-ui / Today Insight Card

Status:

- Minimal SwiftUI UI integration.
- Adds one compact readonly card to the Orbit tab.
- Does not change Xcode project settings beyond adding the Swift source file.
- Does not change entitlements.
- Does not change SwiftData schema.
- Does not change Widget, Reminder, Deep Link, App Group, export, onboarding, or notification behavior.

### Card Design

`TodayInsightCard` uses the existing `GlassCard` surface and dark-first Orbit theme.

It displays:

- `Today insight`
- `TodayOrbitInsight.headline`
- `TodayOrbitInsight.summary`
- `Gentle prompt`
- `TodayOrbitInsight.suggestedPrompt`

The card is intentionally not interactive. It has no button, navigation route, sheet, score, streak, AI framing, diagnosis, prediction, network call, or file write.

### Placement

The card appears in `OrbitHomeView` below the existing date / title header and above the Orbit canvas.

This position keeps the insight close to the daily Orbit question while preserving the existing Orbit canvas, summary card, and add CTA flow.

### Validation Boundary

CI can validate compilation, tests, project membership, and static guardrails.

Manual Mac / Simulator validation remains pending for:

- iPhone SE layout.
- Standard iPhone layout.
- Dynamic Type sanity.
- Empty data.
- Long copy.
- Add / edit / delete refresh.
- Widget, Reminder, Deep Link, and App Group regressions.
