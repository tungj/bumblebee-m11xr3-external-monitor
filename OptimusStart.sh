#! /bin/bash
# Starts a separate X session using Optimus
# and uses separate input devices for each

if [[ $EUID -eq 0 ]]; then
   echo "This script really doesn't need to be run as root" 1>&2
   exit 1
fi

function toggleState {
   local devnames=$(xinput --list | grep -F "$1" | perl -ne 'print $1."\n" if /id=(\d+)/i');
   [ -z "$devnames" ] && { echo "$1" not found; return 1;} 
   for devid in $devnames; do 
    xinput set-prop $devid 'Device Enabled' $2; 
   done;
}

killall synergys && sleep 0.5
synergys -a 127.0.0.1

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
killall synergyc && sleep 0.5; 
synergyc -n tjin256-monitor 127.0.0.1

# Start another session.  This example is for XFCE or Xubuntu, look up the appropriate
# command for your desktop environment of choice and replace 'xfce4-session'.
# Remember to replace USERNAME with your username.
#su -c xfce4-session tjin256 > /dev/null 2>&1
sudo -u "$USER" bash -c 'export GNOME_KEYRING_CONTROL="'"$GNOME_KEYRING_CONTROL"'"; export GNOME_KEYRING_PID="'"$GNOME_KEYRING_PID"'"; export SSH_AUTH_SOCK="'"$SSH_AUTH_SOCK"'"; export GPG_AGENT_INFO="'"$GPG_AGENT_INFO"'"; gnome-session-fallback'
# (this script pauses here until the new session ends)

# Switch back to the internal screen's X server
DISPLAY=$ORIGDISPLAY

# Re-enable external inputs on the internal screen's X server

#toggleState "Mouse USB Laser Mouse" 1
#toggleState "CHICONY USB Keyboard" 1

