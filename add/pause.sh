#!/bin/bash

sleep 60

pid="$(pidof valheim_server.x86_64)"
LOG_FILE="$(cat /data/logs/log-link.txt)"
TMP_FILE="/data/logs/log-tmp.txt"

function refresh { cp "$LOG_FILE" "$TMP_FILE" ;}

until [ -n "$(refresh && cat $TMP_FILE | grep Loaded | grep locations)" ];
do	sleep 5
done


until [ -z "$(cat /proc/$pid/wchan 2>/dev/null)" ];
do
	refresh
	connections="$(cat $TMP_FILE | grep "Connections" | awk 'END{print $4}')"
	logins="$(cat $TMP_FILE | grep ZDOID | awk 'END{print NR}')"
	logouts="$(cat $TMP_FILE | grep "Disposing socket" | awk 'END{print NR"/2"}' | bc)"

	if [ "$connections" = "0" ] || [ "$logins" = "$logouts" ] && [ "$(cat /proc/$pid/wchan)" != "do_signal_stop" ];
	then kill -STOP $pid;
	fi
	sleep 15
done

rm $TMP_FILE
