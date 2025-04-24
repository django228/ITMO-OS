#!/bin/bash

FIFO_PREDICTIONS="/tmp/casino_predictions"
FIFO_RESULTS="/tmp/casino_results"

prediction=$((RANDOM % 100 + 1))
echo "Мой прогноз: $prediction"

echo "$prediction" > "$FIFO_PREDICTIONS"

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
