#!/usr/bin/env bash
set -euo pipefail

RESULT_BUNDLE="TestResults.xcresult"
MIN_COVERAGE=80

if ! command -v xcrun >/dev/null; then
  echo "xcrun is required" >&2
  exit 1
fi

if [ ! -d "$RESULT_BUNDLE" ]; then
  echo "Result bundle not found: $RESULT_BUNDLE" >&2
  exit 1
fi

TOTAL=$(xcrun xccov view --report --json "$RESULT_BUNDLE" | awk -F'[,:}]' '/"lineCoverage"/{print $2*100}' | head -n1 | cut -d. -f1)
TOTAL=${TOTAL:-0}
echo "Coverage: ${TOTAL}%"
if [ "$TOTAL" -lt "$MIN_COVERAGE" ]; then
  echo "Coverage below threshold ${MIN_COVERAGE}%"
  exit 1
fi


