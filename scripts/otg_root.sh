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

# Auto-detect and root in one command
AUTO_ROOT=false
SKIP_BACKUP=false
QUICK_MODE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --auto)
            AUTO_ROOT=true
            shift
            ;;
        --skip-backup)
            SKIP_BACKUP=true
            shift
            ;;
        --quick)
            QUICK_MODE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

check_dependencies() {
    echo -e "${YELLOW}[*]${NC} Checking dependencies..."
    
    MISSING_DEPS=()
    
    if ! command -v adb &> /dev/null; then
        MISSING_DEPS+=("adb")
    fi
    
    if ! command -v fastboot &> /dev/null; then
        MISSING_DEPS+=("fastboot")
    fi
    
    if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
        echo -e "${RED}[!]${NC} Missing dependencies: ${MISSING_DEPS[*]}"
        echo "    Install Android Platform Tools"
        exit 1
    fi
    
    echo -e "${GREEN}[✓]${NC} All dependencies found"
}

detect_device() {
    echo -e "${YELLOW}[*]${NC} Auto-detecting device..."
    
    if ! adb devices | grep -q "device$"; then
        echo -e "${RED}[!]${NC} No device connected"
        echo "    1. Enable USB debugging"
        echo "    2. Connect device via USB"
        echo "    3. Authorize computer on device"
        exit 1
    fi
    
    DEVICE_MODEL=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
    DEVICE_CODE=$(adb shell getprop ro.product.device 2>/dev/null | tr -d '\r')
    DEVICE_BRAND=$(adb shell getprop ro.product.manufacturer 2>/dev/null | tr -d '\r')
    ANDROID_VER=$(adb shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')
    BUILD_ID=$(adb shell getprop ro.build.id 2>/dev/null | tr -d '\r')
    
    echo -e "${GREEN}[✓]${NC} Device detected:"
    echo "    Brand: $DEVICE_BRAND"
    echo "    Model: $DEVICE_MODEL"
    echo "    Codename: $DEVICE_CODE"
    echo "    Android: $ANDROID_VER"
    echo "    Build: $BUILD_ID"
    echo ""
}

check_support() {
    echo -e "${YELLOW}[*]${NC} Checking device support..."
    
    SUPPORTED=false
    ROOT_METHOD=""
    
    case "$DEVICE_CODE" in
        beyond1lte|beyond0lte|beyond2lte)
            SUPPORTED=true
            ROOT_METHOD="samsung_twrp"
            DEVICE_NAME="Samsung Galaxy S10"
            ;;
        sunfish)
            SUPPORTED=true
            ROOT_METHOD="google_magisk"
            DEVICE_NAME="Google Pixel 4a"
            ;;
        mojito)
            SUPPORTED=true
            ROOT_METHOD="xiaomi_twrp"
            DEVICE_NAME="Xiaomi Redmi Note 10"
            ;;
        guacamole)
            SUPPORTED=true
            ROOT_METHOD="oneplus_twrp"
            DEVICE_NAME="OnePlus 7 Pro"
            ;;
        sofia)
            SUPPORTED=true
            ROOT_METHOD="motorola_magisk"
            DEVICE_NAME="Motorola Moto G Power"
            ;;
        *)
            SUPPORTED=false
            ;;
    esac
    
    if [ "$SUPPORTED" = false ]; then
        echo -e "${RED}[!]${NC} Device not supported: $DEVICE_CODE"
        echo ""
        echo "Supported devices:"
        echo "  - Samsung Galaxy S10 series"
        echo "  - Google Pixel 4a"
        echo "  - Xiaomi Redmi Note 10"
        echo "  - OnePlus 7 Pro"
        echo "  - Motorola Moto G Power"
        exit 1
    fi
    
    echo -e "${GREEN}[✓]${NC} Device supported: $DEVICE_NAME"
    echo "    Root method: $ROOT_METHOD"
}

