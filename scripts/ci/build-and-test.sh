#!/usr/bin/env bash
set -euo pipefail

SCHEME="CountdownTests"
PROJECT="Countdown.xcodeproj"
DESTINATION="platform=iOS Simulator,name=iPhone 15"
DERIVED_DATA="$(pwd)/DerivedData"
RESULT_BUNDLE="$(pwd)/TestResults.xcresult"
TEST_PLAN="TestPlan"

rm -rf "$DERIVED_DATA" "$RESULT_BUNDLE"
xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -testPlan "$TEST_PLAN" \
  -destination "$DESTINATION" \
  -derivedDataPath "$DERIVED_DATA" \
  -resultBundlePath "$RESULT_BUNDLE" \
  -enableCodeCoverage YES \
  build test \
  GCC_TREAT_WARNINGS_AS_ERRORS=YES \
  | xcpretty || true
 


