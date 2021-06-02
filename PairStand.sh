#!/bin/bash
sleep 4
for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do
    (
        syspath="${sysdevpath%/dev}"
        devname="$(udevadm info -q name -p $syspath)"
        [[ "$devname" == "bus/"* ]] && exit
        eval "$(udevadm info -q property --export -p $syspath)"
        [[ -z "$ID_SERIAL" ]] && exit
        device="/dev/$devname - $ID_SERIAL" #| grep Silicon_Labs_CP2104_USB | cut -d- -f1 
	espPort=$(echo "$device" | grep Silicon_Labs_CP2104_USB | cut -d " " -f1)
	[[ -z "$espPort" ]] && exit
	stty -F "$espPort" raw -echo 115200

	echo -e "SSID:Tigerblood"> $espPort

	sleep 1

	echo -e "Pass:tiger5000"> $espPort
 
    )
done
