# Dylan William Hardison's .zshrc file. #'
# This script is executed for every interactive shell.
# See also: ~/.zshenv ~/.zprofile [~/.zshrc] ~/.zlogin ~/.zlogout

## {{{ VARIABLES
declare -g ZCACHE
ZCACHE=$XDG_CACHE_HOME/zsh
[[ -d $ZCACHE ]] || mkdir -p $ZCACHE

HISTSIZE=4000
READNULLCMD=${PAGER:-/usr/bin/pager}
LOGCHECK=30
SAVEHIST=3000
HISTFILE=$ZCACHE/history

watch=(all)
fignore=(.o .hi .pyc)
cdpath=(~ ~/src/hewitt ~/Dropbox /media)

export PS_PERSONALITY=linux

## }}}
## {{{ OPTIONS
setopt autocd                  # change to dirs without cd
setopt autopushd               # automatically append dirs to the push/pop list
setopt pushd_ignore_dups       # and do not duplicate them
setopt pushd_to_home           # pushd with no args is like cd with no args.
setopt cdablevars              # the need for an explicit $
setopt autonamedirs            # any var that contains a full path is a named dir
setopt listpacked              # compact completion lists
setopt nolisttypes             # show types in completion
setopt extended_glob           # weird & wacky pattern matching - yay zsh!
setopt alwaystoend             # when complete from middle, move cursor
setopt completeinword          # not just at the end
setopt glob_complete           # complete globs with a menu.
setopt nocorrect               # no spelling correction
setopt promptcr                # add \n which overwrites cmds with no \n
setopt histverify              # when using ! cmds, confirm first
setopt hist_ignore_dups        # ignore same commands run twice+
setopt hist_ignore_all_dups
setopt appendhistory           # do not overwrite history 
setopt sharehistory            # share history between all running instances.
setopt hist_find_no_dups       # ignore dups in history search.
setopt hist_save_no_dups       
setopt hist_expire_dups_first
setopt extended_history        # store time info in history.
setopt interactive_comments    # escape commands so i can use them later
setopt no_print_exit_value     # prompt takes care of this
setopt nomatch                 # #fooo!
setopt noclobber               # do not overwrite files with >
setopt noflow_control          # disable control-q/control-s
setopt hashcmds                # avoid having to type 'rehash' all the time.
setopt rm_star_wait            # wait beforing ask if I want to delete all those files...
setopt multios                 # avoid having to use 'tee'
setopt checkjobs               # warn me about bg processes when exiting
setopt nohup                   # and do not kill them, either
setopt auto_continue           # automatically continue disowned jobs.
setopt auto_resume             # automatically resume jobs from commands
setopt no_list_beep            
setopt nobeep
## }}}
## {{{ KEY BINDINGS
bindkey -v

case $TERM in
    linux|screen*)
        bindkey "^[[1~" beginning-of-line
        bindkey "^[[3~" delete-char
        bindkey "^[[4~" end-of-line
        bindkey "^[[5~" up-line-or-history   # PageUp
        bindkey "^[[6~" down-line-or-history # PageDown
        bindkey "^[[A"  up-line-or-search    # up arrow for back-history-search
        bindkey "^[[B"  down-line-or-search  # down arrow for fwd-history-search
        bindkey "^?"   backward-delete-char
        bindkey "^H"   backward-delete-char
        bindkey "^[OM" accept-line
    ;;
    rxvt-unicode)
        bindkey "^[[7~" beginning-of-line  # home
        bindkey "^[[5~" up-line-or-history # pgup
        bindkey "^[[6~" down-line-or-history # pgdown
        bindkey "^[[8~" end-of-line        # end
        bindkey "^[[A" up-line-or-search   # up arrow
        bindkey "^[[B" down-line-or-search # down arrow
        bindkey "^?"   backward-delete-char
        bindkey "^H"   backward-delete-char
    ;;
    *xterm*|rxvt*|(dt|k|E)term)
        bindkey "^[[2~" yank
        bindkey "^[[3~" delete-char
        bindkey "^[[5~" up-line-or-history # PageUp
        bindkey "^[[6~" down-line-or-history # PageDown
        bindkey "^[[7~" beginning-of-line
        bindkey "^[[8~" end-of-line
        bindkey "^[[A" up-line-or-search ## up arrow for back-history-search
        bindkey "^[[B" down-line-or-search ## down arrow for fwd-history-search
        bindkey "^[OM" accept-line
    ;;
esac

bindkey -a Q quote-line
bindkey -a q quote-region
bindkey "^_" copy-prev-shell-word
bindkey '^Q' push-input
bindkey ' ' magic-space ## do history expansion on space
bindkey -a ' ' magic-space ## do history expansion on space
bindkey -a '^Xe' expand-word
bindkey -a '^Xg' list-expand
bindkey -a '^X^N' infer-next-history

#bindkey '^X^A' fasd-complete    # C-x C-a to do fasd-complete (fils and directories)
#bindkey '^X^F' fasd-complete-f  # C-x C-f to do fasd-complete-f (only files)
#bindkey '^X^D' fasd-complete-d  # C-x C-d to do fasd-complete-d (only directories)

## }}}
## {{{ FUNCTIONS
# Autoload various functions
autoload run-help compinit promptinit colors
autoload title shuffle perlpath prefix
autoload runbg fname mcp 

# initialize advanced tab completion.
compinit -d $ZCACHE/zcompdump

