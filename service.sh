#!/system/bin/sh
# ThermodX Logic

FILESPATH="system/bin"
MODPATH="/data/adb/modules/ThermodX.ADB"
TPATH="/sys/class/thermal/thermal_message/sconfig"
LOG="/storage/emulated/0/XCORE/TX.log"
Path="/sdcard"
bb="/data/adb/magisk/busybox"

# Sleep until boot completed
until [ "$(getprop sys.boot_completed)" = "1" ] || [ "$(getprop dev.bootcomplete)" = "1" ]
do
       sleep 1
done

# Sleep until some time to complete boot and init
sleep 120

make_file_for_module(){
if [ ! -d ${Path}/XCORE ]; then
mkdir -p ${Path}/XCORE
fi
clear
}

make_file_for_module

# clear log
rm ${LOG}

# sync before exuecuting scripts
sync

# Start qcom.sh optimizations
sh "${FILESPATH}/xqcom.sh"

# Setup logging
sh "${FILESPATH}/XLOG.sh"

# Thermal_Message_Tweaks
setup_tweaks_thermal(){
if [ -f ${TPATH} ]; then
echo 10 > ${TPATH}
fi

if [ "$(cat /sys/class/kgsl/kgsl-3d0/throttling)" = "1" ]; then
echo 0 > /sys/class/kgsl/kgsl-3d0/throttling
fi
}

setup_tweaks_thermal

# XPERF,XNET Start
setup_tweaks(){
if [ -f ${FILESPATH}/XPERF.sh ];then
sh "${FILESPATH}/XPERF.sh"
sleep 0.5
fi
if [ -f ${FILESPATH}/XNET.sh ];then
sh "${FILESPATH}/XNET.sh"
fi
}

setup_tweaks

exit 0