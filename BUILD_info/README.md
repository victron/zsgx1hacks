## 1. buildroot: install uClibc toolchain 

- tested on buildroot-2019.11
- for quick inctructions can be used [this](https://www.uclibc.org/toolchains.html)
- to avoid `make menuconfig` can be used one from configs [.config.SHARED](./.config.SHARED) or [.config.STATIC](./.config.STATIC)

```
mv .config.STATIC ..config
```

## 2. common: set env to use toolchain

```
bin=~/Camera/buildroot-2019.11/output/host/bin
sbin=~/Camera/buildroot-2019.11/output/host/sbin
prefix=~/Camera/sysroot
zlib=~/Camera/buildroot-2019.11/output/build/libzlib-1.2.11
strip=~/Camera/buildroot-2019.11/output/host/bin/arm-buildroot-linux-uclibcgnueabi-strip
```
add path to toolchain
`export PATH=$bin:$sbin:$PATH`

## 3. dropbear: build

- tested on dropbear-2016.74
### 3.1. apply patch with new options 

[dropbear-2016.74.patch](./dropbear-2016.74.patch)
```
patch -p1 -i dropbear-2016.74.patch
```
or replace [options.h](./options.h)

### 3.2. configure
```
./configure \
--host=arm-buildroot-linux-uclibcgnueabi \
--disable-lastlog \
--prefix=$prefix \
--disable-zlib \
CFLAGS="-static" \
LDFLAGS="-static" \
--sysconfdir=/media/fake_root/etc/dropbear \
```

- useful options
`CFLAGS="-DDEBUG_TRACE -DDEBUG -g" \` add debug flag `-v`
`--silent` show only warnings and errors
`--disable-loginfunc` configure: Using uClibc - login() and logout() probably don't work, so we won't use them.


available in `dropbear-2019.78`
```
--disable-harden \
--enable-static \
```

- below parameters should be guessed
```
CC=arm-buildroot-linux-uclibcgnueabi-gcc \
LD=arm-buildroot-linux-uclibcgnueabi-ld \
--target=arm-buildroot-linux-uclibcgnueabi \
--build=x86_64-pc-linux-gnu \
```

### 3.3. build and install

```
MULTI=1 SCPPROGRESS=0 PROGRAMS="dropbear" make strip
TODO: dropbearkey not working, also flag -R
# MULTI=1 SCPPROGRESS=0 PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" strip
make PROGRAMS="dropbearmulti" install
# make PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" install
```

`make DESTDIR="${PWD}/root_dir" install` install into dir


## 4. openssh: build

- tested on `openssh-8.1p1`

### 4.1. configure
```
./configure \
--host=arm-buildroot-linux-uclibcgnueabi \
--disable-lastlog \
--prefix=$prefix \
--sysconfdir=/media/fake_root/etc/dropbear \
--without-kerberos5 \
--without-ssl-engine \
--without-pam \
--without-selinux \
--without-openssl \
--with-cflags-after="-static" \
--with-ldflags-after="-static" \
--with-zlib=$zlib \
--disable-strip \
```

### 4.2. build and install
```
make        
make install   # can be error related to prefix
$strip -s $prefix/libexec/sftp-server 
```
`sysroot/libexec/sftp-server`


## 5. useful checks
```
file dropbearmulti
readelf -l dropbearmulti|grep "program interpreter"
readelf -a dropbearmulti
```

