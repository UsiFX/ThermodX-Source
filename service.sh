#!/system/bin/sh
# ThermodX LOGIC

_sleep_to_boot_complete() {
until [[ "$(getprop sys.boot_completed)" == "1" ]] || [[ "$(getprop dev.bootcomplete)" == "1" ]]
do
       sleep 1
done
}

# Sleep until boot completed
_sleep_to_boot_complete

MODPATH=/data/adb/modules/Thermod.XADB
TPATH=/sys/class/thermal/thermal_message/sconfig
LOG=/storage/emulated/0/XCORE/TX.log

Path=/sdcard
if [ ! -d $Path/XCORE ]; then
 mkdir -p $Path/XCORE
fi
clear

# clear log
rm $LOG

# wait for boot to finish first
BOOT=$(getprop getprop sys.boot_completed)
if [ "$BOOT" = "0" ];then
sleep 3
fi

# Wait for boot to finish completely
while [[ `getprop sys.boot_completed` -ne 1 ]] && [[ ! -d "/sdcard" ]]
do
       sleep 1
done

# Sleep an additional 3s to ensure init is finished
sleep 3

# sync before exuecuting scripts
sync 

setup_tweaks() {
if [ -f /sys/class/thermal/thermal_message/sconfig ]; then
echo 10 > /sys/class/thermal/thermal_message/sconfig
fi

if [ $(cat /sys/class/kgsl/kgsl-3d0/throttling) = 1 ]; then
echo 0 > /sys/class/kgsl/kgsl-3d0/throttling
fi
elif [ -f $MODPATH/XPERF]; then
sh $MODPATH/XPERF
sh /system/bin/XPERF
sleep 0.5
elif [ -f $MODPATH/XNET ]; then
sh $MODPATH/XNET
fi
}

setup_tweaks

# in some case , it will reset to default mode , so lock it
chmod 444 $TPATH

exit 0
