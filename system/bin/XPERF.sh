#!/system/bin/sh
#ThermodX™ 1301 R Beta program

LOGPATH="/storage/emulated/0/XCORE/"

# Reducing Some System load
reduce_system_loads() {
if [ -f "/sys/module" ];then
 echo "0" > /sys/module/debug/parameters/enable_event_log && echo "0" > /sys/module/glink/parameters/debug_mask && echo "0" > /sys/module/usb_bam/parameters/enable_event_log && echo "Y" > /sys/module/printk/parameters/console_suspend && echo "Y" > /sys/module/printk/parameters/ignore_loglevel && echo "N" > /sys/module/printk/parameters/time && echo "Y" > /sys/module/bluetooth/parameters/disable_ertm && echo "Y" > /sys/module/bluetooth/parameters/disable_esco && echo "0" > /sys/module/hid_apple/parameters/fnmode && echo "N" > /sys/module/ip6_tunnel/parameters/log_ecn_error && echo "0" > /sys/module/lowmemorykiller/parameters/debug_level && echo "0" > /sys/module/msm_smd_pkt/parameters/debug_mask &&  echo "N" > /sys/module/sit/parameters/log_ecn_error && echo "0" > /sys/module/smp2p/parameters/debug_mask && echo "0" > /sys/module/hid/parameters/ignore_special_drivers && echo "N" > /sys/module/hid_magicmouse/parameters/emulate_3button && echo "N" > /sys/module/hid_magicmouse/parameters/emulate_scroll_wheel && echo "0" > /sys/module/hid_magicmouse/parameters/scroll_speed && echo "1" > /sys/module/subsystem_restart/parameters/disable_restart_work && echo "0" > /sys/module/rmnet_data/parameters/rmnet_data_log_level
echo "0" > /sys/module/binder/parameters/debug_mask
echo "0" > /sys/module/service_locator/parameters/enable
fi
}
# Turn off some useless kernel modules that are not needed & never used
adaptions() {
if [ -f "/sys/module/diagchar/parameters/diag_mask_clear_param" ];then
echo "0" > /sys/module/diagchar/parameters/diag_mask_clear_param && echo "1" > /sys/module/hid/parameters/ignore_special_drivers && echo "0" > /sys/module/icnss/parameters/dynamic_feature_mask && echo "0" > /sys/module/ppp_generic/parameters/mp_protocol_compress
fi
}

#Disable CPU & Touch Boost (Just incase ur kernel have that shi*)
disable_boost(){
if [ -f "/sys/module/cpu_boost/parameters/boost_ms" ]; then
 echo "0" > /sys/module/cpu_boost/parameters/boost_ms
 
elif [ -f "/sys/module/msm_performance/parameters/touchboost" ]; then
 echo "0" > /sys/module/msm_performance/parameters/touchboost
 
elif [ -f /sys/power/pnpmgr/touch_boost ]; then
 echo "0" > /sys/power/pnpmgr/touch_boost
fi
}

