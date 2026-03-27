#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "========================================="
echo "     n3xionroot - Custom ROM Flasher"
echo "========================================="
echo ""

check_device() {
    echo -e "${YELLOW}[*]${NC} Checking device connection..."
    if ! adb devices | grep -q "device$"; then
        echo -e "${RED}[!]${NC} No device detected"
        exit 1
    fi
    
    DEVICE_MODEL=$(adb shell getprop ro.product.model | tr -d '\r')
    DEVICE_CODE=$(adb shell getprop ro.product.device | tr -d '\r')
    echo -e "${GREEN}[✓]${NC} Device: $DEVICE_MODEL ($DEVICE_CODE)"
}

check_recovery() {
    echo -e "${YELLOW}[*]${NC} Checking for custom recovery..."
    echo "    Rebooting to recovery..."
    adb reboot recovery
    sleep 10
    
    echo -e "${YELLOW}[!]${NC} Verify you're in TWRP or custom recovery"
    read -p "Are you in custom recovery? (yes/no): " IN_RECOVERY
    
    if [ "$IN_RECOVERY" != "yes" ]; then
        echo -e "${RED}[!]${NC} Custom recovery required. Install TWRP first."
        exit 1
    fi
    echo -e "${GREEN}[✓]${NC} Custom recovery confirmed"
}

select_rom() {
    echo ""
    echo -e "${BLUE}Available ROM types:${NC}"
    echo "  1) LineageOS"
    echo "  2) Pixel Experience"
    echo "  3) Paranoid Android"
    echo "  4) Evolution X"
    echo "  5) crDroid"
    echo "  6) Custom (provide your own ZIP)"
    read -p "Select ROM type (1-6): " ROM_TYPE
    
    case $ROM_TYPE in
        1) ROM_NAME="LineageOS" ;;
        2) ROM_NAME="Pixel Experience" ;;
        3) ROM_NAME="Paranoid Android" ;;
        4) ROM_NAME="Evolution X" ;;
        5) ROM_NAME="crDroid" ;;
        6) ROM_NAME="Custom ROM" ;;
        *)
            echo -e "${RED}[!]${NC} Invalid selection"
            exit 1
            ;;
    esac
    
    echo -e "${GREEN}[✓]${NC} Selected: $ROM_NAME"
}

prepare_files() {
    echo ""
    echo -e "${YELLOW}[*]${NC} Preparing ROM files..."
    echo ""
    echo "Place the following files in current directory:"
    echo "  - rom.zip (Custom ROM)"
    echo "  - gapps.zip (Optional - Google Apps)"
    echo "  - magisk.zip (Optional - Root)"
    echo ""
    read -p "Press Enter when files are ready..."
    
    if [ ! -f "rom.zip" ]; then
        echo -e "${RED}[!]${NC} rom.zip not found"
        exit 1
    fi
    
    echo -e "${GREEN}[✓]${NC} ROM file found"
    
    # Check optional files
    FLASH_GAPPS=false
    FLASH_MAGISK=false
    
    if [ -f "gapps.zip" ]; then
        read -p "Flash GApps? (yes/no): " GAPPS_CONFIRM
        if [ "$GAPPS_CONFIRM" = "yes" ]; then
            FLASH_GAPPS=true
            echo -e "${GREEN}[✓]${NC} GApps will be flashed"
        fi
    fi
    
    if [ -f "magisk.zip" ]; then
        read -p "Flash Magisk (root)? (yes/no): " MAGISK_CONFIRM
        if [ "$MAGISK_CONFIRM" = "yes" ]; then
            FLASH_MAGISK=true
            echo -e "${GREEN}[✓]${NC} Magisk will be flashed"
        fi
    fi
}

backup_current_rom() {
    echo ""
    echo -e "${YELLOW}[*]${NC} Creating backup of current ROM..."
    read -p "Create TWRP backup? (recommended) (yes/no): " BACKUP
    
    if [ "$BACKUP" = "yes" ]; then
        echo -e "${YELLOW}[!]${NC} MANUAL STEP:"
        echo "    In TWRP: Backup > Select partitions > Swipe to backup"
        echo "    Recommended: System, Data, Boot"
        read -p "Press Enter after backup completes..."
        echo -e "${GREEN}[✓]${NC} Backup created"
    else
        echo -e "${YELLOW}[!]${NC} Skipping backup (not recommended)"
    fi
}

