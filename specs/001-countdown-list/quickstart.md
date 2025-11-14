# Quickstart: Countdown List

## Prerequisites
- Xcode 15+ (Swift 5.9+)
- iOS 17+ Simulator or device

## Build & Run
1. Open `Countdown.xcodeproj` in Xcode.
2. Select the `Countdown` scheme, iOS 17+ simulator.
3. Build (Cmd+B). Ensure 0 warnings (treat as errors in CI).
4. Run (Cmd+R).

## Tests & Coverage
1. Run unit tests (Cmd+U).
2. Enable code coverage in Scheme → Test → Options → Gather coverage.
3. Verify coverage ≥ 80% overall and per module.
4. UI tests: run `CountdownUITests` for primary flows.

## Lint & Format
- Integrate SwiftLint and SwiftFormat locally and in CI.
- Ensure no lint violations before commit.

## Notes
- Persistence: UserDefaults (MVP). Consider SwiftData if model grows.
- Visuals: Use SwiftUI materials to achieve “liquid glass” look.


