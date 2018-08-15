.DEFAULT_GOAL := all

TOOLCHAIN_PATH = ./toolchain/rpi/bin
AS = $(TOOLCHAIN_PATH)/arm-none-eabi-as
CC = $(TOOLCHAIN_PATH)/arm-none-eabi-gcc
LD = $(TOOLCHAIN_PATH)/arm-none-eabi-ld
OBJCOPY = $(TOOLCHAIN_PATH)/arm-none-eabi-objcopy

BASE_ADDRESS = 0x00008000

CFLAGS = -O2
LDFLAGS = -Ttext $(BASE_ADDRESS)

AS_SRC = $(wildcard *.s)
AS_OBJ = $(AS_SRC:.s=.o)
C_SRC = $(wildcard *.c)
C_OBJ = $(C_SRC:.c=.o)

.%.o: %.s
	$(AS) $< -o $@

.%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

kernel.elf: $(AS_OBJ) $(C_OBJ)
	$(LD) $(LDFLAGS) $^ -o $@

kernel.img:	kernel.elf
	$(OBJCOPY) $< -O binary $@

all: kernel.img

clean:
	rm -f *.o *.elf *.img
