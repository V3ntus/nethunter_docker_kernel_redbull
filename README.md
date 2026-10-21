Linux kernel
============

There are several guides for kernel developers and users. These guides can
be rendered in a number of formats, like HTML and PDF. Please read
Documentation/admin-guide/README.rst first.

In order to build the documentation, use ``make htmldocs`` or
``make pdfdocs``.  The formatted documentation can also be read online at:

    https://www.kernel.org/doc/html/latest/

There are various text files in the Documentation/ subdirectory,
several of them using the Restructured Text markup notation.
See Documentation/00-INDEX for a list of what is contained in each file.

Please read the Documentation/process/changes.rst file, as it contains the
requirements for building and running the kernel, and information about
the problems which may result by upgrading your kernel.


# Setup

## 0x01 Environment preparation

It's recommended to run this in an Ubuntu 22.04 or Debian 10 VM/container/machine. I was able to compile this in DistroBox under NixOS using Ubuntu 22.04.

```
apt update && apt upgrade -y && apt full-upgrade -y && apt install -y curl wget vim git ccache automake flex lzop bison gperf \
build-essential zip zlib1g-dev g++-multilib libxml2-utils bzip2 libbz2-dev \
libbz2-1.0 libghc-bzlib-dev squashfs-tools pngcrush schedtool dpkg-dev \
liblz4-tool make optipng maven libssl-dev pwgen libswitch-perl \
policycoreutils minicom libxml-sax-base-perl libxml-simple-perl bc \
libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev \
libgl1-mesa-dev xsltproc unzip device-tree-compiler kmod python3 python3-pip
```

## 0x02 Download the cross-compilation toolchain and kernel 

```
cd /root

git clone https://github.com/kdrag0n/proton-clang.git --depth=1

git clone https://github.com/tomxi1997/nethunter_docker_kernel_redbull.git
```

## 0x03 Patch kernel

```
cd nethunter_docker_kernel_redbull

patch -p1 < add-rtl88xxau-5.6.4.2-drivers.patch
patch -p1 < add-wifi-injection-4.14.patch
patch -p1 < add-kprobe-config.patch
```

## 0x04 Configure the kernel and pull KernelSU Next

Feel free to configure options to your liking. The kernel should already be pre-configured so you can just save and exit.

### KernelSU Next Note!

Currently, this script pulls the UAPI 5 commit for KernelSU Next hooks because the KernelSU Next manager is still on UAPI 5.

Change the commit hash in this script to update.

```
./1.sh
```

## 0x05 Compile the kernel and kernel modules

```
./2.sh
```

You will get the kernel in `out/arch/arm64/boot` it may be `Image` or `image.gz.dtb`.  Get the kernel module in `out/lib/module`.

## 0x06 Rebuild a boot.img

Pull a stock `boot.img` from the factory image. Copy your built `Image` to `kernel` and use `magiskboot` to repack the original `boot.img` to a new boot image:

```
[nix-shell:~/Downloads/bramble/bramble-sq3a.220705.003.a1]$ ls
boot.img kernel
[nix-shell:~/Downloads/bramble/bramble-sq3a.220705.003.a1]$ ../../magiskboot-linux-main/x86_64/magiskboot repack boot.img new-boot.img
Parsing boot image: [boot.img]
HEADER_VER      [3]
KERNEL_SZ       [11731519]
RAMDISK_SZ      [1380363]
OS_VERSION      [12.0.0]
OS_PATCH_LEVEL  [2022-07]
PAGESIZE        [4096]
CMDLINE         []
KERNEL_FMT      [lz4]
RAMDISK_FMT     [lz4_legacy]
VBMETA
Repack to boot image: [new-boot.img]
HEADER_VER      [3]
KERNEL_SZ       [25112507]
RAMDISK_SZ      [0]
OS_VERSION      [12.0.0]
OS_PATCH_LEVEL  [2022-07]
PAGESIZE        [4096]
CMDLINE         []
```
```
```


## 0x07 Boot the kernel and install KernelSU_Next manager

Reboot the phone into the bootloader and run `fastboot boot new-boot.img`.

When it boots, install KernelSU_Next manager app.

Enjoy!

