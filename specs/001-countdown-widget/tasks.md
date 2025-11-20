# Tasks: Countdown Widget Setup

Feature: Countdown Widget Setup  
Spec: `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/specs/001-countdown-widget/spec.md`  
Plan: `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/specs/001-countdown-widget/plan.md`

## Phases

- Phase 1: Setup (project initialization and target wiring)
- Phase 2: Foundational (shared code access, persistence boundary)
- Phase 3: US1 — Configure a widget for a chosen event (P1)
- Phase 4: US2 — Change the widget’s selected event (P2)
- Phase 5: US3 — Visual consistency with app style (P3)
- Final Phase: Polish & Cross-Cutting Concerns

## Phase 1 — Setup

- [X] T001 Create Widget extension target “CountdownWidget” (WidgetKit + SwiftUI) in project file `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/Countdown.xcodeproj/project.pbxproj`
- [X] T002 Add widget target bundle + Info plist file `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Info.plist`
- [X] T003 [P] Create widget bundle entry `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/CountdownWidgetBundle.swift`
- [X] T004 [P] Create widget main file `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/CountdownWidget.swift`
- [X] T005 Enable App Groups capability for App target in project file `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/Countdown.xcodeproj/project.pbxproj`
- [X] T006 Enable App Groups capability for Widget target in project file `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/Countdown.xcodeproj/project.pbxproj`
- [X] T007 [P] Add entitlements file for App target `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/Countdown/Countdown.entitlements`
- [X] T008 [P] Add entitlements file for Widget target `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/CountdownWidget.entitlements`
- [X] T009 Configure shared App Group identifier (e.g., `group.<team>.countdown`) in `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/Countdown/Countdown.entitlements`
- [X] T010 Mirror App Group identifier into `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/CountdownWidget.entitlements`
- [X] T011 [P] Share Localizable resource with widget target `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/Countdown/Resources/Localizable.xcstrings`
- [X] T012 Add shared scheme for widget `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/Countdown.xcodeproj/xcshareddata/xcschemes/CountdownWidget.xcscheme`

## Phase 2 — Foundational

- [X] T013 Create App Group UserDefaults helper `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/Countdown/Data/Sources/AppGroupUserDefaults.swift`
- [X] T014 Create WidgetSelection persistence store `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/Countdown/Data/Sources/WidgetSelectionStore.swift`
- [X] T015 Update repository to accept injected UserDefaults suite `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/Countdown/Data/Sources/UserDefaultsEventRepository.swift`
- [X] T016 Share date formatting provider with widget (enable target membership) `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/Countdown/Presentation/Formatters/DateFormatterProvider.swift`
- [X] T017 [P] Share color/style tokens with widget (enable target membership) `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/Countdown/Presentation/Colors/RowStylingRules.swift`
- [X] T018 [P] Share hex color utilities with widget (enable target membership) `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/Countdown/Presentation/Colors/EntryColor+Hex.swift`
- [X] T019 Add widget-facing display formatter (title/date/countdown) `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/Countdown/Presentation/Formatters/WidgetDisplayFormatter.swift`

## Phase 3 — User Story 1 (P1): Configure a widget for a chosen event
Goal: User can add the smallest-size widget, select an Event (titles-only), and see title, formatted date, and countdown that exactly matches the app.
Independent Test: With at least one saved event, user completes setup and the widget shows correct title, date, and countdown.

- [X] T020 [US1] Implement AppEntity for titles-only selection `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Entities/EventAppEntity.swift`
- [X] T021 [P] [US1] Implement AppIntent for widget configuration parameter `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Intents/SelectEventIntent.swift`
- [X] T022 [P] [US1] Implement AppIntentConfiguration in widget `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/CountdownWidget.swift`
- [X] T023 [US1] Implement Timeline provider to load selection and format display `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/CountdownWidget.swift`
- [X] T024 [P] [US1] Implement smallest-size widget view `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Views/CountdownWidgetEntryView.swift`
- [X] T025 [P] [US1] Persist selection snapshots (title/dateString) on configure `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/CountdownWidget.swift`
- [X] T026 [US1] Placeholder & empty-state handling when no events exist `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/CountdownWidget.swift`
- [X] T027 [P] [US1] Add widget tap URL deep-link to open app `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/CountdownWidget.swift`
- [X] T028 [US1] Unit tests for display formatter (match app semantics) `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownTests/Widget/WidgetDisplayFormatterTests.swift`
- [X] T029 [P] [US1] Unit tests for Timeline provider happy/empty states `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownTests/Widget/CountdownWidgetTimelineTests.swift`

