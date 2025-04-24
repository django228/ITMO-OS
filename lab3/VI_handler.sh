#!/bin/bash

PID_FILE="/home/django/itmo-os/lab3/handler.pid"

echo $$ > $PID_FILE

value=1

usr1() {
    value=$((value + 2))
    echo "after addition: $value"
}

usr2() {
    value=$((value * 2))
    echo "after multiplication: $value"
}

term() {
    echo "Terminated by signal"
    rm $PID_FILE
    exit 0
}

trap 'usr1' USR1
trap 'usr2' USR2
trap 'term' SIGTERM

while true; do
    sleep 1
done
