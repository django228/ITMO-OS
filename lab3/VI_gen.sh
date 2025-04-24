#!/bin/bash

PID_FILE="/home/django/itmo-os/lab3/handler.pid"

if [[ ! -f $PID_FILE ]]; then
    echo "Error: PID файл обработчика не найден"
    exit 1
fi

HANDLER_PID=$(cat $PID_FILE)

while true; do
    read LINE
    case $LINE in
        "+")
            kill -USR1 $HANDLER_PID
            ;;
        \*)
            kill -USR2 $HANDLER_PID
            ;;
        "TERM")
            kill -SIGTERM $HANDLER_PID
            exit 0
            ;;
        *)
            ;;
    esac
done
