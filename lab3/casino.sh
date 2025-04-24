#!/bin/bash

FIFO_PREDICTIONS="/tmp/casino_predictions"
FIFO_RESULTS="/tmp/casino_results"

# Удаляем старые каналы, если есть
rm -f "$FIFO_PREDICTIONS" "$FIFO_RESULTS"
mkfifo "$FIFO_PREDICTIONS" "$FIFO_RESULTS"

echo "Казино открыто. Ожидаем прогнозы..."

# Читаем прогнозы из канала
predictions=()
while read prediction < "$FIFO_PREDICTIONS"; do
    if [[ "$prediction" == "DONE" ]]; then
        break
    fi
    echo "Получен прогноз: $prediction"
    predictions+=("$prediction")
done

# Выбираем победителя
if [ ${#predictions[@]} -eq 0 ]; then
    echo "Нет прогнозов. Казино закрывается."
    exit 1
fi

winner=${predictions[$((RANDOM % ${#predictions[@]}))]}
echo "Победитель: $winner"

# Отправляем результаты
for pred in "${predictions[@]}"; do
    if [[ "$pred" == "$winner" ]]; then
        echo "winner:$pred" > "$FIFO_RESULTS"
    else
        echo "loser:$pred" > "$FIFO_RESULTS"
    fi
done

echo "Результаты отправлены. Казино закрывается."
exit 0
