#!/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$PROJECT_DIR/.build"
APP_NAME="SourceEditor.app"
DEST="/Applications/$APP_NAME"

echo "Building $APP_NAME..."
xcodebuild \
    -project "$PROJECT_DIR/SourceEditor.xcodeproj" \
    -scheme SourceEditor \
    -configuration Release \
    -derivedDataPath "$BUILD_DIR" \
    build

BUILT_APP="$BUILD_DIR/Build/Products/Release/$APP_NAME"

echo "Installing to $DEST..."
rm -rf "$DEST"
cp -R "$BUILT_APP" "$DEST"

echo "Done. Enable the extension in:"
echo "  System Settings > Privacy & Security > Extensions > Xcode Source Editor"
