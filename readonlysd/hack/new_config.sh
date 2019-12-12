#!/bin/sh
# sync the time
/media/hack/test_connect.sh 40 europe.pool.ntp.org && \
/home/busybox/ntpd -p europe.pool.ntp.org || \
echo "may be need to run reboot"

# set timezone
# https://docs.oracle.com/cd/E19057-01/nscp.cal.svr.35/816-5523-10/appf.htm
echo "EET-2EETDST" > /etc/TZ

# -------- new configs -------------
# new users and groups
mount --bind /media/fake_root/etc/group /etc/group
mount --bind /media/fake_root/etc/passwd /etc/passwd
mount --bind /media/fake_root/etc/shadow /etc/shadow
mount --bind /media/fake_root/root /root
# set new env
mount --bind /media/fake_root/etc/profile /etc/profile
# update hosts file to prevent communication
mount --bind /media/fake_root/etc/hosts /etc/hosts

# create link on /var/log
ln -s /media/fake_root/var/log /var/log

# create empty wtmp
echo '' > /var/log/wtmp

# busybox httpd
/home/busybox/httpd -p 8080 -h /media/hack/www

# setup and install dropbear ssh server
/media/fake_root/bin/dropbearmulti dropbear -R
