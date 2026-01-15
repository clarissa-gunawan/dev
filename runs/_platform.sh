#!/usr/bin/env bash

detect_os() {
    case "$(uname -s)" in
        Linux*)  echo "linux" ;;
        Darwin*) echo "mac" ;;
        *)       echo "unknown" ;;
    esac
}

detect_arch() {
    case "$(uname -m)" in
        x86_64)  echo "amd64" ;;
        aarch64) echo "arm64" ;;
        arm64)   echo "arm64" ;;
        *)       echo "unknown" ;;
    esac
}

# Package manager helpers
pkg_install() {
    local os=$(detect_os)
    if [[ "$os" == "linux" ]]; then
        sudo apt update && sudo apt install -y "$@"
    elif [[ "$os" == "mac" ]]; then
        brew install "$@"
    fi
}

pkg_install_cask() {
    local os=$(detect_os)
    if [[ "$os" == "mac" ]]; then
        brew install --cask "$@"
    fi
}

ensure_brew() {
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}
