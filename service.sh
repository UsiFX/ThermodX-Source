#!/system/bin/sh
# ThermodX Logic

MODPATH="/data/adb/modules/ThermodX.ADB"
TPATH="/sys/class/thermal/thermal_message/sconfig"
LOG="/storage/emulated/0/XCORE/TX.log"

# Wget Tool Function
_wget() {
    /data/adb/modules/xtweak/bin/wget "$@"
}

# Sleep until boot completed
until ["$(getprop sys.boot_completed)" = "1"] || ["$(getprop dev.bootcomplete)" = "1"]
do
sleep 1
done

# Sleep until some time to complete boot and init
sleep 60

Path=/sdcard
if [! -d $Path/XCORE]; then
mkdir -p $Path/XCORE
fi
clear

# clear log
rm $LOG

# Update main scripts
_wget -O "$ {
    MODPATH
}/system/bin/XNET" "https://raw.githubusercontent.com/UsiFX/ThermodX-Source/main/system/bin/XNET"
_wget -O "$ {
    MODPATH
}/system/bin/XPERF" "https://raw.githubusercontent.com/UsiFX/ThermodX-Source/main/system/bin/XPERF"
_wget -O "$ {
    MODPATH
}/module.prop" "https://raw.githubusercontent.com/UsiFX/ThermodX-Source/main/module.prop"
_wget -O "$ {
    MODPATH
}/system.prop" "https://raw.githubusercontent.com/UsiFX/ThermodX-Source/main/system.prop"

# Start qcom optimization
sh "/system/bin/xqcom"

# sync before exuecuting scripts
sync

if [-f /sys/class/thermal/thermal_message/sconfig]; then
echo 10 > /sys/class/thermal/thermal_message/sconfig
fi

if [$(cat /sys/class/kgsl/kgsl-3d0/throttling) = 1]; then
echo 0 > /sys/class/kgsl/kgsl-3d0/throttling
fi
elif [-f $MODPATH/XPERF]; then
sh "$MODPATH/XPERF"
sleep 0.5
elif [-f $MODPATH/XNET]; then
sh "$MODPATH/XNET"
fi
