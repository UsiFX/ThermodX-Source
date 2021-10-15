#!/system/bin/sh
#ThermodX™ 1301 R Beta program
# Author: USIF (USIFX @ github)
# Credits : LOOPER (iamlooper @ github)

bb="/data/adb/magisk/busybox"
MODPATH="/data/adb/modules/ThermodX.ADB/"

# Fetch info
VER=$($bb grep versioncodename= "${MODPATH}module.prop" | $bb sed "s/version=//")
CODENAME=$($bb grep codeName= "${MODPATH}module.prop" | $bb sed "s/codeName=//")
STATUS=$($bb grep Status= "${MODPATH}module.prop" | $bb sed "s/Status=//")
AUTHOR=$($bb grep author= "${MODPATH}module.prop" | $bb sed "s/author=//")
LOGPATH="/storage/emulated/0/XCORE/"

print_banner(){
echo " _____ _                                   ___  __  
|_   _| |__   ___ _ __ _ __ ___   ___   __| \ \/ /  
  | | | '_ \ / _ \ '__| '_   _ \ / _ \ / _  |\  /   
  | | | | | |  __/ |  | | | | | | (_) | (_| |/  \ _ 
  |_| |_| |_|\___|_|  |_| |_| |_|\___/ \__,_/_/\_(_)" >> ${LOGPATH}TX.log
}

prepare(){
#Gathering device details
echo "
[*] Preparing...
[*] Author : $AUTHOR
[*] Version : $MODVER
[*] Version Code : $VER
[*] Version Status : $STATUS
[*] Codename : $CODENAME
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[*] DEVICE BRAND : $(getprop ro.product.brand)
[*] DEVICE MODEL : $(getprop ro.product.model)
[*] DEVICE NAME : $(getprop ro.product.device)
[*] ROM : $(getprop ro.build.display.id)
[*] STARTED AT : $(date +"%d-%m-%Y %r" )
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> ${LOGPATH}TX.log
}
xperf_checker(){
if [ -f ${MODPATH}/system/bin/XPERF.sh ]; then
echo "[*] XPERF Found." >> ${LOGPATH}TX.log
else
echo "[!] XPERF Not Found." >> ${LOGPATH}TX.log
fi
}
xnet_checker(){
if [ -f ${MODPATH}/system/bin/XNET.sh ]; then
echo "[*] XNET Found." >> ${LOGPATH}TX.log
else
echo "[!] XNET Not Found." >> ${LOGPATH}TX.log
fi
}

print_banner
prepare
xperf_checker
xnet_checker