# Target MCU and clock speed
MCU = atmega4809
F_CPU = 20000000UL

# Toolchain programs
CC = /opt/homebrew/Cellar/avr-gcc@14/14.2.0/bin/avr-g++
OBJCOPY = /opt/homebrew/Cellar/avr-binutils/2.43.1/bin/avr-objcopy
AVRDUDE = avrdude
AVRDUDE_CONF = /opt/homebrew/etc/avrdude.conf


# Compiler and linker flags
CFLAGS = -mmcu=$(MCU) -DF_CPU=$(F_CPU) -Os -Wall -I/opt/homebrew/Cellar/avr-gcc@14/14.2.0/avr/include -Iinclude
LDFLAGS = -mmcu=$(MCU)

# Directories
SRC_DIR = src
BUILD_DIR = build

# Find all .cpp files recursively and corresponding .o files
SRC = $(shell find $(SRC_DIR) -name '*.cpp')
OBJ = $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(SRC))

# Output files
TARGET = $(BUILD_DIR)/main.elf
HEX = $(BUILD_DIR)/main.hex

# Default target
all: $(HEX)

# Compile each .cpp file into .o
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	@echo "[Compiling] $<"
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c -o $@ $<

# Link all .o files into the .elf file
$(TARGET): $(OBJ)
	@echo "[Linking] $@"
	$(CC) $(LDFLAGS) -o $@ $^

# Convert the .elf file to a .hex file
$(HEX): $(TARGET)
	@echo "[Creating HEX] $@"
	$(OBJCOPY) -O ihex -R .eeprom $< $@

# Reset the board using 1200 baud
reset:
	@echo "[Resetting board]"
	stty -f /dev/tty.usbmodem1301 1200

# Flash the .hex file to the microcontroller
flash: $(HEX)
	@echo "[Resetting board]"
	stty -f /dev/tty.usbmodem1301 1200  # Trigger the reset to enter programming mode
	sleep 1                            # Allow time for the board to reset
	@echo "[Flashing] $<"
	$(AVRDUDE) -C$(AVRDUDE_CONF) -v -patmega4809 -cjtag2updi -P /dev/tty.usbmodem1301 -b 115200 \
		-U flash:w:$<:i \
		-U fuse2:w:0x01:m -U fuse5:w:0xC9:m -U fuse8:w:0x00:m


# Clean up build files
clean:
	@echo "[Cleaning build files]"
	rm -rf $(BUILD_DIR)/*.o $(BUILD_DIR)/*.elf $(BUILD_DIR)/*.hex

# Phony targets to avoid conflicts with file names
.PHONY: all flash reset clean
