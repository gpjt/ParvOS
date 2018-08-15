TOOLCHAIN_PATH = ./toolchain/rpi/bin
AS = $(TOOLCHAIN_PATH)/arm-none-eabi-as
CC = $(TOOLCHAIN_PATH)/arm-none-eabi-gcc

CFLAGS = -O2

.%.o: %.s
	$(AS) $< -o $@

.%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

all: bootstrap.o kernel_main.o

clean:
	rm -f *.o
