#!/bin/bash
set -e

# Decompile with Apktool
wget -q https://github.com/iBotPeaches/Apktool/releases/download/v2.11.0/apktool_2.11.0.jar -O apktool.jar
java -jar apktool.jar d iceraven.apk -o iceraven-patched
rm -rf iceraven-patched/META-INF

NC=$(find iceraven-patched \
  -path '*/mozilla/components/ui/colors/NovaColors.smali' \
  | head -n1)

if [ -n "$NC" ]; then
  sed -i \
    -e 's/ff281d44/ff1d1b1f/g' \
    -e 's/ff3e2976/ff1d1b1f/g' \
    -e 's/80711d08/ff1d1b1f/g' \
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
