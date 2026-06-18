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
