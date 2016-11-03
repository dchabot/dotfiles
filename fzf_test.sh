fel () {
        local file lineno filename
        file=$(grep -r -n -H --line-buffered --color=never --exclude-dir='.git' "" * | \
               fzf --query="$1" --select-1 --exit-0 -d":" -n"3")
        lineno=$(echo "$file" | cut -d":" -f2)
        filename=$(echo "$file" | cut -d":" -f1)
        [ -n "$file" ] && ${EDITOR:-vim} +$lineno $filename
}
