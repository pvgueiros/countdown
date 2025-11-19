# Data Model: Countdown Widget Setup

## Entities

### DateOfInterest (Existing)
- id: String
- title: String
- targetDate: Date

### WidgetSelection
- widgetId: String
- selectedDateId: String
- lastDisplayTitle: String (snapshot for resilience)
- lastDisplayDateString: String (locale-aware snapshot)

## Relationships
- WidgetSelection.selectedDateId → DateOfInterest.id (foreign key by identifier)

## Validation Rules
- A selection must reference an existing DateOfInterest at configuration time.
- When DateOfInterest is deleted, selection becomes invalid → show placeholder and prompt to reselect.

## State Transitions
- Created → Updated (user reselects) → Invalidated (source date deleted) → Recovered (user reselects)


