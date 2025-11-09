#!/system/bin/sh
##########################################################################################
#
# Magisk Module: Mikasa Fast - Performance & Sound Optimization
# Author: anothernop
# Version: 1.0.0
#
##########################################################################################

##########################################################################################
# Config Flags
##########################################################################################

SKIPUNZIP=0
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=true

##########################################################################################
# Replace list
##########################################################################################

REPLACE="
"

##########################################################################################
# Installation Script
##########################################################################################

print_modname() {
  ui_print " "
  ui_print "╔═══════════════════════════════════════╗"
  ui_print "║      MIKASA FAST MODULE v1.0          ║"
  ui_print "║  Performance & Sound Optimization     ║"
  ui_print "║           by anothernop               ║"
  ui_print "╚═══════════════════════════════════════╝"
  ui_print " "
}

on_install() {
  ui_print "⚙️ Installing Mikasa Fast Module..."
  ui_print " "
  
  # Extract module files
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
  unzip -o "$ZIPFILE" 'audio_configs/*' -d $MODPATH >&2
  
  # Create necessary directories
  mkdir -p $MODPATH/system/vendor/etc
  mkdir -p $MODPATH/system/etc
  
  ui_print "✅ Module files extracted successfully"
  ui_print " "
  
  # Install audio configurations
  sh $MODPATH/install_audio.sh
}

set_permissions() {
  # Set permissions for scripts
  set_perm_recursive $MODPATH 0 0 0755 0644
  set_perm $MODPATH/service.sh 0 0 0755 0755
  set_perm $MODPATH/install_audio.sh 0 0 0755 0755
}

##########################################################################################
# Post Installation
##########################################################################################

ui_print " "
ui_print "╔═══════════════════════════════════════╗"
ui_print "║     APPLYING PERFORMANCE TWEAKS       ║"
ui_print "╚═══════════════════════════════════════╝"
ui_print " "

# Apply initial tweaks
apply_tweaks() {
  ui_print "⚡ Optimizing system parameters..."
  
  # CPU
  for cpu in /sys/devices/system/cpu/cpu*/cpufreq/; do
    if [ -f "${cpu}scaling_governor" ]; then
      chmod 644 "${cpu}scaling_governor" 2>/dev/null
      echo 'schedutil' > "${cpu}scaling_governor" 2>/dev/null
    fi
  done
  
  # GPU
  if [ -d "/sys/class/kgsl/kgsl-3d0" ]; then
    echo 'performance' > /sys/class/kgsl/kgsl-3d0/devfreq/governor 2>/dev/null
  fi
  
  # VM
  echo '60' > /proc/sys/vm/swappiness 2>/dev/null
  echo '100' > /proc/sys/vm/vfs_cache_pressure 2>/dev/null
  
  # I/O
  for queue in /sys/block/*/queue/; do
    [ -f "${queue}read_ahead_kb" ] && echo '2048' > "${queue}read_ahead_kb" 2>/dev/null
  done
  
  ui_print "✅ Performance tweaks applied"
}

apply_tweaks

ui_print " "
ui_print "╔═══════════════════════════════════════╗"
ui_print "║    INSTALLATION COMPLETED! ✅         ║"
ui_print "╚═══════════════════════════════════════╝"
ui_print " "
ui_print "✅ Performance optimizations applied"
ui_print "🔊 Sound quality enhanced"
ui_print "⚡ System tweaks activated"
ui_print "🔄 Reboot recommended for full effect"
ui_print " "
ui_print "═══════════════════════════════════════"
ui_print "  Thanks for using Mikasa Fast!"
ui_print "  Follow @anothernop for more modules"
ui_print "═══════════════════════════════════════"
ui_print " "
