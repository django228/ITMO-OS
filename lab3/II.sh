#!/bin/bash

echo "bash /home/django/itmo-os/lab3/I.sh" | at now + 2 minutes
tail -f ~/report &
