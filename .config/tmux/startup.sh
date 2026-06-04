#!/bin/bash

session="xenakis"
tmux new-session -d -s $session

window=0
tmux rename-window -t $session:$window 'notes'
tmux send-keys -t $session:$window 'nvim $NOTES' C-m

window=1
tmux new-window -t $session:$window -n 'main'
tmux send-keys -t $session:$window '. $TMUX_MAIN' C-m;

tmux attach-session -t $session
