#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
printf "${PURPLE}"
cat << "BANNER"
    ███╗   ██╗██████╗ ██╗  ██╗██╗ ██████╗ ███╗   ██╗
    ████╗  ██║╚════██╗╚██╗██╔╝██║██╔═══██╗████╗  ██║
    ██╔██╗ ██║ █████╔╝ ╚███╔╝ ██║██║   ██║██╔██╗ ██║
    ██║╚██╗██║ ╚═══██╗ ██╔██╗ ██║██║   ██║██║╚██╗██║
    ██║ ╚████║██████╔╝██╔╝ ██╗██║╚██████╔╝██║ ╚████║
    ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝
                    ROOT TOOLKIT
BANNER
printf "${NC}\n"
printf "${CYAN}        Android Rooting Made Easy${NC}\n\n"

show_menu() {
    printf "${BLUE}═══════════════════════════════════════${NC}\n"
    printf "${GREEN}Main Menu${NC}\n"
    printf "${BLUE}═══════════════════════════════════════${NC}\n\n"
    
    printf "  ${YELLOW}Quick Actions:${NC}\n"
    printf "    1) 🚀 On-The-Go Root (Auto-detect & Root)\n"
    printf "    2) 📱 Device Info\n\n"
    
    printf "  ${YELLOW}Root Management:${NC}\n"
    printf "    3) ✅ Root Device (Manual)\n"
    printf "    4) ❌ Unroot Device\n"
    printf "    5) 🔍 Verify Root Status\n\n"
    
    printf "  ${YELLOW}System Tools:${NC}\n"
    printf "    6) 💾 Backup Device\n"
    printf "    7) 🔄 Flash Custom ROM\n"
    printf "    8) ⚙️  Kernel Manager\n"
    printf "    9) 📦 Magisk Modules\n\n"
    
    printf "  ${YELLOW}Advanced:${NC}\n"
    printf "   10) 🚫 Block OTA Updates\n"
    printf "   11) ✔️  Unblock OTA Updates\n"
    printf "   12) 📚 View Documentation\n\n"
    
    printf "   0) 🚪 Exit\n\n"
    printf "${BLUE}═══════════════════════════════════════${NC}\n\n"
}

device_info() {
    printf "${YELLOW}[*]${NC} Fetching device information...\n\n"
    
    if ! adb devices | grep -q "device$"; then
        printf "${RED}[!]${NC} No device connected\n"
        return
    fi
    
    printf "${GREEN}Device Information:${NC}\n"
    printf "  Manufacturer: $(adb shell getprop ro.product.manufacturer | tr -d '\r')\n"
    printf "  Model: $(adb shell getprop ro.product.model | tr -d '\r')\n"
    printf "  Device: $(adb shell getprop ro.product.device | tr -d '\r')\n"
    printf "  Android: $(adb shell getprop ro.build.version.release | tr -d '\r')\n"
    printf "  Build: $(adb shell getprop ro.build.id | tr -d '\r')\n"
    printf "  Security Patch: $(adb shell getprop ro.build.version.security_patch | tr -d '\r')\n"
    printf "  Bootloader: $(adb shell getprop ro.bootloader | tr -d '\r')\n\n"
    
    ROOT_CHECK=$(adb shell su -c "echo rooted" 2>/dev/null | tr -d '\r')
    if [ "$ROOT_CHECK" = "rooted" ]; then
        printf "  Root Status: ${GREEN}✓ ROOTED${NC}\n"
        MAGISK_VER=$(adb shell su -c "magisk -v" 2>/dev/null | tr -d '\r')
        if [ -n "$MAGISK_VER" ]; then
            printf "  Magisk: v$MAGISK_VER\n"
        fi
    else
        printf "  Root Status: ${RED}✗ NOT ROOTED${NC}\n"
    fi
    printf "\n"
}

verify_root() {
    printf "${YELLOW}[*]${NC} Checking root status...\n"
    
    if ! adb devices | grep -q "device$"; then
        printf "${RED}[!]${NC} No device connected\n"
        return
    fi
    
    ROOT_CHECK=$(adb shell su -c "echo rooted" 2>/dev/null | tr -d '\r')
    
    if [ "$ROOT_CHECK" = "rooted" ]; then
        printf "${GREEN}[✓]${NC} Device is rooted!\n"
        
        MAGISK_VER=$(adb shell su -c "magisk -v" 2>/dev/null | tr -d '\r')
        if [ -n "$MAGISK_VER" ]; then
            printf "    Magisk version: $MAGISK_VER\n\n"
            printf "    Checking SafetyNet...\n"
            printf "    (Open Magisk Manager and check SafetyNet status)\n"
        fi
    else
        printf "${RED}[✗]${NC} Device is not rooted\n"
    fi
    printf "\n"
}

view_docs() {
    printf "\n${BLUE}Documentation:${NC}\n\n"
    printf "  📖 Supported Devices: docs/supported-devices.md\n"
    printf "  📖 Installation Guide: docs/installation-guide.md\n"
    printf "  📖 Troubleshooting: docs/troubleshooting.md\n\n"
    printf "  🌐 Online Resources:\n"
    printf "     - XDA Developers: https://forum.xda-developers.com\n"
    printf "     - Magisk: https://github.com/topjohnwu/Magisk\n"
    printf "     - TWRP: https://twrp.me\n\n"
}

main() {
    while true; do
        show_menu
        read -p "Select option: " choice
        printf "\n"
        
        case $choice in
            1)
                cd scripts && ./otg_root.sh && cd ..
                ;;
            2)
                device_info
                ;;
            3)
                cd scripts && ./root_device.sh && cd ..
                ;;
            4)
                cd scripts && ./unroot_device.sh && cd ..
                ;;
            5)
                verify_root
                ;;
            6)
                cd scripts && ./backup_device.sh && cd ..
                ;;
            7)
                cd scripts && ./flash_rom.sh && cd ..
                ;;
            8)
                cd scripts && ./kernel_manager.sh && cd ..
                ;;
            9)
                cd scripts && ./magisk_modules.sh && cd ..
                ;;
            10)
                cd scripts && ./block_ota.sh && cd ..
                ;;
            11)
                cd scripts && ./unblock_ota.sh && cd ..
                ;;
            12)
                view_docs
                ;;
            0)
                printf "${GREEN}Goodbye!${NC}\n"
                exit 0
                ;;
            *)
                printf "${RED}Invalid option${NC}\n"
                ;;
        esac
        
        printf "\n"
        read -p "Press Enter to continue..."
        clear
        
        # Re-display banner
        printf "${PURPLE}"
        cat << "BANNER"
    ███╗   ██╗██████╗ ██╗  ██╗██╗ ██████╗ ███╗   ██╗
    ████╗  ██║╚════██╗╚██╗██╔╝██║██╔═══██╗████╗  ██║
    ██╔██╗ ██║ █████╔╝ ╚███╔╝ ██║██║   ██║██╔██╗ ██║
    ██║╚██╗██║ ╚═══██╗ ██╔██╗ ██║██║   ██║██║╚██╗██║
    ██║ ╚████║██████╔╝██╔╝ ██╗██║╚██████╔╝██║ ╚████║
    ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝
                    ROOT TOOLKIT
BANNER
        printf "${NC}\n"
        printf "${CYAN}        Android Rooting Made Easy${NC}\n\n"
    done
}

main
