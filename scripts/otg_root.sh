#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo "========================================="
echo "    n3xionroot - On-The-Go Root Tool"
echo "========================================="
echo ""
echo -e "${PURPLE}Quick root solution for supported devices${NC}"
echo ""

AUTO_ROOT=false
SKIP_BACKUP=false
QUICK_MODE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --auto) AUTO_ROOT=true; shift ;;
        --skip-backup) SKIP_BACKUP=true; shift ;;
        --quick) QUICK_MODE=true; shift ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

check_dependencies() {
    echo -e "${YELLOW}[*]${NC} Checking dependencies..."
    MISSING_DEPS=()
    if ! command -v adb &> /dev/null; then MISSING_DEPS+=("adb"); fi
    if ! command -v fastboot &> /dev/null; then MISSING_DEPS+=("fastboot"); fi
    if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
        echo -e "${RED}[!]${NC} Missing: ${MISSING_DEPS[*]}"
        exit 1
    fi
    echo -e "${GREEN}[✓]${NC} All dependencies found"
}

detect_device() {
    echo -e "${YELLOW}[*]${NC} Auto-detecting device..."
    if ! adb devices | grep -q "device$"; then
        echo -e "${RED}[!]${NC} No device connected"
        exit 1
    fi
    DEVICE_MODEL=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
    DEVICE_CODE=$(adb shell getprop ro.product.device 2>/dev/null | tr -d '\r')
    DEVICE_BRAND=$(adb shell getprop ro.product.manufacturer 2>/dev/null | tr -d '\r')
    ANDROID_VER=$(adb shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')
    echo -e "${GREEN}[✓]${NC} Device: $DEVICE_BRAND $DEVICE_MODEL ($DEVICE_CODE)"
    echo "    Android: $ANDROID_VER"
    echo ""
}

check_support() {
    echo -e "${YELLOW}[*]${NC} Checking device support..."
    case "$DEVICE_CODE" in
        beyond1lte|beyond0lte|beyond2lte)
            SUPPORTED=true; ROOT_METHOD="samsung_twrp"; DEVICE_NAME="Samsung Galaxy S10" ;;
        x1s)
            SUPPORTED=true; ROOT_METHOD="samsung_twrp"; DEVICE_NAME="Samsung Galaxy S20" ;;
        sunfish)
            SUPPORTED=true; ROOT_METHOD="google_magisk"; DEVICE_NAME="Google Pixel 4a" ;;
        redfin)
            SUPPORTED=true; ROOT_METHOD="google_magisk"; DEVICE_NAME="Google Pixel 5" ;;
        mojito)
            SUPPORTED=true; ROOT_METHOD="xiaomi_twrp"; DEVICE_NAME="Xiaomi Redmi Note 10" ;;
        alioth)
            SUPPORTED=true; ROOT_METHOD="xiaomi_twrp"; DEVICE_NAME="Xiaomi Poco F3" ;;
        guacamole)
            SUPPORTED=true; ROOT_METHOD="oneplus_twrp"; DEVICE_NAME="OnePlus 7 Pro" ;;
        sofia)
            SUPPORTED=true; ROOT_METHOD="motorola_magisk"; DEVICE_NAME="Motorola Moto G Power" ;;
        *)
            echo -e "${RED}[!]${NC} Device not supported: $DEVICE_CODE"
            exit 1 ;;
    esac
    echo -e "${GREEN}[✓]${NC} Device supported: $DEVICE_NAME"
    echo "    Root method: $ROOT_METHOD"
}

quick_backup() {
    if [ "$SKIP_BACKUP" = true ]; then
        echo -e "${YELLOW}[!]${NC} Skipping backup"
        return
    fi
    echo -e "${YELLOW}[*]${NC} Quick backup..."
    BACKUP_DIR="./backups/otg_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    BOOT_PARTITION=$(adb shell su -c "ls /dev/block/by-name/boot 2>/dev/null" | tr -d '\r')
    if [ -n "$BOOT_PARTITION" ]; then
        adb shell su -c "dd if=$BOOT_PARTITION of=/sdcard/boot_backup.img" 2>/dev/null
        adb pull /sdcard/boot_backup.img "$BACKUP_DIR/boot.img" 2>/dev/null
        adb shell rm /sdcard/boot_backup.img 2>/dev/null
        echo -e "${GREEN}[✓]${NC} Boot backed up"
    fi
}

