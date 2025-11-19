# Implementation Plan: Countdown List

**Branch**: `001-countdown-list` | **Date**: 2025-11-14 | **Spec**: specs/001-countdown-list/spec.md
**Input**: Feature specification from `/specs/001-countdown-list/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command.

## Summary

Display a SwiftUI-based list of user “Dates of Interest” with two tabs: Upcoming (Today + future, ascending) and Past (past, descending). Each row shows an SF Symbol icon, title, left-aligned date, and a right-aligned countdown pill (future: “X”, past: “-X”, today: “Today”). Adopt SwiftUI’s glass material (“liquid glass”) aesthetics. Persist items on-device (UserDefaults for MVP; consider SwiftData if model complexity grows). Architecture: CLEAN with MVVM + Coordinator. CI gates: warnings-as-errors, SwiftLint/SwiftFormat, ≥80% coverage.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Swift 5.9+ (SwiftUI), iOS 17+  
**Primary Dependencies**: SwiftUI, Combine (for bindings), OSLog, SwiftLint, SwiftFormat  
**Storage**: UserDefaults (MVP); SwiftData if relationships/queries increase  
**Testing**: XCTest (unit), XCUITest (UI), code coverage ≥80%  
**Target Platform**: iOS 17+ (support last two major iOS releases)  
**Project Type**: mobile (iOS app)  
**Performance Goals**: 60 fps UI; smooth scrolling; app launch < 400ms cold on modern device  
**Constraints**: Zero compiler warnings (treat warnings as errors); static analysis passes; offline-capable  
**Scale/Scope**: ~10–100 items; 1 primary screen, basic add/edit sheet

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

MUST satisfy the following gates (per project constitution):

- iOS/SwiftUI stack: Swift 5.9+ and SwiftUI for UI; UIKit exceptions documented.
- SOLID compliance: PASS review checklist or include justification + refactor ticket(s).
- CLEAN architecture: UI → Presentation (MVVM) → Use Cases → Domain; inward dependencies only.
- MVVM + Coordinator: Views are passive; navigation owned by Coordinators; DI via initializers/factories.
- Quality gates: Coverage ≥80% (unit+UI), 0 warnings (treat warnings as errors), all tests pass.
- Static analysis: SwiftLint + SwiftFormat pass in CI.

Status:
- Stack: Swift + SwiftUI (PASS)
- SOLID: Layered responsibilities, DI via initializers (PASS)
- CLEAN: Domain/UseCases/Data/Presentation/UI, inward dependencies only (PASS)
- MVVM + Coordinator: Views passive; navigation via Coordinator (PASS)
- Quality: Tests (unit+UI) with coverage ≥80%, 0 warnings (ENFORCED IN CI)
- Static analysis: Lint/format required (ENFORCED IN CI)

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
Countdown/
├── Domain/
│   ├── Entities/
│   └── Repositories/
├── UseCases/
├── Data/
│   ├── Sources/           # UserDefaults (MVP), SwiftData (future)
│   └── Mappers/
├── Presentation/
│   ├── ViewModels/
│   └── Coordinators/
├── UI/
│   ├── Components/
│   └── Screens/

CountdownTests/
├── Domain/
├── UseCases/
├── Presentation/

CountdownUITests/
```

**Structure Decision**: Single iOS app project (`Countdown/`) organized by CLEAN layers and MVVM+Coordinator. Tests mirror layers in `CountdownTests/` and flows in `CountdownUITests/`.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |

No violations anticipated.
