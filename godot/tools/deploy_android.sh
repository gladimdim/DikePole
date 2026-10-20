#!/usr/bin/env bash
# Build a release APK signed with the gladimdim-main key and install it on a device.
#   tools/deploy_android.sh [adb-serial]
# Credentials come from ~/.config/android-signing/gladimdim-main.properties and are
# passed to Godot through its keystore environment variables, never written to
# export_presets.cfg.
set -euo pipefail
cd "$(dirname "$0")/.."

PROPS="${ANDROID_SIGNING_PROPS:-$HOME/.config/android-signing/gladimdim-main.properties}"
EXPECTED_SHA256_PREFIX="8be425a4"
APK="build/android/locadeserta.apk"
SERIAL="${1:-}"

prop() { grep -E "^$1=" "$PROPS" | head -1 | cut -d= -f2-; }

export GODOT_ANDROID_KEYSTORE_RELEASE_PATH="$(prop storeFile)"
export GODOT_ANDROID_KEYSTORE_RELEASE_USER="$(prop keyAlias)"
export GODOT_ANDROID_KEYSTORE_RELEASE_PASSWORD="$(prop storePassword)"

python3 -I tools/build_image_manifest.py
mkdir -p build/android
godot --headless --path . --export-release "Android" "$APK"

APKSIGNER="$(ls -d "${ANDROID_HOME:-$HOME/Android/Sdk}"/build-tools/*/apksigner | sort -V | tail -1)"
SHA="$("$APKSIGNER" verify --print-certs "$APK" | grep -m1 "SHA-256 digest" | awk '{print $NF}')"
if [[ "$SHA" != "$EXPECTED_SHA256_PREFIX"* ]]; then
	echo "APK is not signed with gladimdim-main (got $SHA)" >&2
	exit 1
fi
echo "Signed with gladimdim-main: ${SHA:0:8}…${SHA: -6}"

# The Godot export restarts the adb daemon, which drops wireless connections.
if [[ "$SERIAL" == *:* ]]; then
	adb connect "$SERIAL" >/dev/null
fi

adb ${SERIAL:+-s "$SERIAL"} install -r --no-streaming "$APK"
adb ${SERIAL:+-s "$SERIAL"} shell monkey -p gladimdim.locadeserta -c android.intent.category.LAUNCHER 1 >/dev/null
echo "Installed and started gladimdim.locadeserta"
