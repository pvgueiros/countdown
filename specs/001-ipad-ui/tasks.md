# Tasks: iPad UI Adaptation

**Input**: Design documents from `/specs/001-ipad-ui/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Tests are MANDATORY per constitution. Maintain ≥80% coverage (unit + UI). Include XCTest for units and XCUITest for critical flows.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

This is an iOS/iPadOS app with WidgetKit extension:
- **Main app**: `Countdown/` (Domain, Data, Presentation, UI)
- **Widget extension**: `CountdownWidget/`
- **Unit tests**: `CountdownTests/`
- **UI tests**: `CountdownUITests/`

### iOS Testing Conventions

- Place unit tests under `CountdownTests/` and UI tests under `CountdownUITests/`.
- Use XCTest for unit tests (Domain, Use Cases, ViewModels) and XCUITest for navigation and primary flows.
- CI MUST fail if coverage < 80% or any test fails.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and validation

- [ ] T001 Verify Xcode 14+ with iOS 16+ SDK installed and iPad simulator configured
- [ ] T002 Review existing architecture (CLEAN + MVVM + Coordinator) in Countdown/ to understand patterns
- [ ] T003 [P] Configure SwiftLint rules for new iPad-specific files (if needed)
- [ ] T004 [P] Run existing test suite to establish baseline (all tests passing before changes)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T005 Add selection state properties to EventListViewModel in Countdown/Presentation/ViewModels/EventListViewModel.swift (@Published selectedEventId: UUID?)
- [ ] T006 Add selectEvent(id:) method to EventListViewModel in Countdown/Presentation/ViewModels/EventListViewModel.swift
- [ ] T007 [P] Add clearSelection() method to EventListViewModel in Countdown/Presentation/ViewModels/EventListViewModel.swift
- [ ] T008 [P] Add selectedEvent() query method to EventListViewModel in Countdown/Presentation/ViewModels/EventListViewModel.swift
- [ ] T009 Create EventListViewModelIPadTests.swift in CountdownTests/Presentation/ for selection state unit tests
- [ ] T010 [P] Write unit test for selectEvent with valid ID in EventListViewModelIPadTests.swift
- [ ] T011 [P] Write unit test for selectEvent with invalid ID in EventListViewModelIPadTests.swift
- [ ] T012 [P] Write unit test for clearSelection in EventListViewModelIPadTests.swift
- [ ] T013 [P] Write unit test for selectedEvent query in EventListViewModelIPadTests.swift
- [ ] T014 Run selection state unit tests and verify all pass (coverage ≥80% on new methods)

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Split View Navigation (Priority: P1) 🎯 MVP

**Goal**: Enable split-view layout on iPad with event list sidebar and detail pane for editing

**Independent Test**: Launch app on iPad Pro 12.9" simulator in landscape. Verify split view with sidebar (~350pt) on left and detail pane on right. Tap an event, verify edit form appears in detail pane without modal overlay.

### Tests for User Story 1

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [ ] T015 [P] [US1] Create IPadSplitViewTests.swift in CountdownUITests/ for split view UI tests
- [ ] T016 [P] [US1] Write UI test: app launches on iPad landscape shows split view layout in IPadSplitViewTests.swift
- [ ] T017 [P] [US1] Write UI test: tapping event in sidebar shows edit form in detail pane in IPadSplitViewTests.swift
- [ ] T018 [P] [US1] Write UI test: tapping add button shows add form in detail pane in IPadSplitViewTests.swift
- [ ] T019 [P] [US1] Write UI test: detail pane shows placeholder when no event selected in IPadSplitViewTests.swift
- [ ] T020 [P] [US1] Write UI test: iPhone/compact width uses modal sheets not split view in IPadSplitViewTests.swift
- [ ] T021 [US1] Run User Story 1 UI tests and verify all FAIL (no implementation yet)

### Implementation for User Story 1

- [ ] T022 [US1] Refactor EventListScreen to extract existing body into compactLayout property in Countdown/UI/Screens/EventListScreen.swift
- [ ] T023 [US1] Add @Environment(\.horizontalSizeClass) to EventListScreen in Countdown/UI/Screens/EventListScreen.swift
- [ ] T024 [US1] Add conditional body based on horizontalSizeClass (regular vs compact) in Countdown/UI/Screens/EventListScreen.swift
- [ ] T025 [US1] Implement splitViewLayout property with NavigationSplitView in Countdown/UI/Screens/EventListScreen.swift
- [ ] T026 [US1] Implement sidebarContent property with header and list in Countdown/UI/Screens/EventListScreen.swift
- [ ] T027 [US1] Implement detailContent property with selectedEvent conditional in Countdown/UI/Screens/EventListScreen.swift
- [ ] T028 [US1] Implement placeholderView for empty detail pane state in Countdown/UI/Screens/EventListScreen.swift
- [ ] T029 [US1] Update row tap handler to call viewModel.selectEvent(id:) when horizontalSizeClass is regular in Countdown/UI/Screens/EventListScreen.swift
- [ ] T030 [US1] Preserve existing modal sheet behavior for compact width in Countdown/UI/Screens/EventListScreen.swift
- [ ] T031 [US1] Update EventRowView to truncate long titles with lineLimit in Countdown/UI/Components/EventRowView.swift
- [ ] T032 [US1] Add accessibility identifiers for split view elements (sidebar, detail pane, placeholder) in EventListScreen
- [ ] T033 [US1] Run User Story 1 UI tests and verify all PASS
- [ ] T034 [US1] Manual test on iPad Pro 12.9" simulator: split view renders correctly
- [ ] T035 [US1] Manual test on iPad Pro 12.9" simulator: event selection updates detail pane
- [ ] T036 [US1] Manual test on iPhone simulator: modal sheets still work (regression test)
- [ ] T037 [US1] Verify unit test coverage for EventListViewModel selection state ≥80%

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - Expanded Widget Sizes (Priority: P2)

**Goal**: Add Medium (2 events), Large (4 events), and Extra Large (6 events) widget sizes for iPad

**Independent Test**: On iPad home screen, add widgets in all 4 sizes. Small shows 1 event (existing), Medium shows 2 events side-by-side, Large shows 4 events in 2x2 grid, Extra Large shows 6 events in 2x3 grid.

### Tests for User Story 2

- [ ] T038 [P] [US2] Create MultiEventWidgetTests.swift in CountdownTests/Widget/ for multi-event widget unit tests
- [ ] T039 [P] [US2] Write unit test for SimpleEntry with multiple events in MultiEventWidgetTests.swift
- [ ] T040 [P] [US2] Write unit test for EventSnapshot countdown calculation in MultiEventWidgetTests.swift
- [ ] T041 [P] [US2] Write unit test for eventCountForFamily returning correct counts in MultiEventWidgetTests.swift
- [ ] T042 [P] [US2] Write unit test for fetchTopEvents returning sorted events in MultiEventWidgetTests.swift
- [ ] T043 [P] [US2] Create IPadWidgetSizeTests.swift in CountdownUITests/ for widget size UI tests
- [ ] T044 [P] [US2] Write UI test: Medium widget displays 2 events side-by-side in IPadWidgetSizeTests.swift
- [ ] T045 [P] [US2] Write UI test: Large widget displays 4 events in 2x2 grid in IPadWidgetSizeTests.swift
- [ ] T046 [P] [US2] Write UI test: Extra Large widget displays 6 events in 2x3 grid in IPadWidgetSizeTests.swift
- [ ] T047 [P] [US2] Write UI test: widgets handle empty state gracefully in IPadWidgetSizeTests.swift
- [ ] T048 [US2] Run User Story 2 tests and verify all FAIL (no implementation yet)

### Implementation for User Story 2

- [ ] T049 [P] [US2] Define EventSnapshot struct in CountdownWidget/Views/CountdownWidget.swift
- [ ] T050 [US2] Refactor SimpleEntry to use events array instead of single event in CountdownWidget/Views/CountdownWidget.swift
- [ ] T051 [US2] Add primaryEvent computed property to SimpleEntry for backward compatibility in CountdownWidget/Views/CountdownWidget.swift
- [ ] T052 [US2] Add eventCountForFamily method to Provider in CountdownWidget/Views/CountdownWidget.swift
- [ ] T053 [US2] Implement fetchTopEvents async method in Provider in CountdownWidget/Views/CountdownWidget.swift
- [ ] T054 [US2] Update timeline method to fetch multiple events based on widget family in CountdownWidget/Views/CountdownWidget.swift
- [ ] T055 [US2] Create SmallWidgetView.swift in CountdownWidget/Views/ by extracting existing widget layout
- [ ] T056 [US2] Update SmallWidgetView to use EventSnapshot instead of SimpleEntry properties in CountdownWidget/Views/SmallWidgetView.swift
- [ ] T057 [P] [US2] Create MediumWidgetView.swift in CountdownWidget/Views/ with 2-event horizontal layout
- [ ] T058 [P] [US2] Implement eventCard view for Medium widget in CountdownWidget/Views/MediumWidgetView.swift
- [ ] T059 [P] [US2] Implement emptySlot view for Medium widget in CountdownWidget/Views/MediumWidgetView.swift
- [ ] T060 [P] [US2] Create LargeWidgetView.swift in CountdownWidget/Views/ with 2x2 grid layout
- [ ] T061 [P] [US2] Implement grid structure with 4 event cards in CountdownWidget/Views/LargeWidgetView.swift
- [ ] T062 [P] [US2] Create ExtraLargeWidgetView.swift in CountdownWidget/Views/ with 2x3 grid layout
- [ ] T063 [P] [US2] Implement grid structure with 6 event cards in CountdownWidget/Views/ExtraLargeWidgetView.swift
- [ ] T064 [US2] Update CountdownWidgetEntryView to switch on widgetFamily environment in CountdownWidget/Views/CountdownWidgetEntryView.swift
- [ ] T065 [US2] Route systemSmall to SmallWidgetView in CountdownWidgetEntryView in CountdownWidget/Views/CountdownWidgetEntryView.swift
- [ ] T066 [US2] Route systemMedium to MediumWidgetView in CountdownWidgetEntryView in CountdownWidget/Views/CountdownWidgetEntryView.swift
- [ ] T067 [US2] Route systemLarge to LargeWidgetView in CountdownWidgetEntryView in CountdownWidget/Views/CountdownWidgetEntryView.swift
- [ ] T068 [US2] Route systemExtraLarge to ExtraLargeWidgetView in CountdownWidgetEntryView in CountdownWidget/Views/CountdownWidgetEntryView.swift
- [ ] T069 [US2] Update supportedFamilies to include systemMedium, systemLarge, systemExtraLarge in CountdownWidget/Views/CountdownWidget.swift
- [ ] T070 [US2] Update containerBackground method to handle multi-event entries in CountdownWidget/Views/CountdownWidget.swift
- [ ] T071 [US2] Run User Story 2 unit tests and verify all PASS
- [ ] T072 [US2] Manual test: Add Medium widget on iPad, verify 2 events display correctly
- [ ] T073 [US2] Manual test: Add Large widget on iPad, verify 4 events in grid
- [ ] T074 [US2] Manual test: Add Extra Large widget on iPad, verify 6 events in grid
- [ ] T075 [US2] Manual test: Verify Small widget still works (regression test)
- [ ] T076 [US2] Verify unit test coverage for widget components ≥80%

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - Adaptive Layout for Multitasking (Priority: P3)

**Goal**: Ensure app adapts gracefully between split view and modal presentation during iPad multitasking (Split View, Slide Over)

**Independent Test**: Launch app full screen on iPad (split view visible), activate Split View 50/50 with another app, verify app switches to modal sheets. Return to full screen, verify split view restored with state preserved.

### Tests for User Story 3

- [ ] T077 [P] [US3] Create IPadMultitaskingTests.swift in CountdownUITests/ for multitasking UI tests
- [ ] T078 [P] [US3] Write UI test: app adapts from split view to modal when entering narrow Split View in IPadMultitaskingTests.swift
- [ ] T079 [P] [US3] Write UI test: app restores split view when returning to full screen in IPadMultitaskingTests.swift
- [ ] T080 [P] [US3] Write UI test: selection state preserved during layout transition in IPadMultitaskingTests.swift
- [ ] T081 [P] [US3] Write UI test: form data preserved during layout transition in IPadMultitaskingTests.swift
- [ ] T082 [P] [US3] Write UI test: Slide Over mode uses modal sheets in IPadMultitaskingTests.swift
- [ ] T083 [P] [US3] Create IPadRotationTests.swift in CountdownUITests/ for rotation tests
- [ ] T084 [P] [US3] Write UI test: portrait to landscape rotation preserves form data in IPadRotationTests.swift
- [ ] T085 [P] [US3] Write UI test: landscape to portrait rotation adapts layout correctly in IPadRotationTests.swift
- [ ] T086 [US3] Run User Story 3 tests and verify all FAIL (or PASS if already working from US1)

### Implementation for User Story 3

- [ ] T087 [US3] Verify EventListScreen size class detection handles all multitasking scenarios in Countdown/UI/Screens/EventListScreen.swift
- [ ] T088 [US3] Test split view layout transition animation smoothness in EventListScreen
- [ ] T089 [US3] Verify selectedEventId persists across layout mode changes (already in ViewModel)
- [ ] T090 [US3] Test keyboard avoidance in split view detail pane with AddEditEventSheet
- [ ] T091 [US3] Manual test: Full screen → Split View 50/50 → Verify modal sheets appear
- [ ] T092 [US3] Manual test: Split View 50/50 → Full screen → Verify split view restored
- [ ] T093 [US3] Manual test: Slide Over mode → Verify modal sheets work
- [ ] T094 [US3] Manual test: Rotate iPad while editing event → Verify form data preserved
- [ ] T095 [US3] Manual test: Test all Split View percentages (50/50, 67/33, 75/25) for layout breakpoints
- [ ] T096 [US3] Run User Story 3 UI tests and verify all PASS
- [ ] T097 [US3] Verify accessibility labels work in all layout modes (VoiceOver test)

**Checkpoint**: All user stories should now be independently functional

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] T098 [P] Add documentation comments to new public methods in EventListViewModel
- [ ] T099 [P] Add documentation comments to new widget view components
- [ ] T100 [P] Review SwiftLint output for all new files and fix any violations
- [ ] T101 [P] Run SwiftFormat on all modified files
- [ ] T102 Verify zero compiler warnings across entire project
- [ ] T103 Run full unit test suite (CountdownTests) and verify ≥80% coverage overall
- [ ] T104 Run full UI test suite (CountdownUITests) and verify all tests pass
- [ ] T105 [P] Validate quickstart.md steps match actual implementation
- [ ] T106 [P] Update README.md with iPad feature notes (if project has README)
- [ ] T107 Test on physical iPad device (if available) for real-world validation
- [ ] T108 Performance test: Measure widget refresh time with Instruments (target <200ms)
- [ ] T109 Performance test: Measure split view transition animation (target 60fps)
- [ ] T110 Accessibility audit: Test with VoiceOver on iPad
- [ ] T111 Accessibility audit: Test with Dynamic Type (largest sizes)
- [ ] T112 Final regression test: Verify all iPhone functionality still works
- [ ] T113 Final validation: Review all functional requirements (FR-001 through FR-014) are met
- [ ] T114 Final validation: Review all success criteria (SC-001 through SC-005) are achieved
- [ ] T115 Code review preparation: Create PR with link to spec and plan documents

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3, 4, 5)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Phase 6)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - Independent of US1 (different files)
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - May leverage US1 split view but validates existing behavior

### Within Each User Story

- Tests MUST be written and FAIL before implementation
- Unit tests (XCTest) run in parallel within each story
- UI tests (XCUITest) run in parallel within each story
- Implementation tasks may have dependencies (ViewModel before View updates)
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel (T003, T004)
- Foundational selection state methods marked [P] can run in parallel (T007, T008)
- Foundational unit tests marked [P] can run in parallel (T010-T013)
- US1 UI tests marked [P] can run in parallel (T016-T020)
- US2 unit tests marked [P] can run in parallel (T039-T042)
- US2 UI tests marked [P] can run in parallel (T044-T047)
- US2 widget view creation marked [P] can run in parallel (T057-T063)
- US3 tests marked [P] can run in parallel (T078-T085)
- Polish documentation tasks marked [P] can run in parallel (T098-T101, T105-T106)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)

---

## Parallel Example: User Story 1

```bash
# After Foundational phase complete, launch all US1 tests together:
Task T016: "Write UI test: app launches on iPad landscape shows split view layout"
Task T017: "Write UI test: tapping event in sidebar shows edit form in detail pane"
Task T018: "Write UI test: tapping add button shows add form in detail pane"
Task T019: "Write UI test: detail pane shows placeholder when no event selected"
Task T020: "Write UI test: iPhone/compact width uses modal sheets not split view"

