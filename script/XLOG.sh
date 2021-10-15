#!/system/bin/sh
#ThermodX™ 1301 R Beta program
# Author: USIF (USIFX @ github)
# Credits : p3dr0zzz (pedrozzz0 @ github), tytydraco (tytydraco @ github), Matt Yang (yc9559 @ github), Ferat Kesaev (feravolt @ github) , LOOPER (iamlooper @ github)

# Fetch info
TITLE=$($bb grep name= "${MODPATH}module.prop" | $bb sed "s/name=//")
VER=$($bb grep version= "${MODPATH}module.prop" | $bb sed "s/version=//")
CODENAME=$($bb grep codeName= "${MODPATH}module.prop" | $bb sed "s/codeName=//")
STATUS=$($bb grep Status= "${MODPATH}module.prop" | $bb sed "s/Status=//")
AUTHOR=$($bb grep author= "${MODPATH}module.prop" | $bb sed "s/author=//")

echo " _____ _                                   ___  __  
      |_   _| |__   ___ _ __ _ __ ___   ___   __| \ \/ /  
        | | | '_ \ / _ \ '__| '_   _ \ / _ \ / _  |\  /   
        | | | | | |  __/ |  | | | | | | (_) | (_| |/  \ _ 
        |_| |_| |_|\___|_|  |_| |_| |_|\___/ \__,_/_/\_(_)" >> /sdcard/XCORE/TX.log

echo "[*] Preparing..." >> /sdcard/XCORE/TX.log
sleep 1.6

echo "[*] Author : $AUTHOR
      [*] Version : $MODVER  
      [*] Version Code : $VER
      [*] Version Status : $STATUS
      [*] Codename : $CODENAME     " >> /sdcard/XCORE/TX.log

#Gathering device details
echo "[*] DEVICE BRAND : $(getprop ro.product.brand)
      [*] DEVICE MODEL : $(getprop ro.product.model)
      [*] DEVICE NAME : $(getprop ro.product.device)
      [*] ROM : $(getprop ro.build.display.id) " >> /sdcard/XCORE/TX.log

if [[ -f $TXDIR/XPERF ]]; then
echo "[!] XPERF Found." >> /sdcard/XCORE/TX.log
else
echo "[!] XPERF Not Found." >> /sdcard/XCORE/TX.log
fi

if [[ -f $TXDIR/XNET ]]; then
echo "[!] XNET Found." >> /sdcard/XCORE/TX.log
else
echo "[!] XNET Not Found." >> /sdcard/XCORE/TX.log
fi