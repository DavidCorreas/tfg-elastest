cd "$(dirname "$0")"
./appium-setup.sh
adb install "$1"
exit 0