quick_backup() {
    if [ "$SKIP_BACKUP" = true ]; then
        echo -e "${YELLOW}[!]${NC} Skipping backup (--skip-backup flag)"
        return
    fi
    
    echo -e "${YELLOW}[*]${NC} Quick backup..."
    
    BACKUP_DIR="./backups/otg_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Backup boot partition
    BOOT_PARTITION=$(adb shell su -c "ls /dev/block/by-name/boot 2>/dev/null" | tr -d '\r')
    if [ -n "$BOOT_PARTITION" ]; then
        adb shell su -c "dd if=$BOOT_PARTITION of=/sdcard/boot_backup.img" 2>/dev/null
        adb pull /sdcard/boot_backup.img "$BACKUP_DIR/boot.img" 2>/dev/null
        adb shell rm /sdcard/boot_backup.img 2>/dev/null
        echo -e "${GREEN}[✓]${NC} Boot partition backed up"
    fi
}

download_files() {
    echo -e "${YELLOW}[*]${NC} Downloading required files..."
    
    MAGISK_URL="https://github.com/topjohnwu/Magisk/releases/latest/download/Magisk-v26.1.apk"
    
    if [ ! -f "Magisk-v26.1.apk" ]; then
        echo "    Downloading Magisk..."
        curl -L -o Magisk-v26.1.apk "$MAGISK_URL" 2>/dev/null || wget -O Magisk-v26.1.apk "$MAGISK_URL" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[✓]${NC} Magisk downloaded"
        else
            echo -e "${RED}[!]${NC} Failed to download Magisk"
            echo "    Download manually from: https://github.com/topjohnwu/Magisk/releases"
            exit 1
        fi
    else
        echo -e "${GREEN}[✓]${NC} Magisk already downloaded"
    fi
}

root_samsung_twrp() {
    echo -e "${YELLOW}[*]${NC} Rooting via TWRP method..."
    
    echo "    Required files:"
    echo "      - twrp.img (place in current directory)"
    echo "      - Magisk-v26.1.apk"
    
    if [ ! -f "twrp.img" ]; then
        echo -e "${RED}[!]${NC} twrp.img not found"
        echo "    Download TWRP for your device from https://twrp.me"
        exit 1
    fi
    
    echo -e "${YELLOW}[*]${NC} Rebooting to bootloader..."
    adb reboot bootloader
    sleep 5
    
    echo -e "${YELLOW}[*]${NC} Booting TWRP..."
    fastboot boot twrp.img
    sleep 15
    
    echo -e "${YELLOW}[*]${NC} Pushing Magisk..."
    adb push Magisk-v26.1.apk /sdcard/
    
    echo ""
    echo -e "${YELLOW}[!]${NC} MANUAL STEP IN TWRP:"
    echo "    1. Install > Select Magisk-v26.1.apk"
    echo "    2. Swipe to flash"
    echo "    3. Reboot System"
    read -p "Press Enter after completing steps..."
}

root_google_magisk() {
    echo -e "${YELLOW}[*]${NC} Rooting via Magisk patched boot..."
    
    echo "    Extracting boot.img from device..."
    adb shell su -c "dd if=/dev/block/by-name/boot of=/sdcard/boot.img" 2>/dev/null || {
        echo -e "${RED}[!]${NC} Failed to extract boot.img"
        echo "    Download factory image and extract boot.img manually"
        exit 1
    }
    
    adb pull /sdcard/boot.img ./
    adb push Magisk-v26.1.apk /sdcard/Download/
    
    echo ""
    echo -e "${YELLOW}[!]${NC} MANUAL STEPS:"
    echo "    1. Install Magisk Manager from /sdcard/Download/"
    echo "    2. Open Magisk > Install > Select and Patch a File"
    echo "    3. Select boot.img"
    read -p "Press Enter after patching..."
    
    adb pull /sdcard/Download/magisk_patched*.img ./boot_patched.img
    
    echo -e "${YELLOW}[*]${NC} Flashing patched boot..."
    adb reboot bootloader
    sleep 5
    fastboot flash boot boot_patched.img
    fastboot reboot
}

