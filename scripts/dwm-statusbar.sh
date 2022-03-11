#!/bin/bash

# ~/bin/dwm-statusbar
# Adapted from w0ng status bar: https://github.com/w0ng/bin
# Adapted from jasonwryan status bar: https://bitbucket.org/jasonwryan/shiv/src/1ad5950c3108a4e5a9dcb78888a1ccfeb9252b45/Scripts/dwm-status?at=default

# Colour codes from dwm/config.h
#color0="\x01" # normal  
#color6="\x02" # green 
#color7="\x03" # blue 
#color1="\x01" # white-ish fg \x01


#---separator                              
#sp="$(echo -ne "${color0} ")" 
#sp1="$(echo -ne "${color0} | ")" 
#sp2="$(echo -ne "${color0}| ")"
#sp3="$(echo -ne "${color0}|")"

print_song_info() {
  track="$(mpc current)"
  artist="${track%%- *}"
  title="${track##*- }"
  [[ -n "$artist" ]] && echo -e "${color6}ê${color0}${artist}${color7}${title} ${color0}|"
}

print_power() {
  status="$(cat /sys/class/power_supply/AC/online)"
  battery="$(cat /sys/class/power_supply/BAT0/capacity)"
  timer="$(acpi -b | grep "Battery" | awk '{print $5}' | cut -c 1-5)"
  if [ "${status}" == 1 ]; then
    echo -ne "  ${battery}% charging "
  else
    echo -ne "  ${battery}% "
  fi
}

print_wifiqual() {
  wifiessid="$(/sbin/iwconfig 2>/dev/null | grep ESSID | cut -d: -f2)"
  wifiawk="$(echo $wifiessid | awk -F',' '{gsub(/"/, "", $1); print $1}')"
  wificut="$(echo $wifiawk | cut -d' ' -f1)"
  echo -ne "  ${wificut} "
}

print_ethernet() {
	if [ "$(cat /sys/class/net/eno1/carrier)" == "1" ]; then
		echo -ne "  ${ETHERNETUP}  ${ETHERNETDOWN} "
	elif [ "$(cat /sys/class/net/wlo1/carrier)" == "1" ]; then
		echo -ne "  ${WIFIUP}  ${WIFIDOWN} "
	else 
		echo -ne " offline "
	fi
}

print_hddfree() {
  hddfree="$(df -Ph /dev/sda5 | awk '$3 ~ /[0-9]+/ {print $4}')"
  echo -ne "  ${hddfree} "
}

 print_volume(){
    mix=`amixer get Master | tail -1`
    vol="$(amixer get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')"
    if [[ $mix == *\[off\]* ]]; then                                               
      echo -ne "  MUTED "
    elif [ "$(amixer get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')" == "0" ]; then
      echo -ne "  MUTED "
    elif [ "$(amixer get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')" == "100" ]; then
      echo -ne "  MAX "
    else
      echo -ne "  ${vol}% "
    fi
 }


print_date() {
  date="$(date "+%F")"
  echo -ne "  ${date} "
}

print_time() {
	time="$(date "+%I:%M")"
	echo -ne "  ${time} "
}

print_cputemp() {
    cputemp="$(sensors|awk 'BEGIN{i=0;t=0;b=0}/id [0-9]/{b=$4};/Core/{++i;t+=$3}END{if(i>0){printf("%0.1f\n",t/i)}else{sub(/[^0-9.]/,"",b);print b}}')"
    echo -ne "  ${cputemp} "

}

print_brightness() {
	bright="$(expr $(cat /sys/class/backlight/intel_backlight/brightness) / 49)"
	echo -ne "  ${bright}% "
}

# cpu (from: https://bbs.archlinux.org/viewtopic.php?pid=661641#p661641)

while true; do
  # get new cpu idle and total usage
  eval $(awk '/^cpu /{print "cpu_idle_now=" $5 "; cpu_total_now=" $2+$3+$4+$5 }' /proc/stat)
  cpu_interval=$((cpu_total_now-${cpu_total_old:-0}))
  # calculate cpu usage (%)
  let cpu_used="100 * ($cpu_interval - ($cpu_idle_now-${cpu_idle_old:-0})) / $cpu_interval"
  # show free memory
  MEM=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
  # wifi packet speed
  WIFIUP=$(ifconfig wlo1 | grep "TX packets" | awk {'print $6 $7'})
  WIFIDOWN=$(ifconfig wlo1 | grep "RX packets" | awk {'print $6 $7'})
  # ethernet packet speed
  ETHERNETUP=$(ifconfig eno1 | grep "TX packets" | awk {'print $6 $7'})
  ETHERNETDOWN=$(ifconfig eno1 | grep "RX packets" | awk {'print $6 $7'})
  # show uptiime
  UPTIME=$(uptime | sed 's/.*up \([^,]*\), .*/\1/')

  # output vars
print_cpu_used() {
  printf "%-1b" "  ${cpu_used}% "
#"%-10b" " CPU:${cpu_used}%"
}
 
  # Pipe to status bar, not indented due to printing extra spaces/tabs
  #xsetroot -name "$(print_power)${sp1}$(print_wifiqual)$(print_hddfree)${sp1}$(print_email_count)$(print_pacup)$(print_aurups)$(print_aurphans)${sp2}$(print_volume)${sp2}$(print_datetime)"
  #xsetroot -name "$(print_cpu_used)$(print_cputemp)$(print_wifiqual)$(print_hddfree)$(print_volume)$(print_power)$(print_datetime)"
  #xsetroot -name "$(print_song_info)$(print_power)${sp1}$(print_wifiqual)$(print_hddfree)${sp2}$(print_volume)${sp2}$(print_datetime)"
  xsetroot -name "|$(print_brightness)|$(print_volume)|$(print_power)|$(print_date)|$(print_time);$(print_wifiqual)|$(print_ethernet)|  $UPTIME |;|$(print_cpu_used)|$(print_cputemp)|  $MEM |$(print_hddfree)"

  # reset old rates
  cpu_idle_old=$cpu_idle_now
  cpu_total_old=$cpu_total_now
  # loop stats every 1 second
  sleep 1 
 done
