#!/system/bin/sh

MODPATH=${0%/*}

ui_print() {
  echo "$1"
}

ui_print "🔊 Installing audio configurations..."

# Install audio_effects.xml
for path in /system/etc /vendor/etc /system/vendor/etc; do
  if [ -f "${path}/audio_effects.xml" ]; then
    mkdir -p "$MODPATH$path"
    cp -f "$MODPATH/audio_configs/audio_effects.xml" "$MODPATH$path/audio_effects.xml"
    chmod 644 "$MODPATH$path/audio_effects.xml"
    ui_print "  ✓ Installed audio_effects.xml to $path"
  fi
done

# Install audio_policy_configuration.xml
for path in /system/etc /vendor/etc /system/vendor/etc; do
  if [ -f "${path}/audio_policy_configuration.xml" ]; then
    mkdir -p "$MODPATH$path"
    cp -f "$MODPATH/audio_configs/audio_policy_configuration.xml" "$MODPATH$path/audio_policy_configuration.xml"
    chmod 644 "$MODPATH$path/audio_policy_configuration.xml"
    ui_print "  ✓ Installed audio_policy_configuration.xml to $path"
  fi
done

# Create system.prop
cat > "$MODPATH/system.prop" << 'EOFPROP'
# Mikasa Fast - Audio Properties
vendor.audio.feature.compress_offload.enable=true
vendor.audio.offload.track.enable=true
vendor.audio.offload.buffer.size.kb=32
vendor.audio.offload.gapless.enabled=true
af.resampler.quality=4
af.fast_track_multiplier=1
audio.deep_buffer.media=true
vendor.audio.adm.buffering.ms=2
persist.vendor.audio.fluence.speaker=true
persist.vendor.audio.fluence.voicecall=true
ro.audio.soundfx.dirac=true
ro.config.media_vol_steps=30
EOFPROP

ui_print "✅ Audio configurations installed"
