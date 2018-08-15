# ParvOS

A really stupid operating system.  Planning to get something that works to some very limited
degree on a Raspberry Pi (and also QEMU emulating one, which will require a few differences),
and a PC.

Raspberry Pi QEMU is the first target.

## Toolchain

We need the ARM cross-compiler from https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads
-- it is assumed to be installed into the .gitignored directory `toolchain`, subdirector `rpi`, such
that (from the directory containing this file) `./toolchain/rpi/bin/arm-none-eabi-gcc` is the GCC compiler.





