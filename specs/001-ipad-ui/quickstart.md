# Quick Start Guide: iPad UI Adaptation

**Feature**: 001-ipad-ui | **Date**: 2025-11-25 | **For**: Developers implementing this feature

## Overview

This guide provides a step-by-step implementation path for adding iPad UI support to the Countdown app. Follow these phases in order for a systematic, testable rollout.

---

## Prerequisites

- ✅ Xcode 14+ with iOS 16+ SDK
- ✅ iPad simulator or physical iPad for testing
- ✅ Familiarity with existing codebase architecture (CLEAN + MVVM + Coordinator)
- ✅ Review completed: `spec.md`, `research.md`, `data-model.md`, `contracts/README.md`

---

## Implementation Phases

### Phase A: Split View Navigation (Priority P1)

**Goal**: Add split-view layout for EventListScreen on iPad

**Estimated Effort**: 4-6 hours

#### Step A1: Extend EventListViewModel with Selection State

**File**: `Countdown/Presentation/ViewModels/EventListViewModel.swift`

```swift
// Add to EventListViewModel class:

// NEW: iPad split-view selection state
@Published public var selectedEventId: UUID? = nil

public func selectEvent(id: UUID) {
    guard items.contains(where: { $0.id == id }) else {
        selectedEventId = nil
        return
    }
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

**Testing**: Add `EventListViewModelIPadTests.swift` with selection state unit tests.

---

#### Step A2: Refactor EventListScreen for Adaptive Layout

**File**: `Countdown/UI/Screens/EventListScreen.swift`

**Strategy**: Wrap existing NavigationView in size-class-aware conditional

```swift
public struct EventListScreen: View {
    @StateObject private var viewModel: EventListViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    public var body: some View {
        if horizontalSizeClass == .regular {
            // iPad split view
            splitViewLayout
        } else {
            // iPhone or iPad compact width (existing behavior)
            compactLayout
        }
    }
    
    // NEW: iPad split view
    private var splitViewLayout: some View {
        NavigationSplitView {
            sidebarContent
        } detail: {
            detailContent
        }
        .navigationSplitViewStyle(.balanced)
    }
    
    // EXISTING: Modal navigation (extract from current body)
    private var compactLayout: some View {
        NavigationView {
            // ... existing ZStack with list and floating button ...
        }
    }
    
