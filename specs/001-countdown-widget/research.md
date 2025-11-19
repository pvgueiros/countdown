# Research: Countdown Widget Setup

## Decisions

- Decision: Use existing Domain + Use Cases + Presentation formatting to power widget strings  
  Rationale: Ensures countdown text matches the app exactly (FR-014, SC-007).  
  Alternatives: Duplicate logic in widget; Risk: drift and inconsistencies.

- Decision: Store widget selection alongside existing preferences boundary  
  Rationale: Reuses established persistence flow and avoids parallel state.  
  Alternatives: Custom store; Risk: fragmentation, sync issues.

- Decision: Support multiple widgets with independent selections  
  Rationale: Aligns with FR-013; enables rich device personalization.  
  Alternatives: Single shared selection; Risk: limits usefulness.

## Best Practices

- Keep widget rendering minimal; preformat strings in Presentation layer.  
- Respect locale; tests should validate date formats and countdown pluralization.  
- Handle deletion gracefully: placeholder + prompt to reselect (clarified).

## Open Questions Resolved

- Countdown semantics: Match app’s days-only text (clarified).  
- Deletion handling: Placeholder + tap to reselect (clarified).


