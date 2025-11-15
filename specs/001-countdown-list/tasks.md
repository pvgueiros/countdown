# Tasks: Countdown List

**Input**: Design documents from `/specs/001-countdown-list/`  
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Tests are MANDATORY per constitution. Maintain ≥80% coverage (unit + UI). Include XCTest for units and XCUITest for critical flows.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 Create CLEAN/MVVM+Coordinator directories in `Countdown/{Domain,UseCases,Data/{Sources,Mappers},Presentation/{ViewModels,Coordinators},UI/{Components,Screens}}/`
- [x] T002 Add SwiftLint config in `.swiftlint.yml` at repo root
- [x] T003 Add SwiftFormat config in `.swiftformat` at repo root
- [x] T004 Enable “Treat warnings as errors” in `Countdown.xcodeproj/project.pbxproj` (Debug + Release)
- [x] T005 Enable code coverage collection in scheme `Countdown` by editing `Countdown.xcodeproj/xcshareddata/xcschemes/Countdown.xcscheme`
- [x] T006 [P] Add logging utility using OSLog in `Countdown/Presentation/Logging/Log.swift`
- [x] T047 Add GitHub Actions workflow to build and test with coverage in `.github/workflows/ios-ci.yml` (xcodebuild with code coverage enabled)
- [x] T048 [P] Add CI script `scripts/ci/build-and-test.sh` to run `xcodebuild` with warnings-as-errors and produce an `.xcresult` with coverage
- [x] T049 Parse coverage from `.xcresult` and fail CI if coverage < 80% in `scripts/ci/check-coverage.sh`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T007 Create entity `DateOfInterest` in `Countdown/Domain/Entities/DateOfInterest.swift` (id, title, date, iconSymbolName, entryColorHex, createdAt)
- [x] T008 Create repository protocol in `Countdown/Domain/Repositories/DateOfInterestRepository.swift` (CRUD: list/add/update)
- [x] T009 Implement UserDefaults repository `UserDefaultsDateOfInterestRepository` in `Countdown/Data/Sources/UserDefaultsDateOfInterestRepository.swift` (JSON encode/decode under key `datesOfInterest`)
- [x] T010 [P] Create mapper helpers in `Countdown/Data/Mappers/DateOfInterestMapper.swift` (entity <-> DTO)
- [x] T011 Create use case `GetDatesPartitionedUseCase` in `Countdown/UseCases/GetDatesPartitionedUseCase.swift` (upcoming/past, sorting + tie-breaker)
- [x] T012 Create use case `AddDateOfInterestUseCase` in `Countdown/UseCases/AddDateOfInterestUseCase.swift`
- [x] T013 Create use case `UpdateDateOfInterestUseCase` in `Countdown/UseCases/UpdateDateOfInterestUseCase.swift`
- [x] T014 [P] Create `CountdownFormatter` in `Countdown/Presentation/Formatters/CountdownFormatter.swift` ("X days left"/"X days ago"/"Today", device time zone)
- [x] T015 [P] Create `DateFormatterProvider` in `Countdown/Presentation/Formatters/DateFormatterProvider.swift` (localized date)
- [x] T016 Create Coordinator base + AppCoordinator in `Countdown/Presentation/Coordinators/AppCoordinator.swift`
- [x] T017 [P] Add color utility `EntryColor+Hex.swift` in `Countdown/Presentation/Colors/EntryColor+Hex.swift` (parse `entryColorHex` to Color; gray fallback)

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - View countdown list (Priority: P1) 🎯 MVP

**Goal**: Show list with title/subtitle and rows (icon, title, date left, countdown right)

**Independent Test**: Launch with predefined list; list renders with correct alignment and content per row.

### Tests for User Story 1

- [x] T018 [P] [US1] Unit test mapping model→row VM in `CountdownTests/Presentation/DateListViewModelTests.swift`
- [x] T019 [P] [US1] UI test for list rendering in `CountdownUITests/CountdownListRenderingTests.swift`

### Implementation for User Story 1

- [x] T020 [US1] Create `DateListViewModel` in `Countdown/Presentation/ViewModels/DateListViewModel.swift` (observable state, rows)
- [x] T021 [P] [US1] Create `CountdownRowView` in `Countdown/UI/Components/CountdownRowView.swift` (layouts, alignment)
- [x] T022 [US1] Create `CountdownListScreen` in `Countdown/UI/Screens/CountdownListScreen.swift` (title/subtitle + list)
- [x] T023 [US1] Wire AppCoordinator to initial screen in `Countdown/Presentation/Coordinators/AppCoordinator.swift`

**Checkpoint**: US1 independently testable

---

## Phase 4: User Story 2 - Understand time remaining (Priority: P1)

**Goal**: Correct countdown phrasing and background per entry color

**Independent Test**: With future and past dates, verify labels show “X days left” / “X days ago”; backgrounds match entry color for future, gray for past.

### Tests for User Story 2

- [ ] T024 [P] [US2] Unit test `CountdownFormatter` edges (past/future/today) in `CountdownTests/Presentation/CountdownFormatterTests.swift`
- [ ] T025 [P] [US2] Unit test color/background mapping in `CountdownTests/Presentation/RowStylingTests.swift`

### Implementation for User Story 2

