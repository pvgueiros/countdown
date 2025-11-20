# Implementation Plan: Countdown Widget Visual Layout

**Branch**: `002-countdown-widget` | **Date**: 2025-11-20 | **Spec**: specs/002-countdown-widget/spec.md  
**Input**: Feature specification from `/specs/002-countdown-widget/spec.md`

## Summary

Update the small CountdownWidget layout and state styling to match the specified design: icon top-left, title below icon, date bottom-left, countdown bottom-right. Three states: Past (gray with “ago”), Future (event color with “days”), Today (event color with “Today” and a small star below). Keep countdown day semantics aligned with the app’s days-only behavior.

## Technical Context

**Language/Version**: Swift 5.9+  
**Primary Dependencies**: SwiftUI (UI), WidgetKit (widget timelines), Foundation (dates, localization)  
**Storage/Integration**: App Group UserDefaults for widget configuration and event snapshots; extend shared event payload to include icon symbol name and color hex  
**Testing**: Unit tests for date classification/formatting; snapshot/UI previews for layout; UITests optional for integration  
**Target Platform**: iOS (last two major versions)  
**Project Type**: iOS app + widget extension  
**Performance Goals**: Lightweight render, no layout jank on smallest size, daily updates at midnight  
**Constraints**: Match app countdown semantics; localization for date and labels; accessibility for VoiceOver; zero warnings  
**Scale/Scope**: Only small widget layout changes; no new widget sizes

NEEDS CLARIFICATION: Confirm whether the visual “TODAY” should be uppercase while preserving the underlying string “Today” to keep parity with app text, or if exact string must remain “Today” visually as well.

## Constitution Check

- iOS/SwiftUI/WidgetKit stack: Using Swift 5.9+ and SwiftUI; WidgetKit for timelines.  
- SOLID: Keep business logic centralized; only view-specific composition in the widget view.  
- CLEAN architecture: UI (Widget) → Presentation (formatters) → Domain. Data through shared App Group repository.  
- MVVM patterns: Reuse Presentation formatters; avoid duplicating countdown math in views.  
- Quality gates: ≥80% coverage cumulative; zero warnings; all tests pass; localized strings added.  
- Static analysis: Keep SwiftLint/SwiftFormat passing.

Gate evaluation: No violations expected if “TODAY” string is aligned with app semantics (decision captured in research).

## Project Structure

```text
specs/002-countdown-widget/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/
    └── README.md
```

Source impacts:
- `CountdownWidget/Views/CountdownWidgetEntryView.swift` (layout and styling updates)
- `CountdownWidget/Entities/EventAppEntity.swift` (extend DTO with iconSymbolName, colorHex)
- Shared persistence writer in app target to include icon/color in App Group events blob
- Localization additions for “days”, “ago”, and accessibility labels as needed

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|--------------------------------------|
| None | — | — |

## Phasing

### Phase 0: Research & Decisions
- Resolve “TODAY” casing vs app parity; star symbol choice; gray color token; pluralization rules; localization strategy; accessibility labels.

### Phase 1: Design & Contracts
- Data model: extend shared DTO with `iconSymbolName` and `colorHex`.  
- Contracts: persistence keys and rendering tokens documented; localization keys defined.

### Phase 2: Implementation Outline (deferred to build step)
- Update widget entry view to specified layout; compute labels and colors per state; ensure truncation and alignment; VoiceOver labels.


