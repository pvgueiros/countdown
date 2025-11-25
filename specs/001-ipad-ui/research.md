# Research: iPad UI Adaptation

**Feature**: 001-ipad-ui | **Date**: 2025-11-25 | **Phase**: 0 (Outline & Research)

## Purpose

This document captures research findings and technical decisions for adapting the Countdown app to iPad. All "NEEDS CLARIFICATION" items from the Technical Context have been investigated and resolved.

## Research Areas

### 1. NavigationSplitView for iPad Split-View Layout

**Question**: How to implement split-view navigation that automatically adapts between split and modal presentation based on screen size?

**Decision**: Use SwiftUI's `NavigationSplitView` with `.navigationSplitViewStyle(.balanced)` and environment-based size class detection.

**Rationale**:
- `NavigationSplitView` is Apple's recommended approach for iPad multi-column layouts (introduced iOS 16)
- Automatically adapts to size classes: regular width → split view, compact width → stack navigation
- Provides built-in animations for layout transitions during multitasking
- Maintains navigation state across layout changes
- Zero custom layout management code required

**Implementation Pattern**:
```swift
NavigationSplitView {
    // Sidebar: Event list
    EventListSidebarView()
} detail: {
    // Detail pane: Add/Edit form or empty state
    if let selectedEvent = viewModel.selectedEvent {
        AddEditEventSheet(viewModel: editViewModel)
    } else {
        PlaceholderView()
    }
}
.navigationSplitViewStyle(.balanced)
```

**Alternatives Considered**:
- Custom `HStack` with manual size class handling → Rejected: reinvents system behavior, complex state management
- `UISplitViewController` bridge → Rejected: unnecessary UIKit dependency, loses SwiftUI declarative benefits

**References**:
- WWDC22 Session 10054: "The SwiftUI cookbook for navigation"
- Apple HIG: iPad Navigation
- Existing project uses SwiftUI throughout (constitutional requirement)

---

### 2. Widget Size Families and Multi-Event Display

**Question**: How to extend the existing small widget to support Medium, Large, and Extra Large sizes with multiple events?

**Decision**: 
- Add `.systemMedium`, `.systemLarge`, `.systemExtraLarge` to `supportedFamilies`
- Create separate view components for each size: `MediumWidgetView`, `LargeWidgetView`, `ExtraLargeWidgetView`
- Use `@Environment(\.widgetFamily)` in `CountdownWidgetEntryView` to switch between layouts

**Rationale**:
- WidgetKit natively supports all four widget families on iPad
- Separate view components maintain single responsibility (one layout per size)
- Environment-based switching is SwiftUI's standard pattern for adaptive UI
- Existing `SimpleEntry` model can be extended to support multiple events without breaking small widget

**Implementation Pattern**:
```swift
struct CountdownWidgetEntryView: View {
    var entry: SimpleEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)  // Existing
        case .systemMedium:
            MediumWidgetView(entry: entry)  // New: 2 events
        case .systemLarge:
            LargeWidgetView(entry: entry)   // New: 4 events
        case .systemExtraLarge:
            ExtraLargeWidgetView(entry: entry)  // New: 6 events
        @unknown default:
            SmallWidgetView(entry: entry)
        }
    }
}
```

**Entry Model Extension**:
```swift
struct SimpleEntry: TimelineEntry {
    let date: Date
    let events: [EventSnapshot]  // Changed from single event to array
    
    struct EventSnapshot {
        let title: String?
        let eventDate: Date?
        let countdownDays: Int?
        let iconSymbolName: String
        let eventColorHex: String
    }
}
```

**Alternatives Considered**:
- Single view with conditional layout → Rejected: complex, violates SRP, hard to test
- Separate widget types for each size → Rejected: requires 4 separate widget configurations, poor UX

**References**:
- Apple WidgetKit documentation: "Building widgets for the iPad Home Screen"
- WWDC21 Session 10028: "Principles of great widgets"
- Existing `CountdownWidget.swift` already uses `.supportedFamilies([.systemSmall])`

---

### 3. Size Class Detection for Adaptive Layouts

**Question**: How to detect when to use split view vs. modal sheets during multitasking?

