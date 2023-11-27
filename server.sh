#!/bin/bash
screen -dmS wow \
tmux new-session \; \
send-keys 'htop' C-m \; \
split-window -v \; \
send-keys '/home/$USER/server/bin/authserver' C-m \; \
split-window -h \; \
send-keys '/home/$USER/server/bin/worldserver' C-m \;
