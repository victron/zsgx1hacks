# Manual input
based on https://github.com/bolshevik/goke-GK7102-customizer
```
killall p2pcam && sleep 2 && echo "V" > /dev/watchdog

PID=$(ps | grep "/home/rsyscall.goke" | grep -v grep | awk '{print($1);}')
kill -9 $PID
rm -rf /tmp/VOICE/
rm -rf /tmp/closelicamera.log
umount /p2pcam/p2pcam
umount /p2pcam

NEW_ROOT=/tmp/root2
cd /media/fake_root/home/
#cd /media/custom_firmware
BASEDIR=.
mkdir -p $NEW_ROOT

source $BASEDIR/config.txt
echo "$MACADDR" > $BASEDIR/data/myuid.bin
echo "$MACADDR" | sed 's/\([0-9A-F]\{2\}\)/\\\\\\x\1/gI' | xargs printf > $BASEDIR/data/mac.ini
$BASEDIR/edit_config.arm -config "$BASEDIR/data/.wifi_conn_info" -current 0 -index 0 -ssid "$WIFI_SSID" -password "$WIFI_PASS" -reset 1



mount -t squashfs -o loop $BASEDIR/mtd3_ro.img $NEW_ROOT
mount -t squashfs -o loop $BASEDIR/mtd5_home.img $NEW_ROOT/home/
mount --bind $BASEDIR/data $NEW_ROOT/data/
mount --bind /media/ $NEW_ROOT/media/

mount -t proc none $NEW_ROOT/proc
# mount -t proc proc $NEW_ROOT/proc
mount --rbind /sys $NEW_ROOT/sys/
mount --rbind /tmp $NEW_ROOT/tmp/
mount --rbind /run $NEW_ROOT/run/

mkdir -p $NEW_ROOT/tmp/wanscam_etc/
cp -R $NEW_ROOT/etc/* $NEW_ROOT/tmp/wanscam_etc/
mount --bind $NEW_ROOT/tmp/wanscam_etc/ $NEW_ROOT/etc/

# mount --bind /home/drv $NEW_ROOT/usr/ko

mount --bind $NEW_ROOT/tmp/ $NEW_ROOT/var/
mkdir -p $NEW_ROOT/var/run/hostapd
mkdir -p $NEW_ROOT/var/lib/misc
touch $NEW_ROOT/var/lib/misc/udhcpd.leases
mkdir -p $NEW_ROOT/var/run/wpa_supplicant

cp -r /etc/sensors/* $NEW_ROOT/etc/sensors/

rmmod timer_drv
rmmod gkptz_gpio
rmmod gio

insmod $NEW_ROOT/home/ko/hi_reg.ko
insmod $NEW_ROOT/home/ko/goke_gpio.ko
insmod $NEW_ROOT/home/ko/gpioi2c.ko
insmod $NEW_ROOT/home/ko/timer_drv.ko

mount -t tmpfs defaults $NEW_ROOT/dev/
mount --bind $BASEDIR/mods/version.ini $NEW_ROOT/home/version.ini
chroot $NEW_ROOT

/etc/init.d/S10mdev start
/etc/init.d/S11devnode start
/etc/init.d/S20urandom start
```

## set path to firmware (out of chroot)
to mount firmware.
if p2pcam not loaded at all, it's need load correct ver of firmware 
```
NEW_ROOT=/tmp/root2
cd /media/fake_root/home/
BASEDIR=.
mount --bind $BASEDIR/mods/version.ini $NEW_ROOT/home/version.ini
rm $NEW_ROOT/dev/mtd*
#mount --bind ${NEW_ROOT}/home/firmware ${NEW_ROOT}/lib/firmware
mount --bind /media/firmware.orig/ ${NEW_ROOT}/lib/firmware
```

## start ipc
```
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin
ifconfig wlan0 down && killall wpa_supplicant && /home/ipc sensortype=gc2033
```



## Some working cmd
```
b=/media/_bolshevik/custom_firmware/data
m=/media/_my_custom/fake_root/home/data
cur=/media/fake_root/home/data

rm -R $cur/*
#cp $b/.wifi_conn_info $cur/
cp $b/config_info.ini $cur/
cp $b/config_info_38_sgy.ini $cur/
#cp $b/mac.ini $cur/
cp $b/.config1 $cur/
cp $b/myuid.bin $cur/
#cp $b/.sensortype $cur/


cp /media/_my_custom/fake_root/home/data/.wifi_conn_info /media/fake_root/home/data/.wifi_conn_info
cp /media/_my_custom/fake_root/home/data/mac.ini /media/fake_root/home/data/mac.ini
```
```
[root@localhost: /root]# ls -la $cur
total 28
drwxr-xr-x    2 root     root          4096 Dec 28 12:43 .
drwxr-xr-x   13 root     root          4096 Dec 27 21:16 ..
-rwxr-xr-x    1 root     root          3335 Dec 28 12:03 .config1
-rwxr-xr-x    1 root     root           507 Dec 28 12:42 .wifi_conn_info
-rwxr-xr-x    1 root     root           379 Dec 28 12:35 config_info.ini
-rwxr-xr-x    1 root     root             6 Dec 28 12:42 mac.ini
-rwxr-xr-x    1 root     root            13 Dec 28 12:03 myuid.bin



[root@localhost: /media/fake_root/home]# hd data/.wifi_conn_info
00000000  00 00 04 00 00 00 4a 5f  77 34 56 67 68 2d 6a 54  |......J_w4Vgh-jT|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000040  00 00 00 00 00 00 43 65  6e 74 72 61 6c 65 00 00  |......Centrale..|
00000050  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000060  00 00 00 00 00 00 01 00  00 00 00 00 00 00 00 00  |................|
00000070  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001f0
```



