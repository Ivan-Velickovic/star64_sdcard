# Star64 microSD card setup

This repository holds a very niche purpose. It contains a script (`build_image.sh`)
that attempts to build a flashable image for the Pine64 Star64 SBC. This image
contains U-Boot SPL, OpenSBI, and a full U-Boot. It *does not* contain Linux.

It does not contain Linux as the purpose is for those who are using TFTP to boot
or are trying to run something other than Linux! This script is very useful for
my work around the seL4 microkernel, but will hopefully be useful for anyone
working on a hobby kernel too!

## Dependenices
* Make
* `mkimage` tool
* `genimage` tool
* riscv64-linux-gnu C toolchain

## Making the image

```sh
$ git clone --recursive https://github.com/Ivan-Velickovic/star64_sdcard.git
$ cd star64_sdcard
$ ./build_image.sh
$ ls images
sdcard.img
```

You can then flash the image onto your microSD card using either
[balenaEtcher](https://www.balena.io/etcher) or the `dd` utility.

## Credit

Thanks to Fishwaldo for the port of [U-Boot to the Pine64](https://github.com/Fishwaldo/u-boot).
At the time of writing mainline U-Boot is yet to have support for the Pine64, which is why
Fishwaldo's fork of U-Boot is used.

