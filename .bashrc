# ~/.bashrc: executed by bash(1) for non-login shells.
# if not running interactively, don't do anything
[[ $- == *i* ]] || return

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# additional binaries
export PATH="$HOME/.local/bin:$PATH"
[ -d /opt/homebrew/bin ] && export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# don't exit shell on ctrl-d; disable for now though
# set -o ignoreeof
# disable flow control protocol xon/xoff (transmit on/off)
stty -ixon

# M-* key is very helpful to extend current glob
shopt -s dirspell cdspell
shopt -s autocd globstar
shopt -s checkwinsize
shopt -s histappend cmdhist

# don't include duplicated items in history
export HISTFILESIZE=100000
export HISTSIZE=100000
export HISTCONTROL=ignoreboth:erasedups

if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
elif [[ -s /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then
    . /opt/homebrew/etc/profile.d/bash_completion.sh
fi
PS1='\u@\h:\[\e[36m\]\W\[\e[0m\]\$ '

export EDITOR=vim
export VISUAL=vim

# don't uncomment, just notes for running java debug
# export JDK_JAVA_OPTIONS='-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=localhost:5005'
# jdb -connect "com.sun.jdi.SocketAttach:hostname=localhost,port=5005"
# unset JDK_JAVA_OPTIONS

alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias myip='dig +short txt ch whoami.cloudflare @1.0.0.1'

# source local config
[ -f ~/.bashrc.local ] && . ~/.bashrc.local
