# ParvOS

A really stupid operating system.  Planning to get something that works to some very limited
degree on a Raspberry Pi (and also QEMU emulating one, which will require a few differences),
and a PC.

Raspberry Pi QEMU is the first target.

## Toolchain

### ARM / Raspberry Pi

We need the ARM cross-compiler from https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads
-- it is assumed to be installed into the .gitignored directory `toolchain`, subdirectory `rpi`, such
that (from the directory containing this file) `./toolchain/rpi/bin/arm-none-eabi-gcc` is the GCC compiler.


### PC

We need a cross-compiler as per https://wiki.osdev.org/GCC_Cross-Compiler installed into the
.gitignored directory `toolchain`, subdirectory `i686`

The following steps worked on my Ubuntu machine:

    cd toolchain/
    mkdir i686
    cd i686
    wget https://mirror.koddos.net/gnu/binutils/binutils-2.31.tar.gz
    wget ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-8.2.0/gcc-8.2.0.tar.gz
    export PREFIX=`pwd`
    export TARGET=i686-elf
    export PATH="$PREFIX/bin:$PATH"
    tar xf binutils-2.31.tar.gz
    mkdir build-binutils
	cd build-binutils/
    ../binutils-2.31/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
    make
    make install
    cd ..
    mkdir build-gcc
    tar xf gcc-8.2.0.tar.gz
    cd build-gcc/
    ../gcc-8.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
    make all-gcc
    make all-target-libgcc
    make install-gcc
    make install-target-libgcc
