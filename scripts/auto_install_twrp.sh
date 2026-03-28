#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "========================================="
echo "  n3xionroot - Auto TWRP Installer"
echo "========================================="
echo ""

RECOVERY_DIR="./recovery"
mkdir -p "$RECOVERY_DIR"

detect_device() {
    echo -e "${YELLOW}[*]${NC} Detecting device..."
    
    if ! adb devices | grep -q "device$"; then
        echo -e "${RED}[!]${NC} No device connected"
        exit 1
    fi
    
    DEVICE_CODE=$(adb shell getprop ro.product.device 2>/dev/null | tr -d '\r')
    DEVICE_MODEL=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
    
    echo -e "${GREEN}[✓]${NC} Device: $DEVICE_MODEL ($DEVICE_CODE)"
}

get_twrp_url() {
    echo -e "${YELLOW}[*]${NC} Finding TWRP for $DEVICE_CODE..."
    
    # TWRP device database
    case "$DEVICE_CODE" in
        beyond1lte|beyond0lte|beyond2lte)
            TWRP_URL="https://dl.twrp.me/beyond1lte/twrp-3.7.0_9-0-beyond1lte.img.tar"
            TWRP_FILE="twrp-beyond1lte.img"
            ;;
        x1s)
            TWRP_URL="https://dl.twrp.me/x1s/twrp-3.7.0_9-0-x1s.img.tar"
            TWRP_FILE="twrp-x1s.img"
            ;;
        o1s)
            TWRP_URL="https://dl.twrp.me/o1s/twrp-3.7.0_9-0-o1s.img.tar"
            TWRP_FILE="twrp-o1s.img"
            ;;
        sunfish)
            TWRP_URL="https://dl.twrp.me/sunfish/twrp-3.7.0_9-0-sunfish.img"
            TWRP_FILE="twrp-sunfish.img"
            ;;
        redfin)
            TWRP_URL="https://dl.twrp.me/redfin/twrp-3.7.0_9-0-redfin.img"
            TWRP_FILE="twrp-redfin.img"
            ;;
        oriole)
            TWRP_URL="https://dl.twrp.me/oriole/twrp-3.7.0_9-0-oriole.img"
            TWRP_FILE="twrp-oriole.img"
            ;;
        mojito)
            TWRP_URL="https://dl.twrp.me/mojito/twrp-3.7.0_9-0-mojito.img"
            TWRP_FILE="twrp-mojito.img"
            ;;
        alioth)
            TWRP_URL="https://dl.twrp.me/alioth/twrp-3.7.0_9-0-alioth.img"
            TWRP_FILE="twrp-alioth.img"
            ;;
        venus)
            TWRP_URL="https://dl.twrp.me/venus/twrp-3.7.0_9-0-venus.img"
            TWRP_FILE="twrp-venus.img"
            ;;
        guacamole)
            TWRP_URL="https://dl.twrp.me/guacamole/twrp-3.7.0_9-0-guacamole.img"
            TWRP_FILE="twrp-guacamole.img"
            ;;
        instantnoodle)
            TWRP_URL="https://dl.twrp.me/instantnoodle/twrp-3.7.0_9-0-instantnoodle.img"
            TWRP_FILE="twrp-instantnoodle.img"
            ;;
        sofia)
            echo -e "${YELLOW}[!]${NC} TWRP not officially available for $DEVICE_CODE"
            echo "    Check XDA Forums for unofficial builds"
            exit 1
            ;;
        *)
            echo -e "${RED}[!]${NC} Device not supported: $DEVICE_CODE"
            exit 1
            ;;
    esac
    
    echo -e "${GREEN}[✓]${NC} TWRP found for device"
}

download_twrp() {
    echo -e "${YELLOW}[*]${NC} Downloading TWRP..."
    
    OUTPUT_PATH="$RECOVERY_DIR/$TWRP_FILE"
    
    if [ -f "$OUTPUT_PATH" ]; then
        echo -e "${GREEN}[✓]${NC} TWRP already downloaded"
        return
    fi
    
    if command -v wget &> /dev/null; then
        wget -O "$OUTPUT_PATH" "$TWRP_URL"
    elif command -v curl &> /dev/null; then
        curl -L -o "$OUTPUT_PATH" "$TWRP_URL"
    else
        echo -e "${RED}[!]${NC} Neither wget nor curl found"
        exit 1
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[✓]${NC} Downloaded: $OUTPUT_PATH"
        
        # Extract if tar file
        if [[ "$TWRP_FILE" == *.tar ]]; then
            tar -xf "$OUTPUT_PATH" -C "$RECOVERY_DIR"
            rm "$OUTPUT_PATH"
            TWRP_FILE="${TWRP_FILE%.tar}"
        fi
    else
        echo -e "${RED}[!]${NC} Download failed"
        exit 1
    fi
}

check_bootloader() {
    echo -e "${YELLOW}[*]${NC} Checking bootloader status..."
    
    adb reboot bootloader
    sleep 5
    
    if ! fastboot devices | grep -q "fastboot"; then
        echo -e "${RED}[!]${NC} Device not in fastboot mode"
        exit 1
    fi
    
    BL_STATUS=$(fastboot getvar unlocked 2>&1 | grep "unlocked")
    
    if [[ "$BL_STATUS" != *"yes"* ]]; then
        echo -e "${RED}[!]${NC} Bootloader is locked"
        echo -e "${YELLOW}[!]${NC} Unlock bootloader before installing TWRP"
        exit 1
    fi
    
    echo -e "${GREEN}[✓]${NC} Bootloader unlocked"
}

flash_twrp() {
    echo -e "${YELLOW}[*]${NC} Flashing TWRP to recovery partition..."
    
    TWRP_PATH="$RECOVERY_DIR/$TWRP_FILE"
    
    if [ ! -f "$TWRP_PATH" ]; then
        echo -e "${RED}[!]${NC} TWRP image not found: $TWRP_PATH"
        exit 1
    fi
    
    fastboot flash recovery "$TWRP_PATH"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[✓]${NC} TWRP flashed successfully"
    else
        echo -e "${RED}[!]${NC} Flash failed"
        exit 1
    fi
}

boot_twrp() {
    echo -e "${YELLOW}[*]${NC} Booting into TWRP..."
    
    fastboot boot "$RECOVERY_DIR/$TWRP_FILE"
    
    echo -e "${GREEN}[✓]${NC} Device should boot into TWRP"
    echo ""
    echo "TWRP installed successfully!"
    echo "To boot TWRP: Power off, then hold Power + Volume Up"
}

main() {
    echo -e "${YELLOW}WARNING: This will flash TWRP recovery${NC}"
    echo "  - Bootloader must be unlocked"
    echo "  - May trip Knox on Samsung devices"
    echo ""
    read -p "Continue? (yes/no): " CONFIRM
    
    if [ "$CONFIRM" != "yes" ]; then
        exit 0
    fi
    
    detect_device
    get_twrp_url
    download_twrp
    check_bootloader
    flash_twrp
    boot_twrp
    
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}TWRP Installation Complete!${NC}"
    echo -e "${GREEN}=========================================${NC}"
}

main
