#!/bin/bash

pids=($(pgrep -f './IV.sh'))

if [ ${#pids[@]} -ge 3 ]; then
    pid1=${pids[0]}
    pid2=${pids[1]}
    pid3=${pids[2]}
    cpulimit --pid $pid1 --limit 10 &
    kill -TERM $pid3
    echo "PID $pid3 terminated"
else
    echo "3 processes not found."
fi
