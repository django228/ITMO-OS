#!/bin/bash

ps -eo pid,etime,cmd --sort=-etime --no-headers | head -n 1