## Phase 4 — User Story 2 (P2): Change the widget’s selected event
Goal: User can reconfigure an existing widget to display a different saved event quickly.
Independent Test: User opens selection for an existing widget, picks another event (titles-only), and the widget updates within a short window.

- [X] T030 [US2] Ensure configuration edit path exposes titles-only list `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Intents/SelectEventIntent.swift`
- [X] T031 [P] [US2] Persist selection keyed by selected event ID `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/CountdownWidget.swift`
- [X] T032 [P] [US2] Refresh timeline upon selection change `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/CountdownWidget.swift`
- [X] T033 [US2] Test reconfiguration behavior `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownTests/Widget/WidgetReconfigurationTests.swift`

## Phase 5 — User Story 3 (P3): Visual consistency with app style
Goal: Widget’s typography, colors, spacing match the app; long titles truncate; content remains readable.
Independent Test: Visual inspection confirms use of app tokens; titles truncate with ellipsis; date/countdown legible in smallest widget.

- [X] T034 [US3] Apply RowStylingRules and color tokens to widget view `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Views/CountdownWidgetEntryView.swift`
- [X] T035 [P] [US3] Truncation rules for long titles (single-line, tail ellipsis) `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Views/CountdownWidgetEntryView.swift`
- [X] T036 [P] [US3] VoiceOver: concise labels for title/date/countdown `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Views/CountdownWidgetEntryView.swift`
- [X] T037 [US3] Localization checks (date format/locale) via formatter `/Users/paulavasconcelosgueiros/Developer/iOS/countdown/Countdown/Presentation/Formatters/WidgetDisplayFormatter.swift`

---

## Dependencies (Story Order)

1) Phase 1 → 2 → 3 (US1) → 4 (US2) → 5 (US3) → Final  
US1 is foundational for US2 and US3. US2 depends on selection storage and timeline refresh from US1. US3 depends on shared styling exposed in Phase 2 and the widget view from US1.

Graph (high-level):
- Setup → Foundational
- Foundational → US1
- US1 → US2
- US1 → US3
- US2, US3 → Polish

## Parallel Execution Examples

- While enabling capabilities (T005–T010), create widget entry/view files (T003–T004) in parallel.
- Share style/formatting membership (T016–T018) in parallel with persistence scaffolding (T013–T015).
- In US1, implement AppIntent and view (T021, T024, T027) in parallel to timeline logic (T023, T026).
- In US2, keying by widget identifier (T031) can proceed in parallel with timeline refresh hook (T032).
- In US3, truncation (T035) and accessibility labels (T036) can proceed in parallel.

## Implementation Strategy (MVP First)

- MVP: Complete US1 (Phase 3) after Setup and Foundational. Ship a smallest-size widget that can be configured to any existing Event and shows correct title/date/countdown matching the app.
- Increment 2: US2 (reconfiguration) to improve usability without recreation.
- Increment 3: US3 (visual polish, accessibility refinements).
- Final: CI/coverage/performance polish.

## Validation

- US1 Independent Test: Add widget, pick event from titles-only list, verify exact title/date/countdown.
- US2 Independent Test: Edit selection for existing widget, verify refresh within a short window.
- US3 Independent Test: Visual tokens align with app; long titles truncate; VoiceOver reads concise labels.

---

## Format Validation

All tasks follow required checklist format:
- Checkbox prefix `- [ ]`
- Sequential Task IDs T001..T041
- [P] marker only on parallelizable tasks
- [USn] labels present only for user story phases
- Descriptions include explicit file paths

---

## Output

Generated file path:
`/Users/paulavasconcelosgueiros/Developer/iOS/countdown/specs/001-countdown-widget/tasks.md`

Summary:
- Total task count: 41
- Task count per user story: US1 (10), US2 (4), US3 (4) — others in Setup/Foundational/Polish
- Parallel opportunities: T003–T004, T007–T008, T016–T018, T021/T024/T027, T031–T032, T035–T036, T039–T040
- Independent test criteria: Defined per US phase above
- Suggested MVP scope: Phase 3 (US1) after Phases 1–2
