#!/bin/bash
for i in {1..3}; do
    while true; do
        result=$((123 * 456))  # Простое вычисление для нагрузки CPU
    done &
    echo "Запущен процесс $! (PID)"
done
