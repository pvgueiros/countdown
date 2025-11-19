# Quickstart: Countdown List

## Prerequisites
- Xcode 15+ (Swift 5.9+)
- iOS 17+ Simulator or device

## Build & Run
1. Open `Countdown.xcodeproj` in Xcode.
2. Select the `Countdown` scheme, iOS 17.5 simulator (Xcode 15.4 on macOS 14 runners).
3. Build (Cmd+B). Ensure 0 warnings (treat as errors in CI).
4. Run (Cmd+R).

## Tests & Coverage
1. Run unit tests (Cmd+U).
2. Enable code coverage in Scheme → Test → Options → Gather coverage.
3. Verify coverage ≥ 80% overall (CI gate).
4. UI tests: run `CountdownUITests` for primary flows.
5. Performance test: run `PerformanceScrollingTests` (scrolling with 100 items).

## Lint & Format
- Integrate SwiftLint and SwiftFormat locally and in CI.
- Ensure no lint violations before commit.

## Notes
- Persistence: UserDefaults (MVP). Consider SwiftData if model grows.
- Visuals: Use SwiftUI materials to achieve “liquid glass” look.

## Useful launch arguments (for tests and manual runs)
- `UITEST_CLEAR_DATA`: wipes UserDefaults storage for a clean start
- `UITEST_PRELOAD_DATA`: loads 3 sample items (future/today/past)
- `UITEST_PRELOAD_100`: loads 100 mixed items to validate scrolling performance
- `UITEST_AUTO_DATE`: Add/Edit sheet treats the date as already chosen

## CI (GitHub Actions)
- Workflow: `.github/workflows/ios-ci.yml`
- Steps:
  - Build and test with coverage via `scripts/ci/build-and-test.sh`
  - Enforce minimum coverage with `scripts/ci/check-coverage.sh` (80%)
  - Upload `TestResults.xcresult` as an artifact


