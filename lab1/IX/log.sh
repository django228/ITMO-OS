find /var/log/ -type f -name "*.log" -exec wc -l {} + | awk '{sum += $1} END {print sum}'
