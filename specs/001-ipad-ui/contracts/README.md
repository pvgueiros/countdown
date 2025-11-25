# Component Contracts: iPad UI Adaptation

**Feature**: 001-ipad-ui | **Date**: 2025-11-25 | **Phase**: 1 (Design & Contracts)

## Overview

This document defines the public interfaces and contracts for all components introduced or modified in the iPad UI adaptation feature. Each contract specifies inputs, outputs, responsibilities, and behavior guarantees.

---

## 1. EventListViewModel (Modified)

**Location**: `Countdown/Presentation/ViewModels/EventListViewModel.swift`

### Public Interface

```swift
@MainActor
public final class EventListViewModel: ObservableObject {
    // EXISTING: Published state (unchanged)
    @Published public private(set) var rows: [Row] = []
    @Published public private(set) var upcomingRows: [Row] = []
    @Published public private(set) var pastRows: [Row] = []
    @Published public private(set) var items: [Event] = []
    
    // NEW: Selection state for iPad split view
    @Published public var selectedEventId: UUID? = nil
    
    // EXISTING: Initialization (unchanged)
    public init(
        repository: any EventRepository,
        dateString: @escaping (Date) -> String = { DateFormatterProvider.mediumLocaleFormatter().string(from: $0) }
    )
    
    // EXISTING: Data loading (unchanged)
    public func load() async
    public func setItems(_ items: [Event])
    public func item(for id: UUID) -> Event?
    public func delete(id: UUID) async
    
    // NEW: Selection management
    public func selectEvent(id: UUID)
    public func clearSelection()
    public func selectedEvent() -> Event?
}
```

### Contract: Selection Management

**Input**: `selectEvent(id: UUID)`
- **Precondition**: None (handles invalid IDs gracefully)
- **Postcondition**: 
  - If `id` exists in `items`: `selectedEventId = id`
  - If `id` does not exist: `selectedEventId = nil`
- **Side effects**: Publishes change to SwiftUI views observing ViewModel

**Input**: `clearSelection()`
- **Precondition**: None
- **Postcondition**: `selectedEventId = nil`
- **Side effects**: Publishes change to SwiftUI views

**Query**: `selectedEvent() -> Event?`
- **Precondition**: None
- **Postcondition**: Returns `Event` if `selectedEventId` matches an item, otherwise `nil`
- **Side effects**: None (pure query)

**Behavior Guarantees**:
1. Selection state persists across `load()` calls if selected event still exists
2. Selection automatically clears if selected event is deleted
3. Selection state is ignored on iPhone (no functional impact on existing behavior)

---

## 2. AppCoordinator (Modified)

**Location**: `Countdown/Presentation/Coordinators/AppCoordinator.swift`

### Public Interface

```swift
public struct AppCoordinator: Coordinator {
    public init()
    
    public func rootView() -> some View
}
```

### Contract: Root View Construction

**Output**: `rootView() -> some View`
- **Precondition**: None
- **Postcondition**: Returns root view appropriate for device:
  - iPad with regular width → `EventListScreen` with split-view layout
  - iPhone or iPad with compact width → `EventListScreen` with modal navigation
- **Side effects**: Creates `EventListViewModel` and `UserDefaultsEventRepository` instances

**Behavior Guarantees**:
1. Dependency injection: Repository injected into ViewModel at construction
2. Single source of truth: One ViewModel instance per app launch
3. Coordinators do not import SwiftUI view internals (only View protocol)

---

## 3. EventListScreen (Modified)

**Location**: `Countdown/UI/Screens/EventListScreen.swift`

### Public Interface

```swift
public struct EventListScreen: View {
    public init(viewModel: EventListViewModel)
    
    public var body: some View
}
```

### Contract: Adaptive Layout Rendering

**Input**: `init(viewModel: EventListViewModel)`
- **Precondition**: ViewModel must be initialized with repository
- **Postcondition**: Screen configured to observe ViewModel state

**Output**: `body: some View`
- **Precondition**: View has been initialized
- **Postcondition**: Returns appropriate layout based on horizontal size class:
  - Regular width → `NavigationSplitView` with sidebar and detail pane
  - Compact width → `NavigationView` with modal sheets (existing behavior)
- **Side effects**: 
  - Calls `viewModel.load()` on appear
  - Updates ViewModel selection state on row tap (iPad only)

**Behavior Guarantees**:
1. Layout adapts automatically when size class changes (multitasking, rotation)
2. State preservation: Form data and selection preserved during layout transitions
3. Backward compatibility: iPhone behavior unchanged
4. Accessibility: All existing accessibility identifiers preserved

---

## 4. SimpleEntry (Modified)

**Location**: `CountdownWidget/Views/CountdownWidget.swift`

### Public Interface

