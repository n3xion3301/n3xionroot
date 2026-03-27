#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "========================================="
echo "     n3xionroot - Kernel Manager"
echo "========================================="
echo ""

check_root() {
    echo -e "${YELLOW}[*]${NC} Checking root access..."
    ROOT_CHECK=$(adb shell su -c "echo rooted" 2>/dev/null | tr -d '\r')
    
    if [ "$ROOT_CHECK" != "rooted" ]; then
        echo -e "${RED}[!]${NC} Root access required"
        exit 1
    fi
    echo -e "${GREEN}[✓]${NC} Root access confirmed"
}

show_current_kernel() {
    echo -e "${YELLOW}[*]${NC} Current kernel information..."
    echo ""
    
    KERNEL_VERSION=$(adb shell uname -r | tr -d '\r')
    KERNEL_NAME=$(adb shell uname -v | tr -d '\r')
    
    echo "  Kernel Version: $KERNEL_VERSION"
    echo "  Build Info: $KERNEL_NAME"
    echo ""
}

backup_current_kernel() {
    echo -e "${YELLOW}[*]${NC} Backing up current kernel..."
    
    BOOT_PARTITION=$(adb shell su -c "ls /dev/block/by-name/boot" 2>/dev/null | tr -d '\r')
    if [ -z "$BOOT_PARTITION" ]; then
        echo -e "${RED}[!]${NC} Boot partition not found"
        exit 1
    fi
    
    BACKUP_DIR="./backups/kernel_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    adb shell su -c "dd if=$BOOT_PARTITION of=/sdcard/boot_backup.img"
    adb pull /sdcard/boot_backup.img "$BACKUP_DIR/boot.img"
    adb shell rm /sdcard/boot_backup.img
    
    echo -e "${GREEN}[✓]${NC} Kernel backed up to: $BACKUP_DIR/boot.img"
}

flash_custom_kernel() {
    echo ""
    echo -e "${BLUE}Popular Custom Kernels:${NC}"
    echo "  - ElementalX"
    echo "  - Franco Kernel"
    echo "  - Kirisakura"
    echo "  - Proton Kernel"
    echo "  - Neutrino Kernel"
    echo ""
    
    echo "Place kernel ZIP in current directory as 'kernel.zip'"
    read -p "Press Enter when ready..."
    
    if [ ! -f "kernel.zip" ]; then
        echo -e "${RED}[!]${NC} kernel.zip not found"
        exit 1
    fi
    
    echo -e "${YELLOW}[*]${NC} Flashing kernel..."
    
    # Check if Magisk is installed for direct flash
    MAGISK_VER=$(adb shell su -c "magisk -v" 2>/dev/null | tr -d '\r')
    
    if [ -n "$MAGISK_VER" ]; then
        echo "  Method: Magisk Manager"
        adb push kernel.zip /sdcard/Download/
        echo ""
        echo -e "${YELLOW}[!]${NC} MANUAL STEPS:"
        echo "    1. Open Magisk Manager"
        echo "    2. Modules > Install from storage"
        echo "    3. Select kernel.zip from Downloads"
        echo "    4. Reboot when prompted"
        read -p "Press Enter after installation..."
    else
        echo "  Method: Recovery"
        adb push kernel.zip /sdcard/
        adb reboot recovery
        sleep 10
        echo ""
        echo -e "${YELLOW}[!]${NC} MANUAL STEPS IN RECOVERY:"
        echo "    1. Install > Select kernel.zip"
        echo "    2. Swipe to flash"
        echo "    3. Reboot system"
        read -p "Press Enter after flashing..."
    fi
    
    echo -e "${GREEN}[✓]${NC} Kernel flashed"
}

