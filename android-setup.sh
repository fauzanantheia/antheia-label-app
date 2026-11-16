#!/usr/bin/env bash
# Runs after "npx cap add android": app icon, splash screen and version number.
set -euo pipefail
cp -r resources/android/res/. android/app/src/main/res/
CODE="${GITHUB_RUN_NUMBER:-1}"
NAME="$(node -p "require('./package.json').version")"
sed -i "s/versionCode 1$/versionCode ${CODE}/; s/versionName \"1.0\"/versionName \"${NAME}\"/" android/app/build.gradle
echo "Android project ready: version ${NAME} (${CODE})"
