#!/bin/bash

echo "Hi, $HOSTNAME!"

if [ $# -eq 0 ]; then
    echo "Usage: $0 num1 num2 ..."
    exit 1
fi

max=$1

for num in "$@"; do
    if [ "$num" -gt "$max" ]; then
        max=$num
    fi
done

echo "$max"
