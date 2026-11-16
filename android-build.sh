#!/usr/bin/env bash
# Builds the APK. With the signing secrets set (see README, step 6) it builds a signed release APK,
# so every new version installs over the old one. Without them it builds a debug APK.
set -euo pipefail
mkdir -p dist-apk
NAME="$(node -p "require('./package.json').version")"
cd android
chmod +x gradlew
if [ -n "${KEYSTORE_BASE64:-}" ] && [ -n "${KEYSTORE_PASSWORD:-}" ]; then
  echo "$KEYSTORE_BASE64" | base64 -d | openssl enc -d -aes-256-cbc -pbkdf2 -pass env:KEYSTORE_PASSWORD > app/release.jks
  cat >> app/build.gradle <<'EOF'

android {
    signingConfigs {
        release {
            storeFile file("release.jks")
            storePassword System.getenv("KEYSTORE_PASSWORD")
            keyAlias "antheia"
            keyPassword System.getenv("KEYSTORE_PASSWORD")
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
EOF
  ./gradlew assembleRelease --no-daemon
  cp app/build/outputs/apk/release/app-release.apk "../dist-apk/antheia-label-${NAME}.apk"
  rm -f app/release.jks
else
  echo "No signing secrets found: building a debug APK."
  ./gradlew assembleDebug --no-daemon
  cp app/build/outputs/apk/debug/app-debug.apk "../dist-apk/antheia-label-${NAME}-debug.apk"
fi
ls -la ../dist-apk
