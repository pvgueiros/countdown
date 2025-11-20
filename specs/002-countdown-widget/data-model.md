# Data Model: Countdown Widget Visual Layout

## Entities

### Event (Existing; extended for widget sharing)
- id: String/UUID
- title: String
- date: Date
- iconSymbolName: String  // SF Symbol name for the event icon
- colorHex: String        // Hex-encoded color used for event styling

### WidgetRenderingState (Derived)
- classification: Enum { Past, Today, Future }
- dayCount: Int (absolute number of days for past/future; zero for today)
- labelToken: String (localized: “ago”, “days”, or “Today”)
- starIconName: String (Today only; default “star.fill”)

## Relationships
- Event is the source for widget display; icon and color flow from Event to widget via App Group shared payload.

## Validation Rules
- iconSymbolName MUST be a valid SF Symbol name available on the minimum iOS version (fallback strategy in UI if missing).
- colorHex MUST be a valid 6- or 8-digit hex value parsable by existing color utilities.
- Date classification MUST use local calendar day boundaries.

## State Transitions
- Future ↔ Today ↔ Past changes occur at local midnight or after timezone change; widget updates on next refresh.