download_files() {
    echo -e "${YELLOW}[*]${NC} Downloading Magisk..."
    MAGISK_URL="https://github.com/topjohnwu/Magisk/releases/latest/download/Magisk-v26.1.apk"
    if [ ! -f "Magisk-v26.1.apk" ]; then
        curl -L -o Magisk-v26.1.apk "$MAGISK_URL" 2>/dev/null || wget -O Magisk-v26.1.apk "$MAGISK_URL" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[✓]${NC} Magisk downloaded"
        else
            echo -e "${RED}[!]${NC} Download failed"
            exit 1
        fi
    fi
}

root_samsung_twrp() {
    echo -e "${YELLOW}[*]${NC} Rooting via TWRP..."
    if [ ! -f "twrp.img" ]; then
        echo -e "${RED}[!]${NC} twrp.img not found"
        echo "    Download TWRP from https://twrp.me"
        exit 1
    fi
    adb reboot bootloader
    sleep 5
    fastboot boot twrp.img
    sleep 15
    adb push Magisk-v26.1.apk /sdcard/
    echo -e "${YELLOW}[!]${NC} In TWRP: Install > Magisk-v26.1.apk > Swipe to flash"
    read -p "Press Enter after flashing..."
}

root_google_magisk() {
    echo -e "${YELLOW}[*]${NC} Rooting via Magisk patched boot..."
    adb shell su -c "dd if=/dev/block/by-name/boot of=/sdcard/boot.img" 2>/dev/null || {
        echo -e "${RED}[!]${NC} Failed to extract boot.img"
        exit 1
    }
    adb pull /sdcard/boot.img ./
    adb push Magisk-v26.1.apk /sdcard/Download/
    echo -e "${YELLOW}[!]${NC} Install Magisk Manager and patch boot.img"
    read -p "Press Enter after patching..."
    adb pull /sdcard/Download/magisk_patched*.img ./boot_patched.img
    adb reboot bootloader
    sleep 5
    fastboot flash boot boot_patched.img
    fastboot reboot
}

root_xiaomi_twrp() {
    echo -e "${YELLOW}[*]${NC} Rooting Xiaomi..."
    echo -e "${RED}[!]${NC} Bootloader must be unlocked with Mi Unlock Tool"
    read -p "Is bootloader unlocked? (yes/no): " UNLOCKED
    if [ "$UNLOCKED" != "yes" ]; then
        echo -e "${RED}[!]${NC} Unlock bootloader first"
        exit 1
    fi
    root_samsung_twrp
}

root_oneplus_twrp() {
    root_samsung_twrp
}

root_motorola_magisk() {
    root_google_magisk
}

execute_root() {
    case "$ROOT_METHOD" in
        samsung_twrp) root_samsung_twrp ;;
        google_magisk) root_google_magisk ;;
        xiaomi_twrp) root_xiaomi_twrp ;;
        oneplus_twrp) root_oneplus_twrp ;;
        motorola_magisk) root_motorola_magisk ;;
    esac
}

verify_root() {
    echo -e "${YELLOW}[*]${NC} Waiting for device..."
    sleep 30
    adb wait-for-device
    sleep 10
    ROOT_CHECK=$(adb shell su -c "echo rooted" 2>/dev/null | tr -d '\r')
    if [ "$ROOT_CHECK" = "rooted" ]; then
        echo -e "${GREEN}[✓]${NC} Root verified!"
    else
        echo -e "${YELLOW}[!]${NC} Root verification inconclusive"
    fi
}

main() {
    if [ "$AUTO_ROOT" = false ]; then
        echo -e "${YELLOW}WARNING: This will root your device${NC}"
        read -p "Continue? (yes/no): " CONFIRM
        if [ "$CONFIRM" != "yes" ]; then exit 0; fi
    fi
    check_dependencies
    detect_device
    check_support
    download_files
    quick_backup
    execute_root
    verify_root
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}Root Process Complete!${NC}"
    echo -e "${GREEN}=========================================${NC}"
}

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  --auto          Skip prompts"
    echo "  --skip-backup   Skip backup"
    echo "  --quick         Fast mode"
    exit 0
fi

main
