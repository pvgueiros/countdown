# Tasks: Countdown Widget Visual Layout (Feature 002)

This plan enumerates actionable, dependency-ordered tasks to implement the widget layout and visual states defined in the spec.

## Phase 1 — Setup

- [X] T001 Add localization keys for widget labels in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/Countdown/Resources/Localizable.xcstrings

## Phase 2 — Foundational (blocking)

- [X] T002 Extend DTO with icon and color in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Entities/EventAppEntity.swift (add iconSymbolName, eventColorHex to DTO and decode)
- [X] T003 Add properties to AppEntity in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Entities/EventAppEntity.swift (expose iconSymbolName, eventColorHex on EventAppEntity)
- [X] T004 Update Timeline entry payload in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/CountdownWidget.swift (SimpleEntry to include iconSymbolName, eventColorHex, classification)
- [X] T005 [P] Wire localized labels in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/CountdownWidget.swift (lookup “days”, “ago”, “Today” via Localizable)
- [X] T006 [P] Ensure color-from-hex utility available in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Colors/Color+Hex.swift (reuse existing; add fallback if needed)

## Phase 3 — User Story 1 (P1): Past event visual state

- [X] T010 [US1] Layout: icon top-left, title below, bottom row date left / countdown right in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Views/CountdownWidgetEntryView.swift
- [X] T011 [US1] Apply gray styling for past state (#808080) in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Views/CountdownWidgetEntryView.swift
- [X] T012 [US1] Show absolute past days + “ago” label (localized) in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Views/CountdownWidgetEntryView.swift
- [X] T013 [US1] Accessibility: concise VoiceOver for past state in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Views/CountdownWidgetEntryView.swift

## Phase 4 — User Story 2 (P1): Future event visual state

- [X] T020 [US2] Apply event color styling (text/accents) in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Views/CountdownWidgetEntryView.swift
- [X] T021 [P] [US2] Show days remaining + “days” label (localized) in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Views/CountdownWidgetEntryView.swift
- [X] T022 [P] [US2] Title truncation and spacing to avoid overlap in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Views/CountdownWidgetEntryView.swift
- [X] T023 [US2] Accessibility: announce “X days” clearly in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Views/CountdownWidgetEntryView.swift

## Phase 5 — User Story 3 (P1): Today event visual state

- [X] T030 [US3] Display “Today” (literal) with small star below (star.fill) in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Views/CountdownWidgetEntryView.swift
- [X] T031 [P] [US3] Apply event color styling for Today state in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Views/CountdownWidgetEntryView.swift
- [X] T032 [P] [US3] Accessibility: hide decorative star or describe appropriately in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Views/CountdownWidgetEntryView.swift
- [X] T033 [US3] Ensure layout stability with long titles (no clipping/overlap) in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Views/CountdownWidgetEntryView.swift

## Final Phase — Polish & Cross-Cutting

- [X] T040 Review previews for three states in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/Views/CountdownWidgetEntryView.swift
- [X] T041 Verify timeline refresh at midnight aligns with classification in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/CountdownWidget/CountdownWidget.swift
- [X] T042 Audit VoiceOver labels and localization coverage across states in project files
- [X] T043 Update docs quickstart validations in /Users/paulavasconcelosgueiros/Developer/iOS/countdown/specs/002-countdown-widget/quickstart.md

## Dependencies (Story Order)

1. Foundational (Phase 2) → enables UI rendering with icon/color/labels  
2. US1 (Past) → validates gray styling and bottom-right label  
3. US2 (Future) → adds event color and “days” label  
4. US3 (Today) → adds “Today” + star and event color styling  
5. Polish

## Parallel Execution Examples

- T005 and T006 can proceed in parallel (resource wiring vs utility confirmation).  
- Within Phase 4, T021 and T022 can proceed in parallel (label vs layout tuning).  
- Within Phase 5, T031 and T032 can proceed in parallel (styling vs accessibility).

## Implementation Strategy

- Deliver MVP per-story in priority order: Past → Future → Today.  
- After each story, validate against quickstart steps and adjust localization or spacing for readability.  
- Keep countdown semantics untouched; only add display labels and styling as per research.

## Counts & Validation

- Total tasks: 20  
- By story: US1 = 4, US2 = 4, US3 = 4; Setup+Foundational+Polish = 8  
- Parallel opportunities: 3 groups (T005/T006, T021/T022, T031/T032)  
- Independent test criteria: Each story phase yields a complete, renderable state per quickstart.


