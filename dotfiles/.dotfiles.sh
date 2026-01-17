# ~/.dotfiles.sh - Shared shell configuration
# Source this from your .bashrc or .zshrc:
#   source ~/.dotfiles.sh

# Detect shell
CURRENT_SHELL=$(basename "$SHELL")

# =============================================================================
# Oh My Posh Configuration (works with bash and zsh)
# =============================================================================
if command -v oh-my-posh &> /dev/null; then
    # Get the themes directory
    if command -v brew &> /dev/null; then
        POSH_THEMES_PATH="$(brew --prefix oh-my-posh)/themes"
    else
        POSH_THEMES_PATH="$HOME/.cache/oh-my-posh/themes"
    fi

    # Available themes - change POSH_THEME to switch
    # Options: catppuccin, powerlevel10k, robbyrussell, zash
    POSH_THEME="${POSH_THEME:-catppuccin}"

    case "$POSH_THEME" in
        catppuccin)
            POSH_THEME_FILE="$POSH_THEMES_PATH/catppuccin_macchiato.omp.json"
            ;;
        powerlevel10k)
            POSH_THEME_FILE="$POSH_THEMES_PATH/powerlevel10k_lean.omp.json"
            ;;
        robbyrussell)
            POSH_THEME_FILE="$POSH_THEMES_PATH/robbyrussell.omp.json"
            ;;
        zash)
            POSH_THEME_FILE="$POSH_THEMES_PATH/zash.omp.json"
            ;;
        *)
            POSH_THEME_FILE="$POSH_THEMES_PATH/$POSH_THEME.omp.json"
            ;;
    esac

    # Initialize Oh My Posh
    if [[ "$CURRENT_SHELL" == "zsh" ]]; then
        eval "$(oh-my-posh init zsh --config "$POSH_THEME_FILE")"
    elif [[ "$CURRENT_SHELL" == "bash" ]]; then
        eval "$(oh-my-posh init bash --config "$POSH_THEME_FILE")"
    fi

    # Function to switch themes on the fly
    posh-theme() {
        if [[ -z "$1" ]]; then
            echo "Current theme: $POSH_THEME"
            echo "Available: catppuccin, powerlevel10k, robbyrussell, zash"
            echo "Usage: posh-theme <theme-name>"
            return
        fi
        export POSH_THEME="$1"
        source ~/.dotfiles.sh
        echo "Switched to: $1"
    }
fi

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
