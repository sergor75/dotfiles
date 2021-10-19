#!/bin/sh
#
# Switch keyboard layout
#
PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin"

[[ "$(setxkbmap -query | awk '/^layout:/ { print $2 }')" = "ru" ]] \
  && ( setxkbmap -layout us; notify-send 'Keyboard' ' US' ) \
  || ( setxkbmap -layout ru; notify-send 'Keyboard' ' RU' )

exit 0
#EOF
