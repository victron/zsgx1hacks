# Wanscam 

## Info
hacked bin from [4pda](http://4pda.ru/forum/index.php?showtopic=928641&view=findpost&p=89274008)

### extract

- `binwalk -e Hip_Mod_fw_S.img`
- `find . -maxdepth 1 -type f ! -name '*.squashfs' -exec rm {} \;`

### mount
```
mkdir s_7102S
mkdir s0_7102S
sudo mount 1F0000.squashfs s_7102S
sudo mount 410000.squashfs s0_7102S
```

### config files
looks for initial config needed
- config_info.ini, 
- .wifi_conn_info, 
- mac.ini, (?) 
- myuid.bin (?)

after first reboot camera resetting `.wifi_conn_inf` but creates `.config1`
need to recreate `.wifi_conn_inf` and next boot with `.config1` is OK.

TODO: fully disabled p2pcam - my method