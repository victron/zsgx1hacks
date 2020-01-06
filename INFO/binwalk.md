# binwalk

- `binwalk Hip_Mod_fw.img` just to see what inside
- `binwalk -e Hip_Mod_fw.img` extract all

## filter options
should be in low case
`-y` include, `-x` exclude
- `binwalk -y filesystem -e Hip_Mod_fw_S.img` extract only filesystem
- `binwalk -y squashfs Hip_Mod_fw_S.img`


## info about decompress
https://www.securitylab.ru/analytics/451089.php
https://habr.com/ru/post/213411/

### extract

- `binwalk -e Hip_Mod_fw_S.img`
with dd it like this
```
$ binwalk -y squashfs Hip_Mod_fw_S.img                                                                                                          [10:31:16]

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
2031616       0x1F0000        Squashfs filesystem, little endian, version 4.0, compression:xz, size: 1731878 bytes, 637 inodes, blocksize: 65536 bytes, created: 2019-09-25 18:43:38
4259840       0x410000        Squashfs filesystem, little endian, version 4.0, compression:xz, size: 3640509 bytes, 301 inodes, blocksize: 65536 bytes, created: 2019-11-04 15:21:46
```
```
$ binwalk Hip_Mod_fw_S.img | more                                                                                                               [11:53:57]

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
162840        0x27C18         CRC32 polynomial table, little endian
169348        0x29584         CRC32 polynomial table, little endian
2031616       0x1F0000        Squashfs filesystem, little endian, version 4.0, compression:xz, size: 1731878 bytes, 637 inodes, blocksize: 65536 bytes, created: 2019-09-25 18:43:38
3932160       0x3C0000        JFFS2 filesystem, little endian
..........
4128768       0x3F0000        JFFS2 filesystem, little endian
4259840       0x410000        Squashfs filesystem, little endian, version 4.0, compression:xz, size: 3640509 bytes, 301 inodes, blocksize: 65536 bytes, created: 2019-11-04 15:21:46
```
4128768 - 2031616 = 2097152
TODO: why not 4259840 - 2031616 ?????
```
dd if=Hip_Mod_fw_S.img of=test1 bs=1 skip=2031616 count=2097152
dd if=Hip_Mod_fw_S.img of=test2 bs=1 skip=4259840
```

- `find . -maxdepth 1 -type f ! -name '*.squashfs' -exec rm {} \;`
or 


### from @bolshevic README.md
```
dd bs=65536 skip=31 count=29 if=$FILE of=mtd3_ro.img
dd bs=65536 skip=60 count=5  if=$FILE of=mtd4_config.img
dd bs=65536 skip=65 count=63 if=$FILE of=mtd5_home.img
```
Note: if flash layout changes, offsets can always be found by grepping `strings FIRMWARE | grep mtdparts=`

```
$ strings Hip_Mod_fw_S.img | grep mtdparts=                                                                                                     [10:31:09] bootargs=console=ttySGK0,115200 mem=36M rootfstype=squashfs root=/dev/mtdblock2 init=linuxrc mtdparts=gk_flash:320K(U),1664K(K),1152K(R),-(A)
```
(320 + 1664) * 1024 = 2031616
2031616 / 65536
```
bootargs=console=ttySGK0,115200 mem=36M rootfstype=squashfs root=/dev/mtdblock2 init=linuxrc mtdparts=gk_flash:320K(U),1664K(K),1856K(R),320K(Cg),-(H)
```
(320 + 1664 + 1856 + 320) * 1024/65536 = 65