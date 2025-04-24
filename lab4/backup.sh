#!/bin/bash

backup_dir="/home/$USER/Backup-$(date +%F)"
source_dir="/home/$USER/source"
report_file="/home/$USER/backup-report"

# Находим последний бэкап (не старше 7 дней)
find_valid_backup() {
    ls -d /home/$USER/Backup-* 2>/dev/null | awk -F'-' '
    {
        date_str = $2 "-" $3 "-" $4;
        cmd = "date -d \"" date_str "\" +%s 2>/dev/null";
        cmd | getline timestamp;
        close(cmd);
        if (timestamp && (systime() - timestamp) <= 7*24*60*60) {
            print $0;
        }
    }' | sort -r | head -n 1
}

last_backup=$(find_valid_backup)

# Создаем или обновляем бэкап
if [ -n "$last_backup" ]; then
    # Обновляем существующий бэкап
    echo "[$(date +%F)] Updating backup folder: $last_backup" >> "$report_file"

    for file in "$source_dir"/*; do
        if [ ! -f "$file" ]; then
            continue
        fi

        filename=$(basename "$file")
        backup_file="$last_backup/$filename"

        if [ -f "$backup_file" ]; then
            # Сравниваем размеры файлов
            if [ $(stat -c %s "$file") -ne $(stat -c %s "$backup_file") ]; then
                # Создаем версионную копию
                mv "$backup_file" "$backup_file.$(date +%F)"
                cp "$file" "$last_backup/"
                echo "Updated: $filename -> $filename.$(date +%F)" >> "$report_file"
            fi
        else
            # Новый файл
            cp "$file" "$last_backup/"
            echo "New: $filename" >> "$report_file"
        fi
    done
else
    # Создаем новый бэкап
    mkdir -p "$backup_dir"
    echo "[$(date +%F)] New backup folder created: $backup_dir" >> "$report_file"

    for file in "$source_dir"/*; do
        if [ ! -f "$file" ]; then
            continue
        fi
        cp "$file" "$backup_dir/"
        echo "Copied: $(basename "$file")" >> "$report_file"
    done
fi
