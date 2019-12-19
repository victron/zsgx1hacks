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