```swift
struct SimpleEntry: TimelineEntry {
    let date: Date
    let events: [EventSnapshot]
    
    var primaryEvent: EventSnapshot? { events.first }
}

struct EventSnapshot {
    let id: UUID
    let title: String?
    let eventDate: Date?
    let countdownDays: Int?
    let iconSymbolName: String
    let eventColorHex: String
}
```

### Contract: Widget Timeline Entry

**Invariants**:
1. `events.count <= 6` (maximum for extra-large widget)
2. `events` are sorted by date (upcoming events first)
3. `countdownDays` calculated relative to `entry.date`
4. `primaryEvent` returns first event or `nil` if `events.isEmpty`

**Behavior Guarantees**:
1. Backward compatibility: Existing small widget code uses `primaryEvent`
2. Multi-event support: New widget sizes iterate `events` array
3. Empty state handling: `events.isEmpty` signals "no events" UI state

---

## 5. CountdownWidget (Modified)

**Location**: `CountdownWidget/Views/CountdownWidget.swift`

### Public Interface

```swift
struct CountdownWidget: Widget {
    let kind: String = "CountdownWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: SelectEventIntent.self, provider: Provider()) { entry in
            CountdownWidgetEntryView(entry: entry)
                .containerBackground(containerBackground(for: entry), for: .widget)
        }
        .configurationDisplayName("Countdown")
        .description("Shows a countdown for a selected event.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
    }
}
```

### Contract: Widget Configuration

**Output**: `body: some WidgetConfiguration`
- **Precondition**: WidgetKit extension initialized
- **Postcondition**: Widget registered with WidgetKit supporting 4 families
- **Side effects**: Widget appears in widget gallery with all size options

**Supported Families**:
- `.systemSmall`: 1 event (existing)
- `.systemMedium`: 2 events (new)
- `.systemLarge`: 4 events (new)
- `.systemExtraLarge`: 6 events (new)

**Behavior Guarantees**:
1. Timeline updates at midnight for accurate daily countdowns
2. Each widget family receives appropriate number of events from provider
3. Widget background color adapts based on event state (future/past/today)

---

## 6. Provider (Modified)

**Location**: `CountdownWidget/Views/CountdownWidget.swift`

### Public Interface

```swift
struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry
    
    func snapshot(for configuration: SelectEventIntent, in context: Context) async -> SimpleEntry
    
    func timeline(for configuration: SelectEventIntent, in context: Context) async -> Timeline<SimpleEntry>
}
```

### Contract: Timeline Generation

**Output**: `timeline(for:in:) async -> Timeline<SimpleEntry>`
- **Precondition**: WidgetKit requests timeline update
- **Postcondition**: Returns timeline with entries for current time and next midnight
- **Side effects**: Reads events from UserDefaults App Group

**Timeline Policy**:
- **Entries**: 2 entries (current time + midnight)
- **Refresh Policy**: `.after(nextMidnight)` - refresh daily at midnight
- **Event Count**: Determined by `context.family`:
  - Small: 1 event
  - Medium: 2 events
  - Large: 4 events
  - Extra Large: 6 events

**Behavior Guarantees**:
1. Events fetched asynchronously without blocking widget render
2. Events sorted by date (upcoming first, then past descending)
3. Countdown days calculated accurately using Calendar API
4. Empty state handled gracefully (returns entry with empty events array)

---

## 7. CountdownWidgetEntryView (Modified)

**Location**: `CountdownWidget/Views/CountdownWidgetEntryView.swift`

### Public Interface

```swift
struct CountdownWidgetEntryView: View {
    var entry: SimpleEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View
}
```

### Contract: Size-Adaptive Widget Rendering

**Input**: `entry: SimpleEntry`
- **Precondition**: Entry contains 0-6 events sorted by date
- **Postcondition**: None (declarative view)

**Output**: `body: some View`
- **Precondition**: View initialized with entry
- **Postcondition**: Returns view appropriate for widget family:
  - `.systemSmall` → `SmallWidgetView(entry: entry.primaryEvent)`
  - `.systemMedium` → `MediumWidgetView(events: entry.events[0..<2])`
  - `.systemLarge` → `LargeWidgetView(events: entry.events[0..<4])`
  - `.systemExtraLarge` → `ExtraLargeWidgetView(events: entry.events[0..<6])`
- **Side effects**: None (pure view rendering)

**Behavior Guarantees**:
1. Falls back to small widget view for unknown families
2. Handles fewer events than expected (shows available events + empty slots)
3. Maintains accessibility labels for VoiceOver
4. Background color adapts per event state (color for future/today, gray for past)

---

## 8. MediumWidgetView (New)

**Location**: `CountdownWidget/Views/MediumWidgetView.swift`

### Public Interface

```swift
struct MediumWidgetView: View {
    let events: [EventSnapshot]
    
    init(events: [EventSnapshot])
    
    var body: some View
}
```

### Contract: Medium Widget Layout

**Input**: `events: [EventSnapshot]`
- **Precondition**: `events.count <= 2`
- **Postcondition**: None

