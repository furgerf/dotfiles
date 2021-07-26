#!/bin/bash
# Default acpi script that takes an entry for all actions
# /etc/acpi/handler.sh

case "$1" in
  ac_adapter)
    DISPLAY=:0 /home/fabian/git/linux-scripts/backlight on
    ;;
  button/lid)
    ;;
  button/wlan)
    ;;
  jack/lineout)
    ;;
  jack/videoout)
    ;;
  jack/headphone)
    ;;
  jack/microphone)
    ;;
  cd/play)
    ;;
  button/mute)
    ;;
  button/f20)
    ;;
  button/volumeup)
    ;;
  button/volumedown)
    ;;
  button/screenlock)
    ;;
  button/sleep)
    ;;
  video/brightnessup)
    ;;
  video/brightnessdown)
    ;;
  battery)
    ;;
  processor)
    ;;
  thermal_zone)
    ;;
  95F24279-4D7B-)
    ;;
  *)
    logger "ACPI group/action not handled: $1 / $2"
    ;;
esac

