#!/bin/bash

restore_dir="/home/$USER/restore"
backup_pattern="Backup-[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]"

# Создаем директорию для восстановления
mkdir -p "$restore_dir" || {
    echo "Error: Failed to create restore directory" >&2
    exit 1
}

# Находим последний допустимый бэкап (не старше 7 дней)
find_valid_backup() {
    ls -d /home/$USER/$backup_pattern 2>/dev/null | while read -r backup; do
        backup_date=$(basename "$backup" | sed 's/Backup-//')
        backup_ts=$(date -d "$backup_date" +%s 2>/dev/null)
        current_ts=$(date +%s)
        week_ago_ts=$((current_ts - 7*24*60*60))

        [ -n "$backup_ts" ] && [ "$backup_ts" -ge "$week_ago_ts" ] && echo "$backup"
    done | sort -r | head -n 1
}

last_backup=$(find_valid_backup)

if [ -z "$last_backup" ]; then
    echo "Error: No valid backup found (created within last 7 days)" >&2
    exit 1
fi

echo "Restoring from backup: $last_backup"

# Сначала собираем все версии файлов
declare -A file_versions
for filepath in "$last_backup"/*; do
    filename=$(basename "$filepath")

    # Для версионных файлов (с датой в расширении)
    if [[ "$filename" =~ ^(.+)\.([0-9]{4}-[0-9]{2}-[0-9]{2})$ ]]; then
        base_name="${BASH_REMATCH[1]}"
        file_date="${BASH_REMATCH[2]}"
        file_ts=$(date -d "$file_date" +%s 2>/dev/null)

        if [ -n "$file_ts" ]; then
            # Запоминаем самую свежую версию
            if [ -z "${file_versions[$base_name]}" ] ||
               [ "$file_ts" -gt "${file_versions[$base_name]}" ]; then
                file_versions["$base_name"]=$file_ts
            fi
        fi
    fi
done

# Восстанавливаем файлы
restored_count=0
for filepath in "$last_backup"/*; do
    filename=$(basename "$filepath")

    # Пропускаем временные/версионные файлы
    [[ "$filename" =~ \.[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && continue

    # Для обычных файлов
    if [ ! -f "$filepath" ]; then
        continue
    fi

    base_name="$filename"
    newest_version="$filepath"

    # Проверяем есть ли более новые версионные копии
    if [ -n "${file_versions[$base_name]}" ]; then
        file_date=$(date -d "@${file_versions[$base_name]}" "+%Y-%m-%d" 2>/dev/null)
        version_file="$last_backup/$base_name.$file_date"

        if [ -f "$version_file" ]; then
            newest_version="$version_file"
        fi
    fi

    # Копируем самую свежую версию
    if cp -r "$newest_version" "$restore_dir/$base_name"; then
        ((restored_count++))
    else
        echo "Warning: Failed to restore $base_name" >&2
    fi
done

echo "Successfully restored $restored_count files from $last_backup"
