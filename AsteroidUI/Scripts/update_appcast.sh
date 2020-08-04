#!/usr/bin/env bash

set -exu

version=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${PROJECT_DIR}/${INFOPLIST_FILE}")
appDir="$ARCHIVE_PATH/Products/Applications/"
appName="./$PRODUCT_NAME.app"
releasesDir="${PROJECT_DIR}/Updates"
zipName="$PROJECT_NAME-$version.zip"
pushd "$appDir"
ditto -c -k --sequesterRsrc --keepParent "$appName" "$releasesDir/$zipName"
popd
"${PROJECT_DIR}/Pods/Sparkle/bin/generate_appcast" "$releasesDir"
