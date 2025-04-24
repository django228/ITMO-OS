#!/bin/bash

input=""

while :
do
        read a
        if [ "$a" == "q" ]
        then
                break
        fi

        input="$input$a"
done

echo $input
