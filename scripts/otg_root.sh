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

AUTO_ROOT=false
SKIP_BACKUP=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --auto) AUTO_ROOT=true; shift ;;
        --skip-backup) SKIP_BACKUP=true; shift ;;
        *) shift ;;
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
    echo -e "${GREEN}[✓]${NC} Dependencies found"
}

detect_device() {
    echo -e "${YELLOW}[*]${NC} Detecting device..."
    if ! adb devices | grep -q "device$"; then
        echo -e "${RED}[!]${NC} No device connected"
        exit 1
    fi
    DEVICE_MODEL=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
    DEVICE_CODE=$(adb shell getprop ro.product.device 2>/dev/null | tr -d '\r')
    ANDROID_VER=$(adb shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')
    echo -e "${GREEN}[✓]${NC} Device: $DEVICE_MODEL ($DEVICE_CODE)"
    echo "    Android: $ANDROID_VER"
}

check_support() {
    echo -e "${YELLOW}[*]${NC} Checking support..."
    case "$DEVICE_CODE" in
        beyond1lte|beyond0lte|beyond2lte)
            SUPPORTED=true; ROOT_METHOD="samsung_twrp"; DEVICE_NAME="Samsung Galaxy S10" ;;
        x1s)
            SUPPORTED=true; ROOT_METHOD="samsung_twrp"; DEVICE_NAME="Samsung Galaxy S20" ;;
        o1s)
            SUPPORTED=true; ROOT_METHOD="samsung_twrp"; DEVICE_NAME="Samsung Galaxy S21" ;;
        r0s)
            SUPPORTED=true; ROOT_METHOD="samsung_twrp"; DEVICE_NAME="Samsung Galaxy S22" ;;
        sunfish)
            SUPPORTED=true; ROOT_METHOD="google_magisk"; DEVICE_NAME="Google Pixel 4a" ;;
        redfin)
            SUPPORTED=true; ROOT_METHOD="google_magisk"; DEVICE_NAME="Google Pixel 5" ;;
        oriole)
            SUPPORTED=true; ROOT_METHOD="google_magisk"; DEVICE_NAME="Google Pixel 6" ;;
        panther)
            SUPPORTED=true; ROOT_METHOD="google_magisk"; DEVICE_NAME="Google Pixel 7" ;;
        mojito)
            SUPPORTED=true; ROOT_METHOD="xiaomi_twrp"; DEVICE_NAME="Xiaomi Redmi Note 10" ;;
        alioth)
            SUPPORTED=true; ROOT_METHOD="xiaomi_twrp"; DEVICE_NAME="Xiaomi Poco F3" ;;
        venus)
            SUPPORTED=true; ROOT_METHOD="xiaomi_twrp"; DEVICE_NAME="Xiaomi Mi 11" ;;
        cupid)
            SUPPORTED=true; ROOT_METHOD="xiaomi_twrp"; DEVICE_NAME="Xiaomi Mi 12" ;;
        guacamole)
            SUPPORTED=true; ROOT_METHOD="oneplus_twrp"; DEVICE_NAME="OnePlus 7 Pro" ;;
        instantnoodle)
            SUPPORTED=true; ROOT_METHOD="oneplus_twrp"; DEVICE_NAME="OnePlus 8" ;;
        lemonadep)
            SUPPORTED=true; ROOT_METHOD="oneplus_twrp"; DEVICE_NAME="OnePlus 9 Pro" ;;
        sofia)
            SUPPORTED=true; ROOT_METHOD="motorola_magisk"; DEVICE_NAME="Motorola Moto G Power" ;;
        *)
            echo -e "${RED}[!]${NC} Device not supported"
            exit 1 ;;
    esac
    echo -e "${GREEN}[✓]${NC} Supported: $DEVICE_NAME"
}

quick_backup() {
    if [ "$SKIP_BACKUP" = true ]; then return; fi
    echo -e "${YELLOW}[*]${NC} Quick backup..."
    BACKUP_DIR="./backups/otg_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    BOOT_PARTITION=$(adb shell su -c "ls /dev/block/by-name/boot 2>/dev/null" | tr -d '\r')
    if [ -n "$BOOT_PARTITION" ]; then
        adb shell su -c "dd if=$BOOT_PARTITION of=/sdcard/boot_backup.img" 2>/dev/null
        adb pull /sdcard/boot_backup.img "$BACKUP_DIR/boot.img" 2>/dev/null
        adb shell rm /sdcard/boot_backup.img 2>/dev/null
        echo -e "${GREEN}[✓]${NC} Backed up"
    fi
}

download_files() {
    echo -e "${YELLOW}[*]${NC} Downloading Magisk..."
    MAGISK_URL="https://github.com/topjohnwu/Magisk/releases/latest/download/Magisk-v26.1.apk"
    if [ ! -f "Magisk-v26.1.apk" ]; then
        curl -L -o Magisk-v26.1.apk "$MAGISK_URL" 2>/dev/null || wget -O Magisk-v26.1.apk "$MAGISK_URL" 2>/dev/null
        [ $? -eq 0 ] && echo -e "${GREEN}[✓]${NC} Downloaded" || exit 1
    fi
}

root_samsung_twrp() {
    echo -e "${YELLOW}[*]${NC} Rooting via TWRP..."
    if [ ! -f "twrp.img" ]; then
        echo -e "${RED}[!]${NC} twrp.img not found"
        exit 1
    fi
    adb reboot bootloader; sleep 5
    fastboot boot twrp.img; sleep 15
    adb push Magisk-v26.1.apk /sdcard/
    echo -e "${YELLOW}[!]${NC} In TWRP: Install > Magisk > Swipe"
    read -p "Press Enter..."
}

root_google_magisk() {
    echo -e "${YELLOW}[*]${NC} Rooting via Magisk..."
    adb shell su -c "dd if=/dev/block/by-name/boot of=/sdcard/boot.img" 2>/dev/null || exit 1
    adb pull /sdcard/boot.img ./
    adb push Magisk-v26.1.apk /sdcard/Download/
    echo -e "${YELLOW}[!]${NC} Patch boot.img in Magisk Manager"
    read -p "Press Enter..."
    adb pull /sdcard/Download/magisk_patched*.img ./boot_patched.img
    adb reboot bootloader; sleep 5
    fastboot flash boot boot_patched.img
    fastboot reboot
}

root_xiaomi_twrp() {
    echo -e "${RED}[!]${NC} Bootloader must be unlocked"
    read -p "Unlocked? (yes/no): " UNLOCKED
    [ "$UNLOCKED" != "yes" ] && exit 1
    root_samsung_twrp
}

root_oneplus_twrp() { root_samsung_twrp; }
root_motorola_magisk() { root_google_magisk; }

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
    echo -e "${YELLOW}[*]${NC} Waiting..."
    sleep 30; adb wait-for-device; sleep 10
    ROOT_CHECK=$(adb shell su -c "echo rooted" 2>/dev/null | tr -d '\r')
    [ "$ROOT_CHECK" = "rooted" ] && echo -e "${GREEN}[✓]${NC} Root verified!" || echo -e "${YELLOW}[!]${NC} Inconclusive"
}

main() {
    if [ "$AUTO_ROOT" = false ]; then
        echo -e "${YELLOW}WARNING: This will root your device${NC}"
        read -p "Continue? (yes/no): " CONFIRM
        [ "$CONFIRM" != "yes" ] && exit 0
    fi
    check_dependencies
    detect_device
    check_support
    download_files
    quick_backup
    execute_root
    verify_root
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}Root Complete!${NC}"
    echo -e "${GREEN}=========================================${NC}"
}

main
