#!/bin/sh  
#
#    ------------------------------------------------------------
#      GK7101      flashwriterFlash                    4PDA
###

echo exec flash writer .......

#read from hardinfo.bin
getHwInfo()
{
	grep $1 /home/hardinfo.bin | awk -F '>'  '{print $2}' | awk -F '<' '{print $1}'
}

echo "Mod FW programming" > /mnt/mod_wr.txt 

BOARDID=$(getHwInfo FirmwareIdent)
echo "$BOARDID" >> /mnt/mod_wr.txt 
if [ "$BOARDID" = "eyeplus_ipc_gk_005" -o "$BOARDID" = "eyeplus_ipc_gk_008" -o "$BOARDID" = "eyeplus_ipc_gk_002" ]; then
	MNTPT=/mnt
	USERDIR=/home
	FLASHWRITER=flashwriterFlash
	FLASHBIN=Hip_Mod_fw.img
else
  echo 'Unknown target.'
  echo "Unknown target." >> /mnt/mod_wr.txt 
  exit
fi

if [ -f $MNTPT/$FLASHBIN ];then
	cp /home/eye.conf $MNTPT/eye.conf
	dd if=/dev/mtd0 of=$MNTPT/mtd0.im
	dd if=/dev/mtd1 of=$MNTPT/mtd1.im
	dd if=/dev/mtd2 of=$MNTPT/mtd2.im
	dd if=/dev/mtd3 of=$MNTPT/mtd3.im
	dd if=/dev/mtd4 of=$MNTPT/mtd4.im
	dd if=/dev/mtd5 of=$MNTPT/mtd5.im

	cat $MNTPT/mtd0.im $MNTPT/mtd1.im $MNTPT/mtd2.im $MNTPT/mtd3.im $MNTPT/mtd4.im $MNTPT/mtd5.im >> $MNTPT/fullDump_Hip.img
	echo "Backup fullDump_Hip.img OK!" >> /mnt/mod_wr.txt 
	sleep 5

	$MNTPT/$FLASHWRITER $MNTPT/$FLASHBIN
	mv $MNTPT/$FLASHBIN $MNTPT/$FLASHBIN.upd
	echo "FLASH write OK!" >> /mnt/mod_wr.txt 
	reboot
	sleep 1000
fi
	