# External Tools
chmod -R 0755 $MODPATH/common/addon/Volume-Key-Selector/tools

chooseport_legacy() {
  # Keycheck binary by someone755 @Github, idea for code below by Zappo @xda-developers
  # Calling it first time detects previous input. Calling it second time will do what we want
	if [ $1 == * ]; then
		set delay=$1
	else
		set delay=3
	fi
	error=false
	while true; do
		timeout $delay $MODPATH/common/addon/Volume-Key-Selector/tools/arm/keycheck
		local sel=$?
		if [ $sel == 42 ]; then
			return 0
		elif [ $sel == 41 ]; then
			return 1
			error=true
		elif $error; then
			abort "Volume key not detected!"
		else
			echo "Volume key not detected. Try again"
		fi
	done
}

chooseport() {
  # Original idea by chainfire and ianmacd @xda-developers
  [ "$1" ] && local delay=$1 || local delay=3
  local error=false
  while true; do
    local count=0
    while true; do
      timeout $delay /system/bin/getevent -lqc 1 2>&1 > $TMPDIR/events &
      sleep 0.5; count=$((count + 1))
      if (`grep -q 'KEY_VOLUMEUP *DOWN' $TMPDIR/events`); then
        return 0
      elif (`grep -q 'KEY_VOLUMEDOWN *DOWN' $TMPDIR/events`); then
        return 1
      fi
      [ $count -gt 6 ] && break
    done
    if $error; then
      echo "Volume key not detected. Trying keycheck method"
      export chooseport=chooseport_legacy VKSEL=chooseport_legacy
      chooseport_legacy $delay
      return $?
    else
      error=true
      echo "Volume key not detected. Try again"
    fi
  done
}

# Keep old variable from previous versions of this
VKSEL=chooseport
