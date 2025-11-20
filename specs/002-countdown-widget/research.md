# Research: Countdown Widget Visual Layout

## Decisions

- Decision: Keep countdown semantics identical to app (days-only; Today vs past/future classification).  
  Rationale: Ensures parity with existing business logic and satisfies success criteria alignment.  
  Alternatives: Divergent widget-specific semantics; Risk: inconsistency, user confusion.

- Decision: Use event color for Future and Today states; use gray for Past.  
  Rationale: Matches spec and existing list styling rules; improves scannability.  
  Alternatives: Monochrome styling; Risk: diminished visual hierarchy.

- Decision: Star icon for Today state uses `star.fill` SF Symbol at caption scale.  
  Rationale: Readable at small size; widely available; good semantic fit.  
  Alternatives: `sparkles`, `sun.max.fill`; Risk: reduced clarity or availability.

- Decision: “Today” string remains “Today” (title case) to match app text; visual emphasis is provided by layout (label position and star), not by changing the literal string to “TODAY”.  
  Rationale: Preserves app parity and avoids accessibility/localization drift; spec focus is visual emphasis.  
  Alternatives: Uppercase “TODAY”; Risk: mismatch with app text and VoiceOver phrasing.

- Decision: Add explicit labels “days” (future) and “ago” (past) in the countdown area; numeric value remains per app logic.  
  Rationale: Satisfies spec while keeping numeric parity; labels are localized.  
  Alternatives: Numeric only; Risk: not meeting spec clarity.

- Decision: Gray token is `#808080` (as used in `RowStylingRules.badgeColorHex`).  
  Rationale: Reuse established token for consistency.  
  Alternatives: Different gray; Risk: inconsistency with list visuals.

## Best Practices

- Precompute display strings and tokens; keep widget view simple.  
- Respect locale for date formatting and pluralization (“day” vs “days”).  
- Ensure truncation for long titles; avoid overlap; maintain touch/assistive labels.  
- Daily refresh at local midnight; handle timezone/clock changes robustly.

## Open Questions Resolved

- TODAY casing: Use “Today” (match app), not uppercase literal.  
- Past/future labels: Add localized “ago” and “days”.  
- Gray color: Use `#808080`.  
- Star symbol: `star.fill` at caption scale.

## Implementation Notes (for planning only)

- Extend App Group event DTO with `iconSymbolName: String` and `colorHex: String`.  
- Update `EventAppEntity.DTO` and decoding accordingly.  
- Add localization keys for “days”, “ago”, and any accessibility phrases if needed.


