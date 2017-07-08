#!/bin/bash
# Default acpi script that takes an entry for all actions
# /etc/acpi/handler.sh

case "$1" in
  ac_adapter)
    DISPLAY=:0 su -c - fabian /home/fabian/git/linux-scripts/backlight
    ;;
  button/lid)
    case "$3" in
      close)
        DISPLAY=:0 su -c - fabian slock &
        ;;
      *)
        logger "ACPI action undefined: $3"
        ;;
    esac
    ;;
  button/wlan)
    rfkill list wlan | grep 'Soft blocked: yes'
    if [ "$?" -eq 0 ]; then
      rfkill block wlan
    else
      refkill unblock wlan
    fi
    ;;

    # actions that are handled elsewhere:
    button/mute)
    # handled by awesome
    #amixer sset Master toggle
    ;;
  button/volumeup)
    # handled by awesome
    #amixer sset Master unmute
    #amixer set Master 3%+
    ;;
  button/volumedown)
    # handled by awesome
    #amixer sset Master unmute
    #amixer set Master 3%-
    ;;
  button/screenlock)
    # handled by awesome
    #DISPLAY=:0 su -c - fabian /usr/bin/slock &
    #DISPLAY=:0 su -c - fabian /usr/bin/xset dpms force off
    #DISPLAY=:0 su -c - fabian slock &> /tmp/foo &
    ;;
  button/sleep)
    #DISPLAY=:0 su -c - fabian /usr/bin/slock &
    ;;
  video/brightnessup)
    # handled by awesome
    ;;
  video/brightnessdown)
    # handled by awesome
    ;;
  ibm/hotkey)
    if [ "$2" == "LEN0068:00" ]; then
      /home/fabian/git/linux-scripts/block-bluetooth
    fi
    ;;
  #    cd/play);;
  #    cd/prev);;
  #    cd/next);;
  *)
    logger "ACPI group/action not handled: $1 / $2"
    ;;
esac