root_xiaomi_twrp() {
    echo -e "${YELLOW}[*]${NC} Rooting Xiaomi device..."
    echo -e "${RED}[!]${NC} IMPORTANT: Bootloader must be unlocked with Mi Unlock Tool"
    read -p "Is bootloader unlocked? (yes/no): " UNLOCKED
    
    if [ "$UNLOCKED" != "yes" ]; then
        echo -e "${RED}[!]${NC} Unlock bootloader first using Mi Unlock Tool"
        echo "    https://en.miui.com/unlock/"
        exit 1
    fi
    
    root_samsung_twrp
}

root_oneplus_twrp() {
    echo -e "${YELLOW}[*]${NC} Rooting OnePlus device..."
    root_samsung_twrp
}

root_motorola_magisk() {
    echo -e "${YELLOW}[*]${NC} Rooting Motorola device..."
    root_google_magisk
}

execute_root() {
    echo ""
    echo -e "${BLUE}=========================================${NC}"
    echo -e "${BLUE}Starting automated root process...${NC}"
    echo -e "${BLUE}=========================================${NC}"
    echo ""
    
    case "$ROOT_METHOD" in
        samsung_twrp)
            root_samsung_twrp
            ;;
        google_magisk)
            root_google_magisk
            ;;
        xiaomi_twrp)
            root_xiaomi_twrp
            ;;
        oneplus_twrp)
            root_oneplus_twrp
            ;;
        motorola_magisk)
            root_motorola_magisk
            ;;
    esac
}

verify_root() {
    echo ""
    echo -e "${YELLOW}[*]${NC} Waiting for device to boot..."
    sleep 30
    
    adb wait-for-device
    sleep 10
    
    echo -e "${YELLOW}[*]${NC} Verifying root access..."
    ROOT_CHECK=$(adb shell su -c "echo rooted" 2>/dev/null | tr -d '\r')
    
    if [ "$ROOT_CHECK" = "rooted" ]; then
        echo -e "${GREEN}[✓]${NC} Root verified successfully!"
        
        MAGISK_VER=$(adb shell su -c "magisk -v" 2>/dev/null | tr -d '\r')
        echo "    Magisk version: $MAGISK_VER"
    else
        echo -e "${YELLOW}[!]${NC} Root verification inconclusive"
        echo "    Open Magisk Manager to verify"
    fi
}

show_summary() {
    echo ""
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}     Root Process Complete!${NC}"
    echo -e "${GREEN}=========================================${NC}"
    echo ""
    echo "Device: $DEVICE_NAME"
    echo "Method: $ROOT_METHOD"
    echo ""
    echo "Next steps:"
    echo "  1. Open Magisk Manager"
    echo "  2. Verify root status"
    echo "  3. Configure Magisk settings"
    echo "  4. Install modules if needed"
    echo ""
    echo "Backup location: $BACKUP_DIR"
    echo ""
}

main() {
    if [ "$AUTO_ROOT" = false ]; then
        echo -e "${YELLOW}=========================================${NC}"
        echo -e "${RED}WARNING:${NC}"
        echo "  - This will root your device"
        echo "  - Warranty will be voided"
        echo "  - Data may be wiped"
        echo "  - Ensure battery >50%"
        echo -e "${YELLOW}=========================================${NC}"
        echo ""
        
        read -p "Continue? (yes/no): " CONFIRM
        if [ "$CONFIRM" != "yes" ]; then
            exit 0
        fi
    fi
    
    check_dependencies
    detect_device
    check_support
    download_files
    quick_backup
    execute_root
    verify_root
    show_summary
}

# Show usage if --help
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --auto          Skip confirmation prompts"
    echo "  --skip-backup   Skip backup step"
    echo "  --quick         Quick mode (auto + skip-backup)"
    echo "  --help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                    # Interactive mode"
    echo "  $0 --auto             # Auto mode with backup"
    echo "  $0 --quick            # Fastest mode (no prompts, no backup)"
    exit 0
fi

main
