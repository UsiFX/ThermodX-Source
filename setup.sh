#!/sbin/sh
#################################
# ThermodX™ 1301 R Beta program #
#################################

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
# Old Setup Wizard (Legacy) Support
LEGACYSETUP=$(getprop presist.thermodx.legacysetup)

# Custom Vars
Path="/sdcard"

# For $MULTILANGSUPPORT (true): For enable , (false1): For disabling AR language only , (false): to skip the entire of it

# For Copycaters:
# if its hard to understand the auto multi languaged setup then
# setprop presist.thermodx.legacysetup 1
# please remove the "#" letter to continue using legacy setup so u can just use it in ur copy build of this module

#####################
# BEGIN
#####################

# Default extraction PATH is to $MODPATH.
unzip -o "$ZIPFILE" 'addon/*' -d $TMPDIR >&2
unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
unzip -o "$ZIPFILE" 'script/*' -d $MODPATH >&2
unzip -o "$ZIPFILE" 'bin/*' -d $MODPATH >&2

make_file_for_module(){
 if [ ! -d ${Path}/XCORE ]; then
  mkdir -p ${Path}/XCORE
 fi
}

make_file_for_module

# Backup device current thermal
if [ ! -d ${Path}/XCORE/backup ]; then
 mkdir -p ${Path}/XCORE/backup
 mkdir -p ${Path}/XCORE/backup/device_thermal
 cp -af /system/vendor/etc/thermal-*.conf /sdcard/XCORE/backup/device_thermal
fi

# Set what you want to be displayed on header on installation process
mod_info_print_en(){
    awk '{print}' "$MODPATH"/tx_banner
    ui_print ""
    ui_print "[⚡] POWERFUL THERMAL & TWEAKER [⚡]"
}

mod_info_print_ar(){
    awk '{print}' "$MODPATH"/tx_banner_ar
    ui_print ""
    ui_print "[⚡] ثرمال قوي و معزز [⚡]"
}

# Detect if we're running on a qualcomm powered device
[[ "$(getprop ro.boot.hardware | grep qcom)" ]] || [[ "$(getprop ro.soc.manufacturer | grep QTI)" ]] || [[ "$(getprop ro.soc.manufacturer | grep Qualcomm)" ]] || [[ "$(getprop ro.hardware | grep qcom)" ]] || [[ "$(getprop ro.vendor.qti.soc_id)" ]] || [[ "$(getprop gsm.version.ril-impl | grep Qualcomm)" ]] && qcom=true

# Detect if we're running on a exynos powered device
[[ "$(getprop ro.boot.hardware | grep exynos)" ]] || [[ "$(getprop ro.board.platform | grep universal)" ]] || [[ "$(getprop ro.product.board | grep universal)" ]] && exynos=true

# Detect if we're running on a mediatek powered device
[[ "$(getprop ro.board.platform | grep mt)" ]] || [[ "$(getprop ro.product.board | grep mt)" ]] || [[ "$(getprop ro.hardware | grep mt)" ]] || [[ "$(getprop ro.boot.hardware | grep mt)" ]] && mtk=true

# Preparing test and rest settings (LEGACY)
Legacy_Setup(){
 prepare_for_confliction(){
  ui_print "[*] Preparing..."
  sleep 1.5
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
  ui_print "[*] Extracting ThermodX files..."
  sleep 1.5
 }
 
 mod_info_print_en
 prepare_for_confliction
 
 # Load Vol Key Selector
 . $TMPDIR/addon/Volume-Key-Selector/install.sh
 
 prepare_thermals(){
  ui_print "[!] installing modded Thermal engine."
  sleep 1.5
  ui_print "[*] Volume + = Switch × Volume - = Select "
  sleep 1.5
  ui_print "[1] SDM 720G"
  sleep 0.8
  ui_print "[2] SDM 710"
  sleep 0.8
  ui_print "[3] SDM 660 "
  sleep 0.8
  ui_print "[4] SDM 430 'MSM8937' "
  sleep 0.8
  ui_print "[5] SDM 820"
  sleep 0.8
  ui_print "[6] Cancel."
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
  if [ $SM -gt 6 ]
  then
   SM=1
  fi
  done
  
  case $SM in
   1) FCTEXTAD1="SDM720G";;
   2) FCTEXTAD1="SDM710";;
   3) FCTEXTAD1="SDM660";;
   4) FCTEXTAD1="SDM430";;
   5) FCTEXTAD1="SDM820";;
   6) FCTEXTAD1="*Cancelled*";;
  esac
 
  ui_print "[*] Selected: $FCTEXTAD1 "
 
  if [[ "$FCTEXTAD1" == "SDM720G" ]]; then
   setprop persist.thermodx.thermal.mode extreme
   unzip -o "$ZIPFILE" 'Thermal720g/*' -d "$TMPDIR" >&2 && cp -af "$TMPDIR"/Thermal720g/* "$MODPATH"/system
 
  elif [[ "$FCTEXTAD1" == "SDM710" ]]; then
   setprop persist.thermodx.thermal.mode extreme
   unzip -o "$ZIPFILE" 'Thermal710/*' -d "$TMPDIR" >&2 && cp -af "$TMPDIR"/Thermal710/* "$MODPATH"/system
 
  elif [[ "$FCTEXTAD1" == "SDM660" ]]; then
   setprop persist.thermodx.thermal.mode extreme
   unzip -o "$ZIPFILE" 'Thermal660/*' -d "$TMPDIR" >&2 && cp -af "$TMPDIR"/Thermal660/* "$MODPATH"/system
 
  elif [[ "$FCTEXTAD1" == "SDM430" ]]; then
   setprop persist.thermodx.thermal.mode extreme
   unzip -o "$ZIPFILE" 'Thermal430/*' -d "$TMPDIR" >&2 && cp -af "$TMPDIR"/Thermal430/* "$MODPATH"/system
 
  elif [[ "$FCTEXTAD1" == "SDM820" ]]; then
   setprop persist.thermodx.thermal.mode extreme
   unzip -o "$ZIPFILE" 'Thermal820/*' -d "$TMPDIR" >&2 && cp -af "$TMPDIR"/Thermal820/* "$MODPATH"/system
  fi
 }
 
 XPERF(){
  ui_print "[!] installing Kernel Tweaks."
  ui_print "[1] Continue."
  sleep 0.8
  ui_print "[2] Cancel."
  sleep 0.8
  ui_print "[*] Select which you want:"
  SM3=1
  while true
  do
   ui_print "   $SM3"
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
   1) FCTEXTAD3="Yes.";;
   2) FCTEXTAD3="*Cancelled*";;
  esac
 
  ui_print "[*] Selected: $FCTEXTAD3 "
 
  if [[ "$FCTEXTAD3" == "*Cancelled*" ]]; then
  rm -rf "$TMPDIR"/system/bin/XPERF.sh && rm -rf "$TMPDIR"/system/bin/xqcom.sh
  fi
  
  if [[ "$FCTEXTAD3" == "Yes." ]]; then
  true
  fi
 }
 
 XNET(){
  ui_print "[!] installing Network Tweaks."
  ui_print "[1] Continue."
  sleep 0.8
  ui_print "[2] Cancel."
  sleep 0.8
  ui_print "[*] Select which you want:"
  SM1=1
  while true
  do
   ui_print "   $SM1"
   if $VKSEL
   then
    SM1=$((SM1 + 1))
   else
    break
   fi
   if [ $SM1 -gt "2" ]
   then
    SM1=1
   fi
  done
 
  case $SM1 in
   1) FCTEXTAD2="Yes.";;
   2) FCTEXTAD2="*Cancelled*";;
  esac
 
  ui_print "[*] Selected: $FCTEXTAD2 "
 
  if [[ "$FCTEXTAD2" == "*Cancelled*" ]]; then
   rm -rf "$TMPDIR"/system/bin/XNET.sh
  fi
 
  if [[ "$FCTEXTAD2" == "Yes." ]]; then
   true
  fi
 }
 prepare_thermals
 XPERF
 XNET
}

if [[ "$LEGACYSETUP" == "1" ]]; then
 # Multi Language Support
 MULTILANGSUPPORT=falseٍ
 ui_print "[*] Starting Legacy Setup Engine..."
 sleep 0.8
 Legacy_Setup
else
 MULTILANGSUPPORT=true
fi

# Custom var
MODDIR=/data/adb/modules
PATH1="/system/vendor/etc/"
THERMAL=$($bb grep File empty by default "${PATH1}thermal-engine.conf" | $bb sed "s/#//")
LANG=$(getprop persist.sys.locale)

# soc=$(getprop ro.soc.model)         # UNDERTESTING 
# soc=$(getprop ro.chipname)          # UNDERTESTING
# soc=$(getprop ro.board.platform)    # UNDERTESTING      
# soc=$(getprop ro.product.board)     # UNDERTESTING     
# soc=$(getprop ro.product.platform)  # UNDERTESTING        

# Preparing test and rest settings
prepare_for_confliction_en(){
 ui_print "[*] Preparing..."
 sleep 1.5
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
}
prepare_thermals_en(){
 if [[ $(getprop ro.board.platform) == "SM7125" ]]; then
     ui_print "[*] Detected Device SoC: SDM720G"
     ui_print "[?] Would You like to Continue"
     ui_print "[1] Continue."
     sleep 0.8
     ui_print "[2] Cancel."
     sleep 0.8
     ui_print "[*] Select which you want:"
     SM1=1
     while true
     do
      ui_print "   $SM1"
      if $VKSEL
      then
       SM1=$((SM1 + 1))
      else
       break
      fi
      if [ $SM1 -gt 2 ]
      then
       SM1=1
      fi
     done
 
     case $SM3 in
      1) FCTEXTAD1="Yes.";;
      2) FCTEXTAD1="*Cancelled*";;
     esac
 
     ui_print "[*] Selected: $FCTEXTAD1 "
     if [[ "$FCTEXTAD1" == "Yes." ]]; then
      setprop persist.thermodx.thermal.mode extreme
      unzip -o "$ZIPFILE" 'Thermal720g/*' -d "$TMPDIR" >&2 && cp -af "$TMPDIR"/Thermal720g/* "$MODPATH"/system
     fi

 elif [[ $(getprop ro.board.platform) == "SDM710" ]]; then
     ui_print "[*] Detected Device SoC: SDM710"
     ui_print "[?] Would You like to Continue"
     ui_print "[1] Continue."
     sleep 0.8
     ui_print "[2] Cancel."
     sleep 0.8
     ui_print "[*] Select which you want:"
     SM1=1
     while true
     do
      ui_print "   $SM1"
      if $VKSEL
      then
       SM1=$((SM1 + 1))
      else
       break
      fi
      if [ $SM1 -gt 2 ]
      then
       SM1=1
      fi
     done
 
     case $SM3 in
      1) FCTEXTAD1="Yes.";;
      2) FCTEXTAD1="*Cancelled*";;
     esac
 
     ui_print "[*] Selected: $FCTEXTAD1 "
     if [[ "$FCTEXTAD1" == "Yes." ]]; then
      setprop persist.thermodx.thermal.mode extreme
      unzip -o "$ZIPFILE" 'Thermal710/*' -d "$TMPDIR" >&2 && cp -af "$TMPDIR"/Thermal710/* "$MODPATH"/system
     fi

 elif [[ $(getprop ro.board.platform) == "SDM660" ]]; then
     ui_print "[*] Detected Device SoC: SDM660"
     ui_print "[?] Would You like to Continue"
     ui_print "[1] Continue."
     sleep 0.8
     ui_print "[2] Cancel."
     sleep 0.8
     ui_print "[*] Select which you want:"
     SM1=1
     while true
     do
      ui_print "   $SM1"
      if $VKSEL
      then
       SM1=$((SM1 + 1))
      else
       break
      fi
      if [ $SM1 -gt 2 ]
      then
       SM1=1
      fi
     done
 
     case $SM3 in
      1) FCTEXTAD1="Yes.";;
      2) FCTEXTAD1="*Cancelled*";;
     esac
 
     ui_print "[*] Selected: $FCTEXTAD1 "
     if [[ "$FCTEXTAD1" == "Yes." ]]; then
      setprop persist.thermodx.thermal.mode extreme
      unzip -o "$ZIPFILE" 'Thermal660/*' -d "$TMPDIR" >&2 && cp -af "$TMPDIR"/Thermal660/* "$MODPATH"/system
     fi

 elif [[ $(getprop ro.board.platform) == "MSM8937" ]]; then
     ui_print "[*] Detected Device SoC: SDM430"
     ui_print "[?] Would You like to Continue"
     ui_print "[1] Continue."
     sleep 0.8
     ui_print "[2] Cancel."
     sleep 0.8
     ui_print "[*] Select which you want:"
     SM1=1
     while true
     do
      ui_print "   $SM1"
      if $VKSEL
      then
       SM1=$((SM1 + 1))
      else
       break
      fi
      if [ $SM1 -gt 2 ]
      then
       SM1=1
      fi
     done
 
     case $SM3 in
      1) FCTEXTAD1="Yes.";;
      2) FCTEXTAD1="*Cancelled*";;
     esac
 
     ui_print "[*] Selected: $FCTEXTAD1 "
     if [[ "$FCTEXTAD1" == "Yes." ]]; then
      setprop persist.thermodx.thermal.mode extreme
      unzip -o "$ZIPFILE" 'Thermal430/*' -d "$TMPDIR" >&2 && cp -af "$TMPDIR"/Thermal430/* "$MODPATH"/system
     fi

 elif [[ $(getprop ro.board.platform) == "MSM8996" ]]; then
     ui_print "[*] Detected Device SoC: SDM820"
     ui_print "[?] Would You like to Continue"
     ui_print "[1] Continue."
     sleep 0.8
     ui_print "[2] Cancel."
     sleep 0.8
     ui_print "[*] Select which you want:"
     SM1=1
     while true
     do
      ui_print "   $SM1"
      if $VKSEL
      then
       SM1=$((SM1 + 1))
      else
       break
      fi
      if [ $SM1 -gt 2 ]
      then
       SM1=1
      fi
     done
 
     case $SM3 in
      1) FCTEXTAD1="Yes.";;
      2) FCTEXTAD1="*Cancelled*";;
     esac
 
     ui_print "[*] Selected: $FCTEXTAD1 "
     if [[ "$FCTEXTAD1" == "Yes." ]]; then
      setprop persist.thermodx.thermal.mode extreme
      unzip -o "$ZIPFILE" 'Thermal820/*' -d "$TMPDIR" >&2 && cp -af "$TMPDIR"/Thermal820/* "$MODPATH"/system
     fi
 elif [[ "$THERMAL" == "File empty by default" ]]; then
     ui_print "[*] Detected Device Thermal Type: Empty"
     ui_print "[?] Would You like to Configuring it"
     ui_print "[1] Continue."
     sleep 0.8
     ui_print "[2] Cancel."
     sleep 0.8
     ui_print "[*] Select which you want:"
     SM1=1
     while true
     do
      ui_print "   $SM1"
      if $VKSEL
      then
       SM1=$((SM1 + 1))
      else
       break
      fi
      if [ $SM1 -gt 2 ]
      then
       SM1=1
      fi
     done
 
     case $SM3 in
      1) FCTEXTAD1="Yes.";;
      2) FCTEXTAD1="*Cancelled*";;
     esac
 
     ui_print "[*] Selected: $FCTEXTAD1 "
     if [[ "$FCTEXTAD1" == "Yes." ]]; then
      setprop persist.thermodx.thermal.mode extreme
      unzip -o "$ZIPFILE" 'Thermalempty/*' -d "$TMPDIR" >&2 && cp -af "$TMPDIR"/Thermalempty/* "$MODPATH"/system
     fi
 else
  ui_print "[*] Device Unsupported, Skipping Thermal installation..."
 fi
}
XPERF_en(){
 ui_print "[!] installing Kernel Tweaks."
 ui_print "[1] Continue."
 sleep 0.8
 ui_print "[2] Cancel."
 sleep 0.8
 ui_print "[*] Select which you want:"
 SM3=1
 while true
 do
  ui_print "   $SM3"
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
  1) FCTEXTAD3="Yes.";;
  2) FCTEXTAD3="*Cancelled*";;
 esac
 
 ui_print "[*] Selected: $FCTEXTAD3 "
 
 if [[ "$FCTEXTAD3" == "*Cancelled*" ]]; then
 rm -rf "$TMPDIR"/system/bin/XPERF.sh && rm -rf "$TMPDIR"/system/bin/xqcom.sh
 fi
}
XNET_en(){
 ui_print "[!] installing Network Tweaks."
 ui_print "[1] Continue."
 sleep 0.8
 ui_print "[2] Cancel."
 sleep 0.8
 ui_print "[*] Select which you want:"
 SM1=1
 while true
 do
  ui_print "   $SM1"
  if $VKSEL
  then
   SM1=$((SM1 + 1))
  else
   break
  fi
  if [ $SM1 -gt "2" ]
  then
   SM1=1
  fi
 done
 
 case $SM1 in
  1) FCTEXTAD2="Yes.";;
  2) FCTEXTAD2="*Cancelled*";;
 esac
 
 ui_print "[*] Selected: $FCTEXTAD2 "
 
 if [[ "$FCTEXTAD2" == "*Cancelled*" ]]; then
 rm -rf "$TMPDIR"/system/bin/XNET.sh
 fi
}
notes_en(){
 sleep 1
 ui_print "[*] ThermodX has been installed successfully."
 sleep 1.5
 ui_print "[-] Additional Notes:"
 ui_print "[*] Reboot is required"
 ui_print "[*] Do not use ThermodX with other optimizer modules"
 ui_print "[*] Report issues to @xprjkts_chat on Telegram"
 ui_print "[*] find me at imUsiF12 @ telegram for direct support"
 sleep 4
}

# Preparing test and rest settings (AR)
prepare_for_confliction_ar(){
 ui_print "[*] يتم التحضير..."
 sleep 1.5
 if [ -d $MODDIR/KTSR ]; then
 ui_print "[*] KTSR اضافة موجودة, تم الغاءها لأسباب أمنية"
 touch $MODDIR/KSTR/disable
 
 elif [ -d $MODDIR/FDE ]; then
 ui_print "[*] FDE.AI اضافة موجودة, تم الغاءها لأسباب أمنية"
 touch $MODDIR/FDE/disable
 
 elif [ -d $MODDIR/MAGNETAR ]; then
 ui_print "[*] MAGNETAR اضافة موجودة, تم الغاءها لأسباب أمنية."
 touch $MODDIR/MAGNETAR/disable
 
 elif [ -d $MODDIR/ZeetaaTweaks ]; then
 ui_print "[*] ZeetaaTweaks اضافة موجودة, تم الغاءها لأسباب أمنية."
 touch $MODDIR/ZeetaaTweaks/disable
 
 elif [ -d $MODDIR/KTSRPRO ]; then
 ui_print "[*] KTSR PRO اضافة موجودة, تم الغاءها لأسباب أمنية."
 touch $MODDIR/KTSRPRO/disable
 
 elif [ -d $MODDIR/ZTS ]; then
 ui_print "[*] ZTS اضافة موجودة, تم الغاءها لأسباب أمنية."
 touch $MODDIR/ZTS/disable
 
 elif [ -d $MODDIR/Pulsar_Engine ]; then
 ui_print "[*] Pulsar Engine اضافة موجودة, تم الغاءها لأسباب أمنية."
 touch $MODDIR/Pulsar_Engine/disable
 
 elif [ -d $MODDIR/ktweak ]; then
 ui_print "[*] KTweak اضافة موجودة, تم الغاءها لأسباب أمنية."
 touch $MODDIR/ktweak/disable
 
 elif [ -d $MODDIR/high_perf_dac ]; then
 ui_print "[*] HIGH PERFORMANCE اضافة موجودة, تم الغاءها لأسباب أمنية."
 touch $MODDIR/high_perf_dac/disable
 
 elif [ -d $MODDIR/fkm_spectrum_injector ]; then
 ui_print "[*] FKM Injector اضافة موجودة, تم الغاءها لأسباب أمنية."
 touch $MODDIR/fkm_spectrum_injector/disable
 
 elif [ -d $MODDIR/toolbox8 ]; then
 ui_print "[*] Pandora's Box اضافة موجودة, تم الغاءها لأسباب أمنية."
 touch $MODDIR/MAGNETAR/disable
 
 elif [ -d $MODDIR/lazy ]; then
 ui_print "[*] Lazy Tweaks اضافة موجودة, تم الغاءها لأسباب أمنية."
 touch $MODDIR/lazy/disable
 
 elif [ "$(pm list package ktweak)" ]; then
 ui_print "[*] KTweak موجود , أزله لتجنب التعارض \ التضارب"
 
 elif [ "$(pm list package kitana)" ]; then
 ui_print "[*] Kitana موجود , أزله لتجنب التعارض \ التضارب"
 
 elif [ "$(pm list package magnetarapp)" ]; then
 ui_print "[*] MAGNETAR موجود , أزله لتجنب التعارض \ التضارب"
 
 elif [ "$(pm list package lsandroid)" ]; then
 ui_print "[*] LSpeed موجود , أزله لتجنب التعارض \ التضارب"
 
 elif [ "$(pm list package feravolt)" ]; then
 ui_print "[*] FDE.AI موجود , أزله لتجنب التعارض \ التضارب"
 fi
}
prepare_thermals_ar(){
 if [[ $(getprop ro.board.platform) == "SM7125" ]]; then
     ui_print "[*] نوع المعالج: SDM720G"
     ui_print "[?] هل تود المتابعة"
     ui_print "[1] نعم."
     sleep 0.8
     ui_print "[2] لا."
     sleep 0.8
     ui_print "[*] اختر ما تود:"
     SM1=1
     while true
     do
      ui_print "   $SM1"
      if $VKSEL
      then
       SM1=$((SM1 + 1))
      else
       break
      fi
      if [ $SM1 -gt 2 ]
      then
       SM1=1
      fi
     done
 
     case $SM3 in
      1) FCTEXTAD1="نعم.";;
      2) FCTEXTAD1="*تم الالغاء*";;
     esac
 
     ui_print "[*] تم اختيار: $FCTEXTAD1 "
     if [[ "$FCTEXTAD1" == "نعم." ]]; then
      setprop persist.thermodx.thermal.mode extreme
      unzip -o "$ZIPFILE" 'Thermal720g/*' -d "$TMPDIR" >&2 && cp -af "$TMPDIR"/Thermal720g/* "$MODPATH"/system
     fi

 elif [[ $(getprop ro.board.platform) == "SDM710" ]]; then
     ui_print "[*] نوع المعالج: SDM710"
     ui_print "[?] هل تود المتابعة"
     ui_print "[1] نعم."
     sleep 0.8
     ui_print "[2] لا."
     sleep 0.8
     ui_print "[*] اختر ما تود:"
     SM1=1
     while true
     do
      ui_print "   $SM1"
      if $VKSEL
      then
       SM1=$((SM1 + 1))
      else
       break
      fi
      if [ $SM1 -gt 2 ]
      then
       SM1=1
      fi
     done
 
     case $SM3 in
      1) FCTEXTAD1="نعم.";;
      2) FCTEXTAD1="*تم الالغاء*";;
     esac
 
     ui_print "[*] تم اختيار: $FCTEXTAD1 "
     if [[ "$FCTEXTAD1" == "نعم." ]]; then
      setprop persist.thermodx.thermal.mode extreme
      unzip -o "$ZIPFILE" 'Thermal710/*' -d "$TMPDIR" >&2 && cp -af "$TMPDIR"/Thermal710/* "$MODPATH"/system
     fi

 elif [[ $(getprop ro.board.platform) == "SDM660" ]]; then
     ui_print "[*] نوع المعالج: SDM660"
     ui_print "[?] هل تود المتابعة"
     ui_print "[1] نعم."
     sleep 0.8
     ui_print "[2] لا."
     sleep 0.8
     ui_print "[*] اختر ما تود:"
     SM1=1
     while true
     do
      ui_print "   $SM1"
      if $VKSEL
      then
       SM1=$((SM1 + 1))
      else
       break
      fi
      if [ $SM1 -gt 2 ]
      then
       SM1=1
      fi
     done
 
     case $SM3 in
      1) FCTEXTAD1="نعم.";;
      2) FCTEXTAD1="*تم الالغاء*";;
     esac
 
     ui_print "[*] تم اختيار: $FCTEXTAD1 "
     if [[ "$FCTEXTAD1" == "نعم." ]]; then
      setprop persist.thermodx.thermal.mode extreme
      unzip -o "$ZIPFILE" 'Thermal660/*' -d "$TMPDIR" >&2 && cp -af "$TMPDIR"/Thermal660/* "$MODPATH"/system
     fi

 elif [[ $(getprop ro.board.platform) == "MSM8937" ]]; then
     ui_print "[*] نوع المعالج: SDM430"
     ui_print "[?] هل تود المتابعة"
     ui_print "[1] نعم."
     sleep 0.8
     ui_print "[2] لا."
     sleep 0.8
     ui_print "[*] اختر ما تود:"
     SM1=1
     while true
     do
      ui_print "   $SM1"
      if $VKSEL
      then
       SM1=$((SM1 + 1))
      else
       break
      fi
      if [ $SM1 -gt 2 ]
      then
       SM1=1
      fi
     done
 
     case $SM3 in
      1) FCTEXTAD1="نعم.";;
      2) FCTEXTAD1="*تم الالغاء*";;
     esac
 
     ui_print "[*] تم اختيار: $FCTEXTAD1 "
     if [[ "$FCTEXTAD1" == "نعم." ]]; then
      setprop persist.thermodx.thermal.mode extreme
      unzip -o "$ZIPFILE" 'Thermal430/*' -d "$TMPDIR" >&2 && cp -af "$TMPDIR"/Thermal430/* "$MODPATH"/system
     fi

 elif [[ $(getprop ro.board.platform) == "MSM8996" ]]; then
     ui_print "[*] نوع المعالج: SDM820"
     ui_print "[?] هل تود المتابعة"
     ui_print "[1] نعم."
     sleep 0.8
     ui_print "[2] لا."
     sleep 0.8
     ui_print "[*] اختر ما تود:"
     SM1=1
     while true
     do
      ui_print "   $SM1"
      if $VKSEL
      then
       SM1=$((SM1 + 1))
      else
       break
      fi
      if [ $SM1 -gt 2 ]
      then
       SM1=1
      fi
     done
 
     case $SM3 in
      1) FCTEXTAD1="Yes.";;
      2) FCTEXTAD1="*Cancelled*";;
     esac
 
     ui_print "[*] تم اختيار: $FCTEXTAD1 "
     if [[ "$FCTEXTAD1" == "Yes." ]]; then
      setprop persist.thermodx.thermal.mode extreme
      unzip -o "$ZIPFILE" 'Thermal820/*' -d "$TMPDIR" >&2 && cp -af "$TMPDIR"/Thermal820/* "$MODPATH"/system
     fi
 elif [[ "$THERMAL" == "File empty by default" ]]; then
     ui_print "[*] نوعية الثرمال المكتشفة: فارغة"
     ui_print "[?] هل تود تهيئتها"
     ui_print "[1] نعم."
     sleep 0.8
     ui_print "[2] لا."
     sleep 0.8
     ui_print "[*] اختر ما تود"
     SM1=1
     while true
     do
      ui_print "   $SM1"
      if $VKSEL
      then
       SM1=$((SM1 + 1))
      else
       break
      fi
      if [ $SM1 -gt 2 ]
      then
       SM1=1
      fi
     done
 
     case $SM3 in
      1) FCTEXTAD1="نعم.";;
      2) FCTEXTAD1="*Cancelled*";;
     esac
 
     ui_print "[*] تم اختيار: $FCTEXTAD1 "
     if [[ "$FCTEXTAD1" == "نعم." ]]; then
      setprop persist.thermodx.thermal.mode extreme
      unzip -o "$ZIPFILE" 'Thermalempty/*' -d "$TMPDIR" >&2 && cp -af "$TMPDIR"/Thermalempty/* "$MODPATH"/system
     fi
 else
  ui_print "[*]  الجهاز غير مدعوم , يتم التخظي تنزيل الثرمال..."
 fi
}
XPERF_ar(){
 ui_print "[!] هل تود تعزيز النواة \ الكيرنل."
 ui_print "[1] نعم."
 sleep 0.8
 ui_print "[2] لا."
 sleep 0.8
 ui_print "[*] اختر ما تود:"
 SM3=1
 while true
 do
  ui_print "   $SM3"
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
  1) FCTEXTAD3="نعم.";;
  2) FCTEXTAD3="*تم الالغاء*";;
 esac
 
 ui_print "[*] تم اختيار: $FCTEXTAD3 "
 
 if [[ "$FCTEXTAD3" == "*تم الالغاء*" ]]; then
 rm -rf "$TMPDIR"/system/bin/XPERF.sh && rm -rf "$TMPDIR"/system/bin/xqcom.sh
 fi
}
XNET_ar(){
 ui_print "[!] هل تود تعزيز الشبكة."
 ui_print "[1] نعم."
 sleep 0.8
 ui_print "[2] لا."
 sleep 0.8
 ui_print "[*] اختر ما تود:"
 SM1=1
 while true
 do
  ui_print "   $SM1"
  if $VKSEL
  then
   SM1=$((SM1 + 1))
  else
   break
  fi
  if [ $SM1 -gt "2" ]
  then
   SM1=1
  fi
 done
 
 case $SM1 in
  1) FCTEXTAD2="نعم.";;
  2) FCTEXTAD2="*تم الالغاء*";;
 esac
 
 ui_print "[*] تم اختيار: $FCTEXTAD2 "
 
 if [[ "$FCTEXTAD2" == "*تم الالغاء*" ]]; then
 rm -rf "$TMPDIR"/system/bin/XNET.sh
 fi
}
notes_ar(){
 sleep 1
 ui_print "[*] تم تنزيل الاضافة بنجاح"
 sleep 1.5
 ui_print "[-] ملحوظات اضافية:"
 ui_print "[*] يجب اعادة التشغيل"
 ui_print "[*] لا تستدخدم هذه الاضافه مع المعززات الاخريات"
 ui_print "[*] للابلاغ عن مشكل: يجب زيارة قناتنا في التلجرام: @xprjkts_chat"
 ui_print "[*] للابلاغ عن مشكل \ الخ : @imUsiF12 في التلجرام"
 sleep 4
}

if [[ "$exynos" == "true" ]]; then
 mod_info_print_en
 ui_print "[!] ThermodX is not designed for Exynos SoC's, aborting..."
 abort
fi

# Language Check
if [[ "$MULTILANGSUPPORT" == "true" ]]; then
 if [[ $(getprop persist.sys.locale) == *"ar-*"* ]]; then
  mod_info_print_ar
  if [[ "$mtk" == "true" ]]; then
   prepare_for_confliction_ar
   ui_print "[*] رفع الصوت = للأختيار × خفص الصوت = تأكيد"
   # Load Vol Key Selector
   . $TMPDIR/addon/Volume-Key-Selector/install_ar.sh
   XPERF_ar
   XNET_ar
  fi
  if [[ "$qcom" == "true" ]]; then 
   prepare_for_confliction_ar
   ui_print "[*] رفع الصوت = للأختيار × خفص الصوت = تأكيد"
   # Load Vol Key Selector
   . $TMPDIR/addon/Volume-Key-Selector/install_ar.sh
   prepare_thermals_ar
   XPERF_ar
   XNET_ar
  fi
 else
  mod_info_print_en
  if [[ "$mtk" == "true" ]]; then
   prepare_for_confliction_en
   # Load Vol Key Selector
   . $TMPDIR/addon/Volume-Key-Selector/install.sh
   XPERF_en
   XNET_en
  fi
  if [[ "$qcom" == "true" ]]; then
   prepare_for_confliction_en
   prepare_thermals_en
   # Load Vol Key Selector
   . $TMPDIR/addon/Volume-Key-Selector/install.sh
   XPERF_en
   XNET_en
  fi
 fi

elif [[ "$MULTILANGSUPPORT" == "false1" ]]; then
 mod_info_print_en
 prepare_for_confliction_en
 ui_print "[*] Volume + = Switch × Volume - = Select "
 # Load Vol Key Selector
 . $TMPDIR/addon/Volume-Key-Selector/install.sh
 prepare_thermals_en
 XPERF_en
 XNET_en
fi

# Set permissions
set_permissions(){
 set_perm_recursive "$MODPATH" 0 0 0755 0644
 set_perm_recursive "$MODPATH/system/bin" 0 0 0755 0755
 set_perm_recursive "$MODPATH/system/vendor/etc" 0 0 0755 0755
 set_perm_recursive "$MODPATH/script" 0 0 0755 0755
 set_perm_recursive "$MODPATH/bin" 0 0 0755 0755
}

set_permissions