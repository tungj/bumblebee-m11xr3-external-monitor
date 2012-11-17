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
synergys -n notebook-monitor -a 127.0.0.1

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
synergyc -n external-monitor 127.0.0.1

# Start another session.  This example is using gnome-session-fallback aka Gnome Classic, look up the appropriate
# command for your desktop environment of choice and replace 'gnome-session-fallback'.
sudo -u "$USER" bash -c 'export GNOME_KEYRING_CONTROL="'"$GNOME_KEYRING_CONTROL"'"; export GNOME_KEYRING_PID="'"$GNOME_KEYRING_PID"'"; export SSH_AUTH_SOCK="'"$SSH_AUTH_SOCK"'"; export GPG_AGENT_INFO="'"$GPG_AGENT_INFO"'"; gnome-session-fallback > /dev/null 2>&1'
# (this script pauses here until the new session ends)

# Switch back to the internal screen's X server
DISPLAY=$ORIGDISPLAY