other_tweaks(){
# VM Tweaks
echo 0 > /proc/sys/vm/oom_dump_tasks

for queue in /sys/block/*/queue; do
   echo 0 > "${queue}"/add_random
   echo 0 > "${queue}"/iostats
   echo 1 > "${queue}"/rq_affinity
   echo 0 > "${queue}"/rotational
   echo 0 > "${queue}"/iosched/slice_idle
   echo 1 > "${queue}"/iosched/group_idle
done
}

ffcharge(){
# Enable FFcharging
ffcharge=/sys/kernel/fast_charge/force_fast_charge
if [ -e $ffcharge ]; then
echo 1 > $ffcharge
 fi
}

msm_t_tweaks(){
# For thermal
if [ -e "/sys/module/msm_thermal/parameters/enabled" ];then
echo 0 > /sys/module/msm_thermal/parameters/enabled

elif [ -e "/sys/module/msm_thermal/vdd_restriction/enable" ];then
echo 0 > /sys/module/msm_thermal/vdd_restriction/enable
fi
}

# Entropy (Stock bess)
if [ -e "/proc/sys/kernel/random/*" ];then
echo 1000 > /proc/sys/kernel/random/read_wakeup_threshold && echo 1000 > /proc/sys/kernel/random/write_wakeup_threshold
fi

#Props
resetprop debug.hwui.renderer skiavk

# Disable Adreno GPU logging

adreno_GPU_log_disable(){
if [ -e "/sys/kernel/debug/kgsl/kgsl-3d0" ];then
echo 0 > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_drv && echo 0 > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_ctxt && echo 0 > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_cmd && echo 0 > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_pwr && echo 0 > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_mem
fi
}

etc_tweaks(){
# Disable various forms of debugging to reduce overhead
echo off > /proc/sys/kernel/printk_devkmsg
echo "0 0 0 0" > /proc/sys/kernel/printk
echo 0 > /proc/sys/debug/exception-trace
echo 0 > /sys/kernel/debug/tracing/tracing_on
echo 0 > /proc/sys/vm/oom_dump_tasks
echo N > /sys/kernel/debug/debug_enabled
echo 0 > /proc/sys/vm/block_dump
echo 0 > /sys/module/subsystem_restart/parameters/enable_ramdumps
echo 0 > /sys/module/rmnet_data/parameters/rmnet_data_log_level
echo 0 > /proc/sys/kernel/compat-log

# Increase VM stat interval to 10 secends to reduce load
echo 10 > /proc/sys/vm/stat_interval
# Disable read ahead for swap
echo 0 > /proc/sys/vm/page-cluster
# When we kill a task, clean its memory footprint to free up whatever amount of RAM it was consuming
echo 1 > /proc/sys/vm/reap_mem_on_sigkill
# Disable dir notifier service to reduce overhead
echo 0 > /proc/sys/fs/dir-notify-enable

# Disable checking for hung tasks
echo 0 > /proc/sys/kernel/hung_task_timeout_secs

# GPU tweaks for Adreno GPU recommended by Qualcomm for better performance in their PDF
echo 1 > /sys/class/kgsl/kgsl-3d0/force_no_nap
echo 0 > /sys/class/kgsl/kgsl-3d0/bus_split
echo 0 > /sys/class/kgsl/kgsl-3d0/throttling
echo 1 > /sys/class/kgsl/kgsl-3d0/force_rail_on
echo 1 > /sys/class/kgsl/kgsl-3d0/force_bus_on
echo 1 > /sys/class/kgsl/kgsl-3d0/force_clk_on

# Swap to swap device at a fair rate
echo 100 > /proc/sys/vm/swappiness

# Disable various daemons used for logging/debugging for less load
stop logd
stop statsd
stop traced

# A miscellaneous pm_async tweak that increases the amount of time (in milliseconds) before user processes & kernel threads are being frozen & "put to sleep";
write /sys/power/pm_freeze_timeout 25000

# Disable exception-trace and reduce some overhead that is caused by a certain amount and percent of kernel logging, in case your kernel of choice have it enabled;
write /proc/sys/debug/exception-trace 0
}

reduce_system_loads
echo "[*] Reducing System loads..." >> ${LOGPATH}TX.log
adaptions
echo "[*] Applying parameters adaptions..." >> ${LOGPATH}TX.log
disable_boost
echo "[*] Disabling some useless CPU performance parameters..." >> "${LOGPATH}"TX.log
other_tweaks
echo "[*] Applying VM Tweaks..." >> ${LOGPATH}TX.log
ffcharge
echo "[*] Applying Force Fast Charging..." >> ${LOGPATH}TX.log
msm_t_tweaks
echo "[*] Adapting MSM Thermals..." >> ${LOGPATH}TX.log
adreno_GPU_log_disable
etc_tweaks