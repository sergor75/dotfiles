# source some aliases
. /etc/ksh.kshrc
test -f $HOME/.aliases && . $HOME/.aliases
test -f $HOME/.functions && . $HOME/.functions

# history
HISTFILE=$HOME/.ksh_hist
HISTSIZE=3000
HISTCONTROL=ignoredups # no doubles

# Disable core dumps
#
ulimit -c 0

export LESSCHARSET=utf-8
export LESS='-F -g -i -M -R -S -w -X -z-4'

# color man-pages persistently
if [[ -x $(command -v most) ]];then
        export MANPAGER='most'
fi

# use colorls if it's installed, plain old ls otherwise
if command -v colorls > /dev/null ; then
  LS='colorls'
else
  LS='ls'
fi
CLICOLOR=1
#LSCOLORS="fxexcxdxbxegedabagacad"
LSCOLORS="GxExcxdxBxegedabagacad"
export LSCOLORS CLICOLOR
export RANGER_LOAD_DEFAULT_RC=FALSE
#export CHROME_FLAGS="--lang=ru_RU --disk-cache-dir=/tmp"

# Prompt
# colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LGRAY='\033[0;37m'
DGRAY='\033[1;30m'
LRED='\033[1;31m'
LGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LBLUE='\033[1;34m'
LPURPLE='\033[1;35m'
LCYAN='\033[1;36m'
WHITE='\033[0;37m'
NC='\033[0m'
GREEN='\e[32m'
YELLOW='\e[33m'
BOLD='\e[1m'

ps1_color()
{
	case "$(id -u)" in
		0) _PS1_COLOR=${RED}  ;;
		*) _PS1_COLOR=${BLUE} ;;
	esac
	printf "%s" "${_PS1_COLOR}"
}

# set prompt red if error
ps1_retvalcol()
{
	case $? in
		0|130) RETVALCOL=${NC}  ;;
		*) RETVALCOL=${RED} ;;
	esac
	printf "%s" "${RETVALCOL}"
}

# pwd on the right
#ps1_pwd()
#{
#	# my PS1 is user@hostname, we need to know how long it is
#	cwd=$(printf "%s" $PWD | sed "s,$HOME,~,")
#	ps1len=$(printf "%s@%s%s" "$(id -un)""$cwd""$(hostname -s)" | wc -m)
#	nspaces=$(($COLUMNS - $ps1len - 1))
#	printf "%*s" $nspaces
#	printf "%s" "$cwd"
#}

#PS1='${NC}$(ps1_color)\u@\h${NC}$(ps1_retvalcol)${BOLD}$(ps1_pwd)${NC}\n\$ '
PS1='\n${NC}$(ps1_color)\u@\h${NC}$(ps1_retvalcol)${BOLD}:\w${NC}\n\$ '
# work in bash
#PS1+='\033[01;33m'
#PS0='\033[00m'

# run previous non-doas command with doas; or retry previous failed doas command
fuck() {
	typeset n=$(fc -l 1 | egrep -v '^[0-9]+[ ]*fuck' | tail -n 1 | cut -d'	' -f1)
	fc -e "ed -s" "$n" <<-EOF
		,v/^doas/s/^/doas /
		w
	EOF
}

# autocompletion
# https://github.com/qbit/dotfiles/blob/master/common/dot_ksh_completions

read_known_hosts() {
        local _file=$1 _line _host

        while read _line ; do
          _line=${_line%%#*} # delete comments
          _line=${_line%%@*} # ignore markers
          _line=${_line%% *} # keep only host field

          [[ -z $_line ]] && continue

          local IFS=,
          for _host in $_line; do
            _host=${_host#\[}
            _host=${_host%%\]*}
            for i in ${HOST_LIST[*]}; do
              [[ $_host == $i ]] && continue 2
            done
            set -s -A HOST_LIST ${HOST_LIST[*]} $_host
          done
        done <$_file
}

[[ -s /etc/ssh/ssh_known_hosts ]] && read_known_hosts /etc/ssh/ssh_known_hosts
[[ -s ~/.ssh/known_hosts ]] && read_known_hosts ~/.ssh/known_hosts

set -A complete_ssh -- ${HOST_LIST[*]}
set -A complete_scp -- ${HOST_LIST[*]}

set -A complete_git -- clone branch add rm checkout fetch show tag commit

# OpenBSD pkg_*
if [ -d /var/db/pkg ]; then
	PKG_LIST=$(ls -1 /var/db/pkg)
	set -A complete_pkg_delete -- $PKG_LIST
	set -A complete_pkg_info -- $PKG_LIST

	set -A complete_pkg_1 -- add check create delete info
	set -A complete_pkg_2 -- $PKG_LIST
fi

set -A complete_rcctl_1 -- disable enable get ls order set
set -A complete_rcctl_2 -- $(ls /etc/rc.d)
set -A complete_kill_1 -- -9 -HUP -INFO -KILL -TERM
set -A complete_signify_1 -- -C -G -S -V
set -A complete_signify_2 -- -q -p -x -c -m -t -z
set -A complete_signify_3 -- -p -x -c -m -t -z
set -A complete_gpg -- --refresh --receive-keys --armor --clearsign --sign --list-key --decrypt --verify --detach-sig
set -A complete_ifconfig_1 -- $(ifconfig | grep ^[a-z] | cut -d: -f1)

pgrep -q vmd >/dev/null 2>&1
if [ $? = 0 ]; then
	set -A complete_vmctl -- console load reload start stop reset status send receive
	set -A complete_vmctl_2 -- $(vmctl status | awk '!/NAME/{print $NF}')
fi

set -A complete_sndioctl_1 -- $(sndioctl | cut -d= -f 1)

# man
#if [ ! -f /tmp/man_list ]; then
#apropos .|cut -d'(' -f1 | cut -d',' -f1 > /tmp/man_list
#fi
#set -A complete_man_1 -- $(cat /tmp/man_list)

pgrep -fq 'mpd'
if [ $? = 0 ]; then
	set -A complete_mpc_1 -- \
		add \
		cdprev channels clear clearerror \
		consume crop crossfade current \
		del disable \
		enable \
		find findadd \
		idle idleloop insert \
		list listall load ls lsplaylists \
		mixrampdb mixrampdelay move \
		next \
		outputs outputset \
		pause pause-if-playing play playlist prev prio \
		random repeat replaygain rescan rm \
		save search searchadd searchplay seek \
		sendmessage shuffle single stats \
		sticker stop subscribe \
		toggle toggleoutput \
		update \
		version volume \
		waitmessage \
	set -A complete_mpc_2 -- $(mpc lsplaylists | sort)
fi
NNN_COLORS=2222
NNN_FCOLORS=0f0f020f0f0f0f0f0f0f0f0f
