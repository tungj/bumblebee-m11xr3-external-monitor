#! /bin/bash
# Starts a separate X session using Optimus
# and uses separate input devices for each
# must be run as root, with 'optirun'

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

function toggleState {
   local devnames=$(xinput --list | grep -F "$1" | perl -ne 'print $1."\n" if /id=(\d+)/i');
   [ -z "$devnames" ] && { echo "$1" not found; return 1;} 
   for devid in $devnames; do 
    xinput set-prop $devid 'Device Enabled' $2; 
   done;
}

su -c 'synergys' tjin256

# First, disable external inputs on internal screen's X server
# Replace these with the names of your EXTERNAL input devices.
#toggleState "Mouse USB Laser Mouse" 0
#toggleState "CHICONY USB Keyboard" 0

# Save current DISPLAY variable so we can use it later
ORIGDISPLAY=$DISPLAY
# Set display ID to the external screen's X server
DISPLAY=':8'  #<-- This should be the value of 'VirtualDisplay' from earlier.

# Disable internal inputs
# Replace these with the names of your INTERNAL input devices
toggleState "AT Translated Set 2 keyboard" 0
toggleState 'SynPS/2 Synaptics TouchPad' 0

# OWN HACK-Disable everything, use synergy
toggleState "Mouse USB Laser Mouse" 0
toggleState "CHICONY USB Keyboard" 0
/home/tjin256/Optimus/autostart/synergyc_start.sh

# Start another session.  This example is for XFCE or Xubuntu, look up the appropriate
# command for your desktop environment of choice and replace 'xfce4-session'.
# Remember to replace USERNAME with your username.
#su -c xfce4-session tjin256 > /dev/null 2>&1

#su -c 'gnome-session-fallback -a=/home/tjin256/Optimus/autostart' tjin256   
su -c 'gnome-session-fallback' tjin256  > /dev/null 2>&1
# (this script pauses here until the new session ends)

# Switch back to the internal screen's X server
DISPLAY=$ORIGDISPLAY

# Re-enable external inputs on the internal screen's X server

#toggleState "Mouse USB Laser Mouse" 1
#toggleState "CHICONY USB Keyboard" 1

