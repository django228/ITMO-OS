#!/bin/bash


if [ "$#" -ne 1 ]; then
    echo "Error: You must write 1 arg - the file name"
fi

mkdir -p ~/.trash
touch ~/.trash.log

file_path="$PWD/$1"

if [ ! -f "$file_path" ]; then
    echo "Incorrect name of file"
    exit 1
fi

cur_number=$(cat ~/.trash.log | tail -n 1 | awk '{print $2}' | grep -E '^[0-9]+$')

if [ -z "$cur_number" ]; then
    cur_number=1
else
    ((cur_number++))
fi

ln "$file_path" ~/.trash/"$cur_number" 2>/dev/null

echo "$file_path $cur_number" >> ~/.trash.log

rm "$file_path"