# memory
## p2pcam is active
```
[root@localhost: /root]# free
             total         used         free       shared      buffers
Mem:         31908        30820         1088            0         4432
-/+ buffers:              26388         5520
Swap:            0            0            0
[root@localhost: /root]#
```
## p2pcam is disabled
```
[root@localhost: /root]# free
             total         used         free       shared      buffers
Mem:         31908        19204        12704            0         3620
-/+ buffers:              15584        16324
Swap:            0            0            0
```
## mounted 
```
[root@localhost: /media/fake_root/home]# free
             total         used         free       shared      buffers
Mem:         31908        22784         9124            0         3696
-/+ buffers:              19088        12820
Swap:            0            0            0
```
## after rmmod
```
[root@localhost: /media/fake_root/home]# free
             total         used         free       shared      buffers
Mem:         31908        22712         9196            0         3696
-/+ buffers:              19016        12892
Swap:            0            0            0
```
## after insmod
```
[root@localhost: /media/fake_root/home]# free
             total         used         free       shared      buffers
Mem:         31908        22920         8988            0         3740
-/+ buffers:              19180        12728
Swap:            0            0            0
```
## after init scripts
```
[root@localhost: /]# free
             total         used         free       shared      buffers
Mem:         31908        25952         5956            0         4236
-/+ buffers:              21716        10192
Swap:            0            0            0
```
## ipc start (old PATH)
```
[root@localhost: /root]# free
             total         used         free       shared      buffers
Mem:         31908        30916          992            0         3100
-/+ buffers:              27816         4092
Swap:            0            0            0
[root@localhost: /root]# free
             total         used         free       shared      buffers
Mem:         31908        30784         1124            0         3008
-/+ buffers:              27776         4132
Swap:            0            0            0

```



# p2pcam disabled (my method)
```
[root@GK710XS: /root]# free
             total         used         free       shared      buffers
Mem:         31908        15364        16544            0           60
-/+ buffers:              15304        16604
Swap:            0            0            0
```
## after rm vice
```
[root@GK710XS: /root]# free
             total         used         free       shared      buffers
Mem:         31908        14616        17292            0           60
-/+ buffers:              14556        17352
Swap:            0            0            0
```
## after all mount
```
[root@GK710XS: /root]# free
             total         used         free       shared      buffers
Mem:         31908        18432        13476            0          160
-/+ buffers:              18272        13636
Swap:            0            0            0
```
## after rmmod 
```
[root@GK710XS: /root]# free
             total         used         free       shared      buffers
Mem:         31908        18400        13508            0          160
-/+ buffers:              18240        13668
Swap:            0            0            0
```
after insmod
```
[root@GK710XS: /root]# free
             total         used         free       shared      buffers
Mem:         31908        18620        13288            0          204
-/+ buffers:              18416        13492
Swap:            0            0            0
```
after init scripts
```
[root@GK710XS: /root]# free
             total         used         free       shared      buffers
Mem:         31908        21460        10448            0          644
-/+ buffers:              20816        11092
Swap:            0            0            0
```
## ipc
```
[root@GK710XS: /root]# free
             total         used         free       shared      buffers
Mem:         31908        30684         1224            0         5520
-/+ buffers:              25164         6744
Swap:            0            0            0
```
with firmware
```
[root@GK710XS: /media/fake_root/home]# free
             total         used         free       shared      buffers
Mem:         31908        30772         1136            0          908
-/+ buffers:              29864         2044
Swap:            0            0            0
```


# modules
## with p2pcam
```
gkptz_gpio 17916 0 - Live 0x7f168000 (O)
9083h 647841 0 - Live 0x7f0ad000 (O)
gc2033_ex 11210 0 - Live 0x7f0a7000 (O)
sensor 155912 1 gc2033_ex, Live 0x7f07d000 (PO)
audio 8700 4 - Live 0x7f077000 (PO)
media 259569 7 sensor, Live 0x7f02f000 (PO)
hw_crypto 1948 1 media, Live 0x7f02b000 (PO)
hal 31555 1 media, Live 0x7f01f000 (PO)
exfat 88974 0 - Live 0x7f004000 (O)
gio 1587 1 - Live 0x7f000000 (O)
[root@localhost: /root]#

[root@localhost: /root]#
```
## completly disabled p2pcam

```
[root@GK710XS: /]# lsmod
timer_drv 7875 0 - Live 0x7f23a000 (O)
gpioi2c 6134 0 - Live 0x7f235000 (O)
goke_gpio 1877 2 timer_drv,gpioi2c, Live 0x7f231000 (O)
hi_reg 1050 0 - Live 0x7f22d000 (O)
9083h 647841 0 - Live 0x7f0ad000 (O)
gc2033_ex 11210 0 - Live 0x7f0a7000 (O)
sensor 155912 1 gc2033_ex, Live 0x7f07d000 (PO)
audio 8700 0 - Live 0x7f077000 (PO)
media 259569 1 sensor, Live 0x7f02f000 (PO)
hw_crypto 1948 1 media, Live 0x7f02b000 (PO)
hal 31555 1 media, Live 0x7f01f000 (PO)
exfat 88974 0 - Live 0x7f004000 (O)

```