**Layout**: Horizontal row with 2 event cards side-by-side

**Output**: `body: some View`
- **Precondition**: Initialized with events array
- **Postcondition**: Returns HStack with:
  - Left slot: `events[0]` or "Add Event" prompt
  - Right slot: `events[1]` or "Add Event" prompt (if `events.count < 2`)
- **Side effects**: None

**Behavior Guarantees**:
1. Each event displays: icon, title, date, countdown
2. Equal spacing between event cards
3. Truncates long titles with ellipsis
4. Empty slots show "Add Event" prompt with tap hint

---

## 9. LargeWidgetView (New)

**Location**: `CountdownWidget/Views/LargeWidgetView.swift`

### Public Interface

```swift
struct LargeWidgetView: View {
    let events: [EventSnapshot]
    
    init(events: [EventSnapshot])
    
    var body: some View
}
```

### Contract: Large Widget Layout

**Input**: `events: [EventSnapshot]`
- **Precondition**: `events.count <= 4`
- **Postcondition**: None

**Layout**: 2x2 grid with 4 event cards

**Output**: `body: some View`
- **Precondition**: Initialized with events array
- **Postcondition**: Returns VStack with 2 HStacks (2 rows of 2 events each)
- **Side effects**: None

**Behavior Guarantees**:
1. Grid layout maintains equal spacing and card sizes
2. Fills grid top-to-bottom, left-to-right
3. Empty slots show "Add Event" prompt
4. Responsive to widget width (uses GeometryReader if needed)

---

## 10. ExtraLargeWidgetView (New)

**Location**: `CountdownWidget/Views/ExtraLargeWidgetView.swift`

### Public Interface

```swift
struct ExtraLargeWidgetView: View {
    let events: [EventSnapshot]
    
    init(events: [EventSnapshot])
    
    var body: some View
}
```

### Contract: Extra Large Widget Layout

**Input**: `events: [EventSnapshot]`
- **Precondition**: `events.count <= 6`
- **Postcondition**: None

**Layout**: 2x3 grid with 6 event cards

**Output**: `body: some View`
- **Precondition**: Initialized with events array
- **Postcondition**: Returns VStack with 3 HStacks (3 rows of 2 events each)
- **Side effects**: None

**Behavior Guarantees**:
1. Grid layout maintains equal spacing and card sizes
2. Fills grid top-to-bottom, left-to-right
3. Empty slots show "Add Event" prompt
4. Font sizes adjusted for readability at this larger size

---

## Contract Testing Checklist

For each component contract above, implementation must include:

### Unit Tests (XCTest)
- [ ] All public methods tested with valid inputs
- [ ] Edge cases tested (nil, empty, boundary values)
- [ ] Precondition violations handled gracefully
- [ ] Postconditions verified in assertions
- [ ] Side effects validated (published changes, repository calls)

### UI Tests (XCUITest)
- [ ] Split view navigation flow end-to-end
- [ ] Size class transitions (rotation, multitasking)
- [ ] Widget rendering for all families
- [ ] Empty state handling in widgets
- [ ] Accessibility labels present and accurate

### Contract Compliance Review
- [ ] Public interface matches contract specification
- [ ] Implementation respects SOLID principles
- [ ] CLEAN architecture boundaries maintained
- [ ] No SwiftUI imports in ViewModels
- [ ] All mutations trigger `@Published` updates

---

## Integration Points

### EventListViewModel ↔ EventListScreen
- **Data Flow**: ViewModel publishes state → Screen observes → SwiftUI renders
- **Selection**: Screen updates `selectedEventId` → ViewModel publishes → Detail pane re-renders
- **Contract**: Screen never directly modifies ViewModel's internal state beyond public setters

### Provider ↔ UserDefaultsEventRepository
- **Data Flow**: Provider async calls repository → Repository reads UserDefaults → Returns Event array
- **Contract**: Provider handles async/await, repository remains synchronous (wraps UserDefaults)
- **Decoupling**: Provider does not depend on repository interface (reads UserDefaults directly for widget isolation)

### CountdownWidgetEntryView ↔ Size-Specific Views
- **Data Flow**: EntryView reads `@Environment(\.widgetFamily)` → Routes to size view → View renders
- **Contract**: EntryView acts as router, size views are pure rendering components
- **Boundary**: Size views are View structs with no business logic

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-11-25 | Initial contract definitions for iPad UI adaptation |

---

## Summary

This contracts document defines:

✅ **10 component interfaces** - Clear public APIs for all modified/new components  
✅ **Preconditions & postconditions** - Formal contracts for each method  
✅ **Behavior guarantees** - Expected behavior under normal and edge conditions  
✅ **Integration points** - Clear boundaries between components  
✅ **Testing checklist** - Verification criteria for contract compliance  

All contracts maintain CLEAN architecture principles and constitutional requirements (SOLID, MVVM, DI via initializers).

