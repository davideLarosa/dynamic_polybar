#!/usr/bin/env bash

# get the active monitors
declare xrandr_values="$(xrandr --listactivemonitors|grep -v Monitors)"
declare xdotool_values="$(xdotool getmouselocation --shell|grep -E '^X=|^Y=')"

# get the mouse position
declare mouse_x=$(echo $xdotool_values|cut -d 'Y' -f1|sed 's|X=||g'|sed 's|\s||g')
declare mouse_y=$(echo $xdotool_values|cut -d 'Y' -f2|sed 's|=||g'|sed 's|\s||g')

# create some support variables
declare -a activeMonitors=()
declare currentMonitor=""

# read the name of the active monitors
readarray -t activeMonitors < <(echo "$xrandr_values"| awk '{print $4}')

# check for each monitor where the mouse is positioned
for m in ${activeMonitors[@]}; do
    
    # get the monitor dimensions
    mon_dim_x=$(echo "$xrandr_values" | grep -w "$m" |awk '{print $3}' |cut -d 'x' -f 1|cut -d '/' -f 1)
    mon_dim_y=$(echo "$xrandr_values" | grep -w "$m" |awk '{print $3}' |cut -d 'x' -f 2|cut -d '/' -f 1)

    # get the monitor position
    mon_pos_x=$(echo "$xrandr_values" | grep -w "$m" |cut -d '/' -f 3|sed 's|\s.*$||g'|cut -d '+' -f2|sed 's|+|\n|g')
    mon_pos_y=$(echo "$xrandr_values" | grep -w "$m" |cut -d '/' -f 3|sed 's|\s.*$||g'|cut -d '+' -f3|sed 's|+|\n|g')

    # check if the mouse cursor is in the boundry of the selected monitor
    if [[ "$mouse_x" -gt "$mon_pos_x" && "$mouse_x" -lt $(( $mon_pos_x + $mon_dim_x )) ]]; then
        if [[ "$mouse_y" -gt "$mon_pos_y" && "$mouse_y" -lt $(( $mon_pos_y + $mon_dim_y )) ]]; then
            # if found, store the monitor name in a variable
            currentMonitor="$m"
        fi
    fi
done

# toggle the polybar:

# the the polybar PID (thray is the bar name
u=$(ps aux | grep "polybar"|grep "tray"|grep -v grep | awk '{print $2}')
if [[ -z "$u" ]]; then
    # if the polybar is not active then create it and write some stuffs in a log file
    echo "---" | tee -a /tmp/polybar2.log
    echo "Creating polybar on monitor $currentMonitor with mouse in position X:Y -> $mouse_x:$mouse_y" | tee -a /tmp/polybar2.log
    MONITOR="$currentMonitor" polybar tray --reload >> /tmp/polybar2.log 2>&1
else
    # if the polybar exists the kill it
    kill -9 $u
fi

