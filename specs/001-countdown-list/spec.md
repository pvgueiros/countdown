# Feature Specification: Countdown List

**Feature Branch**: `001-countdown-list`  
**Created**: 2025-11-14  
**Status**: Draft  
**Input**: User description: "Create a simple Countdown app. The main screen will have the title \"Countdown\" and the subtitle \"Track your special moments\". It should show a list of dates of interest: one per row. Each row will display an icon, title, date (left justified) and a \"countdown pill\" (right justified). Date entries can have multiple colors. If the date is in the future, the countdown pill background should follow the entry color. If it is in the past, it should be gray. For a design reference (not to be identical), refer to the prototype in https://soft-banana-87494529.figma.site."

## Clarifications

### Session 2025-11-14

- Q: What is the MVP data source and persistence level? → A: On-device persistence (e.g., UserDefaults/Core Data) with basic add/edit.
- Q: Which icon set will be used? → A: SF Symbols (system icons).
- Q: How should list ordering and grouping be presented? → A: Two tabs: Upcoming (Today + future) sorted ascending by date; Past sorted descending by date.
- Q: What is the tie-breaker for items with the same date within a tab? → A: Creation time (oldest→newest).

## User Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: User stories should be PRIORITIZED as user journeys ordered by importance.
  Each user story/journey must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them,
  you should still have a viable MVP (Minimum Viable Product) that delivers value.
  
  Assign priorities (P1, P2, P3, etc.) to each story, where P1 is the most critical.
  Think of each story as a standalone slice of functionality that can be:
  - Developed independently
  - Tested independently
  - Deployed independently
  - Demonstrated to users independently
-->

### User Story 1 - View countdown list (Priority: P1)

As a user, I open the app and see a titled screen with a subtitle and a list of my dates of interest, each showing an icon, a title, a date (left-aligned), and a right-aligned countdown pill.

**Why this priority**: This is the core value proposition of the app and must function as the MVP.

**Independent Test**: Launch the app with a predefined list of dates and verify that the title, subtitle, and list render correctly with alignment and content per row.

**Acceptance Scenarios**:

1. Given the app launches, when the main screen loads, then the title reads "Countdown" and the subtitle reads "Track your special moments".
2. Given at least one date of interest exists, when the list renders, then each row shows an icon, a title, a left-justified date, and a right-justified countdown pill.
3. Note: US1 verifies presence and alignment only; the exact pill semantics (number vs “Today”, colors) are finalized in US2.

---

### User Story 2 - Understand time remaining (Priority: P1)

As a user, I can quickly understand how many days remain until a future date or how many days have passed since a past date via the countdown label and its background color.

**Why this priority**: Clear communication of time remaining/past is essential to the feature’s usefulness.

**Independent Test**: With one future, one today, and one past date, verify the day representations (future shows a positive number, today shows “Today”, past shows a leading “-”) and that the future/today item’s countdown background color matches the entry color, while the past item’s countdown background is gray.

**Acceptance Scenarios**:

1. Given a date 10 calendar days in the future, when displayed, then the countdown pill shows "10" and the background color matches the entry color (no qualifier label).
2. Given a date 3 calendar days in the past, when displayed, then the countdown pill shows "-3" and the background color is gray (no qualifier label).
3. Given a date equal to today, when displayed, then the countdown pill shows "Today", and the pill background color matches the entry color, with a slightly darker border for contrast.

---

### User Story 3 - Empty state communication (Priority: P2)

As a user with no saved dates of interest, I see a friendly empty state message explaining that no dates are available yet.

**Why this priority**: Prevents confusion and sets expectations when the list is empty.

**Independent Test**: Launch the app with an empty dataset; verify the empty state message appears and primary title/subtitle still display.

**Acceptance Scenarios**:

1. Given no dates exist, when the main screen loads, then an empty state message appears instead of the list.

---

[Add more user stories as needed, each with an assigned priority]

### User Story 4 - Manage dates (Priority: P2)

As a user, I can add a new date of interest and edit an existing one, and the changes persist across app launches.

**Why this priority**: Basic manageability of the list supports real-world usefulness while keeping scope small.

**Independent Test**: Add a new item and relaunch the app to confirm persistence; edit an item and verify the row updates accordingly.

**Acceptance Scenarios**:

1. Given a valid new date entry, when I add it, then it appears in the list and is present after relaunch.
2. Given an existing entry, when I edit its title/date/icon/color, then the corresponding row updates and persists after relaunch.

---

[Add more user stories as needed, each with an assigned priority]

### User Story 5 - Browse Upcoming and Past tabs (Priority: P1)

