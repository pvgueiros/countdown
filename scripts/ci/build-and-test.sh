#!/usr/bin/env bash
set -euo pipefail

SCHEME="Countdown"
PROJECT="Countdown.xcodeproj"
DESTINATION="platform=iOS Simulator,name=iPhone 15,OS=17.5"
DERIVED_DATA="$(pwd)/DerivedData"
RESULT_BUNDLE="$(pwd)/TestResults.xcresult"

rm -rf "$DERIVED_DATA" "$RESULT_BUNDLE"
xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination "$DESTINATION" \
  -derivedDataPath "$DERIVED_DATA" \
  -enableCodeCoverage YES \
  build test \
  GCC_TREAT_WARNINGS_AS_ERRORS=YES \
  | xcpretty || true

# Attach result bundle if present
if [ -d "$DERIVED_DATA/Logs/Test" ]; then
  find "$DERIVED_DATA/Logs/Test" -name "*.xcresult" -exec cp -R {} "$RESULT_BUNDLE" \; || true
fi


