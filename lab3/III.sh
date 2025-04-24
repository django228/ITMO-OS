#!/bin/bash

script_path="$(pwd)/I.sh"

(crontab -l 2>/dev/null; echo "*/5 * * * * $script_path") | crontab -
