#!/bin/sh

# ANT-THOMAS
############
# HACKS HERE

# mount sd card to separate location
if [ -b /dev/mmcblk0p1 ]; then
	mount -t vfat /dev/mmcblk0p1  /media
elif [ -b /dev/mmcblk0 ]; then
	mount -t vfat /dev/mmcblk0 /media
fi

# confirm hack type
touch /home/HACKSD

mkdir -p /home/busybox

# install updated version of busybox
mount --bind /media/hack/busybox /bin/busybox
/bin/busybox --install -s /home/busybox

# set new env
mount --bind /media/hack/profile /etc/profile

# possibly needed but may not be
mount --bind /media/hack/group /etc/group
mount --bind /media/hack/passwd /etc/passwd
mount --bind /media/hack/shadow /etc/shadow

# update hosts file to prevent communication
mount --bind /media/hack/hosts.new /etc/hosts

# busybox httpd
/home/busybox/httpd -p 8080 -h /media/hack/www

# setup and install dropbear ssh server - no password login
/media/hack/dropbearmulti dropbear -r /media/hack/dropbear_ecdsa_host_key -B

# start ftp server
(/home/busybox/tcpsvd -E 0.0.0.0 21 /home/busybox/ftpd -w / ) &

# sync the time
(/media/hack/test_connect.sh 40 europe.pool.ntp.org && \
/home/busybox/ntpd -p europe.pool.ntp.org || \
echo "may be need to run reboot") &

# set timezone
# https://docs.oracle.com/cd/E19057-01/nscp.cal.svr.35/816-5523-10/appf.htm
echo "EET-2EETDST" > /etc/TZ

# silence the voices - uncomment if needed
#if [ ! -f /home/VOICE-orig.tgz ]; then
#    cp /home/VOICE.tgz /home/VOICE-orig.tgz
#fi
#
#cp /media/hack/VOICE-new.tgz /home/VOICE.tgz

#
############