restore_stock_kernel() {
    echo ""
    echo -e "${YELLOW}[*]${NC} Restoring stock kernel..."
    
    echo "Select restore method:"
    echo "  1) From backup (boot.img)"
    echo "  2) Extract from stock ROM"
    read -p "Select option (1-2): " METHOD
    
    case $METHOD in
        1)
            echo "Place boot.img backup in current directory"
            read -p "Press Enter when ready..."
            
            if [ ! -f "boot.img" ]; then
                echo -e "${RED}[!]${NC} boot.img not found"
                exit 1
            fi
            
            adb reboot bootloader
            sleep 5
            fastboot flash boot boot.img
            fastboot reboot
            echo -e "${GREEN}[✓]${NC} Stock kernel restored"
            ;;
        2)
            echo "Extract boot.img from stock ROM ZIP"
            echo "Place it in current directory as boot.img"
            read -p "Press Enter when ready..."
            
            if [ ! -f "boot.img" ]; then
                echo -e "${RED}[!]${NC} boot.img not found"
                exit 1
            fi
            
            adb reboot bootloader
            sleep 5
            fastboot flash boot boot.img
            fastboot reboot
            echo -e "${GREEN}[✓]${NC} Stock kernel restored"
            ;;
        *)
            echo -e "${RED}[!]${NC} Invalid option"
            exit 1
            ;;
    esac
}

kernel_tweaks() {
    echo ""
    echo -e "${BLUE}Kernel Tweaks (requires root):${NC}"
    echo ""
    
    echo "1. CPU Governor Settings"
    echo "2. I/O Scheduler Settings"
    echo "3. GPU Settings"
    echo "4. Thermal Settings"
    echo "5. Back to main menu"
    read -p "Select option (1-5): " TWEAK
    
    case $TWEAK in
        1)
            echo ""
            echo "Available CPU Governors:"
            adb shell su -c "cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors"
            echo ""
            read -p "Enter governor name (e.g., performance, powersave, interactive): " GOVERNOR
            
            adb shell su -c "echo $GOVERNOR > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
            echo -e "${GREEN}[✓]${NC} CPU governor set to: $GOVERNOR"
            ;;
        2)
            echo ""
            echo "Available I/O Schedulers:"
            adb shell su -c "cat /sys/block/sda/queue/scheduler"
            echo ""
            read -p "Enter scheduler name (e.g., noop, deadline, cfq): " SCHEDULER
            
            adb shell su -c "echo $SCHEDULER > /sys/block/sda/queue/scheduler"
            echo -e "${GREEN}[✓]${NC} I/O scheduler set to: $SCHEDULER"
            ;;
        3)
            echo ""
            echo "GPU Frequency Control"
            adb shell su -c "cat /sys/class/kgsl/kgsl-3d0/devfreq/available_frequencies"
            echo ""
            read -p "Enter max GPU frequency (MHz): " GPU_FREQ
            
            adb shell su -c "echo $GPU_FREQ > /sys/class/kgsl/kgsl-3d0/devfreq/max_freq"
            echo -e "${GREEN}[✓]${NC} GPU max frequency set"
            ;;
        4)
            echo ""
            echo "Thermal Throttling Control"
            read -p "Disable thermal throttling? (not recommended) (yes/no): " THERMAL
            
            if [ "$THERMAL" = "yes" ]; then
                adb shell su -c "echo 0 > /sys/module/msm_thermal/core_control/enabled"
                echo -e "${YELLOW}[!]${NC} Thermal throttling disabled (monitor temps!)"
            fi
            ;;
        5)
            return
            ;;
    esac
}

main() {
    check_root
    show_current_kernel
    
    echo -e "${BLUE}Kernel Manager Options:${NC}"
    echo "  1) Backup current kernel"
    echo "  2) Flash custom kernel"
    echo "  3) Restore stock kernel"
    echo "  4) Kernel tweaks"
    echo "  5) Exit"
    echo ""
    read -p "Select option (1-5): " OPTION
    
    case $OPTION in
        1)
            backup_current_kernel
            ;;
        2)
            backup_current_kernel
            flash_custom_kernel
            ;;
        3)
            restore_stock_kernel
            ;;
        4)
            kernel_tweaks
            ;;
        5)
            exit 0
            ;;
        *)
            echo -e "${RED}[!]${NC} Invalid option"
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}[✓] Operation complete!${NC}"
    echo -e "${GREEN}=========================================${NC}"
}

main
