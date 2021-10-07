#!/sbin/sh
###########################
# MMT - BOURNE SETUP SCRIPT
###########################

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
awk '{print}' "$MODPATH"/TXBanner
ui_print ""
}

# Default extraction path is to $MODPATH. Change the logic to whatever you want.
unzip -o "$ZIPFILE" 'addon/*' -d $TMPDIR > 2
unzip -o "$ZIPFILE" 'system/*' -d $MODPATH > 2
unzip -o "$ZIPFILE" 'script/*' -d $MODPATH
unzip -o "$ZIPFILE" 'bin/*' -d $MODPATH > 2

# Preparing test and rest settings
ui_print "[*] Preparing..."
sleep 1.5
if [-d $MODDIR/KTSR]; then
ui_print "[*] KTSR Module is present, disabled for security purposes."
touch $MODDIR/KSTR/disable

elif [-d $MODDIR/FDE]; then
ui_print "[*] FDE.AI Module is present, disabled for security purposes"
touch $MODDIR/FDE/disable

elif [-d $MODDIR/MAGNETAR]; then
ui_print "[*] MAGNETAR Module is present, disabled for security purposes."
touch $MODDIR/MAGNETAR/disable

elif [-d $MODDIR/ZeetaaTweaks]; then
ui_print "[*] ZeetaaTweaks Module is present, disabled for security purposes."
touch $MODDIR/ZeetaaTweaks/disable

elif [-d $MODDIR/KTSRPRO]; then
ui_print "[*] KTSR PRO Module is present, disabled for security purposes."
touch $MODDIR/KTSRPRO/disable

elif [-d $MODDIR/ZTS]; then
ui_print "[*] ZTS Module is present, disabled for security purposes."
touch $MODDIR/ZTS/disable

elif [-d $MODDIR/Pulsar_Engine]; then
ui_print "[*] Pulsar Engine Module is present, disabled for security purposes."
    touch $MODDIR/Pulsar_Engine/disable

elif [-d $MODDIR/ktweak]; then
ui_print "[*] KTweak Module is present, disabled for security purposes."
    touch $MODDIR/ktweak/disable

elif [-d $MODDIR/high_perf_dac]; then
ui_print "[*] HIGH PERFORMANCE Module is present, disabled for security purposes."
touch $MODDIR/high_perf_dac/disable

elif [-d $MODDIR/fkm_spectrum_injector]; then
ui_print "[*] FKM Injector Module is present, disabled for security purposes."
touch $MODDIR/fkm_spectrum_injector/disable

elif [-d $MODDIR/toolbox8]; then
ui_print "[*] Pandora's Box Module is present, disabled for security purposes."
touch $MODDIR/MAGNETAR/disable

elif [-d $MODDIR/lazy]; then
ui_print "[*] Lazy Tweaks Module is present, disabled for security purposes."
touch $MODDIR/lazy/disable

elif ["$(pm list package ktweak)"]; then
ui_print "[*] KTweak App is present, uninstall it to prevent conflicts."

elif ["$(pm list package kitana)"]; then
ui_print "[*] Kitana App is present, uninstall it to prevent conflicts."

elif ["$(pm list package magnetarapp)"]; then
ui_print "[*] MAGNETAR App is present, uninstall it to prevent conflicts."

elif ["$(pm list package lsandroid)"]; then
ui_print "[*] LSpeed App is present, uninstall it to prevent conflicts."

elif ["$(pm list package feravolt)"]; then
ui_print "[*] FDE.AI App is present, uninstall it to prevent conflicts."
    fi
 ui_print "[*] Extracting ThermodX files..."
 sleep 1.5

# Load Vol Key Selector
. $TMPDIR/addon/Volume-Key-Selector/install.sh


ui_print "[!] installing modded Thermal engine."
sleep 1.5
ui_print "[*] Volume + = Switch × Volume - = Select "
sleep 1.5
ui_print "[1] SDM 720G"
sleep 0.8
ui_print "[2] SDM 660 "
sleep 0.8
ui_print "[3] SDM 430 'MSM8937' "
sleep 0.8
ui_print "[4] SDM 820"
sleep 0.8
ui_print "[5] Cancel."
sleep 0.8
ui_print "[*] Select which your device cpu model:"
SM=1
while true
do
ui_print "   $SM"
if $VKSEL
then
SM=$((SM + 1))
else
break
fi
if [ "SM" -gt "5" ]
then
SM=1
fi
done

