
#!/bin/bash
set -e

# Decompile with Apktool
wget -q https://github.com/iBotPeaches/Apktool/releases/download/v2.11.0/apktool_2.11.0.jar -O apktool.jar
java -jar apktool.jar d iceraven.apk -o iceraven-patched
rm -rf iceraven-patched/META-I
NC=$(find iceraven-patched -path '*/mozilla/components/ui/colors/NovaColors.smali' | head -n1)

if [ -n "$NC" ]; then
  sed -i \
    's/ff180e30/ff1d1b1f/g; s/ff711d08/ff1d1b1f/g; s/80180e30/ff1d1b1f/g; s/b2180e30/ff1d1b1f/g; s/80711d08/ff1d1b1f/g' \
    "$NC"
fi

# Recompile the APK
java -jar apktool.jar b iceraven-patched -o iceraven-patched.apk --use-aapt2

# Align the APK (signing happens in the workflow with the release keystore)
zipalign -f 4 iceraven-patched.apk iceraven-patched-signed.apk

# Clean up
rm -rf iceraven-patched iceraven-patched.apk apktool.jar