# After tests written and verified to FAIL, begin implementation:
Task T022: "Refactor EventListScreen to extract existing body into compactLayout"
# ... sequential implementation tasks ...
```

---

## Parallel Example: User Story 2

```bash
# Launch all US2 widget views together (different files):
Task T057: "Create MediumWidgetView.swift with 2-event horizontal layout"
Task T060: "Create LargeWidgetView.swift with 2x2 grid layout"
Task T062: "Create ExtraLargeWidgetView.swift with 2x3 grid layout"

# These can be worked on simultaneously as they're independent files
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (T001-T004)
2. Complete Phase 2: Foundational (T005-T014) - CRITICAL, blocks all stories
3. Complete Phase 3: User Story 1 (T015-T037)
4. **STOP and VALIDATE**: Test User Story 1 independently on iPad
5. Deploy/demo split view navigation if ready

**Estimated Time**: ~6-8 hours (Setup: 1h, Foundational: 1-2h, US1: 4-6h)

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP: iPad split view!)
3. Add User Story 2 → Test independently → Deploy/Demo (Enhanced: Widget sizes!)
4. Add User Story 3 → Test independently → Deploy/Demo (Polished: Multitasking!)
5. Each story adds value without breaking previous stories

**Estimated Total Time**: 12-17 hours
- Setup: 1 hour
- Foundational: 1-2 hours
- User Story 1: 4-6 hours
- User Story 2: 6-8 hours
- User Story 3: 2-3 hours
- Polish: 2-3 hours