case $SM in
1) FCTEXTAD1 = "SDM720G";;
2) FCTEXTAD1 = "SDM660";;
3) FCTEXTAD1 = "SDM430";;
4) FCTEXTAD1 = "SDM820";;
5) FCTEXTAD1 = "*Cancelled*";;
esac

ui_print "[*] Selected: $FCTEXTAD1 "

if [["$FCTEXTAD1" == "SDM720G"]]; then
unzip -o "$ZIPFILE" 'Thermal720g/*' -d $TMPDIR > 2 && cp -af $TMPDIR/Thermal720g/* $MODPATH/system

elif [["$FCTEXTAD1" == "SDM660"]]; then
unzip -o "$ZIPFILE" 'Thermal660/*' -d $TMPDIR > 2 && cp -af $TMPDIR/Thermal660/* $MODPATH/system

elif [["$FCTEXTAD1" == "SDM430"]]; then
unzip -o "$ZIPFILE" 'Thermal430/*' -d $TMPDIR > 2 && cp -af $TMPDIR/Thermal430/* $MODPATH/system

elif [["$FCTEXTAD1" == "SDM820"]]; then
unzip -o "$ZIPFILE" 'Thermal820/*' -d $TMPDIR > 2 && cp -af $TMPDIR/Thermal820/* $MODPATH/system

elif [["$FCTEXTAD1" == "*Cancelled*"]]; then

ui_print "[!] installing Kernel Tweaks."
ui_print "[1] Continue."
sleep 0.8
ui_print "[2] Cancel."
sleep 0.8
ui_print "[*] Select which you want:"
SM3 = 1
while true
do
ui_print "   $SM3"
if $VKSEL
then
SM3=$((SM3 + 1))
else
break
fi
if [ "SM3" -gt "2" ]
then
SM3=1
fi
done

case $SM3 in
1) FCTEXTAD3 = "Yes.";;
2) FCTEXTAD3 = "*Cancelled*";;
esac

ui_print "[*] Selected: $FCTEXTAD3 "

if [["$FCTEXTAD3" == "*Cancelled*"]]; then
rm -rf $TMPDIR/system/bin/XPERF

elif [["$FCTEXTAD3" == "Yes."]]; then

ui_print "[!] installing Network Tweaks."
ui_print "[1] Continue."
sleep 0.8
ui_print "[2] Cancel."
sleep 0.8
ui_print "[*] Select which you want:"
SM1 = 1
while true
do
ui_print "   $SM1"
if $VKSEL
then
SM1=$((SM1 + 1))
else
break
fi
if [ "SM1" -gt "2" ]
then
SM1=1
fi
done

case $SM1 in
1) FCTEXTAD2 = "Yes.";;
2) FCTEXTAD2 = "*Cancelled*";;
esac

ui_print "[*] Selected: $FCTEXTAD2 "

if [["$FCTEXTAD2" == "*Cancelled*"]]; then
rm -rf $TMPDIR/system/bin/XNET

if [["$FCTEXTAD2" == "Yes."]]; then

sleep 1
ui_print "[*] ThermodX has been installed successfully."
sleep 1.5
ui_print "[-] Additional Notes:"
ui_print "[*] Reboot is required"
ui_print "[*] Do not use ThermodX with other optimizer modules"
ui_print "[*] Report issues to @thermxocg on Telegram"
ui_print "[*] You can find me at imUsiF12 @ telegram for direct support"
sleep 4

# Set permissions
set_permissions() {
set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm_recursive "$MODPATH/system/bin" 0 0 0755 0755
set_perm_recursive "$MODPATH/system/vendor/etc" 0 0 0755 0755
set_perm_recursive "$MODPATH/script" 0 0 0755 0755
set_perm_recursive "$MODPATH/bin" 0 0 0755 0755
}