#!/bin/sh
# simple script to test connection
# usage test_connect.sh <watchdog_timer> <host> && <PROG1> || <PROG2>
# args:
# $1: int time after which return 1, in unsuccess
# $2: host to ping

COUNTER=0
while [  $COUNTER -lt $1 ]; do
    ping -c 1 $2 && exit 0
    sleep 1
    let COUNTER=COUNTER+1 
done
exit 1
