# =========================
# Project
# =========================
TARGET = lvgl_stm32f429
BUILD_DIR = build

# =========================
# Toolchain
# =========================
CC = arm-none-eabi-gcc
AS = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
SIZE = arm-none-eabi-size

# =========================
# MCU & Flags
# =========================
MCU = cortex-m4
CPU_FLAGS = -mcpu=$(MCU) -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard

DEFS = -DUSE_HAL_DRIVER -DSTM32F429xx
CFLAGS = $(CPU_FLAGS) -O2 -Wall -ffunction-sections -fdata-sections $(DEFS)

# =========================
# Includes
# =========================
INCLUDES = -I. -Isrc -Iinc \
           -ICMSIS/core -ICMSIS/device \
           -IHAL_Driver/Inc \
           -Ilvgl/src

# =========================
# Linker
# =========================
LDSCRIPT = LinkerScript.ld
LDFLAGS = $(CPU_FLAGS) -T$(LDSCRIPT) -Wl,--gc-sections

# =========================
# Sources
# =========================
C_SOURCES = src/main.c src/system_stm32f4xx.c src/stm32f4xx_it.c src/syscalls.c
HAL_SOURCES = HAL_Driver/Src/stm32f4xx_hal.c HAL_Driver/Src/stm32f4xx_hal_gpio.c HAL_Driver/Src/stm32f4xx_hal_rcc.c HAL_Driver/Src/stm32f4xx_hal_dma.c HAL_Driver/Src/stm32f4xx_hal_cortex.c
LVGL_SOURCES = $(shell find lvgl/src -name "*.c")

SOURCES = $(C_SOURCES) $(HAL_SOURCES) $(LVGL_SOURCES)
OBJECTS = $(addprefix $(BUILD_DIR)/, $(SOURCES:.c=.o))

# =========================
# Rules
# =========================
all: $(BUILD_DIR)/$(TARGET).elf

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS)
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SIZE) $@

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean
