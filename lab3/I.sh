#!/bin/bash

mkdir ~/test

if [ $? -eq 0 ]; then
    echo "catalog test was created successfully" >> ~/report
    touch ~/test/$(date +"%Y-%m-%d_%H-%M-%S")
fi

ping -c 1 www.net_nikogo.ru > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "$(date +"%Y-%m-%d %H:%M:%S") Host www.net_nikogo.ru is unreachable" >> ~/report
fi
