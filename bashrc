# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
#[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

PS1='\n\[\e[01;37m\]╭─ [\[\e[01;32m\]\u@\h\[\e[01;37m\]]:[\[\e[01;34m\]\w\[\e[01;37m\]]
╰─>  \[\e[00m\]'
export PROMPT_COMMAND='echo -ne "\033]0;`whoami`@`hostname -s`\007"'

export PATH="$PATH:/sbin:/usr/sbin:/usr/local/sbin:/usr/lib/epics/bin/linux-x86_64"
# channelfinder, java crud
export PATH="$PATH:$HOME/jdk1.8.0_121/bin:$HOME/elasticsearch-1.7.5/bin:$HOME/glassfish4/bin"
export PATH="$PATH:$HOME/apache-maven-3.3.9/bin"
export JAVA_HOME="$HOME/jdk1.8.0_121"

# linuxbrew
export PATH="$HOME/.linuxbrew/bin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"

# EPICS
#export EPICS_CA_AUTO_ADDR_LIST=NO
#export EPICS_CA_ADDR_LIST="`python $HOME/bin/get_ca_bcast_addr.py`"
#export EPICS_CA_ADDR_LIST=127.0.0.1
export EPICS_CA_MAX_ARRAY_BYTES=20000000

# FRIB CTS proxies
export http_proxy=http://webproxy.cts:3128
export https_proxy=https://webproxy.cts:3128
export no_proxy=localhost

# debian packaging nicities
export DEBFULLNAME='Daron Chabot'
export DEBEMAIL='chabot@frib.msu.edu'

#export PAGER="/usr/bin/less"
#export LESS='-FSRX' #give 'less' some smarts...
export EDITOR="/usr/bin/vim"
# activate 'vi' mode
set -o vi

function tmux() {
    # update-env command addition from:
    # https://raim.codingfarm.de/blog/2013/01/30/tmux-update-environment/
    local tmux=$(type -fp tmux)
    case "$1" in
        update-environment|update-env|env-update)
            local v
            while read v; do
                if [[ $v == -* ]]; then
                    unset ${v/#-/}
                else
                    # Add quotes around the argument
                    v=${v/=/=\"}
                    v=${v/%/\"}
                    eval export $v
                fi
            done < <(tmux show-environment)
            ;;
        *)
            $tmux "$@"
            ;;
    esac
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#if [ -z "$SSH_AUTH_SOCK" ] ; then
#  eval `ssh-agent -s`
#  ssh-add $HOME/.ssh/id_rsa
#fi
# pilfered from here - https://github.com/neovim/neovim/issues/1670#issuecomment-67423125
fel () {
        local file lineno filename
        file=$(grep -r -n -H --line-buffered --color=never --exclude-dir='.git' "" * | \
               fzf --query="$1" --select-1 --exit-0 -d":" -n"3")
        lineno=$(echo "$file" | cut -d":" -f2)
        filename=$(echo "$file" | cut -d":" -f1)
        [ -n "$file" ] && ${EDITOR:-vim} +$lineno $filename
}

vgrep () {
    vim -q <(grep -RnH --exclude-dir=".git" $1 $2) +cw
}
