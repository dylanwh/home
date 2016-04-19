REALNAME="Dylan William Hardison"
EMAIL="dylan@hardison.net"
BROWSER="firefox"
MANPAGER='less -s'
GIT_CEILING_DIRECTORIES="$HOME/src"

export REALNAME EMAIL BROWSER MANPAGER GIT_CEILING_DIRECTORIES

if [[ -z "$EDITOR" && -z "$VISUAL" && "$TERM" != dumb ]]; then
    EDITOR="vim"
    VISUAL="$EDITOR"
    export EDITOR
    export EDITOR
fi

LANG=en_US.UTF-8
LC_COLLATE=POSIX # sort in POSIX order.

export LC_COLLATE TZ

XDG_DATA_HOME=$HOME/.local/share
XDG_CONFIG_HOME=$HOME/.config
XDG_CACHE_HOME=$HOME/.cache

if [[ -z $XDG_RUNTIME_DIR ]]; then
    XDG_RUNTIME_DIR=/tmp/$LOGNAME
    [[ -d $XDG_RUNTIME_DIR ]] || mkdir $XDG_RUNTIME_DIR
fi

export XDG_DATA_HOME XDG_CONFIG_HOME XDG_CACHE_HOME XDG_RUNTIME_DIR

PATH="$HOME/bin:$PATH"

if which plenv &>/dev/null; then
    eval "$(plenv init -)"
elif [[ -d ~/perl5 ]]; then
    eval $(perl -I ~/perl5/lib/perl5 -Mlocal::lib)
fi

export PATH
