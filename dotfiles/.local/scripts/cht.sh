#!/usr/bin/env bash


FUZZY_SEARCH=0

if (( ! $FUZZY_SEARCH )); then
    languages=(
        "python" "python3" "bash" "c" "cpp" "cmake" "javascript" "typescript"
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

else
    CHT_SH_LIST_CACHE_DIR="$HOME/.cache/cht_sh/"
    CHT_SH_LIST_CACHE="$HOME/.cache/cht_sh/cht_sh_cached_list"
    
    #Cache the list on first run
    if [ ! -f "$CHT_SH_LIST_CACHE" ]; then
        if [ ! -d "$CHT_SH_LIST_CACHE_DIR" ]; then
            mkdir $CHT_SH_LIST_CACHE_DIR
        fi
        echo "Run for the first time. Downloading chat.sh/:list to $CHT_SH_LIST_CACHE"
        curl -s cht.sh/:list > $CHT_SH_LIST_CACHE
    fi
    
    # Source bashrc for tools
    if [ -f ~/.bashrc ]; then
        source ~/.bashrc
    fi
    
    #Select a cht.sh cheat from the list
    selected=$(cat $CHT_SH_LIST_CACHE | fzf --reverse --ansi --print-query --prompt="CHEAT.SH>" --preview="curl -s cht.sh/{}")
    
    echo "SELECTED: $selected"
    if [[ -z $selected ]]; then
        exit 0
    fi
    
    query_list=$(curl -s "cht.sh/$selected/:list")
    echo "QUERY LIST: $query_list"
    # Remove the special items
    filtered_list=$(echo "$query_list" | grep -vE "^(:list|:learn|rosetta/)$")
    
    # Check if it's a language (after filtering)
    trimmed=$(echo "$filtered_list" | tr -d '[:space:]')
    echo "$trimmed"
    if [[ -z "$trimmed" ]]; then
        echo "Utils"
    else
        echo "Language"
    fi
    
    #query=$(curl -s "cht.sh/$selected/:list" | fzf --reverse --print-query --ansi --nth 2..,.. --prompt="CHEAT.SH/$selected >" 
     #       --preview="curl -s cht.sh/$selected/{1} && curl -s cht.sh/$selected/{q}")
    
    #query=`curl -s cht.sh/$selected/:list | fzf --print-query --reverse --height 75% --border -m --ansi --nth 2..,.. --prompt='CHEAT.SH/'$(echo $selected | tr a-z A-Z)'> ' \
    #    --preview='curl -s cht.sh/'$selected'/{1} && curl -s cht.sh/'$selected'/{q}' --preview-window=right:80%`
    
    

fi


