#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}"
cat << "BANNER"
    ╔═══════════════════════════════════════╗
    ║      KERNEL MANAGER                   ║
    ╚═══════════════════════════════════════╝
BANNER
echo -e "${NC}"

show_menu() {
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${GREEN}Kernel Management Menu${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}\n"
    
    echo "  1) 📊 View Current Kernel Info"
    echo "  2) 🔍 List Available Kernels"
    echo "  3) 📥 Download Kernel"
    echo "  4) 🔨 Flash Kernel (via TWRP)"
    echo "  5) 🔨 Flash Kernel (via Fastboot)"
    echo "  6) 💾 Backup Current Kernel"
    echo "  7) 🔄 Restore Kernel Backup"
    echo "  8) ⚙️  Kernel Tweaks (Advanced)"
    echo "  9) 🗑️  Delete Kernel Backup"
    echo "  0) 🔙 Back to Main Menu"
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════${NC}\n"
}

view_kernel_info() {
    echo -e "${YELLOW}[*]${NC} Current Kernel Information:\n"
    
    if ! adb devices | grep -q "device$"; then
        echo -e "${RED}[!]${NC} No device connected"
        return
    fi
    
    echo -e "${GREEN}Kernel Details:${NC}"
    KERNEL_VER=$(adb shell uname -r | tr -d '\r')
    KERNEL_NAME=$(adb shell cat /proc/version | tr -d '\r')
    
    echo "  Version: $KERNEL_VER"
    echo "  Full: $KERNEL_NAME"
    echo ""
}

list_kernels() {
    echo -e "${YELLOW}[*]${NC} Popular Kernels by Device:\n"
    
    DEVICE_CODE=$(adb shell getprop ro.product.device 2>/dev/null | tr -d '\r')
    
    echo -e "${CYAN}For your device ($DEVICE_CODE):${NC}\n"
    
    case "$DEVICE_CODE" in
        beyond*|x1s|o1s|r0s)
            echo "  1. ElementalX Kernel"
            echo "     - Battery optimization"
            echo "     - Custom governors"
            echo "     - Download: https://elementalx.org"
            echo ""
            echo "  2. Kirisakura Kernel"
            echo "     - Performance focused"
            echo "     - Advanced features"
            echo ""
            ;;
        sunfish|redfin|oriole|panther)
            echo "  1. Kirisakura Kernel"
            echo "     - Pixel optimized"
            echo "     - Performance boost"
            echo ""
            echo "  2. Proton Kernel"
            echo "     - Battery life"
            echo "     - Smooth performance"
            echo ""
            ;;
        *)
            echo "  Check XDA Forums for kernels:"
            echo "  https://forum.xda-developers.com"
            ;;
    esac
}

backup_kernel() {
    echo -e "${YELLOW}[*]${NC} Backing up current kernel...\n"
    
    BACKUP_DIR="./backups/kernels"
    mkdir -p "$BACKUP_DIR"
    
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    BACKUP_NAME="boot_backup_$TIMESTAMP.img"
    
    echo "  Extracting boot partition..."
    adb shell su -c "dd if=/dev/block/by-name/boot of=/sdcard/boot_backup.img" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        adb pull /sdcard/boot_backup.img "$BACKUP_DIR/$BACKUP_NAME"
        adb shell rm /sdcard/boot_backup.img
        echo -e "${GREEN}[✓]${NC} Kernel backed up: $BACKUP_DIR/$BACKUP_NAME"
    else
        echo -e "${RED}[!]${NC} Backup failed"
    fi
    echo ""
}

flash_kernel_twrp() {
    echo -e "${YELLOW}[*]${NC} Flash Kernel via TWRP\n"
    
    echo "  Place kernel ZIP in: ./kernels/"
    read -p "  Kernel ZIP filename: " KERNEL_ZIP
    
    if [ ! -f "./kernels/$KERNEL_ZIP" ]; then
        echo -e "${RED}[!]${NC} File not found"
        return
    fi
    
    echo "  Pushing to device..."
    adb push "./kernels/$KERNEL_ZIP" /sdcard/
    
    echo -e "${YELLOW}[!]${NC} Instructions:"
    echo "  1. Reboot to TWRP recovery"
    echo "  2. Install > $KERNEL_ZIP"
    echo "  3. Swipe to flash"
    echo "  4. Reboot system"
    echo ""
    
    read -p "Reboot to recovery now? (yes/no): " REBOOT
    if [ "$REBOOT" = "yes" ]; then
        adb reboot recovery
    fi
}

flash_kernel_fastboot() {
    echo -e "${YELLOW}[*]${NC} Flash Kernel via Fastboot\n"
    
    echo "  Place boot.img in: ./kernels/"
    read -p "  Boot image filename: " BOOT_IMG
    
    if [ ! -f "./kernels/$BOOT_IMG" ]; then
        echo -e "${RED}[!]${NC} File not found"
        return
    fi
    
    echo -e "${YELLOW}[!]${NC} This will reboot to bootloader"
    read -p "Continue? (yes/no): " CONFIRM
    
    if [ "$CONFIRM" = "yes" ]; then
        adb reboot bootloader
        sleep 5
        fastboot flash boot "./kernels/$BOOT_IMG"
        fastboot reboot
        echo -e "${GREEN}[✓]${NC} Kernel flashed"
    fi
}

kernel_tweaks() {
    echo -e "${YELLOW}[*]${NC} Kernel Tweaks (Advanced)\n"
    
    echo -e "${CYAN}Available Tweaks:${NC}"
    echo "  1) Change CPU Governor"
    echo "  2) Adjust I/O Scheduler"
    echo "  3) Modify GPU Settings"
    echo "  4) Battery Optimization"
    echo "  5) Performance Mode"
    echo "  0) Back"
    echo ""
    
    read -p "Select: " TWEAK
    
    case $TWEAK in
        1)
            echo -e "\n${YELLOW}CPU Governors:${NC}"
            echo "  - performance (max speed)"
            echo "  - powersave (battery)"
            echo "  - interactive (balanced)"
            echo "  - conservative (gradual)"
            echo ""
            echo "Requires root and kernel support"
            ;;
        4)
            echo -e "\n${YELLOW}Applying battery optimizations...${NC}"
            adb shell su -c "echo 'powersave' > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" 2>/dev/null
            echo -e "${GREEN}[✓]${NC} Applied (if supported)"
            ;;
        5)
            echo -e "\n${YELLOW}Applying performance mode...${NC}"
            adb shell su -c "echo 'performance' > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" 2>/dev/null
            echo -e "${GREEN}[✓]${NC} Applied (if supported)"
            ;;
    esac
}

main() {
    while true; do
        show_menu
        read -p "Select option: " choice
        echo ""
        
        case $choice in
            1) view_kernel_info ;;
            2) list_kernels ;;
            3) echo "Download from XDA or kernel developer sites" ;;
            4) flash_kernel_twrp ;;
            5) flash_kernel_fastboot ;;
            6) backup_kernel ;;
            7) echo "Restore feature - select backup to restore" ;;
            8) kernel_tweaks ;;
            9) echo "Delete backup feature" ;;
            0) exit 0 ;;
            *) echo -e "${RED}Invalid option${NC}" ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
        clear
        echo -e "${CYAN}"
        cat << "BANNER"
    ╔═══════════════════════════════════════╗
    ║      KERNEL MANAGER                   ║
    ╚═══════════════════════════════════════╝
BANNER
        echo -e "${NC}"
    done
}

main
