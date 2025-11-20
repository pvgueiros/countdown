# Feature Specification: Countdown Widget Visual Layout

**Feature Branch**: `002-countdown-widget`  
**Created**: 2025-11-20  
**Status**: Draft  
**Input**: User description: "Make the CountdownWidget look like the attached image. The top left icon should match the event's icon. Below the icon is the event's title. On the bottom of the view, to the left, is the event date, and to the right, the countdown to the date. The first view is for dates in the past, the second for dates in the future and the third for dates in the current day. Dates in the past have the gray style and show the number of days past since the date, and the 'ago' label. Dates in the future match the event color in the widget and show the number of days until the date, and the 'days' label. Dates in the current day also match the event color in the widget and show 'TODAY' with the little star icon below. Please refer to the attached image for details."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Past event visual state (Priority: P1)

As a user, when the selected event date is in the past, I see a gray-styled widget indicating how many days have passed, with an “ago” label, so I can immediately recognize it’s in the past.

**Independent Test**: With an event dated N days before today, the widget shows: top-left event icon, title beneath the icon, bottom-left localized date, and bottom-right a gray-styled countdown showing the absolute day count with the “ago” label.

**Acceptance Scenarios**:
1. Given an event dated 3 calendar days in the past, when the widget renders, then the right-bottom area displays “3” with an “ago” label, using a gray style that visually differs from future/today states.
2. Given a long title for a past event, when the widget renders, then the title truncates gracefully without overlap while preserving icon position and bottom row alignment.

---

### User Story 2 - Future event visual state (Priority: P1)

As a user, when the selected event date is in the future, I see the widget using the event’s color and the days remaining with a “days” label, so I can quickly understand time until the event.

**Independent Test**: With an event dated N days after today, the widget shows: top-left event icon, title beneath the icon, bottom-left localized date, and bottom-right a color-styled countdown (matching the event) showing the day count with the “days” label.

**Acceptance Scenarios**:
1. Given an event 10 calendar days in the future, when the widget renders, then the right-bottom area displays “10” with a “days” label and uses the event’s color for the visual styling.
2. Given different event colors, when the widget renders, then the future-state styling consistently matches each event’s color without reducing legibility.

---

### User Story 3 - Today event visual state (Priority: P1)

As a user, when the selected event date is today, I see the widget using the event’s color and the prominent “TODAY” label with a small star below, so I can distinguish same-day events at a glance.

**Independent Test**: With an event dated today, the widget shows: top-left event icon, title beneath the icon, bottom-left localized date, and bottom-right the label “TODAY” with a small star icon below, using the event’s color.

**Acceptance Scenarios**:
1. Given an event dated today, when the widget renders, then the right-bottom area displays “TODAY” and a small star icon directly below, styled with the event color.
2. Given a long title for a today event, when the widget renders, then the layout remains aligned (icon top-left, title below, date bottom-left, today-state bottom-right) with no clipping.

---

### Edge Cases

- Very long titles: truncation must avoid clipping, overlapping, or crowding other elements.
- Locale and calendar differences: date formatting and pluralization adjust per user locale; day boundaries follow the user’s current local calendar day.
- Timezone/daylight saving changes: the day classification (past/future/today) updates correctly after device time changes.
- Extremely large day counts: numeric values remain legible without breaking layout.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The widget MUST place the event’s icon in the top-left.
- **FR-002**: The widget MUST place the event’s title below the icon with readable typography and graceful truncation.
- **FR-003**: The widget MUST place the event date in the bottom-left using localized date formatting.
- **FR-004**: The widget MUST place the countdown in the bottom-right, aligned opposite the date.
- **FR-005**: For past events, the countdown area MUST use a gray visual style and display the absolute number of days that have passed with an “ago” label (e.g., “3” + “ago”).
- **FR-006**: For future events, the countdown area MUST use a visual style that matches the event’s color and display the number of days remaining with a “days” label.
- **FR-007**: For events occurring today, the countdown area MUST use a visual style that matches the event’s color and display “TODAY” with a small star icon directly below.
- **FR-008**: The widget MUST follow the app’s established visual language for typography, color tokens, and spacing so it feels cohesive with the app.
- **FR-009**: The countdown day calculation semantics MUST match the app’s existing days-only countdown behavior (inclusive/exclusive rules and day boundary behavior).
- **FR-010**: Text and numbers MUST remain legible on the smallest widget surface; overflow MUST be truncated gracefully; elements MUST not overlap.
- **FR-011**: The widget MUST support accessibility with clear VoiceOver labels for icon, title, date, and countdown (including “ago”, “days”, or “TODAY” as applicable).
- **FR-012**: Localization MUST be supported for date formatting and for any displayed labels; pluralization rules MUST respect locale where applicable.

### Key Entities *(include if feature involves data)*

- **Event (existing)**: title, date, icon identifier, color identifier.
- **Widget Rendering State**: derived classification of the event date as Past, Today, or Future; determines styling and labels.
- **Display Tokens**: localized date string, numeric day count (absolute), label token (“ago”, “days”, “TODAY”), and a star icon for the Today state.

### Assumptions

- The event’s icon and color are already defined by the app’s data model and visual system.
- The “small star” used for the Today state is available in the existing iconography and is visually compatible at widget scale.
- Day calculations are days-only and aligned to the local calendar day; no hours/minutes shown.
- The attached image is authoritative for relative placement (icon top-left, title below, date bottom-left, countdown bottom-right) and state styling signals (gray vs event color).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In QA with one past, one future, and one today event, 100% of renders match the specified positions (icon top-left, title below, date bottom-left, countdown bottom-right).
- **SC-002**: In the same QA, 100% of state styles are correct: gray for past with “ago”, event color for future with “days”, event color for today with “TODAY” + star.
- **SC-003**: Date formatting and label localization display correctly for at least 3 common locales (e.g., en, es, pt-BR) with no clipping in 95% of cases.
- **SC-004**: For identical event inputs, the widget’s numeric day counts and state classification match the app’s countdown text 100% of the time.
- **SC-005**: No overlapping or clipped text in 100% of tested long-title cases; truncation appears graceful.
- **SC-006**: Accessibility pass: VoiceOver announces icon, title, date, and countdown state clearly across all three states with 0 critical issues.

### Dependencies

- Existing event data and visual tokens (icon set, color tokens).
- Localization resources for date formatting and labels (“ago”, “days”, “TODAY”).

### Out of Scope

- Larger widget sizes and alternate layouts.
- Live updates beyond day-level refresh semantics already established by the app.
- Changes to widget setup or selection flows (covered by earlier widget setup feature).

### Risks & Mitigations

- Long localized strings might overflow: ensure truncation and test top locales.
- Icon or star visibility at small sizes: verify contrast and fallback variants if needed.
- Edge timezone transitions: verify day classification after clock/timezone changes.


