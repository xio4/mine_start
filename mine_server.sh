#!/bin/bash

#To auto start in rc.local place
#su -c "/home/kook/mine/mine_server.sh start" -s /bin/bash kook

SUCCESS=0
FAILURE=1
SERVER=0
SESSION_NAME="mine"

sessions=`tmux ls 2>/dev/null | grep : | awk '{ print $1 }' | sed 's/://'`
needCreate=1

tmux start-server

for session in $sessions; do
    if [ "$session" = $SESSION_NAME ]; then
        needCreate=0
    fi
done

if [ "$needCreate" = 1 ]; then
    echo "Creating new session"

    tmux new-session -d -s $SESSION_NAME -n $SERVER
    tmux new-window -t $SESSION_NAME:1 -n htop
    tmux new-window -t $SESSION_NAME:2 -n cmd 
fi

tmux select-window -t $SESSION_NAME:$SERVER

if [ "$1" = "start" ]; then 
    echo "Starting server"
    tmux send-keys -t $SESSION_NAME:$SERVER 'cd ~/mine' C-m
    tmux send-keys -t $SESSION_NAME:$SERVER 'clear' C-m
    tmux send-keys -t $SESSION_NAME:$SERVER './ServerStart.sh' C-m
    exit $SUCCESS
fi 

if [ "$1" = "kill" ]; then 
    tmux kill-session -t $SESSION_NAME
    exit $SUCCESS
fi 
 

if [ "$1" = "stop" ]; then 
    echo "Stopping server"
    tmux send-keys -t $SESSION_NAME:$SERVER '/stop' C-m
    tmux send-keys -t $SESSION_NAME:$SERVER '/stop' C-m

    exit $SUCCESS 
fi 

function usage {
    echo "USAGE: `basename $0` <start|stop|kill>"
    exit $FAILURE
}
 
usage
