#!/bin/bash

declare -a array=()

> report2.log

counter=0

while true; do
    array+=(1 2 3 4 5 6 7 8 9 10)

    ((counter++))

    if (( counter % 100000 == 0 )); then
        array_size=${#array[@]}
        echo "Step $counter: Array size = $array_size" >> report2.log
        echo "Logged step $counter (array size: $array_size)"
    fi
done
-----