As a user, I can switch between two tabs: Upcoming (Today and future dates) and Past (past dates), where Upcoming is sorted ascending by date and Past is sorted descending by date.

**Why this priority**: Ensures users can focus on imminent events while keeping history accessible and organized.

**Independent Test**: With multiple items spanning past, today, and future, verify that items appear under the correct tab and are ordered per the rules.

**Acceptance Scenarios**:

1. Given items with dates in the past, today, and future, when viewing Upcoming, then it shows today and future items only, sorted by date ascending (nearest first).
2. Given items with dates in the past, today, and future, when viewing Past, then it shows past items only, sorted by date descending (most recent first).
3. Given two items on the same date, when displayed within a tab, then their relative order is creation time ascending (oldest→newest).

---

### Edge Cases

 - Date is today: Display the countdown pill as "Today"; background uses the item’s entry color with a slightly darker border for contrast.
- Time zone differences: Use the device’s current time zone for day calculations; day boundaries occur at local midnight and counts may adjust when traveling.
- Very large date ranges (years away or years past): display should remain legible; numeric value may grow large but must not overflow layout.
- SF Symbols availability: If a chosen symbol is unavailable on the minimum iOS target, use a compatible fallback symbol.
- Sorting tie-breakers: When multiple items share the same calendar date within a tab, order by creation time ascending (oldest→newest).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The main screen MUST display the title "Countdown" and subtitle "Track your special moments".
- **FR-002**: The main screen MUST show a list of dates of interest; each row MUST display: an icon, a title, a left-justified date, and a right-justified countdown pill.
- **FR-003**: Entries MUST support an entry color per item; icons may remain monochrome while UI elements (e.g., row or countdown label background) use the entry color.
- **FR-004**: For future dates, the countdown pill’s background color MUST visually match the associated entry color.
- **FR-005**: For past dates, the countdown pill’s background color MUST be gray.
- **FR-006**: The countdown pill MUST show the number of whole calendar days between “today” and the target date as a NUMBER ONLY; past dates MUST be prefixed with “-”. If the target date is today, the pill MUST display the string “Today” instead of a number.  
  - MUST use the user’s current locale calendar and device time zone; day boundaries occur at local midnight and counts may adjust when traveling.
  - If the target date is today, the pill MUST show "Today", the background color MUST match the entry color, and the pill MUST have a slightly darker border for contrast.
- **FR-007**: The date text MUST be formatted legibly according to the user’s locale and be left-aligned; the countdown pill MUST be right-aligned within the row.
- **FR-008**: When no dates are available, the screen MUST display a clear empty state message in place of the list.
- **FR-009**: Visual presentation SHOULD be consistent with the provided design reference while not requiring pixel-perfect matching; use SwiftUI material (e.g., `.ultraThinMaterial`) for list or row backgrounds to achieve the “liquid glass” style and ensure text contrast passes accessibility checks.
- **FR-010**: The interface MUST maintain sufficient contrast for readability of the countdown pill on both colored and gray backgrounds.
- **FR-011**: The app MUST persist dates of interest on-device (e.g., UserDefaults or Core Data) so entries survive app relaunches.
- **FR-012**: The app MUST support basic add and edit operations for dates of interest (no delete required for MVP).
- **FR-013**: Icons MUST use SF Symbols; each item stores an SF Symbol name and an entry color. The countdown label background MUST match the entry color for future dates (icons may remain monochrome).
- **FR-014**: The main list MUST be split into two tabs: Upcoming (includes Today and future) and Past (includes strictly past).
- **FR-015**: Upcoming MUST be ordered by calendar date ascending (nearest first). Past MUST be ordered by calendar date descending (most recent first).
- **FR-016**: For items with the same calendar date within a tab, the app MUST order by creation time ascending (oldest→newest).

*Clarifications resolved:*
- “Today”: show text "Today", use entry color background, add slightly darker border.
- Time zone: use device’s current time zone; day boundaries at local midnight.

### Key Entities *(include if feature involves data)*

- **Date of Interest**: Represents a user-relevant date. Attributes include: title (string), date (calendar date), iconSymbolName (SF Symbol identifier), entryColor (color identifier).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of rows display all four elements (icon, title, date left-aligned, countdown right-aligned) in usability tests.
- **SC-002**: In test scenarios with at least one past and one future date, countdown backgrounds follow the specified color rules with 100% accuracy.
- **SC-003**: In moderated tests, 90% of participants can correctly state the days remaining/past for a given item within 5 seconds of viewing.
- **SC-004**: Empty state is shown 100% of the time when no dates exist and is not shown when dates exist.