### Parallel Team Strategy

With multiple developers:

1. **Team completes Setup + Foundational together** (2-3 hours)
2. **Once Foundational is done**:
   - **Developer A**: User Story 1 (Split view navigation)
   - **Developer B**: User Story 2 (Widget sizes) - completely independent
   - **Developer C**: Polish tasks or User Story 3
3. Stories complete and integrate independently
4. Merge in priority order: US1 → US2 → US3

**Time Savings**: With 2 developers, could complete in ~8-10 hours instead of 12-17 hours

---

## Task Summary

**Total Tasks**: 115
- **Phase 1 (Setup)**: 4 tasks
- **Phase 2 (Foundational)**: 10 tasks (includes selection state + tests)
- **Phase 3 (User Story 1 - P1)**: 23 tasks (7 tests + 16 implementation)
- **Phase 4 (User Story 2 - P2)**: 39 tasks (11 tests + 28 implementation)
- **Phase 5 (User Story 3 - P3)**: 21 tasks (10 tests + 11 implementation/validation)
- **Phase 6 (Polish)**: 18 tasks (cross-cutting improvements)

**Parallel Opportunities Identified**: 34 tasks marked [P] can run in parallel within their phases

**Independent Test Criteria**:
- **US1**: Launch iPad in landscape → split view visible → tap event → detail pane updates
- **US2**: Add widgets in all 4 sizes → correct event count per size
- **US3**: Enter/exit Split View → layout adapts → state preserved

**Suggested MVP Scope**: Phase 1 + Phase 2 + Phase 3 (User Story 1 only) = 37 tasks, ~6-8 hours

**Test Coverage Target**: ≥80% (per constitution)
- Unit tests: EventListViewModel selection state, widget entry logic
- UI tests: Split view navigation, widget sizes, multitasking scenarios

---

## Notes

- [P] tasks = different files, no dependencies within phase
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Write tests first, verify they FAIL before implementing
- Commit after each logical group of tasks
- Stop at any checkpoint to validate story independently
- All tasks include specific file paths for clarity
- Constitutional requirements: SOLID compliance, CLEAN architecture, ≥80% coverage, zero warnings

