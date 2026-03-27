#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

BACKUP_DIR="./backups/$(date +%Y%m%d_%H%M%S)"

echo "========================================="
echo "     n3xionroot - Device Backup"
echo "========================================="
echo ""

check_device() {
    echo -e "${YELLOW}[*]${NC} Checking device connection..."
    if ! adb devices | grep -q "device$"; then
        echo -e "${RED}[!]${NC} No device detected"
        exit 1
    fi
    
    DEVICE_MODEL=$(adb shell getprop ro.product.model | tr -d '\r')
    echo -e "${GREEN}[✓]${NC} Device: $DEVICE_MODEL"
}

create_backup_dir() {
    echo -e "${YELLOW}[*]${NC} Creating backup directory..."
    mkdir -p "$BACKUP_DIR"
    echo -e "${GREEN}[✓]${NC} Backup location: $BACKUP_DIR"
}

backup_boot_image() {
    echo -e "${YELLOW}[*]${NC} Backing up boot partition..."
    
    BOOT_PARTITION=$(adb shell su -c "ls /dev/block/by-name/boot" 2>/dev/null | tr -d '\r')
    if [ -z "$BOOT_PARTITION" ]; then
        echo -e "${YELLOW}[!]${NC} Boot partition not found, skipping"
        return
    fi
    
    adb shell su -c "dd if=$BOOT_PARTITION of=/sdcard/boot.img"
    adb pull /sdcard/boot.img "$BACKUP_DIR/boot.img"
    adb shell rm /sdcard/boot.img
    
    echo -e "${GREEN}[✓]${NC} Boot image backed up"
}

backup_recovery_image() {
    echo -e "${YELLOW}[*]${NC} Backing up recovery partition..."
    
    RECOVERY_PARTITION=$(adb shell su -c "ls /dev/block/by-name/recovery" 2>/dev/null | tr -d '\r')
    if [ -z "$RECOVERY_PARTITION" ]; then
        echo -e "${YELLOW}[!]${NC} Recovery partition not found, skipping"
        return
    fi
    
    adb shell su -c "dd if=$RECOVERY_PARTITION of=/sdcard/recovery.img"
    adb pull /sdcard/recovery.img "$BACKUP_DIR/recovery.img"
    adb shell rm /sdcard/recovery.img
    
    echo -e "${GREEN}[✓]${NC} Recovery image backed up"
}

backup_efs() {
    echo -e "${YELLOW}[*]${NC} Backing up EFS partition (IMEI/baseband)..."
    
    EFS_PARTITION=$(adb shell su -c "ls /dev/block/by-name/efs" 2>/dev/null | tr -d '\r')
    if [ -z "$EFS_PARTITION" ]; then
        echo -e "${YELLOW}[!]${NC} EFS partition not found, skipping"
        return
    fi
    
    adb shell su -c "dd if=$EFS_PARTITION of=/sdcard/efs.img"
    adb pull /sdcard/efs.img "$BACKUP_DIR/efs.img"
    adb shell rm /sdcard/efs.img
    
    echo -e "${GREEN}[✓]${NC} EFS backed up (CRITICAL - keep safe!)"
}

backup_persist() {
    echo -e "${YELLOW}[*]${NC} Backing up persist partition..."
    
    PERSIST_PARTITION=$(adb shell su -c "ls /dev/block/by-name/persist" 2>/dev/null | tr -d '\r')
    if [ -z "$PERSIST_PARTITION" ]; then
        echo -e "${YELLOW}[!]${NC} Persist partition not found, skipping"
        return
    fi
    
    adb shell su -c "dd if=$PERSIST_PARTITION of=/sdcard/persist.img"
    adb pull /sdcard/persist.img "$BACKUP_DIR/persist.img"
    adb shell rm /sdcard/persist.img
    
    echo -e "${GREEN}[✓]${NC} Persist backed up"
}

backup_nvram() {
    echo -e "${YELLOW}[*]${NC} Backing up nvram (MediaTek devices)..."
    
    NVRAM_PARTITION=$(adb shell su -c "ls /dev/block/by-name/nvram" 2>/dev/null | tr -d '\r')
    if [ -z "$NVRAM_PARTITION" ]; then
        echo -e "${YELLOW}[!]${NC} NVRAM partition not found, skipping"
        return
    fi
    
    adb shell su -c "dd if=$NVRAM_PARTITION of=/sdcard/nvram.img"
    adb pull /sdcard/nvram.img "$BACKUP_DIR/nvram.img"
    adb shell rm /sdcard/nvram.img
    
    echo -e "${GREEN}[✓]${NC} NVRAM backed up"
}

backup_app_data() {
    echo -e "${YELLOW}[*]${NC} Backing up app data..."
    
    adb backup -apk -shared -all -f "$BACKUP_DIR/app_data.ab"
    
    echo -e "${GREEN}[✓]${NC} App data backed up"
}

save_device_info() {
    echo -e "${YELLOW}[*]${NC} Saving device information..."
    
    cat > "$BACKUP_DIR/device_info.txt" << INFO
Device Backup Information
=========================
Date: $(date)
Model: $(adb shell getprop ro.product.model | tr -d '\r')
Manufacturer: $(adb shell getprop ro.product.manufacturer | tr -d '\r')
Device: $(adb shell getprop ro.product.device | tr -d '\r')
Android Version: $(adb shell getprop ro.build.version.release | tr -d '\r')
Build Number: $(adb shell getprop ro.build.display.id | tr -d '\r')
Security Patch: $(adb shell getprop ro.build.version.security_patch | tr -d '\r')
Bootloader: $(adb shell getprop ro.bootloader | tr -d '\r')
Baseband: $(adb shell getprop ro.baseband | tr -d '\r')
INFO
    
    echo -e "${GREEN}[✓]${NC} Device info saved"
}

main() {
    echo -e "${YELLOW}=========================================${NC}"
    echo "This will backup critical partitions"
    echo "Requires root access"
    echo -e "${YELLOW}=========================================${NC}"
    echo ""
    
    read -p "Continue? (yes/no): " CONFIRM
    if [ "$CONFIRM" != "yes" ]; then
        exit 0
    fi
    
    check_device
    create_backup_dir
    save_device_info
    
    echo ""
    echo "Select backup type:"
    echo "  1) Quick (boot + recovery only)"
    echo "  2) Standard (boot + recovery + EFS)"
    echo "  3) Full (all partitions + app data)"
    read -p "Select option (1-3): " TYPE
    
    case $TYPE in
        1)
            backup_boot_image
            backup_recovery_image
            ;;
        2)
            backup_boot_image
            backup_recovery_image
            backup_efs
            backup_persist
            ;;
        3)
            backup_boot_image
            backup_recovery_image
            backup_efs
            backup_persist
            backup_nvram
            backup_app_data
            ;;
        *)
            echo -e "${RED}[!]${NC} Invalid option"
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}[✓] Backup complete!${NC}"
    echo "    Location: $BACKUP_DIR"
    echo "    Keep EFS backup safe - needed for IMEI restore!"
    echo -e "${GREEN}=========================================${NC}"
}

main
