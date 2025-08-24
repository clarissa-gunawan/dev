#!/usr/bin/env bash

languages=$(echo "python3 bash c cpp cmake javascript typescript golang rust django" | tr " " "\n")
core_utils=$(echo "find xargs sed awk grep docker rg fd tar zip ssh ssh-keygen tmux vim nvim :help :intro" | tr " " "\n")
selected=$(echo -e "$languages\n$core_utils" | fzf)

read -p "Query (try :learn, or :list for languages or empty for core utilies): " query

if echo "$languages" | grep -qs $selected; then
    curl --silent cht.sh/$selected/$(echo "$query" | tr " " "+") | less -R
else
    curl --silent cht.sh/$selected~$query | less -R
fi
