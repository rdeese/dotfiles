#!/bin/bash
tmux new-session -d -s anything -c ~
tmux new-session -d -s platform -c ~/Documents/console
tmux new-window -t platform -c ~/Documents/console
tmux new-window -t platform -c ~/Documents/console
tmux new-session -d -s work-notes -c ~/Documents/work-notes
tmux attach -t anything
