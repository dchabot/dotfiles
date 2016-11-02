fel () {
        local file lineno filename
        file=$(grep -n --line-buffered --color=never -r "" * | fzf --query="$1" --select-1 --exit-0) 
        lineno=$(echo "$file" | cut -d":" -f2)
        filename=$(echo "$file" | cut -d":" -f1)
        [ -n "$file" ] && ${EDITOR:-vim} +$lineno $filename
}
