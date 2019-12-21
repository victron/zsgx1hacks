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

# disable p2pcam
/media/hack/p2pcam_off.sh

# new settings for p2pcam
# mount --bind /media/fake_root/home/hwcfg.ini /home/hwcfg.ini

# custom p2pcam
# http://4pda.ru/forum/index.php?showtopic=928641
# mount --bind /media/fake_root/p2pcam/p2pcam /p2pcam/p2pcam

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
