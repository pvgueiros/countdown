# Contracts: Countdown Widget Setup

This app feature does not introduce a remote API. Contracts below define module boundaries and persisted data expectations to keep UI and widget in sync.

## Module Contracts

### Presentation → Widget
- Provides formatted strings for:
  - title (truncated as needed)
  - date (locale-aware)
  - countdown text (matches app semantics)

### Data Persistence
- Selection store keys
  - key: `widget.selection.<widgetId>.dateId` → String
  - key: `widget.selection.<widgetId>.title` → String (snapshot)
  - key: `widget.selection.<widgetId>.dateString` → String (snapshot)

### Error/Invalidation Handling
- If `dateId` no longer resolves to a DateOfInterest:
  - Widget renders neutral placeholder
  - On tap, open selection flow to reselect


