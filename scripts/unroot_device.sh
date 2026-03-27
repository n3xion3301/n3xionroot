#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "========================================="
echo "      n3xionroot - Unroot Device"
echo "========================================="
echo ""

detect_device() {
    echo -e "${YELLOW}[*]${NC} Detecting device..."
    
    DEVICE_MODEL=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
    DEVICE_CODE=$(adb shell getprop ro.product.device 2>/dev/null | tr -d '\r')
    
    if [ -z "$DEVICE_MODEL" ]; then
        echo -e "${RED}[!]${NC} No device detected"
        exit 1
    fi
    
    echo -e "${GREEN}[✓]${NC} Device: $DEVICE_MODEL ($DEVICE_CODE)"
}

check_root() {
    echo -e "${YELLOW}[*]${NC} Checking root status..."
    
    ROOT_CHECK=$(adb shell su -c "echo rooted" 2>/dev/null | tr -d '\r')
    if [ "$ROOT_CHECK" != "rooted" ]; then
        echo -e "${YELLOW}[!]${NC} Device doesn't appear to be rooted"
        read -p "Continue anyway? (yes/no): " CONTINUE
        if [ "$CONTINUE" != "yes" ]; then
            exit 0
        fi
    else
        echo -e "${GREEN}[✓]${NC} Root detected"
    fi
}

uninstall_magisk() {
    echo -e "${YELLOW}[*]${NC} Uninstalling Magisk..."
    
    # Check if Magisk is installed
    MAGISK_VER=$(adb shell su -c "magisk -v" 2>/dev/null | tr -d '\r')
    if [ -n "$MAGISK_VER" ]; then
        echo "    Magisk version: $MAGISK_VER"
        
        # Uninstall via Magisk Manager
        echo "[!] MANUAL STEP: Open Magisk Manager > Uninstall > Complete Uninstall"
        read -p "Press Enter after uninstalling Magisk..."
    else
        echo "    Magisk not found via command line"
    fi
}

restore_stock_boot() {
    echo -e "${YELLOW}[*]${NC} Restoring stock boot image..."
    echo ""
    echo "Choose restoration method:"
    echo "  1) Flash stock boot.img (you provide)"
    echo "  2) Restore from Magisk backup"
    echo "  3) Flash full stock firmware"
    echo "  4) Skip (already done manually)"
    read -p "Select option (1-4): " METHOD
    
    case $METHOD in
        1)
            echo "[*] Place stock boot.img in current directory"
            read -p "Press Enter when ready..."
            if [ ! -f "stock_boot.img" ]; then
                echo -e "${RED}[!]${NC} stock_boot.img not found"
                exit 1
            fi
            
            adb reboot bootloader
            sleep 5
            fastboot flash boot stock_boot.img
            fastboot reboot
            echo -e "${GREEN}[✓]${NC} Stock boot flashed"
            ;;
        2)
            echo "[*] Checking for Magisk backup..."
            adb shell su -c "ls /data/magisk_backup*.img.gz" 2>/dev/null
            echo "[!] If backup exists, restore it in Magisk Manager"
            echo "    Magisk > Uninstall > Restore Images"
            read -p "Press Enter after restoring..."
            ;;
        3)
            echo "[!] Flash stock firmware using manufacturer tool:"
            echo "    - Samsung: Odin + stock firmware"
            echo "    - Google: flash-all.bat/sh"
            echo "    - Xiaomi: Mi Flash Tool"
            echo "    - OnePlus: MSM Download Tool"
            read -p "Press Enter after flashing stock firmware..."
            ;;
        4)
            echo "[*] Skipping boot restoration"
            ;;
        *)
            echo -e "${RED}[!]${NC} Invalid option"
            exit 1
            ;;
    esac
}

restore_stock_recovery() {
    echo -e "${YELLOW}[*]${NC} Restoring stock recovery..."
    read -p "Do you have custom recovery installed? (yes/no): " HAS_CUSTOM
    
    if [ "$HAS_CUSTOM" = "yes" ]; then
        echo "[*] Place stock recovery.img in current directory"
        read -p "Press Enter when ready (or skip if using full firmware): " 
        
        if [ -f "stock_recovery.img" ]; then
            adb reboot bootloader
            sleep 5
            fastboot flash recovery stock_recovery.img
            echo -e "${GREEN}[✓]${NC} Stock recovery flashed"
        fi
    fi
}

factory_reset() {
    echo -e "${YELLOW}[*]${NC} Factory reset recommended to remove all root traces"
    read -p "Perform factory reset? (yes/no): " RESET
    
    if [ "$RESET" = "yes" ]; then
        echo -e "${RED}[!]${NC} This will erase all data!"
        read -p "Are you sure? (yes/no): " CONFIRM
        
        if [ "$CONFIRM" = "yes" ]; then
            adb reboot recovery
            echo "[!] In recovery mode:"
            echo "    - Select 'Wipe data/factory reset'"
            echo "    - Confirm and reboot"
        fi
    fi
}

relock_bootloader() {
    echo -e "${YELLOW}[*]${NC} Relock bootloader (optional)..."
    echo -e "${RED}[!]${NC} WARNING: Only relock if you've restored stock firmware!"
    echo "    Relocking with custom software can brick your device"
    read -p "Relock bootloader? (yes/no): " RELOCK
    
    if [ "$RELOCK" = "yes" ]; then
        read -p "Are you ABSOLUTELY sure stock firmware is installed? (yes/no): " CONFIRM
        if [ "$CONFIRM" = "yes" ]; then
            adb reboot bootloader
            sleep 5
            fastboot flashing lock
            echo "[*] Follow on-screen instructions"
        fi
    fi
}

main() {
    echo -e "${YELLOW}=========================================${NC}"
    echo "This will remove root access from device"
    echo -e "${YELLOW}=========================================${NC}"
    echo ""
    
    detect_device
    check_root
    uninstall_magisk
    restore_stock_boot
    restore_stock_recovery
    factory_reset
    relock_bootloader
    
    echo ""
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}[✓] Unroot process complete!${NC}"
    echo "    Your device should now be unrooted"
    echo -e "${GREEN}=========================================${NC}"
}

main
