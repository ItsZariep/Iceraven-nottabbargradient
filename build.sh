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
    -e 's/fff2f0f8/ff1d1b1f/g' \
    -e 's/b2f2f0f8/801d1b1f/g' \
    -e 's/ffe2dcf2/ff1d1b1f/g' \
    -e 's/ffcac1e4/ff1d1b1f/g' \
    -e 's/ffb0a3d2/ff1d1b1f/g' \
    -e 's/8cb0a3d2/801d1b1f/g' \
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
    `# Violet Spectrum` \
    -e 's/fff5ecff/ff1d1b1f/g' \
    -e 's/ffe5d6ff/ff1d1b1f/g' \
    -e 's/80e5d6ff/801d1b1f/g' \
    -e 's/ffcdb7ff/ff1d1b1f/g' \
    -e 's/ffb393ff/ff1d1b1f/g' \
    -e 's/ff956eff/ff1d1b1f/g' \
    -e 's/ff764edd/ff1d1b1f/g' \
    -e 's/ff5939a8/ff1d1b1f/g' \
    -e 's/ff3e2976/ff1d1b1f/g' \
    -e 's/ff271c48/ff1d1b1f/g' \
    -e 's/ff161423/ff1d1b1f/g' \
    `# Purple Spectrum` \
    -e 's/fffaebff/ff1d1b1f/g' \
    -e 's/fff1d0ff/ff1d1b1f/g' \
    -e 's/ffe1afff/ff1d1b1f/g' \
    -e 's/ffcd89fc/ff1d1b1f/g' \
    -e 's/ffb561eb/ff1d1b1f/g' \
    -e 's/ff9540c8/ff1d1b1f/g' \
    -e 's/ff702e98/ff1d1b1f/g' \
    -e 's/ff4f216b/ff1d1b1f/g' \
    -e 's/ff311842/ff1d1b1f/g' \
    -e 's/ff1a1220/ff1d1b1f/g' \
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
