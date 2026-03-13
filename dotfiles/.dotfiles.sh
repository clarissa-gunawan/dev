# ~/.dotfiles.sh - Shared shell configuration
# Source this from your .bashrc or .zshrc:
#   source ~/.dotfiles.sh

# Detect shell
CURRENT_SHELL=$(basename "$SHELL")

# =============================================================================
# Starship Prompt (works with bash and zsh)
# =============================================================================
if command -v starship &> /dev/null; then
    export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
    if [[ "$CURRENT_SHELL" == "zsh" ]]; then
        eval "$(starship init zsh)"
    elif [[ "$CURRENT_SHELL" == "bash" ]]; then
        eval "$(starship init bash)"
    fi
fi

# =============================================================================
# PATH Configuration
# =============================================================================
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.local/scripts/"
export PATH="$HOME/.opencode/bin:$PATH"
export PATH="$PATH:$HOME/.lmstudio/bin"
export PATH="$PATH:$HOME/go/bin"

# =============================================================================
# Environment Variables
# =============================================================================
export TERMINAL=ghostty
export EDITOR=nvim

# Point lazygit to ~/.config on macOS (it defaults to ~/Library/Application Support/)
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"

# =============================================================================
# Aliases
# =============================================================================
alias vim="nvim"

# eza aliases (modern ls replacement)
alias ls='eza'
alias ll='eza -al'
alias la='eza -a'
alias l='eza'

# bat/batcat alias (Linux package is named batcat)
if command -v batcat &> /dev/null; then
    alias bat="batcat"
fi

# =============================================================================
# FZF Configuration
# =============================================================================
export FZF_DEFAULT_OPTS=" \
    --color=fg:#c0caf5,bg:#1a1b26,hl:#ff9e64 \
    --color=fg+:#c0caf5,bg+:#292e42,hl+:#ff9e64 \
    --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7aa2f7 \
    --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a"

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
# Tmux sessionizer keybindings
# =============================================================================
if [[ "$CURRENT_SHELL" == "bash" ]]; then
    bind '"\C-f":"tmux-sessionizer\n"' 2>/dev/null
elif [[ "$CURRENT_SHELL" == "zsh" ]]; then
    tmux-sessionizer-widget() {
        BUFFER="tmux-sessionizer"
        zle accept-line
    }
    zle -N tmux-sessionizer-widget
    bindkey '^F' tmux-sessionizer-widget
fi
