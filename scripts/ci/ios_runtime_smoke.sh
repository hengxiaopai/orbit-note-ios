#!/usr/bin/env bash
set -euo pipefail

echo "== Xcode =="
xcodebuild -version

echo "== iOS runtimes =="
xcrun simctl list runtimes

echo "== Available iPhone simulators =="
xcrun simctl list devices available | sed -n '/-- iOS /,/-- /p'

if ! xcrun simctl list runtimes | grep -E "iOS (1[7-9]|[2-9][0-9])" >/dev/null; then
  echo "No iOS 17+ simulator runtime found on this GitHub Actions runner."
  exit 1
fi

if ! xcrun simctl list devices available | grep -E "iPhone" >/dev/null; then
  echo "No available iPhone simulator device found on this GitHub Actions runner."
  exit 1
fi

echo "Simulator runtime smoke check passed."
