# Implementation Plan: iPad UI Adaptation

**Branch**: `001-ipad-ui` | **Date**: 2025-11-25 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-ipad-ui/spec.md`

## Summary

This feature adapts the Countdown app's user interface for iPad, leveraging the larger screen real estate through a split-view navigation pattern, expanded widget sizes, and graceful multitasking support. The implementation follows the existing CLEAN architecture with MVVM + Coordinator pattern, extending the current SwiftUI-based UI layer without introducing new domain entities.

**Primary Requirements**:
- Split view layout with event list (sidebar) and detail pane for add/edit forms
- Medium, Large, and Extra Large widget sizes supporting 2, 4, and 6 events respectively
- Adaptive layout that responds to multitasking (Split View, Slide Over) and orientation changes
- Preservation of all existing iPhone functionality

**Technical Approach**: 
- Use `NavigationSplitView` for iPad split-view navigation with size class detection
- Extend existing widget configuration to support `.systemMedium`, `.systemLarge`, and `.systemExtraLarge` families
- Implement responsive layout using SwiftUI's `horizontalSizeClass` environment value
- Maintain current CLEAN architecture boundaries: UI → Presentation (ViewModels) → Use Cases → Domain

## Technical Context

**Language/Version**: Swift 5.9+  
**Primary Dependencies**: SwiftUI, WidgetKit, Foundation, Combine  
**Storage**: UserDefaults via App Group (existing: `group.com.bluecode.CountdownApp`)  
**Testing**: XCTest for unit tests, XCUITest for UI tests  
**Target Platform**: iPadOS 16.0+ (matches existing iOS 16.0+ minimum)  
**Project Type**: iOS/iPadOS app with WidgetKit extension (mobile)  
**Performance Goals**: 60 fps animations for layout transitions, widget refresh within 200ms, smooth split-view interactions  
**Constraints**: Zero impact on iPhone UI, zero impact on existing small widget, backward compatible with iPad Air 2 (iPadOS 16)  
**Scale/Scope**: 2 new screen layouts (split view for EventListScreen and AddEditEventSheet), 3 new widget sizes, ~8-12 new SwiftUI views/components

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

MUST satisfy the following gates (per project constitution):

- ✅ **iOS/SwiftUI stack**: Using Swift 5.9+ and SwiftUI for all new UI components. No UIKit required.
- ✅ **SOLID compliance**: 
  - Single Responsibility: Each view handles one layout concern (split view, widget size)
  - Open/Closed: Extending EventListScreen and widget without modifying core behavior
  - Liskov Substitution: Views maintain same public interface, internal layout adapts
  - Interface Segregation: No new protocols needed, using existing EventRepository
  - Dependency Inversion: ViewModels remain independent of UI framework
- ✅ **CLEAN architecture**: No changes to Domain or Use Cases layers. Changes isolated to:
  - **UI Layer**: New split-view layouts, widget entry views for new sizes
  - **Presentation Layer**: Potential ViewState additions for split-view selection state
  - Dependencies remain inward: UI → Presentation → Use Cases → Domain
- ✅ **MVVM + Coordinator**: 
  - Views remain passive and declarative
  - EventListViewModel and AddEditEventViewModel handle state (no SwiftUI imports)
  - AppCoordinator owns navigation decisions (split view vs modal presentation)
  - DI via initializers (existing pattern preserved)
- ✅ **Quality gates**: 
  - Target: ≥80% coverage including new iPad-specific UI paths
  - Zero warnings commitment maintained
  - All tests pass (including new iPad UI tests and widget tests)
  - SwiftLint + SwiftFormat pass for all new code

**Gate Status**: ✅ PASS - No constitutional violations. Feature extends existing patterns without introducing architectural debt.

## Project Structure

### Documentation (this feature)

```text
specs/001-ipad-ui/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
│   └── README.md        # Component contracts and view state definitions
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created yet)
```

### Source Code (repository root)

```text
Countdown/                                    # Main app target
├── Domain/
│   ├── Entities/
│   │   └── Event.swift                      # [NO CHANGES - existing entity]
│   ├── Repositories/
│   │   └── EventRepository.swift            # [NO CHANGES - existing protocol]
│   └── UseCases/
│       └── GetEventsPartitionedUseCase.swift # [NO CHANGES - existing use case]
├── Data/
│   └── Sources/
│       └── UserDefaultsEventRepository.swift # [NO CHANGES - existing implementation]
├── Presentation/
│   ├── Coordinators/
│   │   └── AppCoordinator.swift             # [MODIFIED - iPad split view detection]
│   └── ViewModels/
│       ├── EventListViewModel.swift         # [POTENTIAL MINOR CHANGES - selection state]
│       └── AddEditEventViewModel.swift      # [NO CHANGES - existing]
├── UI/
│   ├── Screens/
│   │   ├── EventListScreen.swift            # [MODIFIED - NavigationSplitView wrapper]
│   │   └── AddEditEventSheet.swift          # [MINOR CHANGES - layout adaptations]
│   └── Components/
│       └── EventRowView.swift               # [MINOR CHANGES - truncation for narrow sidebar]

CountdownWidget/                             # Widget extension target
├── Views/
│   ├── CountdownWidget.swift                # [MODIFIED - add new widget families]
│   ├── CountdownWidgetEntryView.swift       # [MODIFIED - size-adaptive layouts]
│   ├── MediumWidgetView.swift               # [NEW - 2 events side-by-side]
│   ├── LargeWidgetView.swift                # [NEW - 4 events in 2x2 grid]
│   └── ExtraLargeWidgetView.swift           # [NEW - 6 events in 2x3 grid]
└── Intents/
    └── SelectEventIntent.swift              # [POTENTIAL CHANGES - multi-event selection]

CountdownTests/                              # Unit tests
├── Presentation/
│   └── EventListViewModelIPadTests.swift    # [NEW - selection state tests]
└── Widget/
    └── MultiEventWidgetTests.swift          # [NEW - multi-event widget logic tests]

CountdownUITests/                            # UI tests
├── IPadSplitViewTests.swift                 # [NEW - split view navigation flows]
├── IPadMultitaskingTests.swift              # [NEW - Split View, Slide Over tests]
├── IPadWidgetSizeTests.swift                # [NEW - medium/large/extra-large widget tests]
└── IPadRotationTests.swift                  # [NEW - orientation change tests]
```

**Structure Decision**: 
- **Mobile app with WidgetKit extension** pattern matches existing structure
- Maintains existing CLEAN architecture layers: Domain → Use Cases → Data + Presentation → UI
- iPad-specific logic is isolated to UI and Presentation layers
- Widget views organized by size family for clarity
- Test structure mirrors source organization (Presentation tests, Widget tests, UI tests)
- Zero changes to Domain and Use Cases layers preserve existing business logic
- All new code follows existing directory conventions (`UI/Screens/`, `UI/Components/`, `CountdownWidget/Views/`)

## Complexity Tracking

No constitutional violations require justification. All gates pass cleanly.

This feature extends existing patterns without introducing architectural complexity:
- Reuses existing ViewModels, repositories, and use cases
- Adds new view layouts and widget sizes within established SwiftUI patterns
- Maintains strict layer boundaries and dependency rules
- No new dependencies, frameworks, or architectural patterns required
