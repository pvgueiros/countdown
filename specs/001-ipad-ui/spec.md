# Feature Specification: iPad UI Adaptation

**Feature Branch**: `001-ipad-ui`  
**Created**: 2025-11-25  
**Status**: Draft  
**Input**: User description: "Adapt the UI for ipad."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Split view navigation (Priority: P1)

As an iPad user, when I open the app in landscape orientation or on a larger iPad screen, I see a two-column layout with the event list on the left side and the add/edit form on the right side, allowing me to browse and edit events simultaneously without modal sheets covering the entire screen.

**Why this priority**: This is the fundamental iPad experience that leverages the larger screen real estate and provides the most immediate value differentiating the iPad experience from iPhone.

**Independent Test**: Launch the app on iPad simulator in landscape orientation with existing events. Verify that the screen shows a sidebar with the event list on the left (approximately 1/3 width) and a detail pane on the right. Tap an event and verify the edit form appears in the right pane without covering the list.

**Acceptance Scenarios**:

1. **Given** the app launches on iPad in landscape orientation, **When** the main screen loads with at least one event, **Then** the screen displays a split view with the event list on the left and a detail/edit area on the right.
2. **Given** the split view is displayed, **When** I tap an event in the list, **Then** the edit form appears in the right pane without covering the list, and I can still see and select other events.
3. **Given** the split view is displayed with an event selected, **When** I tap the add button, **Then** the add form appears in the right pane, replacing any previous content.
4. **Given** the app is in portrait orientation on iPad, **When** the screen width is sufficient (iPad 10.2" or larger in portrait), **Then** the split view remains visible; otherwise, it falls back to a modal sheet presentation similar to iPhone.

---

### User Story 2 - Expanded widget sizes (Priority: P2)

As an iPad user, I can add medium, large, and extra-large countdown widgets to my home screen, allowing me to see multiple events at once or view a single event with more detail and visual prominence on the larger iPad display.

**Why this priority**: Widgets are a key feature of the iOS experience, and iPad's larger screen enables showing more information at once. This extends the app's value beyond just opening the app.

**Independent Test**: On iPad, enter widget edit mode and add countdown widgets in small, medium, large, and extra-large sizes. Verify each size displays appropriate content: small shows one event (existing behavior), medium shows up to 2 events in a row, large shows up to 4 events in a 2x2 grid, and extra-large shows up to 6 events in a 2x3 grid.

**Acceptance Scenarios**:

1. **Given** I'm adding a widget on iPad home screen, **When** I select the Countdown widget, **Then** I see size options including Small, Medium, Large, and Extra Large.
2. **Given** a Medium widget is placed and configured to show specific events, **When** the widget loads, **Then** it displays up to 2 events side by side with icon, title, date, and countdown for each.
3. **Given** a Large widget is placed and configured, **When** the widget loads, **Then** it displays up to 4 events in a 2x2 grid layout with clear visual separation between events.
4. **Given** an Extra Large widget is placed and configured, **When** the widget loads, **Then** it displays up to 6 events in a 2x3 grid layout.
5. **Given** any multi-event widget has fewer events than its maximum capacity, **When** the widget loads, **Then** remaining spaces show an "Add Event" prompt or remain empty with appropriate messaging.

---

### User Story 3 - Adaptive layout for multitasking (Priority: P3)

As an iPad user working in Split View or Slide Over mode, the app adapts its layout gracefully to narrower widths, automatically switching from split view to full-screen modal sheets when the app window becomes too narrow, ensuring usability regardless of multitasking configuration.

**Why this priority**: iPad users frequently use Split View and Slide Over for multitasking. The app must remain functional and not feel broken when space is constrained.

**Independent Test**: Launch the app on iPad in full screen, then activate Split View with another app taking 50% or more of the screen. Verify the countdown app switches to a modal sheet presentation. Expand the app back to full screen and verify it returns to split view mode.

**Acceptance Scenarios**:

1. **Given** the app is running in Split View with narrow width (1/3 or 1/2 screen), **When** I tap an event, **Then** the edit form appears as a modal sheet overlaying the list, similar to iPhone behavior.
2. **Given** the app is running in Split View and I expand it to full screen, **When** the layout has sufficient width, **Then** the app automatically switches to split view layout with list on left and detail on right.
3. **Given** the app is running in Slide Over mode (compact width), **When** I interact with the app, **Then** all interactions use modal sheet presentations and the UI remains fully functional despite limited space.
4. **Given** the app switches between layout modes due to multitasking changes, **When** the transition occurs, **Then** the layout change is animated smoothly and my current context (selected event, form data) is preserved.

---

### Edge Cases

- **Rotation during editing**: If user rotates iPad from portrait to landscape (or vice versa) while editing an event, the form content and current input must be preserved, and the layout must adapt smoothly without data loss.
- **Very long event titles on split view**: In split view with list on left, very long event titles must truncate with ellipsis rather than wrapping multiple lines or breaking the layout.
- **Keyboard dismissal in split view**: When editing in the split view's right pane, the keyboard should not cover the form fields. If it does, the form should scroll to keep the focused field visible.
- **Widget configuration with no events**: When configuring a medium/large/extra-large widget but no events exist in the app, the widget configuration interface should clearly indicate that events must be created first.
- **Multitasking split percentages**: Test common Split View configurations (50/50, 67/33, 75/25) to ensure layout breakpoint is appropriate for each.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: On iPad in landscape orientation with regular width size class, the app MUST display a split view layout with the event list in a sidebar (left side, approximately 320-400pt wide) and a detail/edit pane on the right side.
- **FR-002**: When an event is selected in split view mode, the edit form MUST appear in the right pane without presenting a modal sheet that covers the list.
- **FR-003**: When the add button is tapped in split view mode, the add form MUST appear in the right pane without presenting a modal sheet.
- **FR-004**: The app MUST automatically adapt between split view mode and modal sheet mode based on available width using SwiftUI's size classes or horizontal size class detection.
- **FR-005**: In compact width scenarios (iPad in Slide Over, narrow Split View, or portrait on smaller iPads), the app MUST fall back to modal sheet presentation for add/edit operations, matching iPhone behavior.
- **FR-006**: The countdown widget MUST support Medium, Large, and Extra Large sizes on iPad in addition to the existing Small size.
- **FR-007**: Medium widgets MUST display up to 2 events side by side with icon, title, date, and countdown for each event.
- **FR-008**: Large widgets MUST display up to 4 events in a 2x2 grid layout with consistent spacing and alignment.
- **FR-009**: Extra Large widgets MUST display up to 6 events in a 2x3 grid layout with consistent spacing and alignment.
- **FR-010**: Multi-event widgets MUST handle cases where fewer events exist than the widget capacity, showing appropriate empty state messaging or "Add Event" prompts for unused spaces.
- **FR-011**: When the app window size changes due to multitasking (Split View, Slide Over) or rotation, the app MUST adapt its layout mode smoothly with animation and preserve the user's current context (selected event, form data, scroll position).
- **FR-012**: In split view mode, very long event titles in the list MUST truncate with ellipsis to maintain layout integrity.
- **FR-013**: When the keyboard appears in split view mode, focused text fields MUST remain visible either by scrolling the form or by the system's automatic keyboard avoidance.
- **FR-014**: All existing iPhone functionality (tabs, swipe to delete, color selection, icon selection, date picking) MUST continue to work on iPad in all layout modes.

### Key Entities *(include if feature involves data)*

No new entities are introduced. This feature enhances the presentation layer for existing Event entities on iPad devices.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: On iPad Pro 12.9" in landscape orientation, the split view displays with list width between 320-400pt and the detail pane fills remaining space, verified in 100% of test launches.
- **SC-002**: Users can edit an event in split view mode while simultaneously viewing and selecting other events in the list, verified in usability testing with 90% task completion rate without confusion.
- **SC-003**: Medium, Large, and Extra Large widgets display the correct number of events (2, 4, 6 respectively) in 100% of configurations when sufficient events exist.
- **SC-004**: The app successfully adapts between split view and modal sheet modes when transitioning between full screen and Split View (50/50) in 100% of test cases, preserving user context without data loss.
- **SC-005**: App maintains functionality and visual polish in all common Split View configurations (50/50, 67/33, 75/25) with no layout breakage in any configuration.

## Assumptions

- Users have iPadOS 16.0 or later (supports modern SwiftUI navigation patterns and widget families)
- The existing app architecture uses SwiftUI throughout, making adaptive layouts straightforward
- Small widget functionality already exists and works correctly; this feature extends it to larger sizes
- The app already uses UserDefaults in an App Group, allowing widgets to access event data
- Split view uses NavigationSplitView or similar SwiftUI component supporting three-column adaptive layouts (simplified to two-column: list + detail)
- Layout breakpoint for split vs modal is based on horizontal size class: regular = split view, compact = modal sheets
