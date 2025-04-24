#!/bin/bash

value=1
mode="add"
PIPE_PATH="/home/django/itmo-os/lab3/pipe"

if [[ ! -p $PIPE_PATH ]]; then
    echo "Error: Invalid channel"
    exit 1
fi

tail -f $PIPE_PATH | while true; do
    read LINE
    case $LINE in
        "+")
            mode="add"
            ;;
        \*)
            mode="multiply"
            ;;
        "QUIT")
            echo "exit"
            break
            ;;
        *)
            if [[ $LINE =~ ^[0-9]+$ ]]; then
                if [ "$mode" = "add" ]; then
                    value=$((value + LINE))
                else
                    value=$((value * LINE))
                fi
                echo $value
            else
                echo "Error: Invalid input"
            fi
            ;;
    esac
done
