#!/bin/sh

# disable p2pcam and enable network

mount --bind /media/fake_root/p2pcam/p2pcam_dummy /p2pcam/p2pcam
grep mtd3 /proc/mtd > /dev/null && ro_rootfs=1

#network init 
idProduct=`cat /sys/bus/usb/devices/1-1/idProduct`
idVendor=`cat /sys/bus/usb/devices/1-1/idVendor`
WIFIDRVS="mt7601Usta 8188fu 9083h"
if [ -n "$ro_rootfs" ]; then DRVPATH=/home/drv; else DRVPATH=/home; fi
if [ "$idVendor" = "2310" -a "$idProduct" = "9086" ]; then
    WIFIDRV=9083h
elif [ "$idVendor" = "0bda" -a "$idProduct" = "f179" ]; then
    WIFIDRV=8188fu
elif [ "$idProduct" = "7601" ]; then
    WIFIDRV=mt7601Usta
fi
if [ -n "$WIFIDRV" ]; then
    for w in $WIFIDRVS; do
        if [ $w != $WIFIDRV ]; then rm -f $DRVPATH/$w.ko*; fi
    done
    insmod $DRVPATH/$WIFIDRV.ko.lzma || insmod $DRVPATH/$WIFIDRV.ko
fi
wpa_supplicant -B -iwlan0 -Dwext -c /media/fake_root/home/wpa_supplicant.conf > /media/wpa_supplicant.log
udhcpc -i wlan0 -q > /media/udhcpc.log
