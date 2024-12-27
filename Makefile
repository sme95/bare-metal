# Target MCU and clock speed
MCU = atmega328p
F_CPU = 16000000UL

# Toolchain programs
CC = avr-g++
OBJCOPY = avr-objcopy
AVRDUDE = avrdude

# Compiler flags
CFLAGS = -mmcu=$(MCU) -DF_CPU=$(F_CPU) -Os -Wall -I/opt/homebrew/Cellar/avr-gcc@9/9.4.0_1/avr/include -Iinclude

# Directories
SRC_DIR = src
BUILD_DIR = build

# Find all .cpp files and corresponding .o files
SRC = $(wildcard $(SRC_DIR)/**/*.cpp)
OBJ = $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(SRC))

# Output files
TARGET = $(BUILD_DIR)/main.elf
HEX = $(BUILD_DIR)/main.hex

# Default target
all: $(HEX)

# Compile each .cpp file into .o
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c -o $@ $<

# Link all .o files into the .elf file
$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^

# Convert the .elf file to a .hex file
$(HEX): $(TARGET)
	$(OBJCOPY) -O ihex -R .eeprom $< $@

# Flash the .hex file to the microcontroller
flash: $(HEX)
	$(AVRDUDE) -c arduino -P /dev/ttyUSB0 -p $(MCU) -U flash:w:$<:i

# Clean up build files
clean:
	rm -rf $(BUILD_DIR)
