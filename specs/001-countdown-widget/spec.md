# Feature Specification: Countdown Widget Setup

**Feature Branch**: `001-countdown-widget`  
**Created**: 2025-11-19  
**Status**: Draft  
**Input**: User description: "Add the ability to set up widgets from this app. The widget should have the smallest size, users should be able to select an event from the list (show titles only), and, once chosen, the widget should display the title, date and countdown for that event in the widget. The UI should go nicely with the app style."

## Clarifications

### Session 2025-11-19

- Q: How should “days remaining” be calculated for the widget countdown? → A: Match app countdown text (days-only semantics).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Configure a widget for a chosen event (Priority: P1)

As a user, I can set up a small home screen widget that shows one of my saved events so that I can see its title, date, and live countdown at a glance.

**Why this priority**: This is the core value of the feature—surfacing countdown information outside the app for quick access.

**Independent Test**: Starting with at least one saved event, a user can select one event and complete widget setup, resulting in a widget showing the selected title, date, and countdown.

**Acceptance Scenarios**:

1. Given at least one event exists, When I choose “Set up widget” and pick an event (titles only list), Then I can confirm and see a small widget showing that event’s title, formatted date, and countdown.
2. Given no events exist, When I attempt to set up a widget, Then I am informed I need a saved event first and given a clear path to create one.

---

### User Story 2 - Change the widget’s selected event (Priority: P2)

As a user, I can change which event a widget displays so I can quickly repurpose the widget without deleting and recreating it.

**Why this priority**: Reduces friction and improves long-term usability.

**Independent Test**: With an existing widget, the user can open selection, pick a different event (titles only), and the widget updates to the new title, date, and countdown.

**Acceptance Scenarios**:

1. Given a widget is already configured, When I open selection and pick another event, Then the widget updates within a short period to reflect the new event.

---

### User Story 3 - Visual consistency with app style (Priority: P3)

As a user, I expect the widget’s look and feel (typography, colors, spacing) to match the app’s visual style so it feels cohesive.

**Why this priority**: Builds trust and brand consistency; improves readability on small surfaces.

**Independent Test**: Visual inspection shows the widget uses the same color tokens and typographic scale as the app, with readable truncation and spacing in a compact layout.

**Acceptance Scenarios**:

1. Given the app’s defined color and type scale, When the widget renders, Then the title is readable with sensible truncation and the date/countdown are legible in smallest size.

---

### Edge Cases

- No saved events exist at setup time (show empty-state guidance and a path to create an event).
- Multiple saved events have identical titles (list remains disambiguated by list order; title is still shown as-is).
- Selected event’s date is in the past (countdown displays zero or “Today/Past” per Formatting requirement).
- Selected event is deleted after widget setup (widget shows a neutral placeholder and, on tap, prompts the user to reselect an event).
- Timezone changes or daylight saving time shifts (countdown remains accurate after device time changes).
- Very long titles (truncate gracefully with ellipsis; ensure no overlap).
- Localization differences for date formatting and pluralization of countdown units.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST allow users to set up a small widget that displays a single selected event.
- **FR-002**: During selection, the system MUST present a list of saved events showing titles only.
- **FR-003**: After selection, the widget MUST display the selected event’s title, the formatted date, and a countdown.
- **FR-004**: The widget MUST use the smallest available widget size for its layout.
- **FR-005**: The widget MUST render with visual style aligned to the app (color tokens, typography scale, spacing rules).
- **FR-006**: Users MUST be able to change the widget’s selected event after initial setup.
- **FR-007**: If no events exist, the system MUST block setup and provide clear guidance to create an event first.
- **FR-008**: The countdown MUST update at an appropriate cadence to remain perceived as current on small surfaces (e.g., days-first display).
- **FR-009**: The date text MUST respect user locale for formatting (e.g., day/month order).
- **FR-010**: Text overflow MUST be truncated gracefully without clipping or overlap.
- **FR-011**: If the selected event is deleted post-setup, the system MUST show a neutral placeholder and, on tap, prompt the user to reselect an event.
- **FR-012**: Accessibility: The widget content MUST be readable with dynamic type and support VoiceOver labels that announce title, date, and countdown succinctly.
- **FR-013**: Users MAY place more than one widget and configure each to a different saved event (multiple widgets supported).
- **FR-014**: Countdown calculation semantics (inclusive/exclusive rules, day-boundary behavior) MUST match the app’s days-only countdown text exactly.

### Key Entities *(include if feature involves data)*

- **Event (existing)**: title, target date/time, identifier.
- **Widget Selection**: reference to an Event by identifier; includes display parameters (title as string snapshot; date as display string; countdown units policy).

### Assumptions

- The smallest widget surface is the primary target; larger sizes are out of scope for this feature.
- Countdown unit granularity defaults to “days remaining” for compactness; hours/minutes not shown unless space allows.
- Multiple widgets are allowed; each widget is tied to one saved event.
- If an event is edited (title or date), the widget reflects the updated values on next refresh.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A typical user can complete widget setup for an existing event in under 20 seconds.
- **SC-002**: 95% of users can identify and select the correct event from the titles-only list without confusion.
- **SC-003**: 99% of countdown displays remain accurate across timezone changes and overnight refreshes.
- **SC-004**: Visual QA confirms 100% of long titles truncate without clipping or overlap on smallest size.
- **SC-005**: 90%+ of surveyed users rate visual consistency with the app as “good” or better.
- **SC-006**: For users who change the selected event, the widget reflects the new selection within a reasonable refresh window (e.g., within minutes as perceived by users).
- **SC-007**: For identical event dates and locale, widget countdown text matches the app text 100% of the time.