colors
promptinit   # Setup prompt theming 
prompt solarized # Set the prompt.

function mdc      { mkdir -p $1 && cd $1 }
function namedir  { declare -g $1=$2  }
function save_cwd { echo $PWD >! $ZCACHE/last_cwd }

chpwd_functions+=( save_cwd )
## }}}
## {{{ ALIASES
alias have='whence -p ls &>/dev/null'

alias cdd='cd ~desk'
alias cp='cp -i'
alias cpanm-test='command cpanm'
alias cpanm='cpanm --notest'
alias dbfs='dropbox filestatus'
alias dbs='dropbox status'
alias df="df -h"
alias evince='runbg evince'
alias find="noglob find"
alias free="free -m"
alias g='git'
alias gcd='cd $(git top)'
alias gvi=gvim
alias help=run-help
alias l='ls -L'
alias la='ls -ax'
alias ll='ls -l'
alias lsd='ls -d *(/)'
alias md="mkdir -p"
alias muttrc="$EDITOR ~/.mutt/muttrc"
alias mv='mv -i'
alias nl0="tr '\n' '\0'"
alias pd=popd
alias pdoc=perldoc
alias please='sudo !!'
alias pu=pushd
alias rd="rmdir"
alias rm='rm -i'
alias vi=vim
alias vimrc="$EDITOR ~/.vimrc"
alias xmrc='vim ~/.xmonad/xmonad.hs && xmonad --recompile && xmonad --restart'
alias xrc='vim ~/.xinitrc'
alias xs=cd
alias zenv='vim ~/.zshenv' 
alias zpro='vim ~/.zprofile'
alias zrc='vim ~/.zshrc'
alias i3rc='vim ~/.config/i3/config.tt'
alias zreload='exec env SHLVL=0 $SHELL'

have pinfo      && alias info=pinfo
have ack-grep   && alias ack=ack-grep
have hub        && eval "$(hub alias -s)"
have fasd       && eval "$(fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install)"

# paste
alias p='xclip -o'
alias P='xclip -o |'

# copy
alias c='xclip -i'
alias -g C='| xclip -i'
alias -g @='$( xclip -o )'
alias -g '"@"'='"$( xclip -o )"'
alias -g 'G'='|grep '

alias pvc='p | vipe | c'
alias ppc='p | publish | c'

# less
alias -g L='| less -F'

# scripts
alias -s pl='perl -S'
alias -s py=python
alias -s rb=ruby
alias -s hs=runhaskell

if [[  ~/.zshrc -nt $ZCACHE/alias-ls || ! -f $ZCACHE/alias-ls ]]; then
    # handle ls specially...
    local ls_cmd=ls
    local -a ls_args

    if have gls; then ls_cmd=gls; fi
    ls_args=('-Fh' '--color=auto' '--group-directories-first')

    while (( $#ls_args > 0 )); do
        if $ls_cmd $ls_args ~/.zsh &> /dev/null; then
            break
        else
            ls_args[-1]=()
        fi
    done
    echo "alias ls=\"$ls_cmd $ls_args\"" >! $ZCACHE/alias-ls 
    unset ls_cmd ls_args
fi

source $ZCACHE/alias-ls

case $OSTYPE in
    *gnu*)
        # use colors on gnu systems.
        alias grep='grep --color=auto'
        alias egrep='egrep --color=auto'
        alias fgrep='fgrep --color=auto'
    ;;
    *bsd*)
        have gdircolors && alias dircolors=gdircolors
        if have gmake; then
            alias make=gmake
            alias bsdmake='command make'
        fi
    ;;
esac

## }}}

# Add sbin directories for sudo tab completion.
zstyle ':completion:*:sudo:*' command-path $path /usr/sbin /sbin

# cache the output of completion functions.
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $ZCACHE

if have dircolors; then
    unset LS_COLORS

    eval $(dircolors ~/.config/dircolors-solarized/dircolors.ansi-dark )

    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

umask  077   # Create files that are readable only by moi
stty -ixon   # Disable the freeze-the-terminal-on-control-s thing.
ttyctl -f    # Freeze terminal properties.

namedir progfiles     ~/.wine/drive_c/Program\ Files
namedir moonshine     ~/src/moonshine

namedir g2            ~/src/g2
namedir hewitt        ~/src/hewitt
namedir mar_alignment ~hewitt/hewitt-marriott-alignment
namedir bes           ~/src/hewitt/bes
namedir bes2010       ~bes/BES-2010
namedir bes2011       ~bes/BES-2011
namedir bes2011_data  ~bes/BES-2011-Data
namedir bes2012_data  ~bes/hewitt-bes-2012-data
namedir bes_eers      ~bes/hewitt-bes-eers
namedir bes_setup     ~bes/hewitt-bes-setup
namedir bes_workspace ~bes/hewitt-bes-workspace
namedir bes_import    ~bes/hewitt-bes-import

if have xdg-user-dir; then
    namedir docs   $(xdg-user-dir DOCUMENTS)
    namedir desk   $(xdg-user-dir DESKTOP)
    namedir pub    $(xdg-user-dir PUBLICSHARE)
    namedir mus    $(xdg-user-dir MUSIC)
    namedir pics   $(xdg-user-dir PICTURES)
    namedir vids   $(xdg-user-dir VIDEOS)
    namedir dl     $(xdg-user-dir DOWNLOAD)
fi

# vim: set sw=4 ts=4 foldmethod=marker path=.,~/.zsh:
