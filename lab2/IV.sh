#!/bin/bash

output="avg_runtime.txt"
> "$output"

for pid in $(ls /proc | grep '^[0-9]'); do
    if [ -f /proc/$pid/stat ] && [ -f /proc/$pid/sched ]; then
        ppid=$(awk '{print $4}' /proc/$pid/stat)
        nice_value=$(ps -o nice= -p "$pid" 2>/dev/null)
        art=$(awk '/sum_exec_runtime/ {print $3}' /proc/$pid/sched)
        switches=$(awk '/nr_switches/ {print $3}' /proc/$pid/sched)

        if [ "$switches" -gt 0 ]; then
            avg_runtime=$(echo "$art / $switches" | bc -l)
            echo "ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$avg_runtime : Nice_value=$nice_value" >> "$output"
        fi
    fi
done

echo "done"
