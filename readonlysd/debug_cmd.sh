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

# start ftp server
(/home/busybox/tcpsvd -E 0.0.0.0 21 /home/busybox/ftpd -w / ) &

# new config
/media/hack/new_config.sh &

# silence the voices - uncomment if needed
#if [ ! -f /home/VOICE-orig.tgz ]; then
#    cp /home/VOICE.tgz /home/VOICE-orig.tgz
#fi
#
#cp /media/hack/VOICE-new.tgz /home/VOICE.tgz

#
############
