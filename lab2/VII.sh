#!/bin/bash

get_read_bytes() {
    for pid in $(ls /proc | grep -E '^[0-9]+$'); do
        if [ -f /proc/$pid/io ]; then
            read_bytes=$(grep 'read_bytes' /proc/$pid/io | awk '{print $2}')
            cmdline=$(tr -d '\0' < /proc/$pid/cmdline)
            echo "$pid:$cmdline:$read_bytes"
        fi
    done
}

start_read_bytes=$(get_read_bytes)

sleep 10

end_read_bytes=$(get_read_bytes)

echo "$start_read_bytes" | while read -r line; do
    pid=$(echo "$line" | cut -d: -f1)
    cmdline=$(echo "$line" | cut -d: -f2)
    start_bytes=$(echo "$line" | cut -d: -f3)
    end_line=$(echo "$end_read_bytes" | grep "^$pid:")
    if [ -n "$end_line" ]; then
        end_bytes=$(echo "$end_line" | cut -d: -f3)
        diff=$((end_bytes - start_bytes))
        echo "$pid:$cmdline:$diff"
    fi
done | sort -t: -k3 -nr | head -n 3
