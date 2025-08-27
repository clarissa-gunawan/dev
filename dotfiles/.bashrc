# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
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

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


export PATH="$HOME/.local/bin:$PATH"

export TERMINAL=ghostty
export PS1="\[\e[1;32m\]\u\[\e[0m\]@\[\e[1;34m\]\h\[\e[0m\]:\w\$ "

alias bat="batcat"
alias cat="batcat"

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash
eval "$(fzf --bash)"
alias fzf="fzf --preview='batcat {}'"
export FZF_DEFAULT_OPTS=" \
    --color=fg:#D6DAE8,bg:#161821,hl:#88c0d0 \
    --color=fg+:#E8ECF4,bg+:#1E2132,hl+:#88c0d0 \
    --color=info:#9CCEF2,prompt:#BBA8E8,pointer:#EBCB8B \
    --color=marker:#C8E6A0,spinner:#9CCEF2,header:#8B95B8"
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'

export PATH="$PATH":"$HOME/.local/scripts/"
bind '"\C-f":"tmux-sessionizer\n"'

alias vim="nvim"

# Allow for task.dev to autocomplete
eval "$(task --completion bash)"

# Persistent SSH Agent Setup
# This script ensures a single SSH agent persists across all shell sessions
# by creating a fixed socket location and reusing the same agent process

# Check if our persistent SSH agent socket exists and is actually a socket file
# -S tests specifically for socket files (not regular files or directories)
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
    # No persistent agent found, so start a new SSH agent
    # ssh-agent outputs environment variables (SSH_AUTH_SOCK and SSH_AGENT_PID)
    # eval executes these assignments in the current shell
    eval `ssh-agent`
    
    # Create a symbolic link from the temporary agent socket to our fixed location
    # This allows us to always connect to the same agent across sessions
    # -s: create symbolic link
    # -f: force overwrite if the link already exists
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi

# Always point SSH_AUTH_SOCK to our persistent socket location
# This ensures all shells use the same agent, whether we just started it
# or it was already running from a previous session
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock

# Automatically load SSH keys if none are currently loaded
# ssh-add -l lists currently loaded keys
# > /dev/null discards the output (we only care about success/failure)
# || means "if the previous command failed, run this command"
# ssh-add with no arguments loads default keys (~/.ssh/id_rsa, ~/.ssh/id_dsa, etc.)
ssh-add -l > /dev/null || ssh-add

# Zoxide to initialize
eval "$(zoxide init bash)"

# Bash Completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

# Open Code Config
export EDITOR=vim
export PATH="$HOME/.opencode/bin:$PATH"

