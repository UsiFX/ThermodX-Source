#!/sbin/sh
###################################
# ThermodX Beta SETUP SCRIPT
###################################
# Config Vars

# Choose if you want to skip mount for your module or not.
SKIPMOUNT=false
# Set true if you want to load system.prop
PROPFILE=true
# Set true if you want to load post-fs-data.sh
POSTFSDATA=false
# Set true if you want to load service.sh
LATESTARTSERVICE=true
# Set true if you want to clean old files in module before injecting new module
CLEANSERVICE=true
# Select true if you want to want to debug
DEBUG=true
# Select this if you want to add cloud support to your scripts
#CLOUDSUPPPORT=true
# Add cloud host path to this variable
#CLOUDHOST=

# Custom var
MODDIR=/data/adb/modules

# Input options which you want to be replaced
REPLACE="
"

# Set what you want to be displayed on header on installation process
mod_info_print() {
awk '{print}' "$MODPATH"/ThermodXbanner
ui_print ""
}

# Default extraction path is to $MODPATH. Change the logic to whatever you want.
install_module() {
# Unzip
unzip -o "$ZIPFILE" 'addon/*' -d $TMPDIR >&2
unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2


# Preparing rest settings
ui_print "[*] Preparing..."

if [ -d $MODDIR/KTSR ]; then
ui_print "[*] KTSR Module is present, disabled for security purposes."
touch $MODDIR/KSTR/disable

elif [ -d $MODDIR/FDE ]; then
ui_print "[*] FDE.AI Module is present, disabled for security purposes" 
touch $MODDIR/FDE/disable

elif [ -d $MODDIR/MAGNETAR ]; then
ui_print "[*] MAGNETAR Module is present, disabled for security purposes."
touch $MODDIR/MAGNETAR/disable

elif [ -d $MODDIR/ZeetaaTweaks ]; then
ui_print "[*] ZeetaaTweaks Module is present, disabled for security purposes."
touch $MODDIR/ZeetaaTweaks/disable

elif [ -d $MODDIR/KTSRPRO ]; then
ui_print "[*] KTSR PRO Module is present, disabled for security purposes."
touch $MODDIR/KTSRPRO/disable

elif [ -d $MODDIR/ZTS ]; then
ui_print "[*] ZTS Module is present, disabled for security purposes."
touch $MODDIR/ZTS/disable

elif [ -d $MODDIR/Pulsar_Engine ]; then
ui_print "[*] Pulsar Engine Module is present, disabled for security purposes."
touch $MODDIR/Pulsar_Engine/disable

elif [ -d $MODDIR/ktweak ]; then
ui_print "[*] KTweak Module is present, disabled for security purposes."
touch $MODDIR/ktweak/disable

elif [ -d $MODDIR/high_perf_dac ]; then
ui_print "[*] HIGH PERFORMANCE Module is present, disabled for security purposes."
touch $MODDIR/high_perf_dac/disable

elif [ -d $MODDIR/fkm_spectrum_injector ]; then
ui_print "[*] FKM Injector Module is present, disabled for security purposes."
touch $MODDIR/fkm_spectrum_injector/disable

elif [ -d $MODDIR/toolbox8 ]; then
ui_print "[*] Pandora's Box Module is present, disabled for security purposes."
touch $MODDIR/MAGNETAR/disable

elif [ -d $MODDIR/lazy ]; then
ui_print "[*] Lazy Tweaks Module is present, disabled for security purposes."
touch $MODDIR/lazy/disable

elif [ "$(pm list package ktweak)" ]; then
ui_print "[*] KTweak App is present, uninstall it to prevent conflicts."

elif [ "$(pm list package kitana)" ]; then
ui_print "[*] Kitana App is present, uninstall it to prevent conflicts."

elif [ "$(pm list package magnetarapp)" ]; then
ui_print "[*] MAGNETAR App is present, uninstall it to prevent conflicts."

elif [ "$(pm list package lsandroid)" ]; then
ui_print "[*] LSpeed App is present, uninstall it to prevent conflicts."

elif [ "$(pm list package feravolt)" ]; then
ui_print "[*] FDE.AI App is present, uninstall it to prevent conflicts."
fi

# Print module extracting text here for better ordered arrangement of prints
ui_print "[*] Extracting module files..."

# Load Vol Key Selector (don't change)
. $TMPDIR/addon/Volume-Key-Selector/install.sh

# Modify this section according to your needs.
ui_print "[!] installing modded Thermal engine..."
ui_print "[?] Select your device CPU model"
 sleep 0.2
ui_print "[1] SDM 720G"
 sleep 0.2
ui_print "[2] SDM 660 (MAY WORK ON ALL 600 Family)"
 sleep 0.2
ui_print "[3] SDM 430 (MSM8937)"
 sleep 0.2
ui_print "[4] SDM 820
 sleep 0.2
ui_print "[5] Cancel."
 sleep 0.5
ui_print "[*] Select which you want"
ui_print "[*] Volume + = Switch × Volume - = Select "
ui_print "[*] Select which you want:"
SM=1
while true
do
ui_print "  $SM"
if $VKSEL 
then
SM=$((SM + 1))
else 
break
fi
if [ $SM -gt 5 ]
then
SM=1
fi
done
case $SM in		
1) FCTEXTAD1="SDM720G ";;
2) FCTEXTAD1="SDM660 ";;
3) FCTEXTAD1="SDM430 ";;
3) FCTEXTAD1="SDM820 ";;
5) FCTEXTAD1="Cancelled.";;
esac
ui_print "[*] Selected Thermal: $FCTEXTAD1 "

if [[ "$FCTEXTAD1" == "SDM720G" ]]; then
unzip -o "$ZIPFILE" 'Thermal720g/*' -d $TMPDIR >&2
cp -af $TMPDIR/Thermal720g/* $MODPATH/system

elif [[ "$FCTEXTAD1" == "SDM660" ]]; then
unzip -o "$ZIPFILE" 'Thermal660/*' -d $TMPDIR >&2 
cp -af $TMPDIR/Thermal660/* $MODPATH/system

elif [[ "$FCTEXTAD1" == "SDM430" ]]; then
unzip -o "$ZIPFILE" 'Thermal430/*' -d $TMPDIR >&2 
cp -af $TMPDIR/Thermal430/* $MODPATH/system

elif [[ "$FCTEXTAD1" == "SDM820" ]]; then
unzip -o "$ZIPFILE" 'Thermal820/*' -d $TMPDIR >&2 
cp -af $TMPDIR/Thermal820/* $MODPATH/system

sleep 0.2
ui_print "[?] Do you want kernel tweaks"
sleep 0.2
ui_print "[1] Yes, Sure "
sleep 0.2
ui_print "[2] No, Thanks "
sleep 0.2
ui_print "[*] Select which you want"
SM2=1
while true
do
ui_print "  $SM2"
if $VKSEL 
then
SM2=$((SM2 + 1))
else 
break
fi
if [ $SM2 -gt 2 ]
then
SM=1
fi
done

case $SM2 in
1) FCTEXTAD2=" Yes ";;
2) FCTEXTAD2=" No ";;
esac

if [[ "$FCTEXTAD2" == " Yes " ]]; then
sleep 0.1

elif [[ "$FCTEXTAD2" == " No " ]]; then
rm -rf $MODPATH/system/bin/XPERF


ui_print "[*] Kernel Tweaks Selected: $FCTEXTAD2"
sleep 0.2
ui_print "[?] Do you want Network tweaks"
sleep 0.2
ui_print "[1] Yes, Sure "
sleep 0.2
ui_print "[2] No, Thanks "
sleep 0.2
ui_print "[*] Select which you want"
SM3=1
while true
do
ui_print "  $SM2"
if $VKSEL 
then
SM3=$((SM3 + 1))
else 
break
fi
if [ $SM3 -gt 2 ]
then
SM3=1
fi
done

case $SM3 in
1) FCTEXTAD3=" Yes ";;
2) FCTEXTAD3=" No ";;
esac

if [[ "$FCTEXTAD3" == " Yes " ]]; then
sleep 0.1

elif [[ "$FCTEXTAD3" == " No " ]]; then
rm -rf $TMPDIR/system/bin/XNET

ui_print "[*] Network Tweaks Selected: $FCTEXTAD3"

# Input some notes here about module or any other info
ui_print "[!] Notes: "
ui_print "[*] Reboot is required"
sleep 0.5
ui_print "[*] Do not use Thermod.X with other optimizer modules"
ui_print "[*] Report issues to @thermxocg on Telegram"
ui_print "[*] You can find me at imUsiF12 @ telegram for direct support"
ui_print "[*] Much Love 💕 , Happy Gaming"
sleep 1

}

# Set permissions
set_permissions() {
  set_perm_recursive "$MODPATH" 0 0 0755 0644
  set_perm_recursive "$MODPATH/system/bin" 0 0 0755 0755

}
