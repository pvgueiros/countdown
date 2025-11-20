# Data Model: Countdown List

Date: 2025-11-14  
Branch: 001-countdown-list

## Entities

### Event
- id: UUID (unique, immutable)
- title: String (1…80 chars)
- date: Date (truncated to calendar day in device time zone)
- iconSymbolName: String (SF Symbol name)
- eventColorHex: String (e.g., #RRGGBB or named color key)
- createdAt: Date (for tie-breaker ordering)
- updatedAt: Date (optional)

## Validation Rules
- title is non-empty, max 80 chars
- iconSymbolName must map to available symbol on min iOS target; use fallback if unavailable
- date stored as full `Date` but comparisons use calendar-day granularity in device time zone
- eventColorHex must parse to a valid color

## Relationships
- None (MVP)

## Derived/Computed
- isPast / isToday / isFuture based on local calendar day
- daysDelta: integer number of calendar days from today
- countdownNumberText:
  - future: "X"
  - past: "-X" (leading minus)
  - today: "Today"

## Persistence
- MVP: UserDefaults under key `events`, JSON-encoded array
- Future: SwiftData model with `@Model EventEntity` mapped 1:1 to fields above


