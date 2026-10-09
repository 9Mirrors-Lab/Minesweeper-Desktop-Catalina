#!/usr/bin/env bash
# Build Minesweeper for macOS 10.15+ and install to /Applications.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "xcodebuild not found. Install Xcode 16 from the App Store or developer.apple.com, then run:"
  echo "  sudo xcode-select -s /Applications/Xcode.app/Contents/Developer"
  exit 1
fi

XCODE_MAJOR="$(xcodebuild -version | awk '/Xcode/ {print int($2)}')"
if [[ "$XCODE_MAJOR" -ge 27 ]]; then
  echo "This Xcode cannot deploy below macOS 12."
  echo "Use Xcode 16.x to build a Catalina (10.15) binary."
  exit 1
fi

echo "Building Minesweeper (macOS 10.15+, universal)..."
xcodebuild build \
  -project Minesweeper.xcodeproj \
  -scheme Minesweeper \
  -configuration Release \
  -destination 'platform=macOS' \
  ARCHS='arm64 x86_64' \
  ONLY_ACTIVE_ARCH=NO \
  MACOSX_DEPLOYMENT_TARGET=10.15 \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGNING_REQUIRED=NO \
  -quiet

APP="$(find ~/Library/Developer/Xcode/DerivedData -path '*/Build/Products/Release/Minesweeper.app' -print -quit 2>/dev/null || true)"
if [[ -z "${APP}" || ! -d "${APP}" ]]; then
  echo "Build finished but Minesweeper.app was not found in DerivedData."
  exit 1
fi

DEST="/Applications/Minesweeper.app"
echo "Installing to ${DEST}..."
rm -rf "${DEST}"
cp -R "${APP}" "${DEST}"

echo "Done. Launching..."
open "${DEST}"
