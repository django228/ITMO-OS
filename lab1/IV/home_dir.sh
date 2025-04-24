#!/bin/bash

if [[ $PWD == $HOME ]]; then
    echo "$HOME"
    exit 0
else
    echo "It's not a home dir"
    exit 1
fi
