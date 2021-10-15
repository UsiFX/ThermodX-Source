#!/system/bin/sh
# ThermodX Logic

FILESPATH="system/bin"
TPATH="/sys/class/thermal/thermal_message/sconfig"
LOG="/storage/emulated/0/XCORE/TX.log"
Path="/sdcard"
bb="/data/adb/magisk/busybox"
LOGPATH="/storage/emulated/0/XCORE/"

# Sleep until boot completed
until [ "$(getprop sys.boot_completed)" = "1" ] || [ "$(getprop dev.bootcomplete)" = "1" ]
do
       sleep 1
done

# Sleep until some time to complete boot and init
sleep 30

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
$bb sh "${FILESPATH}/XLOG.sh"

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
setup_xperf(){
if [ -f ${FILESPATH}/XPERF.sh ];then
echo "[*] Starting XPERF..." >> ${LOGPATH}TX.log && sh "${FILESPATH}/XPERF.sh"
fi
}
setup_xnet(){
if [ -f ${FILESPATH}/XNET.sh ];then
echo "[*] Starting XNET..." >> ${LOGPATH}TX.log && sh "${FILESPATH}/XNET.sh"
fi
}

setup_xperf
sleep 0.5
setup_xnet

echo "[*] PROCESS DONE AT : $(date +"%d-%m-%Y %r" )" >> ${LOGPATH}TX.log
echo "[*] Finishing up...
[*] Done." >> ${LOGPATH}TX.log

exit 0