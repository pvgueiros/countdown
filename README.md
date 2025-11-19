# Countdown

![CI](https://img.shields.io/badge/CI-xcodebuild-blue)
![Platform](https://img.shields.io/badge/platform-iOS%2017%2B-lightgrey)
![Swift](https://img.shields.io/badge/swift-5.9%2B-orange)
![Coverage](https://img.shields.io/badge/coverage-%E2%89%A580%25-brightgreen)

A lightweight SwiftUI app to track your Dates of Interest with a clean list, colorful countdown pills, and persistence. Built using CLEAN architecture with MVVM + Coordinator. Fully offline; no external APIs.

## Features
- Two tabs: **Upcoming** (Today + future, ascending) and **Past** (past, descending)
- Each row shows an SF Symbol, title, localized date, and a countdown pill
- Countdown pill formats as:
  - future: “X”
  - past: “- X”
  - today: “Today”
- Persistence via `UserDefaults` (MVP)
- Accessibility: contrast-safe pills; Dynamic Type support
- Localization: English and Portuguese (Brazil)

## Architecture
- CLEAN layering: `UI → Presentation (MVVM) → UseCases → Domain → Data`
- Coordinator owns navigation: see `Countdown/Presentation/Coordinators/AppCoordinator.swift`
- Key folders:
  - `Countdown/Domain` — entities and repository protocols
  - `Countdown/UseCases` — business rules (partitioning, add/update)
  - `Countdown/Data` — `UserDefaults` repository + mappers
  - `Countdown/Presentation` — view models, formatters, colors, coordinators
  - `Countdown/UI` — screens and components

## Getting Started
### Prerequisites
- Xcode 15.4+
- iOS 17.5 Simulator (recommended) or device

### Build & Run
1. Open `Countdown.xcodeproj`.
2. Select the `Countdown` scheme.
3. Build (Cmd+B) and Run (Cmd+R).

### Tests & Coverage
- Run tests (Cmd+U) or via scripts:
  - `scripts/ci/build-and-test.sh`
  - `scripts/ci/check-coverage.sh` (coverage gate: 80%)
- UI tests live under `CountdownUITests/`.
- Performance test: `PerformanceScrollingTests` (100 items scroll).

## Useful Launch Arguments
Add to Scheme → Run → Arguments → Arguments Passed On Launch:
- `UITEST_CLEAR_DATA` — clears stored items
- `UITEST_PRELOAD_DATA` — preload 3 sample items
- `UITEST_PRELOAD_100` — preload 100 items (perf)
- `UITEST_AUTO_DATE` — Add/Edit treats date as picked

## Localization
- String Catalog: `Countdown/Resources/Localizable.xcstrings`
- Supported: `en`, `pt-BR`

## Accessibility
- Dynamic Type-ready text styles
- Pill foreground color adapts for contrast; past entries use system primary on gray background

## CI
- GitHub Actions workflow at `.github/workflows/ios-ci.yml`
  - Builds and tests with coverage
  - Enforces coverage via `scripts/ci/check-coverage.sh`
  - Uploads `TestResults.xcresult` artifact

## Contributing
- Follow Swift API Design Guidelines and the existing code style.
- Keep responsibilities within the appropriate CLEAN layer.
- Add unit tests (and UI tests, if applicable) for new features.

## License
This project is licensed under the terms of the `LICENSE` file.