**Decision**: Use SwiftUI's `@Environment(\.horizontalSizeClass)` to detect compact vs. regular width.

**Rationale**:
- Horizontal size class is Apple's standard mechanism for adaptive layout decisions
- Automatically updates during:
  - Multitasking changes (Split View, Slide Over)
  - Device rotation
  - Window resizing
- No manual frame tracking or geometry reader gymnastics required
- Constitutional compliance: pure SwiftUI solution

**Implementation Pattern**:
```swift
struct EventListScreen: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @StateObject private var viewModel: EventListViewModel
    
    var body: some View {
        if horizontalSizeClass == .regular {
            // iPad full screen or larger Split View → Split view layout
            NavigationSplitView { /* ... */ }
        } else {
            // iPhone or iPad narrow Split View/Slide Over → Modal sheets
            NavigationView { /* existing implementation */ }
        }
    }
}
```

**Size Class Breakpoints**:
- **Regular width**: iPad full screen landscape, iPad 2/3 split in landscape
- **Compact width**: iPad 1/3 split, iPad Slide Over, iPad portrait (some models), all iPhones

**Alternatives Considered**:
- Manual frame width checking → Rejected: fragile, device-specific magic numbers, doesn't handle all cases
- Device idiom checking (`UIDevice.current.userInterfaceIdiom`) → Rejected: doesn't account for multitasking

**References**:
- Apple HIG: "Layout - Adaptivity and Layout"
- UIKit documentation: UIUserInterfaceSizeClass (SwiftUI uses same concepts)

---

### 4. State Management for Split View Selection

**Question**: Does EventListViewModel need modification to track selected event for split-view detail pane?

**Decision**: Add `@Published var selectedEvent: Event?` to `EventListViewModel` to track detail pane state.

**Rationale**:
- Split view requires persistent selection state (which event is being edited in detail pane)
- ViewModel already manages event state, natural fit for selection tracking
- Published property enables SwiftUI view updates when selection changes
- No impact on iPhone: selection state unused in modal sheet flow
- Maintains MVVM boundary: ViewModel owns state, View observes

**Implementation**:
```swift
@MainActor
public final class EventListViewModel: ObservableObject {
    // Existing properties...
    @Published public private(set) var rows: [Row] = []
    @Published public private(set) var items: [Event] = []
    
    // New: iPad split view selection
    @Published public var selectedEvent: Event? = nil
    
    public func selectEvent(id: UUID) {
        selectedEvent = items.first(where: { $0.id == id })
    }
    
    public func clearSelection() {
        selectedEvent = nil
    }
}
```

**Alternatives Considered**:
- Store selection in View @State → Rejected: loses state during view recreation, not testable
- Create separate iPad-specific ViewModel → Rejected: duplicates logic, violates DRY

**Testing Impact**: New unit tests required for selection state management.

---

### 5. Widget Multi-Event Selection Strategy

**Question**: How should users configure which events appear in multi-event widgets?

**Decision**: **Defer to implementation phase** - Start with "top N events" automatic selection, add manual selection in future iteration if needed.

**Rationale for Automatic Selection**:
- Simplest UX: no configuration required, widget shows upcoming events automatically
- Consistent with existing single-event widget behavior (shows configured event)
- Meets functional requirements: widgets display events with correct countdown
- Can iterate to manual selection based on user feedback

**Initial Implementation**:
- Small widget: User-configured single event (existing behavior)
- Medium widget: Top 2 upcoming events (automatic)
- Large widget: Top 4 upcoming events (automatic)
- Extra Large widget: Top 6 upcoming events (automatic)

**Future Enhancement** (out of scope for this feature):
- Extend `SelectEventIntent` to support multiple event selection
- Add widget configuration UI for choosing specific events
- Store multi-event preferences in UserDefaults App Group

**Alternatives Considered**:
- Manual multi-event selection now → Rejected: significant scope increase, delays MVP
- Show all events (scrollable) → Rejected: widgets are glanceable, not scrollable

**References**:
- Spec assumption: "widget configuration with no events" edge case documented
- Existing `SelectEventIntent.swift` supports single event selection

---

### 6. Performance Considerations for Widget Refresh

