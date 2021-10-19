PATH=$HOME/bin:$HOME/.local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games:/opt/bin:.:/usr/local/jdk-1.8.0/jre/bin/:/usr/local/share/isotop/bin
# use vim if it's installed, vi otherwise
case "$(command -v vim)" in
  */vim) VIM=vim ;;
  *)     VIM=vi  ;;
esac
alias vi=$VIM
EDITOR=$VIM
VISUAL='vi'
FCEDIT=$EDITOR
TOP='-s .5'
PAGER=less
ENV=$HOME/.kshrc
MANPATH=:$HOME/man
export VISUAL EDITOR FCEDIT PATH HOME TERM TOP PAGER ENV MANPATH
export LDFLAGS="-L /usr/lib -L/usr/local/lib"
export CXXFLAGS="-I /usr/include -I/usr/local/include"
export ROVER_OPEN="rover-open"
