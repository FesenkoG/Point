#!/bin/sh
xcrun xcodebuild \
  -scheme $XCODE_SCHEME \
  -project $XCODE_PROJECT \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 6s,OS=11.4' \
  -derivedDataPath \
  build

if [[ "$TRAVIS_BRANCH" == "develop" ]]; then
  fastlane fabric
elif [[ "$TRAVIS_BRANCH" == "release" ]]; then
  fastlane testflight_beta version:1.0
else
  echo "The file 'somefile' does not exist."
fi
