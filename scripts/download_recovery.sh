#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "========================================="
echo "  n3xionroot - Recovery Image Downloader"
echo "========================================="
echo ""

RECOVERY_DIR="./recovery"
mkdir -p "$RECOVERY_DIR"

detect_device() {
    printf "${YELLOW}[*]${NC} Detecting connected device...\n"
    
    if adb devices | grep -q "device$"; then
        DEVICE_CODE=$(adb shell getprop ro.product.device 2>/dev/null | tr -d '\r')
        DEVICE_MODEL=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
        printf "${GREEN}[✓]${NC} Device detected: $DEVICE_MODEL ($DEVICE_CODE)\n\n"
        AUTO_DETECTED=true
    else
        printf "${YELLOW}[!]${NC} No device connected\n"
        AUTO_DETECTED=false
    fi
}

select_device() {
    if [ "$AUTO_DETECTED" = true ]; then
        printf "Use detected device: $DEVICE_MODEL? (yes/no): "
        read USE_DETECTED
        
        if [ "$USE_DETECTED" = "yes" ]; then
            return
        fi
    fi
    
    printf "\n${BLUE}Select device manually:${NC}\n"
    printf "  1) Samsung Galaxy S10 (beyond1lte)\n"
    printf "  2) Samsung Galaxy S20 (x1s)\n"
    printf "  3) Google Pixel 4a (sunfish)\n"
    printf "  4) Google Pixel 5 (redfin)\n"
    printf "  5) Xiaomi Redmi Note 10 (mojito)\n"
    printf "  6) Xiaomi Poco F3 (alioth)\n"
    printf "  7) OnePlus 7 Pro (guacamole)\n"
    printf "  8) Motorola Moto G Power (sofia)\n"
    printf "  9) Custom (enter codename)\n"
    printf "\nSelect option (1-9): "
    read DEVICE_OPTION
    
    case $DEVICE_OPTION in
        1) DEVICE_CODE="beyond1lte"; DEVICE_MODEL="Samsung Galaxy S10" ;;
        2) DEVICE_CODE="x1s"; DEVICE_MODEL="Samsung Galaxy S20" ;;
        3) DEVICE_CODE="sunfish"; DEVICE_MODEL="Google Pixel 4a" ;;
        4) DEVICE_CODE="redfin"; DEVICE_MODEL="Google Pixel 5" ;;
        5) DEVICE_CODE="mojito"; DEVICE_MODEL="Xiaomi Redmi Note 10" ;;
        6) DEVICE_CODE="alioth"; DEVICE_MODEL="Xiaomi Poco F3" ;;
        7) DEVICE_CODE="guacamole"; DEVICE_MODEL="OnePlus 7 Pro" ;;
        8) DEVICE_CODE="sofia"; DEVICE_MODEL="Motorola Moto G Power" ;;
        9)
            printf "Enter device codename: "
            read DEVICE_CODE
            DEVICE_MODEL="Custom Device"
            ;;
        *)
            printf "${RED}[!]${NC} Invalid option\n"
            exit 1
            ;;
    esac
    
    printf "${GREEN}[✓]${NC} Selected: $DEVICE_MODEL ($DEVICE_CODE)\n\n"
}

select_recovery_type() {
    printf "${BLUE}Select recovery type:${NC}\n"
    printf "  1) TWRP (Team Win Recovery Project)\n"
    printf "  2) OrangeFox Recovery\n"
    printf "  3) LineageOS Recovery\n"
    printf "  4) Stock Recovery\n"
    printf "\nSelect option (1-4): "
    read RECOVERY_OPTION
    
    case $RECOVERY_OPTION in
        1) RECOVERY_TYPE="twrp" ;;
        2) RECOVERY_TYPE="orangefox" ;;
        3) RECOVERY_TYPE="lineageos" ;;
        4) RECOVERY_TYPE="stock" ;;
        *)
            printf "${RED}[!]${NC} Invalid option\n"
            exit 1
            ;;
    esac
}

download_twrp() {
    printf "\n${YELLOW}[*]${NC} Downloading TWRP for $DEVICE_CODE...\n"
    
    # TWRP official download URL pattern
    TWRP_URL="https://dl.twrp.me/$DEVICE_CODE/"
    
    printf "    Fetching available versions...\n"
    
    # Try to get latest version
    LATEST_IMG=$(curl -s "$TWRP_URL" | grep -oP 'twrp-[0-9.]+-[0-9]+-'$DEVICE_CODE'.img' | head -1)
    
    if [ -z "$LATEST_IMG" ]; then
        printf "${YELLOW}[!]${NC} Could not auto-detect latest version\n"
        printf "    Visit: https://twrp.me/Devices/\n"
        printf "    Search for your device and download manually\n"
        printf "\nEnter TWRP image filename (or 'skip'): "
        read MANUAL_IMG
        
        if [ "$MANUAL_IMG" = "skip" ]; then
            return
        fi
        
        LATEST_IMG="$MANUAL_IMG"
    fi
    
    DOWNLOAD_URL="${TWRP_URL}${LATEST_IMG}"
    OUTPUT_FILE="$RECOVERY_DIR/twrp-$DEVICE_CODE.img"
    
    printf "    Downloading: $LATEST_IMG\n"
    printf "    URL: $DOWNLOAD_URL\n"
    
    if command -v wget &> /dev/null; then
        wget -O "$OUTPUT_FILE" "$DOWNLOAD_URL"
    elif command -v curl &> /dev/null; then
        curl -L -o "$OUTPUT_FILE" "$DOWNLOAD_URL"
    else
        printf "${RED}[!]${NC} Neither wget nor curl found\n"
        exit 1
    fi
    
    if [ $? -eq 0 ] && [ -f "$OUTPUT_FILE" ]; then
        printf "${GREEN}[✓]${NC} Downloaded: $OUTPUT_FILE\n"
        
        # Verify file size
        FILE_SIZE=$(stat -f%z "$OUTPUT_FILE" 2>/dev/null || stat -c%s "$OUTPUT_FILE" 2>/dev/null)
        if [ "$FILE_SIZE" -lt 10000000 ]; then
            printf "${YELLOW}[!]${NC} Warning: File size seems small (${FILE_SIZE} bytes)\n"
            printf "    This might be an error page. Verify manually.\n"
        fi
    else
        printf "${RED}[!]${NC} Download failed\n"
        printf "    Manual download: https://twrp.me/Devices/\n"
    fi
}

