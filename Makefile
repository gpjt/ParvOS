TOOLCHAIN_PATH = ./toolchain/rpi/bin
AS = $(TOOLCHAIN_PATH)/arm-none-eabi-as
CC = $(TOOLCHAIN_PATH)/arm-none-eabi-gcc
LD = $(TOOLCHAIN_PATH)/arm-none-eabi-ld

CFLAGS = -O2
LDFLAGS = -Ttext 0x00008000

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

all: kernel.elf

clean:
	rm -f *.o kernel.elf
