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
    fuzzy_search_name="fuzzy search"
    languages=$(printf "%s\n" "${languages[@]}")
    core_utils=$(printf "%s\n" "${core_utils[@]}")
    selected=$(echo -e "$fuzzy_search_name\n$languages\n$core_utils" | fzf)
    
    if [[ $selected == "$fuzzy_search_name" ]]; then
        FUZZY_SEARCH=1
    else
         read -p "Query (try :learn, or :list for languages or empty for core utilies): " query
         if echo "$languages" | grep -qs $selected; then
             curl --silent cht.sh/$selected/$(echo "$query" | tr " " "+") | less -R
         else
             curl --silent cht.sh/$selected~$query | less -R
         fi
    fi
fi

if (( $FUZZY_SEARCH )); then
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
    
    selected=$(cat $CHT_SH_LIST_CACHE | fzf --reverse --ansi --prompt="CHEAT.SH>" --preview="curl -s cht.sh/{}")
    
    query=$(curl -s "cht.sh/$selected/:list" | fzf --reverse --ansi --prompt="CHEAT.SH/$selected >" 
          --preview="curl -s cht.sh/$selected/{1} && curl -s cht.sh/$selected/{q}")
    query=$(echo $query | tr " " "+" | sed "s/.*+//")
    
    if [[ -z $query ]]; then
        curl -s cht.sh/$selected | less -R
    else
        curl -s "cht.sh/$selected/$query" | less -R
    fi
fi


