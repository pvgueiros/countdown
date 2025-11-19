# Checklist: Requirements Quality - “Unit Tests for English”

Purpose: Validate the clarity, completeness, consistency, measurability, and coverage of the Countdown List requirements.  
Created: 2025-11-19  
Docs: [Spec](`specs/001-countdown-list/spec.md`), [Plan](`specs/001-countdown-list/plan.md`), [Tasks](`specs/001-countdown-list/tasks.md`)

## Requirement Completeness
- [ ] CHK001 Are title/subtitle requirements explicitly listed for the main screen? [Completeness, Spec §FR-001]
- [ ] CHK002 Are all row elements (icon, title, date-left, countdown-right) enumerated? [Completeness, Spec §FR-002]
- [ ] CHK003 Are sorting rules for both tabs (asc/desc) documented including tie-breaker? [Completeness, Spec §FR-014–FR-016]
- [ ] CHK004 Are empty-state requirements present with conditions for when to show/hide? [Completeness, Spec §FR-008]
- [ ] CHK005 Are manage actions (add, edit, delete + confirm) fully specified? [Completeness, Spec §FR-012, §FR-017]
- [ ] CHK006 Are persistence requirements (on-device, survives relaunch) documented? [Completeness, Spec §FR-011]

## Requirement Clarity
- [ ] CHK007 Is “Today” behavior precisely defined (text, background, border)? [Clarity, Spec §FR-006 note, §FR-010]
- [ ] CHK008 Is the time-zone/day-boundary rule clearly stated (local midnight, device TZ)? [Clarity, Spec §FR-006]
- [ ] CHK009 Is “liquid glass” visual intent bounded to materials without pixel-perfect demand? [Clarity, Spec §FR-009]
- [ ] CHK010 Are color rules unambiguous for future/today vs past backgrounds? [Clarity, Spec §FR-004–FR-005]
- [ ] CHK011 Are tab names and membership rules (Upcoming includes Today) clearly stated? [Clarity, Spec §FR-014]

## Requirement Consistency
- [ ] CHK012 Do acceptance scenarios align with functional rules (e.g., today in Upcoming)? [Consistency, Spec §US2, §FR-014]
- [ ] CHK013 Do sorting requirements match user stories and success criteria? [Consistency, Spec §US5, §FR-015–FR-016]
- [ ] CHK014 Do color/contrast requirements align with accessibility notes? [Consistency, Spec §FR-009–FR-010]

## Acceptance Criteria Quality (Measurability)
- [ ] CHK015 Are success criteria quantified with measurable thresholds (e.g., 90% within 5s)? [Acceptance Criteria, Spec §SC-003]
- [ ] CHK016 Are verification conditions for empty state and color rules objectively testable? [Acceptance Criteria, Spec §SC-002, §SC-004]
- [ ] CHK017 Are alignment requirements testable (left/right justification) without subjective wording? [Measurability, Spec §FR-002, §FR-007]

## Scenario Coverage
- [ ] CHK018 Are primary flows (view list, understand countdown) covered by stories with independent tests? [Coverage, Spec §US1–US2]
- [ ] CHK019 Are management flows (add, edit, delete with confirm) fully represented? [Coverage, Spec §US4]
- [ ] CHK020 Are browsing flows between Upcoming and Past defined with examples? [Coverage, Spec §US5]

## Edge Case Coverage
- [ ] CHK021 Is “today” case specified including border/contrast detail? [Edge Case, Spec §Edge, §FR-006]
- [ ] CHK022 Are very large day counts addressed for legibility/layout bounds? [Edge Case, Spec §Edge]
- [ ] CHK023 Is SF Symbols availability fallback defined? [Edge Case, Spec §Edge]
- [ ] CHK024 Are sorting tie-breakers for same-day items covered? [Edge Case, Spec §Edge, §FR-016]

## Non-Functional Requirements
- [ ] CHK025 Are accessibility requirements (contrast, Dynamic Type) explicitly stated? [NFR, Spec §FR-009–FR-010]
- [ ] CHK026 Is localization scope documented (languages, key phrases)? [NFR, Gap]
- [ ] CHK027 Are performance expectations for list scrolling defined? [NFR, Gap]

## Dependencies & Assumptions
- [ ] CHK028 Are storage technology choices and upgrade paths (UserDefaults→SwiftData) documented as assumptions? [Assumption, Plan]
- [ ] CHK029 Are device locale/timezone dependencies acknowledged with implications? [Dependency, Spec §FR-006]

## Ambiguities & Conflicts
- [ ] CHK030 Is “matches entry color” defined to include tint/opacity/border rules? [Ambiguity, Spec §FR-004, §FR-006]
- [ ] CHK031 Is the visual glass effect defined enough to avoid subjective review conflicts? [Ambiguity, Spec §FR-009]

## Traceability
- [ ] CHK032 Do requirements (FR/US/SC) have stable IDs used consistently across docs? [Traceability, Spec §FR-xxx, §USx, §SC-xxx]
- [ ] CHK033 Is there an acceptance-criteria ID scheme for linking tests to requirements? [Traceability, Gap]


