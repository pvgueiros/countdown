# Data Model: iPad UI Adaptation

**Feature**: 001-ipad-ui | **Date**: 2025-11-25 | **Phase**: 1 (Design & Contracts)

## Overview

This feature **does not introduce new domain entities**. It extends the presentation layer to support iPad-specific UI patterns (split view, larger widgets) while preserving the existing `Event` domain entity and repository contracts.

Changes are limited to:
1. **Presentation State**: Selection tracking for split-view navigation
2. **Widget Data Transfer Objects**: Multi-event timeline entries for larger widgets

## Existing Domain Model (No Changes)

### Event (Domain Entity)

**Location**: `Countdown/Domain/Entities/Event.swift`

```swift
public struct Event: Equatable, Identifiable {
    public let id: UUID
    public var title: String
    public var date: Date
    public var iconSymbolName: String
    public var eventColorHex: String
    public let createdAt: Date
}
```

**Responsibility**: Core domain entity representing a countdown event.

**Invariants**:
- `id` is immutable (creation time only)
- `createdAt` is immutable (used for tie-breaking in sorting)
- `title` must not be empty (validated at ViewModel layer)
- `date` represents calendar date (time component ignored)
- `iconSymbolName` must be valid SF Symbol name
- `eventColorHex` must be valid hex color (e.g., "#3B82F6")

**No changes required**: Event entity remains pure domain model.

---

## Presentation Layer Extensions

### EventListViewModel Selection State

**Location**: `Countdown/Presentation/ViewModels/EventListViewModel.swift`

**New Property**:
```swift
@MainActor
public final class EventListViewModel: ObservableObject {
    // Existing properties (unchanged)
    @Published public private(set) var rows: [Row] = []
    @Published public private(set) var upcomingRows: [Row] = []
    @Published public private(set) var pastRows: [Row] = []
    @Published public private(set) var items: [Event] = []
    
    // NEW: iPad split-view selection state
    @Published public var selectedEventId: UUID? = nil
}
```

**New Methods**:
```swift
public func selectEvent(id: UUID) {
    selectedEventId = id
}

public func clearSelection() {
    selectedEventId = nil
}

public func selectedEvent() -> Event? {
    guard let id = selectedEventId else { return nil }
    return items.first(where: { $0.id == id })
}
```

**Rationale**:
- Stores `UUID` instead of `Event` to avoid reference issues when items array updates
- Published property triggers SwiftUI view updates for detail pane
- Optional value represents "no selection" state (empty detail pane)
- Read-only public access via `selectedEvent()` method

**Impact on iPhone**: 
- Selection state is unused in modal sheet flow (no breaking changes)
- Property remains `nil` throughout iPhone usage

---

## Widget Layer Data Transfer Objects

### SimpleEntry (Extended for Multi-Event Widgets)

**Location**: `CountdownWidget/Views/CountdownWidget.swift`

**Current Structure** (Small widget only):
```swift
struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String?
    let eventDate: Date?
    let countdownDays: Int?
    let iconSymbolName: String
    let eventColorHex: String
}
```

**New Structure** (Supporting all widget sizes):
```swift
struct SimpleEntry: TimelineEntry {
    let date: Date
    let events: [EventSnapshot]  // Changed from single event to array
    
    // Computed property for backward compatibility with small widget
    var primaryEvent: EventSnapshot? {
        events.first
    }
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

**Migration Strategy**:
- Existing small widget code accesses `entry.primaryEvent` instead of individual properties
- New widget sizes iterate over `entry.events` array
- Timeline provider populates `events` array with 1 event for small widgets, up to 6 for extra large

**Rationale**:
- `EventSnapshot` is a value type (struct) suitable for widget timeline serialization
- Array of events supports all widget sizes without separate entry types
- `primaryEvent` computed property maintains backward compatibility
- `id` field enables tap interactions (future enhancement)

---

### Widget Timeline Provider Updates

**Location**: `CountdownWidget/Views/CountdownWidget.swift` (Provider struct)

**New Logic** (in `timeline(for:in:)` method):
```swift
private func timeline(for configuration: SelectEventIntent, in context: Context) async -> Timeline<SimpleEntry> {
    let now = Date()
    let cal = Calendar.current
    let nextMidnight = cal.date(byAdding: .day, value: 1, to: cal.startOfDay(for: now)) ?? now
    
    // Determine number of events based on widget family
    let eventCount = eventCountForFamily(context.family)
    
    // Fetch events from repository (via UserDefaults App Group)
    let events = await fetchTopEvents(count: eventCount, referenceDate: now)
    
    let currentEntry = SimpleEntry(date: now, events: events)
    let midnightEntry = SimpleEntry(date: nextMidnight, events: await fetchTopEvents(count: eventCount, referenceDate: nextMidnight))
    
    return Timeline(entries: [currentEntry, midnightEntry], policy: .after(nextMidnight))
}

private func eventCountForFamily(_ family: WidgetFamily) -> Int {
    switch family {
    case .systemSmall: return 1
    case .systemMedium: return 2
    case .systemLarge: return 4
    case .systemExtraLarge: return 6
    @unknown default: return 1
    }
}

private func fetchTopEvents(count: Int, referenceDate: Date) async -> [EventSnapshot] {
    let suite = UserDefaults(suiteName: "group.com.bluecode.CountdownApp") ?? .standard
    // Decode events from UserDefaults, sort by date (upcoming first), take top N
    // Return as EventSnapshot array
}
```

**Rationale**:
- Family-based event count keeps widget views focused on display logic
- Async fetching maintains non-blocking widget updates
- Midnight timeline refresh ensures daily countdown updates for all visible events

---

## View State Contracts

### Split View Navigation State

**State Flow**:
```
User taps event row
    ↓
