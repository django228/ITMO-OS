#!/bin/bash

ps -eo pid,cmd --no-headers | awk '$2 ~ /^\/sbin\//' > sbin_processes.txt
