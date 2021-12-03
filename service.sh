#!/system/bin/sh
# ThermodX Logic

# Custom Var
FILESPATH="system/bin"
TPATH="/sys/class/thermal/thermal_message/sconfig"
LOG="/storage/emulated/0/XCORE/TX.log"
bb="/data/adb/magisk/busybox"
LOGPATH="/storage/emulated/0/XCORE/"

# Detect if we're running on a qualcomm powered device
[[ "$(getprop ro.boot.hardware | grep qcom)" ]] || [[ "$(getprop ro.soc.manufacturer | grep QTI)" ]] || [[ "$(getprop ro.soc.manufacturer | grep Qualcomm)" ]] || [[ "$(getprop ro.hardware | grep qcom)" ]] || [[ "$(getprop ro.vendor.qti.soc_id)" ]] || [[ "$(getprop gsm.version.ril-impl | grep Qualcomm)" ]] && qcom=true

#####################
# BEGIN
#####################

# Sleep until boot completed
until [ "$(getprop sys.boot_completed)" = "1" ] || [ "$(getprop dev.bootcomplete)" = "1" ]
do
       sleep 1
done

# Sleep until some time to complete boot and init
sleep 30

# clear log
rm ${LOG}

# sync before exuecuting scripts
sync

if [[ "$qcom" == "true" ]]; then
 # Start qcom.sh optimizations
 sh "${FILESPATH}/xqcom.sh"
fi

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
  echo "[*] Starting XPERF..." >> ${LOGPATH}TX.log && $bb sh "${FILESPATH}/XPERF.sh"
 fi
}
setup_xnet(){
 if [ -f ${FILESPATH}/XNET.sh ];then
  echo "[*] Starting XNET..." >> ${LOGPATH}TX.log && $bb sh "${FILESPATH}/XNET.sh"
 fi
}

setup_xperf
sleep 0.5
setup_xnet

echo "[*] PROCESS DONE AT : $(date +"%d-%m-%Y %r" )" >> ${LOGPATH}TX.log
echo "[*] Finishing up...
[*] Done." >> ${LOGPATH}TX.log

exit 0