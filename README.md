GitHub Markup
=============

This is a shell script + configuration to use an external monitor on a notebook with an Optimus display card, initially based on https://github.com/Bumblebee-Project/Bumblebee/wiki/Multi-monitor-setup 

There's some tweaks:
* share mouse/keyboard/clipboard across the two screens using http://synergy-foss.org/
* root isn't required to start the external monitor. 
* uses Gnome Classic (gnome-session-fallback) instead of XFCE
* copies env variables for GNOME_KEYRING_CONTROL, GNOME_KEYRING_PID, GPG_AGENT_INFO and SSH_AUTH_SOCK on the external monitor so you aren't prompted to type in your password again in the external monitor to access the login keyring (XFCE doesn't seem to need the Gnome ones since it's not Gnome-based). 
* 'xinput enable' doesn't seem to work for me, so using some regexs and xinput set-prop instead

Setup
-------

These instructions are designed for a Ubuntu 12.04 m11xR3 using Gnome Classic connecting to a LG Electronics W1953 monitor, it's probable that you might want to change the xorg files for your monitor and the OptimusStart.sh to match your keyboard/mouse names. 

    # Get a copy of these files
    cd ~
    git clone git://github.com/tungj/bumblebee-m11xr3-external-monitor.git Optimus
    # Install Bumblebee, synergy, perl and killall ; defer to instructions on Bumblebee/Synergy website if this doesn't work
    sudo add-apt-repository ppa:bumblebee/stable
    sudo apt-get install bumbleebee bumblebee-nvidia synergy perl psmisc
    # Edit /etc/bumbleebee/xorg.conf.nvidia as appropriate to setup the external monitor. In my case, I ran 'optirun nvidia-settings -c :8', 'X Server Display Configuration' tweaked the settings, then saved the file as /etc/bumbleebee/xorg.conf.nvidia
    optirun nvidia-settings -c :8
    ... save output to /etc/bumbleebee/xorg.conf.nvidia
    # Run xinput -list, make a note of your keyboard and pointer devices
    xinput -list
    # Edit OptimusStart.sh, replace the section about disabling internal inputs with the names of your keyboards/mice
    # If you're not using Gnome Classic, replace gnome-session-fallback as appropriate. 
    gedit ~/Optimus/OptimusStart.sh
    # Setup synergy's default config file
    ln -s ln -s ~/Optimus/.synergy.conf ~/.synergy.conf
    # Start the external monitor, hopefully everything will work. 
    optirun ~/Optimus/OptimusStart.sh
    
