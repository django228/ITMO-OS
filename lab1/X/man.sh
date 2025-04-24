man bash | tr -s '[:space:][:punct:]' '\n' | awk 'length($0) >= 4' | sort | uniq -c | sort -nr | head -3
