# Implementation Plan: Countdown Widget Setup

**Branch**: `001-countdown-widget` | **Date**: 2025-11-19 | **Spec**: specs/001-countdown-widget/spec.md  
**Input**: Feature specification from `/specs/001-countdown-widget/spec.md`

## Summary

Add the ability to set up a smallest-size home screen widget that displays a selected Date of Interest (title, date, countdown), matching the app’s countdown semantics and visual style. Follow existing architecture: Domain entities and Use Cases remain the source of truth; Presentation/ViewModels provide formatted strings; a widget configuration surface lets users choose a date (titles-only) and updates the widget content accordingly.

## Technical Context

**Language/Version**: Swift 5.9+  
**Primary Dependencies**: SwiftUI (UI), Widget-like surface for home-screen widget, Foundation (dates, localization)  
**Storage**: Persist dates via existing repository; store widget selection in shared preferences aligned with current data source  
**Testing**: Swift Testing for units; XCUITest for flows; snapshot testing for widget rendering where feasible  
**Target Platform**: iOS (last two major versions)  
**Project Type**: Mobile (iOS app + widget extension)  
**Performance Goals**: Lightweight rendering; instantaneous widget load; no layout jank on smallest size  
**Constraints**: Match app countdown text exactly; respect locale; zero warnings; ≥80% coverage  
**Scale/Scope**: Multiple widgets supported (each configured to a different date)

## Constitution Check

All gates addressed:
- iOS/SwiftUI stack: Using Swift 5.9+ and SwiftUI for UI.  
- SOLID compliance: Keep business logic in Use Cases; ViewModels adapt data for display; views passive.  
- CLEAN architecture: UI → Presentation (ViewModels) → Use Cases → Domain. Data implements repositories defined inward.  
- MVVM + Coordinator: Reuse existing coordinators and ViewModels patterns for any in-app selection flow.  
- Quality gates: Target ≥80% coverage (unit+UI); zero warnings; all tests pass.  
- Static analysis: Keep SwiftLint/SwiftFormat passing.

## Project Structure

### Documentation (this feature)

```text
specs/001-countdown-widget/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/
```

### Source Code (repository root)

```text
Countdown/
├── Domain/
│   ├── Entities/
│   ├── Repositories/
│   └── UseCases/
├── Data/
│   ├── Sources/
│   └── Mappers/
├── Presentation/
│   ├── ViewModels/
│   ├── Formatters/
│   └── Coordinators/
├── UI/
│   ├── Components/
│   └── Screens/
└── [New] Widget Extension (source files colocated under a new target)
```

**Structure Decision**: Extend the current CLEAN layered architecture. Introduce a widget extension target that depends on Presentation formatting logic and reads through repository interfaces to ensure consistency. Configuration state stored via the same persistence boundary the app uses.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | — | — |
