#!/bin/sh

if [[ "$TRAVIS_BRANCH" == "develop" ]]; then
  fastlane fabric
elif [[ "$TRAVIS_BRANCH" == "release" ]]; then
  fastlane testflight_beta version:1.0
else
  echo "The file 'somefile' does not exist."
fi
