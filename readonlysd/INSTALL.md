# install instructions
- copy content of this dir in root of SD card
- set wifi settings in `cls.conf` (no empty line at the end)

## change passwords

generate hash
```
mkpasswd --method=SHA-512 <new_password>
```
put hash inside `/media/fake_root/etc/shadow`

## change ssh host keys

```
rm /media/fake_root/etc/dropbear/*
cd /media/fake_root/bin/
./dropbearmulti dropbearkey -t rsa -f /media/fake_root/etc/dropbear/dropbear_rsa_host_key
./dropbearmulti dropbearkey -t dss -f /media/fake_root/etc/dropbear/dropbear_dss_host_key
./dropbearmulti dropbearkey -t ecdsa -f /media/fake_root/etc/dropbear/dropbear_ecdsa_host_key
```


## ssh public key
put your key in `~/.ssh/authorized_keys`
file permissions not checked. (looks a bug in dropbear-2016.74 fortunately:) ) 
