# ~/.dotfiles.sh - Shared shell configuration
# Source this from your .bashrc or .zshrc:
#   source ~/.dotfiles.sh

# Detect shell
CURRENT_SHELL=$(basename "$SHELL")

# =============================================================================
# PATH Configuration
# =============================================================================
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.local/scripts/"
export PATH="$HOME/.opencode/bin:$PATH"
export PATH="$PATH:$HOME/.lmstudio/bin"

# =============================================================================
# Environment Variables
# =============================================================================
export TERMINAL=ghostty
export EDITOR=nvim

# =============================================================================
# Aliases
# =============================================================================
alias vim="nvim"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# bat/batcat alias (Linux uses batcat, Mac uses bat)
if command -v batcat &> /dev/null; then
    alias bat="batcat"
    alias cat="batcat"
elif command -v bat &> /dev/null; then
    alias cat="bat"
fi

# =============================================================================
# FZF Configuration
# =============================================================================
export FZF_DEFAULT_OPTS=" \
    --color=fg:#D6DAE8,bg:#161821,hl:#88c0d0 \
    --color=fg+:#E8ECF4,bg+:#1E2132,hl+:#88c0d0 \
    --color=info:#9CCEF2,prompt:#BBA8E8,pointer:#EBCB8B \
    --color=marker:#C8E6A0,spinner:#9CCEF2,header:#8B95B8"

if command -v fd &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
fi

# FZF shell integration
if command -v fzf &> /dev/null; then
    if [[ "$CURRENT_SHELL" == "zsh" ]]; then
        eval "$(fzf --zsh)"
    elif [[ "$CURRENT_SHELL" == "bash" ]]; then
        eval "$(fzf --bash)"
    fi
fi

# =============================================================================
# Zoxide (better cd)
# =============================================================================
if command -v zoxide &> /dev/null; then
    if [[ "$CURRENT_SHELL" == "zsh" ]]; then
        eval "$(zoxide init zsh)"
    elif [[ "$CURRENT_SHELL" == "bash" ]]; then
        eval "$(zoxide init bash)"
    fi
fi

# =============================================================================
# SSH Agent (persistent across sessions)
# =============================================================================
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
    eval $(ssh-agent)
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l > /dev/null || ssh-add 2>/dev/null

# =============================================================================
# Yazi file manager wrapper (cd to last directory on exit)
# =============================================================================
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if [[ "$CURRENT_SHELL" == "zsh" ]]; then
        cwd=$(<"$tmp")
    else
        IFS= read -r -d '' cwd < "$tmp"
    fi
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

# =============================================================================
# Tmux sessionizer keybinding (bash only - zsh uses different binding)
# =============================================================================
if [[ "$CURRENT_SHELL" == "bash" ]]; then
    bind '"\C-f":"tmux-sessionizer\n"' 2>/dev/null
fi
