# Contracts: Countdown Widget Visual Layout

This feature does not introduce a remote API. Contracts define module boundaries, shared persistence, and rendering tokens to ensure consistent visuals across app and widget.

## Module Contracts

### App (Persistence) → Widget (Read)
- Shared App Group key: `events` → JSON array of Event DTOs including:
  - `id`: UUID/String
  - `title`: String
  - `date`: ISO-8601 String
  - `iconSymbolName`: String (SF Symbol name)
  - `colorHex`: String (event color)

### Presentation/Formatting → Widget View
- Provides display tokens:
  - `title`: String (truncated if needed in UI)
  - `dateText`: String (locale-aware, medium style)
  - `countdownNumber`: Int (absolute days; zero for today)
  - `classification`: Past | Today | Future
  - `labels`:
    - Past → “ago”
    - Future → “days”
    - Today → “Today” and `starIconName = "star.fill"`

### Localization
- Keys required:
  - `widget.countdown.days` = "days"
  - `widget.countdown.ago` = "ago"
  - `widget.countdown.today` = "Today"
- Pluralization rules for “day” vs “days” are handled by using the numeric + label form for future and past; if singularization is desired, add ICU plural entries in the strings file.

### Accessibility
- VoiceOver labels MUST announce:
  - Title
  - Date
  - Countdown with context (“X days”, “X ago”, or “Today”)
- Decorative star for Today is hidden from accessibility or described if needed.

### Error/Invalidation Handling
- If an Event cannot be resolved or decoded:
  - Render a neutral placeholder (title empty or guidance string)
  - On tap, route user to selection flow in the app


