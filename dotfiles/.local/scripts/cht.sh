#!/usr/bin/env bash

languages=(
    "python3" "bash" "c" "cpp" "cmake" "javascript" "typescript"
    "golang" "rust" "django"
)
core_utils=(
    "find" "xargs" "sed" "awk" "grep" "docker" "rg" "fd" "bc" "git"
    "sort" "uniq" "jq" "tr" "parallel" "tar" "zip" "ssh" "ssh-keygen"
    "tmux" "vim" "nvim" "head" "tail" ":help" ":intro"
)

# Convert to newline-separated strings for fzf
languages=$(printf '%s\n' "${languages[@]}")
core_utils=$(printf '%s\n' "${core_utils[@]}")
selected=$(echo -e "$languages\n$core_utils" | fzf)

read -p "Query (try :learn, or :list for languages or empty for core utilies): " query

if echo "$languages" | grep -qs $selected; then
    curl --silent cht.sh/$selected/$(echo "$query" | tr " " "+") | less -R
else
    curl --silent cht.sh/$selected~$query | less -R
fi
