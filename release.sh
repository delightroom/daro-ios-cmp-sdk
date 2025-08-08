#!/bin/bash

set -e

# Ensure a version number is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

VERSION=$1

# Validate the version format
if [[ ! $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+)?$ ]]; then
  echo "Version must be in the format x.x.x or x.x.x-tag (e.g., 1.0.0 or 1.0.0-beta)"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PODSPEC_PATH="$SCRIPT_DIR/DaroCMP.podspec"

# 현재 브랜치 감지 (정보 표시용)
CURRENT_BRANCH=$(git branch --show-current)
echo $'\e[34m=== 서브모듈 릴리스 시작 ===\e[0m'
echo "서브모듈 현재 브랜치: $CURRENT_BRANCH"
echo "릴리스 버전: $VERSION"
echo $'\e[34m=============================\e[0m'
echo ""

# Update version in podspec file
sed -i '' "s/spec\.version[[:space:]]*=[[:space:]]*['\"].*['\"]/spec.version = '$VERSION'/" "$PODSPEC_PATH"

# Stage changes but don't commit yet
git add "$PODSPEC_PATH"

# Check if there are changes to commit
if git diff --cached --quiet; then
  echo "No changes to commit (version already up to date)"
  NEEDS_COMMIT=false
else
  echo "Changes staged for commit"
  NEEDS_COMMIT=true
fi

# Check if tag already exists
if git rev-parse "$VERSION" >/dev/null 2>&1; then
  echo "Tag $VERSION already exists, skipping tag creation"
  NEEDS_TAG=false
else
  echo "Tag $VERSION will be created"
  NEEDS_TAG=true
fi

# Check if DaroCMP.xcframework.zip exists
if [ ! -f "$SCRIPT_DIR/build/DaroCMP.xcframework.zip" ]; then
  echo "$SCRIPT_DIR/build/DaroCMP.xcframework.zip file not found"
  exit 1
fi

# Check if release already exists
if gh release view $VERSION >/dev/null 2>&1; then
  echo "GitHub release $VERSION already exists, skipping release creation"
else
  # Create a tag and release using GitHub CLI with the file
  # Note: gh release create will create and push the tag automatically
  gh release create $VERSION "$SCRIPT_DIR/build/DaroCMP.xcframework.zip" --title "Release $VERSION" --notes "Release version $VERSION"
  NEEDS_TAG=false  # gh release create already created and pushed the tag
fi

# Push the podspec to the trunk
echo "Pushing podspec to CocoaPods trunk..."
if pod trunk push "$PODSPEC_PATH" --allow-warnings --verbose; then
    echo "✅ Successfully pushed to CocoaPods trunk"
else
    echo "❌ Failed to push to CocoaPods trunk"
    echo "Make sure you are registered with CocoaPods trunk (pod trunk register)"
    exit 1
fi

# Now commit and push everything if needed
if [ "$NEEDS_COMMIT" = true ]; then
  git commit -m "Bump version to $VERSION"
  git push origin $CURRENT_BRANCH
fi

if [ "$NEEDS_TAG" = true ]; then
  git tag $VERSION
  git push origin $VERSION
fi

git pull --no-rebase origin $CURRENT_BRANCH