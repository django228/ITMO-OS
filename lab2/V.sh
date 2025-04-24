#!/bin/bash

output="avg_runtimeV.txt"
> "$output"

for pid in $(ls /proc | grep '^[0-9]'); do
    if [ -f /proc/$pid/status ] && [ -f /proc/$pid/sched ]; then
        ppid=$(awk '/PPid:/ {print $2}' /proc/$pid/status)
        art=$(awk '/sum_exec_runtime/ {print $3}' /proc/$pid/sched)
        switches=$(awk '/nr_switches/ {print $3}' /proc/$pid/sched)

        if [ "$switches" -gt 0 ]; then
            avg_runtime=$(echo "$art / $switches" | bc -l)
            echo "$ppid $pid $avg_runtime" >> temp_output.txt
        fi
    fi
done

sort -n temp_output.txt > sorted_output.txt

current_ppid=""
total_art=0
count=0

while read ppid pid art; do
    if [[ "$ppid" != "$current_ppid" && "$current_ppid" != "" ]]; then
        avg=$(echo "$total_art / $count" | bc -l)
        echo "Average_Running_Children_of_ParentID=$current_ppid is $avg" >> "$output"
        echo -e "|-----------------------------------------------------------------| \n" >> "$output"
        total_art=0
        count=0
    fi

    echo "ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$art" >> "$output"
    current_ppid="$ppid"
    total_art=$(echo "$total_art + $art" | bc -l)
    count=$((count + 1))
done < sorted_output.txt

if [[ "$count" -gt 0 ]]; then
    avg=$(echo "$total_art / $count" | bc -l)
    echo "Average_Running_Children_of_ParentID=$current_ppid is $avg" >> "$output"
fi

rm temp_output.txt sorted_output.txt

echo "done"