**Question**: Will loading multiple events for large widgets impact widget refresh performance?

**Decision**: No architectural changes needed. Existing repository pattern and UserDefaults storage are sufficient.

**Rationale**:
- UserDefaults reads are fast (~1ms for small datasets)
- Current app has no performance issues with event loading
- Widget timeline provider already loads events asynchronously
- Target: widget refresh within 200ms (well within WidgetKit limits)

**Performance Profile**:
- Small dataset: ~10-50 events expected (personal countdown app)
- UserDefaults read: O(1) for app group suite, O(n) to decode events
- Extra Large widget (6 events): still only decoding/displaying subset of total events

**Monitoring**:
- Add performance logging to widget timeline provider
- Track widget refresh time in tests (target: <200ms)
- Monitor with Instruments if performance issues arise

**Alternatives Considered**:
- Add caching layer → Rejected: premature optimization, adds complexity
- Use Core Data → Rejected: over-engineering for small dataset

---

### 7. Keyboard Avoidance in Split View

**Question**: How to ensure text fields remain visible when keyboard appears in split-view detail pane?

**Decision**: Use SwiftUI's automatic keyboard avoidance with `ScrollView` + `.ignoresSafeArea(.keyboard, edges: .bottom)`.

**Rationale**:
- SwiftUI's `Form` and `ScrollView` automatically adjust for keyboard by default
- Existing `AddEditEventSheet` uses `ScrollView`, already keyboard-aware
- iPad keyboard behavior: system automatically scrolls focused field into view
- No custom keyboard handling code required

**Implementation Verification**:
- Test focus on bottom text field with keyboard open
- Verify scrolling behavior maintains field visibility
- Edge case: iPad external keyboard (no virtual keyboard) → no impact

**Alternatives Considered**:
- Custom `GeometryReader` + keyboard notification handling → Rejected: reinvents SwiftUI behavior
- Adjust layout based on keyboard frame → Rejected: SwiftUI handles this automatically

---

### 8. Testing Strategy for iPad-Specific Features

**Question**: How to structure tests for iPad-specific UI behavior without duplicating iPhone test coverage?

**Decision**: 
- **Unit tests**: Extend existing ViewModel tests with selection state scenarios
- **UI tests**: Create new iPad-specific test files with device-specific launch arguments
- **Widget tests**: Add widget family environment injection to test different sizes

**Test Organization**:
```text
CountdownTests/
├── Presentation/
│   └── EventListViewModelIPadTests.swift     # New: selection state unit tests
└── Widget/
    └── MultiEventWidgetTests.swift            # New: multi-event widget logic

CountdownUITests/
├── IPadSplitViewTests.swift                   # New: split view navigation
├── IPadMultitaskingTests.swift                # New: Split View, Slide Over
├── IPadWidgetSizeTests.swift                  # New: medium/large/extra-large
└── IPadRotationTests.swift                    # New: orientation changes
```

**UI Test Device Selection**:
```swift
// In test setUp
let app = XCUIApplication()
app.launchArguments = ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryM"]
if UIDevice.current.userInterfaceIdiom == .pad {
    // iPad-specific tests run here
}
```

**Alternatives Considered**:
- Run all tests on iPad simulator → Rejected: slower, redundant for iPhone-only tests
- Scheme-based test selection → Rejected: complicates CI configuration

---

## Technology Stack Summary

| Component | Technology | Version | Justification |
|-----------|-----------|---------|---------------|
| Split View | NavigationSplitView | iOS 16+ | Native SwiftUI, automatic adaptation |
| Size Classes | @Environment(\.horizontalSizeClass) | iOS 13+ | Standard adaptive layout mechanism |
| Widget Families | WidgetKit | iOS 16+ | Native support for all four sizes |
| State Management | @Published properties | Combine | Existing pattern in ViewModels |
| Testing | XCTest + XCUITest | Xcode 14+ | Constitutional requirement |

## Open Questions

None. All technical unknowns have been resolved through research.

## Next Steps

Proceed to **Phase 1: Design & Contracts** to define:
- View state contracts for split-view navigation
- Widget entry model with multi-event support
- Component interfaces for new widget size views
- Quick start guide for implementing split-view patterns