wipe_partitions() {
    echo ""
    echo -e "${YELLOW}[*]${NC} Wiping partitions..."
    echo -e "${RED}[!]${NC} This will erase all data!"
    read -p "Continue with wipe? (yes/no): " WIPE_CONFIRM
    
    if [ "$WIPE_CONFIRM" != "yes" ]; then
        echo "Aborted."
        exit 0
    fi
    
    echo ""
    echo "Select wipe type:"
    echo "  1) Clean install (wipe System, Data, Cache, Dalvik)"
    echo "  2) Dirty flash (wipe Cache, Dalvik only)"
    read -p "Select option (1-2): " WIPE_TYPE
    
    echo ""
    echo -e "${YELLOW}[!]${NC} MANUAL STEPS IN TWRP:"
    
    case $WIPE_TYPE in
        1)
            echo "    Wipe > Advanced Wipe"
            echo "    Select: System, Data, Cache, Dalvik/ART Cache"
            echo "    Swipe to Wipe"
            ;;
        2)
            echo "    Wipe > Advanced Wipe"
            echo "    Select: Cache, Dalvik/ART Cache"
            echo "    Swipe to Wipe"
            ;;
        *)
            echo -e "${RED}[!]${NC} Invalid option"
            exit 1
            ;;
    esac
    
    read -p "Press Enter after wiping..."
    echo -e "${GREEN}[✓]${NC} Partitions wiped"
}

push_files() {
    echo ""
    echo -e "${YELLOW}[*]${NC} Pushing files to device..."
    
    adb push rom.zip /sdcard/
    echo "    ROM pushed"
    
    if [ "$FLASH_GAPPS" = true ]; then
        adb push gapps.zip /sdcard/
        echo "    GApps pushed"
    fi
    
    if [ "$FLASH_MAGISK" = true ]; then
        adb push magisk.zip /sdcard/
        echo "    Magisk pushed"
    fi
    
    echo -e "${GREEN}[✓]${NC} All files pushed to /sdcard/"
}

flash_rom() {
    echo ""
    echo -e "${YELLOW}[*]${NC} Flashing ROM..."
    echo ""
    echo -e "${YELLOW}[!]${NC} MANUAL STEPS IN TWRP:"
    echo "    1. Install > Select rom.zip"
    echo "    2. Swipe to confirm flash"
    
    if [ "$FLASH_GAPPS" = true ]; then
        echo "    3. Add more zips > Select gapps.zip"
    fi
    
    if [ "$FLASH_MAGISK" = true ]; then
        echo "    4. Add more zips > Select magisk.zip"
    fi
    
    echo "    5. Swipe to flash"
    echo "    6. DO NOT REBOOT YET"
    echo ""
    read -p "Press Enter after flashing completes..."
    echo -e "${GREEN}[✓]${NC} ROM flashed"
}

format_data() {
    echo ""
    echo -e "${YELLOW}[*]${NC} Format data partition..."
    read -p "Format data? (required for encryption, wipes internal storage) (yes/no): " FORMAT
    
    if [ "$FORMAT" = "yes" ]; then
        echo -e "${YELLOW}[!]${NC} MANUAL STEP IN TWRP:"
        echo "    Wipe > Format Data > Type 'yes'"
        read -p "Press Enter after formatting..."
        echo -e "${GREEN}[✓]${NC} Data formatted"
    fi
}

reboot_system() {
    echo ""
    echo -e "${YELLOW}[*]${NC} Rebooting to system..."
    echo -e "${YELLOW}[!]${NC} First boot may take 5-10 minutes"
    echo ""
    echo "MANUAL STEP IN TWRP:"
    echo "    Reboot > System"
    echo ""
    read -p "Press Enter to finish..."
}

main() {
    echo -e "${YELLOW}=========================================${NC}"
    echo -e "${RED}WARNING:${NC}"
    echo "  - This will wipe your device"
    echo "  - Backup your data first"
    echo "  - Ensure battery is >70%"
    echo "  - Have stock firmware ready for recovery"
    echo -e "${YELLOW}=========================================${NC}"
    echo ""
    
    read -p "Continue? (yes/no): " CONFIRM
    if [ "$CONFIRM" != "yes" ]; then
        exit 0
    fi
    
    check_device
    select_rom
    prepare_files
    check_recovery
    backup_current_rom
    wipe_partitions
    push_files
    flash_rom
    format_data
    reboot_system
    
    echo ""
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}[✓] ROM flash complete!${NC}"
    echo ""
    echo "Post-flash checklist:"
    echo "  - Wait for first boot (5-10 min)"
    echo "  - Complete setup wizard"
    echo "  - Install Magisk Manager if rooted"
    echo "  - Restore app data from backup"
    echo -e "${GREEN}=========================================${NC}"
}

main
