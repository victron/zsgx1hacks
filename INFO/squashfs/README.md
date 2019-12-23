# squashfs

## INSTALL

bin in distro can not support some compressions

- `https://github.com/plougher/squashfs-tools/archive/4.4.tar.gz`
- some headers in
```
sudo apt install libzstd1-dev
sudo apt install liblzo2-dev
sudo apt install liblzma-dev
```
- edit/replace [./squashfs-tools-4.4/squashfs-tools/Makefile](/INFO/squashfs/Makefile)
- as always `make` `sudo make install`

## mount

```
sudo mount _Hip_Mod_fw.img.extracted/1F0000.squashfs sq1
sudo mount _Hip_Mod_fw.img.extracted/410000.squashfs sq2
```

## working notes
[Неизвестный losetup и создание дискового раздела в файле ](https://www.stableit.ru/2011/05/losetup.html)
```
losetup /dev/loop0 partition.img
file /dev/loop0
/dev/loop0: block special
mount /dev/loop0 /mnt
losetup -a
/dev/loop0: [0902]:4358159 (/root/partition.img)
losetup -d /dev/loop0
```

[How to build an sd card image, without an sd card?](https://superuser.com/questions/830733/how-to-build-an-sd-card-image-without-an-sd-card)

[Creating and using squashed file systems](http://tldp.org/HOWTO/SquashFS-HOWTO/creatingandusing.html)

