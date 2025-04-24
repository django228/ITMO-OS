#!/bin/bash

PIPE_PATH="/home/django/itmo-os/lab3/pipe"
PID_FILE="/home/django/itmo-os/lab3/handler.pid"

mkfifo "$PIPE_PATH" 2>/dev/null

while true; do
    read LINE
    echo "$LINE" > "$PIPE_PATH"
    if [ "$LINE" = "QUIT" ]; then
        if [ -f "$PID_FILE" ]; then
            HANDLER_PID=$(cat "$PID_FILE")
            kill -SIGTERM "$HANDLER_PID"
        else
            echo "Handler PID file not found!"
        fi
        break
    fi
done

rm "$PIPE_PATH"
exit 0