EventListScreen updates selection binding
    ↓
EventListViewModel.selectedEventId = <tapped-event-id>
    ↓
NavigationSplitView detail pane observes selectedEventId
    ↓
Detail pane displays AddEditEventSheet with selected event
    ↓
User saves or cancels
    ↓
EventListViewModel.clearSelection() (optional, or keep selection)
    ↓
Detail pane updates (form refreshes or returns to placeholder)
```

**State Preservation During Multitasking**:
- `selectedEventId` preserved in ViewModel when transitioning between split view and modal presentation
- Modal sheet uses `.sheet(item:)` binding which manages its own presentation state
- No conflict: split view uses `selectedEventId`, modal sheet uses `@State` in EventListScreen

---

### Widget Size Layout State

**Layout Selection Flow**:
```
WidgetKit renders widget
    ↓
CountdownWidgetEntryView reads @Environment(\.widgetFamily)
    ↓
Switch statement routes to size-specific view:
    - .systemSmall → SmallWidgetView (existing)
    - .systemMedium → MediumWidgetView (new)
    - .systemLarge → LargeWidgetView (new)
    - .systemExtraLarge → ExtraLargeWidgetView (new)
    ↓
Size-specific view renders with entry.events array
```

**Empty State Handling**:
- If `entry.events.isEmpty`: Display "No Events" placeholder
- If `entry.events.count < expectedCount`: Display available events + "Add Event" prompts in remaining slots

---

## Validation Rules

### EventListViewModel Selection Validation

```swift
// Valid states:
selectedEventId = nil                    // ✅ No selection (empty detail pane)
selectedEventId = <valid-event-id>       // ✅ Event exists in items array
selectedEventId = <deleted-event-id>     // ⚠️ Handle gracefully: clear selection

// Validation on selection:
public func selectEvent(id: UUID) {
    guard items.contains(where: { $0.id == id }) else {
        // Event not found, clear selection
        selectedEventId = nil
        return
    }
    selectedEventId = id
}
```

### Widget Entry Validation

```swift
// SimpleEntry constraints:
events.count >= 0                        // ✅ Empty allowed (shows placeholder)
events.count <= 6                        // ✅ Max for ExtraLarge widget
events[i].countdownDays can be negative  // ✅ Past events allowed
events[i].title can be nil               // ✅ "No event selected" state

// Timeline provider ensures:
- events are sorted by date (upcoming first)
- countdownDays are calculated relative to entry.date
- EventSnapshot fields match domain Event fields
```

---

## Data Flow Diagrams

### Split View Selection Flow

```
┌─────────────────┐
│ EventListScreen │
│ (UI Layer)      │
└────────┬────────┘
         │ Tap event row
         ↓
┌──────────────────────┐
│ EventListViewModel   │
│ (Presentation Layer) │
│ @Published           │
│ selectedEventId: UUID│
└────────┬─────────────┘
         │ ObservableObject publishes change
         ↓
┌─────────────────────────┐
│ NavigationSplitView     │
│ detail: {               │
│   if selectedEvent {    │
│     AddEditEventSheet() │
│   }                     │
│ }                       │
└─────────────────────────┘
```

### Widget Timeline Flow

```
┌──────────────────────┐
│ WidgetKit System     │
│ Requests Timeline    │
└─────────┬────────────┘
          │
          ↓
┌──────────────────────────────┐
│ Provider.timeline()          │
│ - Reads context.family       │
│ - Determines event count     │
│ - Fetches from UserDefaults  │
└────────┬─────────────────────┘
         │
         ↓
┌─────────────────────────────────┐
│ SimpleEntry(events: [...])      │
│ - EventSnapshot array           │
│ - Sorted by date                │
│ - Limited by widget family size │
└────────┬────────────────────────┘
         │
         ↓
┌────────────────────────────────┐
│ CountdownWidgetEntryView       │
│ @Environment(\.widgetFamily)   │
│ Switch to size-specific view   │
└────────┬───────────────────────┘
         │
         ↓
┌────────────────────────────┐
│ MediumWidgetView           │
│ LargeWidgetView            │
│ ExtraLargeWidgetView       │
│ - Iterate entry.events     │
│ - Display grid/row layout  │
└────────────────────────────┘
```

---

## Testing Considerations

### Unit Test Scenarios for EventListViewModel

```swift
// Selection state tests
- testSelectEvent_WithValidId_SetsSelection()
- testSelectEvent_WithInvalidId_ClearsSelection()
- testClearSelection_RemovesSelection()
- testSelectedEvent_ReturnsCorrectEvent()
- testSelectedEvent_AfterEventDeleted_ReturnsNil()
- testLoadEvents_PreservesSelection_IfEventStillExists()
- testLoadEvents_ClearsSelection_IfEventDeleted()
```

### Widget Entry Tests

```swift
// Multi-event entry tests
- testSimpleEntry_WithMultipleEvents_ReturnsAll()
- testSimpleEntry_PrimaryEvent_ReturnsFirstEvent()
- testSimpleEntry_EmptyEvents_PrimaryEventIsNil()
- testEventSnapshot_CalculatesCountdownDays_Correctly()
- testTimelineProvider_ReturnsCorrectEventCount_ForFamily()
```

---

## Summary

This data model document defines:

✅ **No new domain entities** - Event remains unchanged  
✅ **Presentation state extension** - Selection tracking for split view  
✅ **Widget DTO evolution** - Multi-event SimpleEntry structure  
✅ **State validation rules** - Selection and widget entry constraints  
✅ **Data flow contracts** - Clear boundaries between layers  

All changes maintain CLEAN architecture principles: Domain layer untouched, changes isolated to Presentation (selection state) and UI (widget display) layers.