    private var sidebarContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerView
            if isEmpty {
                emptyStateView
            } else {
                tabsAndList
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var detailContent: some View {
        if let event = viewModel.selectedEvent() {
            AddEditEventSheet(
                viewModel: AddEditEventViewModel(
                    repository: UserDefaultsEventRepository(userDefaults: AppGroupUserDefaults.make()),
                    mode: .edit(event),
                    onCompleted: { viewModel.clearSelection() }
                )
            )
        } else {
            placeholderView
        }
    }
    
    private var placeholderView: some View {
        VStack {
            Image(systemName: "calendar")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            Text("Select an event to edit")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
    
    private var tabsAndList: some View {
        VStack {
            Picker("Sections", selection: $selectedTab) {
                Text("Upcoming").tag(0)
                Text("Past").tag(1)
            }
            .pickerStyle(.segmented)
            
            List(currentRows) { row in
                Button {
                    if horizontalSizeClass == .regular {
                        // iPad: update selection for detail pane
                        viewModel.selectEvent(id: row.id)
                    } else {
                        // iPhone: open modal sheet (existing behavior)
                        if let item = viewModel.item(for: row.id) { 
                            editingItem = item 
                        }
                    }
                } label: {
                    EventRowView(row: row)
                }
                .buttonStyle(.plain)
                .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .swipeActions {
                    Button {
                        pendingDeleteId = row.id
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                }
            }
            .listStyle(.plain)
        }
    }
}
```

**Testing**: 
- Unit test: Selection state updates correctly
- UI test: `IPadSplitViewTests.swift` - verify split view appears on iPad, modal on iPhone

---

#### Step A3: Update AppCoordinator (Optional)

**File**: `Countdown/Presentation/Coordinators/AppCoordinator.swift`

No changes required if EventListScreen handles size class internally. Coordinator remains simple:

```swift
public func rootView() -> some View {
    let repository = UserDefaultsEventRepository(userDefaults: AppGroupUserDefaults.make())
    let viewModel = EventListViewModel(repository: repository)
    return EventListScreen(viewModel: viewModel)
}
```

---

### Phase B: Expanded Widget Sizes (Priority P2)

**Goal**: Add Medium, Large, Extra Large widget sizes

**Estimated Effort**: 6-8 hours

#### Step B1: Refactor SimpleEntry for Multi-Event Support

**File**: `CountdownWidget/Views/CountdownWidget.swift`

```swift
// REPLACE SimpleEntry with:

struct SimpleEntry: TimelineEntry {
    let date: Date
    let events: [EventSnapshot]
    
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

**Testing**: Widget entry tests for multi-event arrays

---

#### Step B2: Update Provider to Fetch Multiple Events

**File**: `CountdownWidget/Views/CountdownWidget.swift` (Provider struct)

```swift
private func timeline(for configuration: SelectEventIntent, in context: Context) async -> Timeline<SimpleEntry> {
    let now = Date()
    let cal = Calendar.current
    let nextMidnight = cal.date(byAdding: .day, value: 1, to: cal.startOfDay(for: now)) ?? now
    
    let eventCount = eventCountForFamily(context.family)
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
    
    // Decode all events from UserDefaults
    guard let data = suite.data(forKey: "events"),
          let events = try? JSONDecoder().decode([EventDTO].self, from: data) else {
        return []
    }
    
    let cal = Calendar.current
    let startOfReferenceDay = cal.startOfDay(for: referenceDate)
    
    // Sort: upcoming first (by date ASC), then past (by date DESC)
    let upcoming = events.filter { cal.startOfDay(for: $0.date) >= startOfReferenceDay }
        .sorted { $0.date < $1.date }
    let past = events.filter { cal.startOfDay(for: $0.date) < startOfReferenceDay }
        .sorted { $0.date > $1.date }
    
    let sorted = upcoming + past
    let topN = Array(sorted.prefix(count))
    
    return topN.map { event in
        let startTarget = cal.startOfDay(for: event.date)
        let countdownDays = cal.dateComponents([.day], from: startOfReferenceDay, to: startTarget).day ?? 0
        
        return EventSnapshot(
            id: event.id,
            title: event.title,
            eventDate: event.date,
            countdownDays: countdownDays,
            iconSymbolName: event.iconSymbolName,
            eventColorHex: event.eventColorHex
        )
    }
}

// EventDTO matches domain Event structure
private struct EventDTO: Codable {
    let id: UUID
    let title: String
    let date: Date
    let iconSymbolName: String
    let eventColorHex: String
}
```

**Testing**: Timeline provider tests with multiple events

---

#### Step B3: Update CountdownWidgetEntryView for Size Routing

**File**: `CountdownWidget/Views/CountdownWidgetEntryView.swift`

```swift
struct CountdownWidgetEntryView: View {
    var entry: SimpleEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(event: entry.primaryEvent)
        case .systemMedium:
            MediumWidgetView(events: Array(entry.events.prefix(2)))
        case .systemLarge:
            LargeWidgetView(events: Array(entry.events.prefix(4)))
        case .systemExtraLarge:
            ExtraLargeWidgetView(events: Array(entry.events.prefix(6)))
        @unknown default:
            SmallWidgetView(event: entry.primaryEvent)
        }
    }
}
```

**Testing**: Widget entry view tests with environment family injection

---

#### Step B4: Implement Small Widget View (Refactor Existing)

**File**: `CountdownWidget/Views/SmallWidgetView.swift` (NEW FILE)

Extract existing `CountdownWidgetEntryView` body into `SmallWidgetView`:

```swift
struct SmallWidgetView: View {
    let event: EventSnapshot?
    
    var body: some View {
        // ... existing CountdownWidgetEntryView body ...
        // Update to use EventSnapshot instead of SimpleEntry properties
    }
}
```

---

#### Step B5: Implement Medium Widget View

**File**: `CountdownWidget/Views/MediumWidgetView.swift` (NEW FILE)

```swift
struct MediumWidgetView: View {
    let events: [EventSnapshot]
    
    var body: some View {
        HStack(spacing: 12) {
            if events.isEmpty {
                emptySlot
                emptySlot
            } else if events.count == 1 {
                eventCard(events[0])
                emptySlot
            } else {
                eventCard(events[0])
                eventCard(events[1])
            }
        }
        .padding(16)
    }
    
    private func eventCard(_ event: EventSnapshot) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Icon, title, date, countdown
            // Similar layout to SmallWidgetView but scaled for horizontal space
        }
        .frame(maxWidth: .infinity)
    }
    
    private var emptySlot: some View {
        VStack {
            Image(systemName: "plus.circle")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("Add Event")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
```

---

#### Step B6: Implement Large Widget View

**File**: `CountdownWidget/Views/LargeWidgetView.swift` (NEW FILE)

```swift
struct LargeWidgetView: View {
    let events: [EventSnapshot]
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                eventCard(at: 0)
                eventCard(at: 1)
            }
            HStack(spacing: 12) {
                eventCard(at: 2)
                eventCard(at: 3)
            }
        }
        .padding(16)
    }
    
    private func eventCard(at index: Int) -> some View {
        Group {
            if index < events.count {
                EventCardView(event: events[index])
            } else {
                EmptySlotView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
```

---

#### Step B7: Implement Extra Large Widget View

**File**: `CountdownWidget/Views/ExtraLargeWidgetView.swift` (NEW FILE)

```swift
struct ExtraLargeWidgetView: View {
    let events: [EventSnapshot]
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                eventCard(at: 0)
                eventCard(at: 1)
            }
            HStack(spacing: 12) {
                eventCard(at: 2)
                eventCard(at: 3)
            }
            HStack(spacing: 12) {
                eventCard(at: 4)
                eventCard(at: 5)
            }
        }
        .padding(16)
    }
    
    private func eventCard(at index: Int) -> some View {
        Group {
            if index < events.count {
                EventCardView(event: events[index])
            } else {
                EmptySlotView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
```

---

#### Step B8: Update Widget Configuration

**File**: `CountdownWidget/Views/CountdownWidget.swift`

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
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])  // ADDED: new sizes
    }
}
```

**Testing**: 
- Unit tests: Multi-event widget layouts
- UI tests: `IPadWidgetSizeTests.swift` - verify all 4 sizes render correctly

---

### Phase C: Multitasking Adaptation (Priority P3)

**Goal**: Ensure graceful layout transitions during Split View and Slide Over

**Estimated Effort**: 2-3 hours

#### Step C1: Verify Size Class Transitions

**Already handled** by `@Environment(\.horizontalSizeClass)` in EventListScreen. When iPad enters Split View (narrow), size class changes from `.regular` to `.compact`, triggering automatic switch to modal layout.

**Testing**: UI test `IPadMultitaskingTests.swift`:
- Launch full screen → verify split view
- Activate Split View 50/50 → verify modal sheets
- Return to full screen → verify split view restored
- Test Slide Over → verify modal sheets

---

#### Step C2: Verify State Preservation

**Implementation**: Ensure `viewModel.selectedEventId` persists across layout transitions.

**Testing**: 
- Select event in split view
- Trigger Split View multitasking (narrow width)
- Return to full screen
- Verify: selection still active, detail pane shows same event

---

#### Step C3: Rotation Testing

**Testing**: UI test `IPadRotationTests.swift`:
- Launch in portrait → verify layout mode
- Rotate to landscape → verify layout adapts
- While editing event, rotate device → verify form data preserved
- Verify keyboard remains accessible after rotation

---

## Testing Strategy

### Unit Tests (XCTest)

**New Test Files**:
- `EventListViewModelIPadTests.swift` - Selection state tests
- `MultiEventWidgetTests.swift` - Widget entry and provider tests

**Coverage Target**: ≥80% on new code

**Run Command**:
```bash
xcodebuild test -scheme Countdown -destination 'platform=iOS Simulator,name=iPad Pro (12.9-inch)'
```

---

### UI Tests (XCUITest)

**New Test Files**:
- `IPadSplitViewTests.swift` - Split view navigation flows
- `IPadMultitaskingTests.swift` - Multitasking layout adaptation
- `IPadWidgetSizeTests.swift` - Widget size rendering
- `IPadRotationTests.swift` - Orientation changes

**Run Command**:
```bash
xcodebuild test -scheme CountdownUITests -destination 'platform=iOS Simulator,name=iPad Pro (12.9-inch)'
```

---

## Validation Checklist

Before marking feature complete:

- [ ] All functional requirements (FR-001 through FR-014) implemented
- [ ] All success criteria (SC-001 through SC-005) verified
- [ ] Unit test coverage ≥80%
- [ ] Zero compiler warnings
- [ ] SwiftLint passes without violations
- [ ] UI tests pass on iPad Pro 12.9" simulator
- [ ] Manual testing on physical iPad (if available)
- [ ] Accessibility labels verified with VoiceOver
- [ ] iPhone functionality unchanged (regression test)
- [ ] Existing small widget unchanged (backward compatibility)

---

## Common Pitfalls & Solutions

### Pitfall 1: Split view detail pane not updating
**Solution**: Ensure `viewModel.selectedEventId` is `@Published` and `selectedEvent()` is called in detail pane builder.

### Pitfall 2: Modal sheets appearing on iPad split view
**Solution**: Check size class detection. Use `@Environment(\.horizontalSizeClass)` not device idiom.

### Pitfall 3: Widget showing wrong number of events
**Solution**: Verify `eventCountForFamily()` logic and `fetchTopEvents()` returns correct array size.

### Pitfall 4: Layout breaks during rotation
**Solution**: SwiftUI handles this automatically if size classes are respected. Avoid hard-coded frame widths.

### Pitfall 5: State lost during multitasking
**Solution**: Store state in ViewModel (`@Published` properties), not View (`@State`). ViewModels survive view recreation.

---

## Next Steps After Implementation

1. **Code Review**: Submit PR with reference to this spec and plan
2. **QA Testing**: Follow test scenarios in `spec.md`
3. **Performance Profiling**: Use Instruments to verify widget refresh <200ms
4. **Accessibility Audit**: Test with VoiceOver, Dynamic Type, high contrast
5. **Beta Testing**: Deploy via TestFlight to gather iPad user feedback

---

## Resources

- **Spec**: `specs/001-ipad-ui/spec.md`
- **Research**: `specs/001-ipad-ui/research.md`
- **Data Model**: `specs/001-ipad-ui/data-model.md`
- **Contracts**: `specs/001-ipad-ui/contracts/README.md`
- **Apple HIG**: [iPad Design Guidelines](https://developer.apple.com/design/human-interface-guidelines/ipad)
- **WWDC22**: Session 10054 - The SwiftUI cookbook for navigation

---

**Estimated Total Time**: 12-17 hours (split view: 4-6h, widgets: 6-8h, multitasking: 2-3h)

**Recommended Approach**: Implement in phases A → B → C. Test thoroughly after each phase before proceeding.

