#!/bin/bash
set -e

# Decompile with Apktool
wget -q https://github.com/iBotPeaches/Apktool/releases/download/v2.11.0/apktool_2.11.0.jar -O apktool.jar
java -jar apktool.jar d iceraven.apk -o iceraven-patched
rm -rf iceraven-patched/META-INF

NC=$(find iceraven-patched \
  -path '*/mozilla/components/ui/colors/NovaColors.smali' \
  | head -n1)

# Source: https://github.com/akliuxingyuan/android-components/blob/437b3596289fa012aed066840c31e8fc0c8bc7a7/components/ui/colors/src/main/java/mozilla/components/ui/colors/NovaColors.kt

if [ -n "$NC" ]; then
  sed -i \
    `# VioletDesaturated Spectrum` \
    -e 's/ff9484bd/ff1d1b1f/g' \
    -e 's/ff75669f/ff1d1b1f/g' \
    -e 's/db75669f/801d1b1f/g' \
    -e 's/ff584a7d/ff1d1b1f/g' \
    -e 's/ff3e315f/ff1d1b1f/g' \
    -e 's/ff281d44/ff1d1b1f/g' \
    -e 's/ff180e30/ff1d1b1f/g' \
    -e 's/ff1a1526/ff1d1b1f/g' \
    -e 's/66180e30/801d1b1f/g' \
    -e 's/80180e30/801d1b1f/g' \
    -e 's/b2180e30/801d1b1f/g' \
    `# Gradient end stop` \
    -e 's/80711d08/801d1b1f/g' \
    "$NC"
else
  echo "NovaColors.smali not found"
fi

# Recompile the APK
java -jar apktool.jar b iceraven-patched -o iceraven-patched.apk --use-aapt2

# Align the APK
zipalign -f 4 iceraven-patched.apk iceraven-patched-signed.apk

# Clean up
rm -rf iceraven-patched iceraven-patched.apk apktool.jar
