#!/system/bin/sh
##########################################################################################
#
# Mikasa Fast - Service Script
# Runs on boot to maintain performance and sound tweaks
# Author: anothernop
#
##########################################################################################

MODDIR=${0%/*}
LOGFILE=/data/local/tmp/mikasa_fast.log

# Wait for boot completion
while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 1
done

sleep 30

log_message() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> $LOGFILE
}

log_message "========================================="
log_message "Mikasa Fast Service Started"
log_message "========================================="

# Apply CPU tweaks
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/; do
  if [ -f "${cpu}scaling_governor" ]; then
    echo 'schedutil' > "${cpu}scaling_governor" 2>/dev/null
  fi
done

# Apply GPU tweaks
if [ -d "/sys/class/kgsl/kgsl-3d0" ]; then
  echo 'performance' > /sys/class/kgsl/kgsl-3d0/devfreq/governor 2>/dev/null
fi

# Apply VM tweaks
echo '60' > /proc/sys/vm/swappiness 2>/dev/null
echo '100' > /proc/sys/vm/vfs_cache_pressure 2>/dev/null

# Apply I/O tweaks
for queue in /sys/block/*/queue/; do
  [ -f "${queue}read_ahead_kb" ] && echo '2048' > "${queue}read_ahead_kb" 2>/dev/null
done

# Apply audio properties
setprop af.resampler.quality 4 2>/dev/null
setprop vendor.audio.offload.track.enable true 2>/dev/null
setprop vendor.audio.feature.compress_offload.enable true 2>/dev/null

log_message "All tweaks applied successfully"

# Monitor and maintain
while true; do
  sleep 600
  for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    [ -f "$cpu" ] && echo 'schedutil' > "$cpu" 2>/dev/null
  done
done
