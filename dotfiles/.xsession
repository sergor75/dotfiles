#!/bin/sh

# isotop first start
if [ -f $HOME/.first.sh ]; then
	sh $HOME/.first.sh
fi

# translations and environment
. $HOME/.profile

LC_CTYPE="en_EN.UTF-8"
LC_MESSAGES="en_EN.UTF-8"
LC_COLLATE="en_EN.UTF-8"
LC_ALL="en_EN.UTF-8"
LANG="ru_RU.UTF-8"
export LC_CTYPE LC_MESSAGES LC_COLLATE LC_ALL LANG

# Disable core dumps
#
ulimit -c 0

# dbus
#if [ -x /usr/local/bin/dbus-launch -a -z "${DBUS_SESSION_BUS_ADDRESS}" ]; then
#    eval `dbus-launch --sh-syntax --exit-with-x11` &
#fi

# autostart

# Load X options
xrdb -merge $HOME/.Xresources
# disable bell
xset b off &
# pick a random wallpaper
#rdmwall $HOME/.wallpapers/ &
rdmwall /usr/local/share/openbsd-backgrounds &
# numpad
numlockx &
# Vi user, be grateful
#xcape -e 'Alt_L=Escape' &
# take care of you eyes, change temperature color
sctd >/dev/null 2>&1 &
# Auto-lock the screen
xidle -timeout 900 -program "/usr/local/bin/slock setxkbmap -layout us" &
# hide cursor
xbanish -i mod4 &
# music player
#mpd &

# clock at top
#slstatus &
#spoon &
# in case of running cwm 
#xclockstatusbar &
#xterm -name termbar -class termbar +cm -e /home/sergor/scripts/termbar &
#polybar -c ~/.config/polybar/mockup top &
$HOME/scripts/polybar

# simple notification daemon
dunst &

# if you have a ThinkPad, the following lines enable TrackPoint
# scrolling by dragging with the middle button.
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation" 1 
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Button" 2 
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Axes" 6 7 4 5

# xcompmgr if available
xdpyinfo | grep -q Composite > /dev/null && \
	xcompmgr -C -t-5 -l-5 -r4.2 -o.8 &

# switch keyboard layouts
#setxkbmap -layout us,ru -option grp:win_space_toggle
setxkbmap -layout us,ru &

# start cwm. No & here
cwm 

# start dwm
#dwm-isotop
#dwm-isotop.orig
