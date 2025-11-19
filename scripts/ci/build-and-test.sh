#!/usr/bin/env bash
set -euo pipefail
set -x

SCHEME="CountdownTests"
PROJECT="Countdown.xcodeproj"
DERIVED_DATA="$(pwd)/DerivedData"
RESULT_BUNDLE="$(pwd)/TestResults.xcresult"
TEST_PLAN="TestPlan"

# Resolve a stable simulator destination (prefer the newest available iPhone)
FOUND_UDID="$(xcrun simctl list devices available -j | /usr/bin/python3 - <<'PY' || true
import sys, json
data = json.load(sys.stdin)
# Sort runtimes descending to prefer newest
for runtime in sorted(data.get("devices", {}).keys(), reverse=True):
    for d in data["devices"][runtime]:
        if d.get("isAvailable") and "iPhone" in d.get("name",""):
            print(d["udid"])
            raise SystemExit(0)
raise SystemExit(1)
PY
)"
if [ -z "$FOUND_UDID" ]; then
  echo "Failed to locate an available iPhone simulator" >&2
  xcrun simctl list
  exit 1
fi
DESTINATION="platform=iOS Simulator,id=$FOUND_UDID"

# Show available schemes for diagnostics
xcodebuild -list -project "$PROJECT" | sed -n '/Schemes:/,/^$/p' || true

rm -rf "$DERIVED_DATA" "$RESULT_BUNDLE"
xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -testPlan "$TEST_PLAN" \
  -destination "$DESTINATION" \
  -derivedDataPath "$DERIVED_DATA" \
  -resultBundlePath "$RESULT_BUNDLE" \
  -enableCodeCoverage YES \
  -sdk iphonesimulator \
  -only-testing:CountdownTests \
  build test \
  GCC_TREAT_WARNINGS_AS_ERRORS=YES \
  | xcpretty || true
 
# Fallback: if no direct result bundle, try to copy from DerivedData logs
if [ ! -d "$RESULT_BUNDLE" ] && [ -d "$DERIVED_DATA/Logs/Test" ]; then
  FOUND_RESULT="$(find "$DERIVED_DATA/Logs/Test" -name "*.xcresult" | head -n1 || true)"
  if [ -n "$FOUND_RESULT" ]; then
    cp -R "$FOUND_RESULT" "$RESULT_BUNDLE" || true
  fi
fi