- [ ] T026 [US2] Integrate `CountdownFormatter` into `DateListViewModel` in `Countdown/Presentation/ViewModels/DateListViewModel.swift`
- [ ] T027 [US2] Apply entry color logic in `CountdownRowView` in `Countdown/UI/Components/CountdownRowView.swift`

**Checkpoint**: US1 + US2 independently testable

---

## Phase 5: User Story 5 - Browse Upcoming and Past tabs (Priority: P1)

**Goal**: Two tabs: Upcoming (today+future asc) and Past (past desc); tie-breaker by creation time (oldest→newest)

**Independent Test**: With mixed items, verify partitioning and sort order in each tab.

### Tests for User Story 5

- [ ] T028 [P] [US5] Unit test partition/sort logic (including same-date tie-breaker by `createdAt`) in `CountdownTests/UseCases/GetDatesPartitionedUseCaseTests.swift`
- [ ] T029 [P] [US5] UI test tabs behavior in `CountdownUITests/TabsOrderingTests.swift`

### Implementation for User Story 5

- [ ] T030 [US5] Add two tabs (using `SegmentedControl`) to `CountdownListScreen` in `Countdown/UI/Screens/CountdownListScreen.swift`
- [ ] T031 [US5] Expose partitioned sections from `DateListViewModel` in `Countdown/Presentation/ViewModels/DateListViewModel.swift`

**Checkpoint**: P1 scope complete and demoable

---

## Phase 6: User Story 3 - Empty state communication (Priority: P2)

**Goal**: Friendly empty state when no items exist

**Independent Test**: Launch with empty dataset; see empty state message; title/subtitle still appear.

### Tests for User Story 3

- [ ] T032 [P] [US3] UI test empty state in `CountdownUITests/EmptyStateTests.swift`

### Implementation for User Story 3

- [ ] T033 [US3] Add empty state view to `CountdownListScreen` in `Countdown/UI/Screens/CountdownListScreen.swift`

**Checkpoint**: US3 independently testable

---

## Phase 7: User Story 4 - Manage dates (Priority: P2)

**Goal**: Add and edit entries; persist across relaunch

**Independent Test**: Add then relaunch; entry persists. Edit then relaunch; changes persist.

### Tests for User Story 4

- [ ] T034 [P] [US4] Unit test Add/Update use cases in `CountdownTests/UseCases/AddUpdateUseCasesTests.swift`
- [ ] T035 [P] [US4] UI test add/edit flow in `CountdownUITests/AddEditFlowTests.swift`

### Implementation for User Story 4

- [ ] T036 [US4] Add `AddEditDateViewModel` in `Countdown/Presentation/ViewModels/AddEditDateViewModel.swift`
- [ ] T037 [P] [US4] Add `AddEditDateSheet` in `Countdown/UI/Screens/AddEditDateSheet.swift` (fields: title, date, iconSymbolName, entryColor)
- [ ] T038 [US4] Wire add/edit actions in `DateListViewModel` and `AppCoordinator` (`Countdown/Presentation/ViewModels/DateListViewModel.swift`, `Countdown/Presentation/Coordinators/AppCoordinator.swift`)
- [ ] T039 [US4] Persist via repository; set `createdAt` when adding; update fields when editing in `Countdown/Data/Sources/UserDefaultsDateOfInterestRepository.swift`

**Checkpoint**: US4 independently testable

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] T040 Apply “liquid glass” style in `Countdown/UI/Components/GlassBackground.swift` and integrate in `Countdown/UI/Screens/CountdownListScreen.swift`
- [ ] T041 Accessibility: ensure contrast for entry-colored labels; Dynamic Type support in all views
- [ ] T042 Localization: add `Localizable.strings` and use format strings for “%d days left”, “%d days ago”, “Today”, title/subtitle
- [ ] T043 [P] Add additional unit tests in `CountdownTests/` to raise coverage ≥80%
- [ ] T044 [P] Add additional UI tests in `CountdownUITests/` for primary flows
- [ ] T045 Performance: verify smooth scrolling in list with 100 items
- [ ] T046 Validate quickstart.md steps and update if needed in `specs/001-countdown-list/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - P1 stories (US1, US2, US5) first → then P2 (US3, US4)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2); no dependencies on other stories
- **User Story 2 (P1)**: Depends on `CountdownFormatter` and row styling from US1
- **User Story 5 (P1)**: Depends on repository + partition/sort use case
- **User Story 3 (P2)**: Depends on list rendering from US1
- **User Story 4 (P2)**: Depends on repository and add/update use cases

### Within Each User Story

- Tests MUST be written and FAIL before implementation
- Models before use cases
- Use cases before view models
- View models before views
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational completes, P1 stories (US1, US2, US5) can be staffed in parallel
- Within a story, unit tests marked [P] can run in parallel
- Separate views and view models marked [P] can proceed in parallel

---

## Implementation Strategy

### MVP First (P1 scope)

1. Complete Phase 1: Setup  
2. Complete Phase 2: Foundational  
3. Deliver US1 → US2 → US5 (independently testable)  
4. STOP and VALIDATE: Ensure coverage ≥80%, 0 warnings, UI matches spec intent

### Incremental Delivery

1. Add US3 (empty state) → validate independently  
2. Add US4 (add/edit) → validate independently  
3. Polish cross-cutting tasks (accessibility, localization, performance)


