# =========================
# Project Settings
# =========================
TARGET = lvgl_stm32f429
BUILD_DIR = build
SRC_DIRS = HAL_Driver/Src lvgl src
INC_DIRS = inc HAL_Driver/Inc CMSIS/core CMSIS/device lvgl

# =========================
# Compiler Settings
# =========================
CC = arm-none-eabi-gcc
CFLAGS = -Wall -O2 -mcpu=cortex-m4 -mthumb
INCLUDES = $(foreach dir,$(INC_DIRS),-I$(dir))

# =========================
# Check LVGL Submodule
# =========================
LVGL_DIR = lvgl
ifeq ("$(wildcard $(LVGL_DIR)/lvgl.h)","")
$(error "LVGL submodule not found! Please run: git submodule update --init --recursive")
endif

# =========================
# Sources & Objects
# =========================
SRCS = $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.c))
OBJS = $(patsubst %.c,$(BUILD_DIR)/%.o,$(SRCS))

# Create build folder structure
$(shell mkdir -p $(BUILD_DIR)/HAL_Driver/Src $(BUILD_DIR)/lvgl $(BUILD_DIR)/src)

# =========================
# Build Rules
# =========================
all: $(BUILD_DIR)/$(TARGET).elf

$(BUILD_DIR)/%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -T LinkerScript.ld -o $@

clean:
	rm -rf $(BUILD_DIR)/*

.PHONY: all clean
