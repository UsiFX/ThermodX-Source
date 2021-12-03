#!/system/bin/sh

blue='\e[1;34m' 
green='\e[1;32m' 
purple='\e[1;35m' 
cyan='\e[1;36m' 
red='\e[1;31m' 
white='\e[1;37m'
yellow='\e[01;33m'

LOG="/storage/emulated/0/XCORE/TX_menu.log"
MODPATH="/data/adb/modules/ThermodX.ADB/"

if [ -f /data/adb/magisk/busybox ]; then
 bb="/data/adb/magisk/busybox"
fi

# Fetch info & Vars
VER=$($bb grep versioncodename= "${MODPATH}module.prop" | $bb sed "s/versioncodename=//")
CODENAME=$($bb grep codeName= "${MODPATH}module.prop" | $bb sed "s/codeName=//")
STATUS=$($bb grep Status= "${MODPATH}module.prop" | $bb sed "s/Status=//")
AUTHOR=$($bb grep author= "${MODPATH}module.prop" | $bb sed "s/author=//")
LOGPATH="/storage/emulated/0/XCORE/"

#####################
# BEGIN
#####################

# Debug
set +x

if [ ! -d $(getprop persist.thermodx.thermal.mode) ]
then
 TMODE=UnRegistered
else
 TMODE=$(getprop persist.thermodx.thermal.mode)
fi

echo "[*] TX Menu Started at $(date)" >> ${LOGPATH}TX_menu.log

if [ ! -d set +x ]
then
 # Check ThermodX detection
 if [ ! -e "$MODPATH" ]; then
 echo "[!] ThermodX Module not detected!"
 exit 1
 fi
fi

# CREDIT: https://github.com/fearside/ProgressBar
# ProgressBar <progress> <total>
ProgressBar() {
	# Determine Screen Size
	if [[ ${COLUMNS} -le "57" ]]; then
		var1=2
		var2=20
	else
		var1=4
		var2=40
	fi
	# Process data
	_progress=$((($1 * 100 / $2 * 100) / 100))
	_done=$(((_progress * var1) / 10))
	_left=$((var2 - _done))
	# Build progressbar string lengths
	_done=$(printf "%${_done}s")
	_left=$(printf "%${_left}s")

	# Build progressbar strings and print the ProgressBar line
	printf "\rProgress : ${BGBL}|${N}${_done// /${BGBL}$loadBar${N}}${_left// / }${BGBL}|${N} ${_progress}%%"
}


# cmd & spinner <message>
spinner() {
	PID=$!
	h=0
	anim='-\|/'
	while [[ -d /proc/$PID ]]; do
		h=$(((h + 1) % 4))
		sleep 0.02
		printf "\r${@} [${anim:h:1}]"
	done
}

##############################
# MENU
##############################

# Clear previous stuff
clear

# Functions

  conf_check() {
   PATH1="/system/vendor/etc/"
   while "[.] Checking Thermal Configs"
   do
    if [ ! -e ${PATH1} ]; then
     echo -e "[!] Error Occured."
     THERMAL=Unknown
    else
     if [[ $($bb grep "ThermodX™ empty Configurations" ${PATH1}thermal-engine.conf | $bb sed "s/# //") == "ThermodX™ empty Configurations" ]]
     then
      THERMAL=ThermodX™ empty Configurations
     elif [[ $($bb grep "ThermodX™ sdm660 Configurations" ${PATH1}thermal-engine.conf | $bb sed "s/# //") == "ThermodX™ sdm660 Configurations" ]]
     then
      THERMAL=ThermodX™ sdm660 Configurations
     elif [[ $($bb grep "ThermodX™ sdm710 Configurations" ${PATH1}thermal-engine.conf | $bb sed "s/# //") == "ThermodX™ sdm710 Configurations" ]]
     then
      THERMAL=ThermodX™ sdm710 Configurations
     elif [[ $($bb grep "ThermodX™ sdm710 Configurations" ${PATH1}thermal-engine.conf | $bb sed "s/# //") == "ThermodX™ sdm710 Configurations" ]]
     then
      THERMAL=ThermodX™ sdm720g Configurations
     elif [[ $($bb grep "ThermodX™ sdm430 Configurations" ${PATH1}thermal-engine.conf | $bb sed "s/#//") == " ThermodX™ sdm430 Configurations" ]]
     then
      THERMAL=ThermodX™ sdm430 Configurations
     elif [[ $($bb grep "ThermodX™ sdm820 Configurations" ${PATH1}thermal-engine.conf | $bb sed "s/#//") == " ThermodX™ sdm820 Configurations" ]]
     then
      THERMAL=ThermodX™ sdm820 Configurations
     else
      THERMAL=Unknown
     fi
    fi
  done
  echo -e "[*] Done."
  }

  conf_menu() {
    echo -e "[*] Thermal Type: $THERMAL"
    sleep 0.1
    echo -e "[*] Configuration Mode:"
    sleep 0.1
    echo -e "[*] Current Mode: $TMODE"
    sleep 0.1
    echo -e "[1] Auto (BETA)"
    sleep 0.1
    echo -e "[2] Extreme Throttle"
    sleep 0.1
    echo -e "[3] Battery Friendly"
    sleep 0.1
    echo -e "[4] Default"
    sleep 0.1
    echo -e "[5] Return to main menu."
    sleep 0.1
    echo -e "[0] Get Out."
    echo -e "[Enter]: \c"
    read -r conf_case
    case $conf_case in
     1)
      echo "[*] Coming Soon..."
      sleep 2
      clear

     ;;
     2)
      if [[ $TMODE == "extreme" ]]
      then
       echo -e "[!] Extreme mode already applied, aborting..."
       sleep 2
       clear
       return
      else
       while spinner "applying extreme mode"
       do
        sleep 2
        setprop persist.thermodx.thermal.mode extreme
        cp -af ${MODPATH}Thermalempty/* /system
       done
       echo -e "[*] Done."
       clear
       return
      fi
     ;;
     3)
      if [[ $TMODE == "battery" ]]
      then
       echo -e "[!] Battery mode already applied, aborting..."
       sleep 2
       clear
       return
      else
       while spinner "applying battery mode"
       do
        sleep 2
        setprop persist.thermodx.thermal.mode battery
        cp -af ${MODPATH}Thermalempty/* /vendor/etc
        cp -af ${MODPATH}Thermalempty/* /system/vendor/etc
       done
       echo -e "[*] Done."
       clear
       return
      fi
     ;;
     4)
      if [[ $TMODE == "default" ]]
      then
       echo -e "[!] Default mode already applied, aborting..."
       sleep 2
       clear
       return
      else
       while spinner "applying default settings"
       do
        sleep 2
        setprop persist.thermodx.thermal.mode default
        cp -af ${MODPATH}Thermalempty/* /vendor/etc
        cp -af ${MODPATH}Thermalempty/* /system/vendor/etc
       done
       echo -e "[*] Done."
       clear
       return
      fi
     ;;
     5)
     break 2
     ;;
     0) 
      echo "[*] Done. , Logs saved at /XCORE/TX_menu.log"
      sleep 2.5
      return
     ;;
     *) 
      echo -e "[*] Response error, opening menu again..."
      sleep 2.5
      break 3
     ;;
    esac
}


# MENU                                                       
echo
echo -e $cyan"==========================================="
echo -e $white"         ThermodX Setting up menu"
echo -e $cyan"==========================================="
sleep 0.1
echo
echo -e $white"[1] Configurations Menu"
sleep 0.1
echo -e "[2] Dynamic Thermal Menu"
sleep 0.1
echo -e "[3] Tweaks Menu"
sleep 0.1
echo -e "[4] About/Help"
sleep 0.1
echo -e "[0] Go out."
echo
echo -e "[$cyan Enter$white ]: \c"
read -r choice
case $choice in
1)
 clear
 conf_check
 conf_menu
;;
4) 
 clear
 echo -e $cyan"[*] Author: $white$AUTHOR"
 sleep 0.1
 echo -e $cyan"[*] Codename: $white$CODENAME"
 sleep 0.1
 echo -e $cyan"[*] Version Codename: $white$VER"
 sleep 0.1
 echo -e $cyan"[*] Version Status: $white$STATUS"
 sleep 0.1
 echo -e $cyan"[?] return (y/n)"
 sleep 0.1
 echo -e $cyan"[Enter]: \c"
 read -r case_1
 case $case_1 in
  y)
   clear
   return
  ;;
  n)
   echo "[*] Done. , Logs saved at /XCORE/TX_menu.log"
   sleep 2.5
   exit 0
  ;;
 esac
;;
0) 
 echo "[*] Done. , Logs saved at /XCORE/TX_menu.log"
 sleep 2.5
 exit 0
;;
*) 
 echo -e "[*] Response error, opening menu again..."
 sleep 2.5
 return
;;

esac