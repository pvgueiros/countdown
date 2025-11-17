# Research: Countdown List

Date: 2025-11-14  
Branch: 001-countdown-list

## Decisions

### Persistence: UserDefaults (MVP), SwiftData (optional)
- Decision: Use `UserDefaults` for MVP to persist a small array of items. Consider `SwiftData` if relationships, queries, or scale grow.
- Rationale: Minimal dependencies, simple serialization, fast iteration; upgrade path exists.
- Alternatives: `SwiftData` now; Core Data. Rejected for MVP due to complexity and setup overhead.

### Icons: SF Symbols
- Decision: Use SF Symbols with stored `iconSymbolName`.
- Rationale: Native, scalable, dynamic weight/scale; easy theming.
- Alternatives: Custom assets; remote icons. Rejected due to asset management overhead.

### UI Aesthetics: Liquid glass style
- Decision: Use SwiftUI materials (`.ultraThinMaterial` / `.thinMaterial`) and blur to emulate “liquid glass” panels.
- Rationale: Native performance, aligns with Apple design. Use fallback material for older OS versions.
- Alternatives: Custom blur stacks. Rejected for complexity.

### Time semantics
- Decision: Device time zone; local midnight day boundaries; countdown shown as a number-only pill. Past values include a leading “-”; “Today” shown as "Today" with entry-colored background and darker border.
- Rationale: Matches user expectations; clarity for 0-day case.
- Alternatives: UTC or fixed TZ; rejected for potential confusion.

### Sorting and Tabs
- Decision: Two tabs: Upcoming (Today+future asc), Past (past desc); tie-breaker by creation time (oldest→newest).
- Rationale: Prioritizes imminence; history accessible; deterministic.
- Alternatives: Title sort; rejected as less meaningful chronologically.

## Open Items (none blocking)
- Accessibility: Verify contrast for colored countdown labels and borders (WCAG AA).
- Localization: Confirm phrasing “X days left” / “X days ago” for pluralization.


