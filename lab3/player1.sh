#!/bin/bash

FIFO_PREDICTIONS="/tmp/casino_predictions"
FIFO_RESULTS="/tmp/casino_results"

prediction=$((RANDOM % 100 + 1))
echo "Мой прогноз: $prediction"

# Отправляем прогноз в казино
echo "$prediction" > "$FIFO_PREDICTIONS"

# Ждем результат
while read -r result; do
    IFS=':' read -ra parts <<< "$result"
    if [[ "${parts[1]}" == "$prediction" ]]; then
        if [[ "${parts[0]}" == "winner" ]]; then
            echo "Я победил!"
        else
            echo "Я проиграл."
        fi
        break
    fi
done < "$FIFO_RESULTS"
