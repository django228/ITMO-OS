#!/bin/bash

while :
do
        echo -e "Выберите пункт:\n"
        echo -e "1. Запустить vi\n"
        echo -e "2. Запустить nano\n"
        echo -e "3. Запустить links\n"
        echo -e "4. Выйти\n"

        read input
        case $input in
            "1")
            /usr/bin/vi start
            ;;

            "2")
            /usr/bin/nano start
            ;;

            "3")
            /usr/bin/links start
            ;;

            "4")
            break
            ;;

        *)

        esac
done