download_orangefox() {
    printf "\n${YELLOW}[*]${NC} Downloading OrangeFox for $DEVICE_CODE...\n"
    
    ORANGEFOX_URL="https://orangefox.download/device/$DEVICE_CODE"
    
    printf "    OrangeFox download page: $ORANGEFOX_URL\n"
    printf "    Please download manually from the website\n"
    printf "    Save to: $RECOVERY_DIR/orangefox-$DEVICE_CODE.img\n"
    
    read -p "Press Enter after downloading..."
}

download_lineageos_recovery() {
    printf "\n${YELLOW}[*]${NC} LineageOS Recovery for $DEVICE_CODE...\n"
    
    printf "    LineageOS recovery is included in LineageOS ROM ZIP\n"
    printf "    Download LineageOS ROM from: https://download.lineageos.org/$DEVICE_CODE\n"
    printf "    Extract recovery.img from the ZIP\n"
    
    read -p "Press Enter to continue..."
}

download_stock_recovery() {
    printf "\n${YELLOW}[*]${NC} Stock Recovery for $DEVICE_CODE...\n"
    
    printf "    Stock recovery must be extracted from stock firmware\n"
    printf "    Sources:\n"
    printf "      - Samsung: https://samfw.com or https://samfrew.com\n"
    printf "      - Google: https://developers.google.com/android/images\n"
    printf "      - Xiaomi: https://xiaomifirmwareupdater.com\n"
    printf "      - OnePlus: https://www.oneplus.com/support/softwareupgrade\n"
    
    read -p "Press Enter to continue..."
}

verify_recovery() {
    printf "\n${YELLOW}[*]${NC} Verifying downloaded recovery...\n"
    
    RECOVERY_FILE="$RECOVERY_DIR/${RECOVERY_TYPE}-${DEVICE_CODE}.img"
    
    if [ ! -f "$RECOVERY_FILE" ]; then
        printf "${YELLOW}[!]${NC} Recovery file not found: $RECOVERY_FILE\n"
        return
    fi
    
    FILE_SIZE=$(stat -f%z "$RECOVERY_FILE" 2>/dev/null || stat -c%s "$RECOVERY_FILE" 2>/dev/null)
    printf "    File: $RECOVERY_FILE\n"
    printf "    Size: $FILE_SIZE bytes ($(($FILE_SIZE / 1024 / 1024)) MB)\n"
    
    # Check if file is valid
    if command -v file &> /dev/null; then
        FILE_TYPE=$(file "$RECOVERY_FILE")
        printf "    Type: $FILE_TYPE\n"
    fi
    
    printf "${GREEN}[✓]${NC} Recovery image ready\n"
}

flash_recovery() {
    printf "\n${BLUE}Flash recovery now?${NC}\n"
    printf "  This will flash the downloaded recovery to your device\n"
    printf "  Device must be in bootloader/fastboot mode\n"
    read -p "Flash now? (yes/no): " FLASH
    
    if [ "$FLASH" != "yes" ]; then
        printf "Skipping flash. You can flash manually later.\n"
        return
    fi
    
    RECOVERY_FILE="$RECOVERY_DIR/${RECOVERY_TYPE}-${DEVICE_CODE}.img"
    
    if [ ! -f "$RECOVERY_FILE" ]; then
        printf "${RED}[!]${NC} Recovery file not found\n"
        return
    fi
    
    printf "${YELLOW}[*]${NC} Rebooting to bootloader...\n"
    adb reboot bootloader 2>/dev/null
    sleep 5
    
    printf "${YELLOW}[*]${NC} Flashing recovery...\n"
    fastboot flash recovery "$RECOVERY_FILE"
    
    if [ $? -eq 0 ]; then
        printf "${GREEN}[✓]${NC} Recovery flashed successfully\n"
        printf "\nReboot to recovery? (yes/no): "
        read REBOOT
        
        if [ "$REBOOT" = "yes" ]; then
            fastboot reboot recovery
        fi
    else
        printf "${RED}[!]${NC} Flash failed\n"
    fi
}

main() {
    detect_device
    select_device
    select_recovery_type
    
    case $RECOVERY_TYPE in
        twrp)
            download_twrp
            ;;
        orangefox)
            download_orangefox
            ;;
        lineageos)
            download_lineageos_recovery
            ;;
        stock)
            download_stock_recovery
            ;;
    esac
    
    verify_recovery
    flash_recovery
    
    printf "\n${GREEN}=========================================${NC}\n"
    printf "${GREEN}Recovery download complete!${NC}\n"
    printf "Location: $RECOVERY_DIR/\n"
    printf "${GREEN}=========================================${NC}\n"
}

main
