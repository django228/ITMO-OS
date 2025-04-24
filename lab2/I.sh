#!/bin/bash

count=$(ps -U django --no-headers | wc -l)
echo "Процессов запущено пользователем 'django': $count"

ps -U django -o pid,cmd --no-headers > user_processes.txt
echo "Список процессов сохранён в user_processes.txt"
