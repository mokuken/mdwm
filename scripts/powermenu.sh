#!/bin/bash

function powermenu {
	options="cancel\nshutdown\nreboot\nhibernate"
	selected=$(echo -e $options | dmenu -x 400 -y 745 -z 600 )
	if [[ $selected =  "shutdown" ]]; then
		poweroff 
	elif [[ $selected = "reboot" ]]; then
		reboot
	elif [[ $selected = "hibernate" ]]; then
		systemctl suspend
	elif [[ $selected = "cancel" ]]; then
		return
	fi
}


powermenu
