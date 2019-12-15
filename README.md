# Improve Y4C-ZA

All current changes related to `./readonlysd`

## Info

- legacy [parent](https://github.com/ant-thomas/zsgx1hacks) project
- install [instruction](./readonlysd/INSTALL.md)
- build [info](./BUILD_info/README.md)
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
