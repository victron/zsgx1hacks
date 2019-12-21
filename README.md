# Improve Y4C-ZA

All current changes related to `./readonlysd`

## Info

- legacy [parent](https://github.com/ant-thomas/zsgx1hacks) project
- install [instruction](./readonlysd/INSTALL.md)
- build [info](./INFO/buildroot/README.md)
- PTZ and IfRed: http://iP-Addr:8080/cgi-bin/webui (http://4pda.ru/forum/index.php?showtopic=928641&st=0#entry79020856)

### iSpy notes

#### PTZ
[info source](http://4pda.ru/forum/index.php?showtopic=928641&view=findpost&p=85725897)
add to the end
```
  <Camera id="259">
    <Makes>
      <Make Name="GK7102" Model="HIP-291G-2M-IA" />
    </Makes>
    <CommandURL>/0/av0</CommandURL>
    <Commands>
      <Left>/cgi-bin/webui?command=ptzl</Left>
      <Right>/cgi-bin/webui?command=ptzr</Right>
      <Up>/cgi-bin/webui?command=ptzu</Up>
      <Down>/cgi-bin/webui?command=ptzd</Down>
      <LeftUp>/cgi-bin/webui?command=ptzlu</LeftUp>
      <RightUp>/cgi-bin/webui?command=ptzru</RightUp>
      <LeftDown>/cgi-bin/webui?command=ptzld</LeftDown>
      <RightDown>/cgi-bin/webui?command=ptzrd</RightDown>
      <ZoomIn>/cgi-bin/webui?command=iron</ZoomIn>
      <ZoomOut>/cgi-bin/webui?command=iroff</ZoomOut>
    </Commands>
    <ExtendedCommands>
    </ExtendedCommands>
  </Camera>
```

##### more info
[info about driver](https://github.com/ant-thomas/zsgx1hacks/blob/master/ptz/ptz.md)
[more about driver](http://4pda.ru/forum/index.php?showtopic=928641&view=findpost&p=82742427)


### p2pcam settings
settings located in `/home/hwcfg.ini` or bind to `/media/fake_root/...`

`voice_volume = 4` - info voice volume
`show_osd_time = 1` - show date and time on video stream

#### disable p2pcam

during startup `p2pcam` creates watchdog, so after killing system rebooted
- [p2pcam_off.sh](./readonlysd/hack/p2pcam_off.sh) setup wifi when p2pcam not working, called by [debug_cmd.sh](./readonlysd/debug_cmd.sh)
- [p2pcam_dummy](./readonlysd/fake_root/p2pcam/p2pcam_dummy) empty scripted which called instead bin file by `/home/start.sh`
 - [wpa_supplicant.conf](./readonlysd/fake_root/home/wpa_supplicant.conf) wifi settings
