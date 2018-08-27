.DEFAULT_GOAL := all

ARCH = rpi
CPU = cortex-a7

TOOLCHAIN_PATH = ./toolchain/$(ARCH)/bin
AS = $(TOOLCHAIN_PATH)/arm-none-eabi-as
CC = $(TOOLCHAIN_PATH)/arm-none-eabi-gcc
LD = $(TOOLCHAIN_PATH)/arm-none-eabi-ld
OBJCOPY = $(TOOLCHAIN_PATH)/arm-none-eabi-objcopy

CFLAGS = -mcpu=$(CPU) -O2 -I.

ARCH_DIR = ./arch/$(ARCH)
BUILD_DIR = ./build/$(ARCH)

GENERIC_AS_SRC = $(wildcard *.s)
GENERIC_AS_OBJ = $(patsubst %.s, $(BUILD_DIR)/%.o, $(GENERIC_AS_SRC))
ARCH_AS_SRC = $(wildcard $(ARCH_DIR)/*.s)
ARCH_AS_OBJ = $(patsubst $(ARCH_DIR)/%.s, $(BUILD_DIR)/%.o, $(ARCH_AS_SRC))

GENERIC_C_SRC = $(wildcard *.c)
GENERIC_C_OBJ = $(patsubst %.c, $(BUILD_DIR)/%.o, $(GENERIC_C_SRC))
ARCH_C_SRC = $(wildcard $(ARCH_DIR)/*.c)
ARCH_C_OBJ = $(patsubst $(ARCH_DIR)/%.c, $(BUILD_DIR)/%.o, $(ARCH_C_SRC))

$(BUILD_DIR)/%.o: $(ARCH_DIR)/%.s
	mkdir -p $(@D)
	$(AS) $< -o $@

$(BUILD_DIR)/%.o: %.s
	mkdir -p $(@D)
	$(AS) $< -o $@

$(BUILD_DIR)/%.o: $(ARCH_DIR)/%.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: %.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/kernel.elf: $(GENERIC_AS_OBJ) $(ARCH_AS_OBJ) $(GENERIC_C_OBJ) $(ARCH_C_OBJ) $(ARCH_DIR)/linker.ld
	$(LD) $(LDFLAGS) -T $(ARCH_DIR)/linker.ld -o $@ $(GENERIC_AS_OBJ) $(ARCH_AS_OBJ) $(GENERIC_C_OBJ) $(ARCH_C_OBJ)

$(BUILD_DIR)/kernel.img: $(BUILD_DIR)/kernel.elf
	$(OBJCOPY) $< -O binary $@

all: $(BUILD_DIR)/kernel.img

clean:
	rm -rf build
