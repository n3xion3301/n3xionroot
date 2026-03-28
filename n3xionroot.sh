#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

show_banner() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "    ███╗   ██╗██████╗ ██╗  ██╗██╗ ██████╗ ███╗   ██╗"
    echo "    ████╗  ██║╚════██╗╚██╗██╔╝██║██╔═══██╗████╗  ██║"
    echo "    ██╔██╗ ██║ █████╔╝ ╚███╔╝ ██║██║   ██║██╔██╗ ██║"
    echo "    ██║╚██╗██║ ╚═══██╗ ██╔██╗ ██║██║   ██║██║╚██╗██║"
    echo "    ██║ ╚████║██████╔╝██╔╝ ██╗██║╚██████╔╝██║ ╚████║"
    echo "    ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝"
    echo -e "${NC}"
    echo -e "${PURPLE}${BOLD}              🔓 ROOT TOOLKIT v2.0 🔓${NC}"
    echo -e "${WHITE}          Android Rooting Made Easy${NC}"
    echo ""
    echo -e "${PURPLE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC}  ${CYAN}📱 22 Devices${NC}  │  ${CYAN}📦 25+ Modules${NC}  │  ${CYAN}🎯 20 Features${NC}  ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_menu() {
    echo -e "${YELLOW}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║${NC}                    ${BOLD}${WHITE}MAIN MENU${NC}                            ${YELLOW}║${NC}"
    echo -e "${YELLOW}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${CYAN}⚡ Quick Actions${NC}"
    echo -e "  ${GREEN}1)${NC} 🚀 On-The-Go Root          ${BLUE}(Auto-detect & Root)${NC}"
    echo -e "  ${GREEN}2)${NC} 📱 Device Info             ${BLUE}(View device details)${NC}"
    echo ""
    
    echo -e "${CYAN}🔐 Root Management${NC}"
    echo -e "  ${GREEN}3)${NC} ✅ Root Device             ${BLUE}(Manual rooting)${NC}"
    echo -e "  ${GREEN}4)${NC} ❌ Unroot Device           ${BLUE}(Remove root)${NC}"
    echo -e "  ${GREEN}5)${NC} 🔍 Verify Root Status      ${BLUE}(Check root)${NC}"
    echo ""
    
    echo -e "${CYAN}🛠️  System Tools${NC}"
    echo -e "  ${GREEN}6)${NC} 💾 Backup Device           ${BLUE}(Full backup)${NC}"
    echo -e "  ${GREEN}7)${NC} ☁️  Cloud Backup Manager    ${BLUE}(Drive/Dropbox/OneDrive)${NC}"
    echo -e "  ${GREEN}8)${NC} 🔄 Flash Custom ROM        ${BLUE}(Install ROM)${NC}"
    echo -e "  ${GREEN}9)${NC} 💡 ROM Recommender         ${BLUE}(Smart suggestions)${NC}"
    echo -e " ${GREEN}10)${NC} ⚙️  Kernel Manager          ${BLUE}(Manage kernels)${NC}"
    echo -e " ${GREEN}11)${NC} 🔧 Custom Kernel Installer ${BLUE}(Flash kernels)${NC}"
    echo -e " ${GREEN}12)${NC} 📦 Magisk Modules          ${BLUE}(25+ modules)${NC}"
    echo ""
    
    echo -e "${CYAN}📥 Downloads & Installation${NC}"
    echo -e " ${GREEN}13)${NC} 📥 Download Recovery       ${BLUE}(TWRP/OrangeFox)${NC}"
    echo -e " ${GREEN}14)${NC} 🔨 Auto Install TWRP       ${BLUE}(One-click)${NC}"
    echo -e " ${GREEN}15)${NC} 📥 Download Firmware       ${BLUE}(Stock firmware)${NC}"
    echo -e " ${GREEN}16)${NC} 🔧 Install ADB/Fastboot    ${BLUE}(Platform tools)${NC}"
    echo ""
    
    echo -e "${CYAN}🔬 Advanced${NC}"
    echo -e " ${GREEN}17)${NC} 🚫 Block OTA Updates       ${BLUE}(Prevent updates)${NC}"
    echo -e " ${GREEN}18)${NC} ✔️  Unblock OTA Updates     ${BLUE}(Allow updates)${NC}"
    echo -e " ${GREEN}19)${NC} 🛡️  SafetyNet Fix           ${BLUE}(4 methods)${NC}"
    echo -e " ${GREEN}20)${NC} 📚 Documentation           ${BLUE}(View guides)${NC}"
    echo ""
    
    echo -e "  ${RED}0)${NC} 🚪 Exit"
    echo ""
    echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
    echo ""
}

main() {
    while true; do
        show_banner
        show_menu
        
        echo -ne "${CYAN}${BOLD}Select [0-20]: ${NC}"
        read choice
        echo ""
        
        case $choice in
            1) bash scripts/otg_root.sh ;;
            2) bash scripts/root_device.sh --info-only ;;
            3) bash scripts/root_device.sh ;;
            4) bash scripts/unroot_device.sh ;;
            5) bash scripts/root_device.sh --verify-only ;;
            6) bash scripts/backup_device.sh ;;
            7) bash scripts/cloud_backup.sh ;;
            8) bash scripts/flash_rom.sh ;;
            9) bash scripts/rom_recommender.sh ;;
            10) bash scripts/kernel_manager.sh ;;
            11) bash scripts/custom_kernel_installer.sh ;;
            12) bash scripts/magisk_modules.sh ;;
            13) bash scripts/download_recovery.sh ;;
            14) bash scripts/auto_install_twrp.sh ;;
            15) bash scripts/download_firmware.sh ;;
            16) bash scripts/install_adb_fastboot.sh ;;
            17) bash scripts/block_ota.sh ;;
            18) bash scripts/unblock_ota.sh ;;
            19) bash scripts/install_safetynet_fix.sh ;;
            20) cat docs/README.md 2>/dev/null || echo "Docs: github.com/n3xion3301/n3xionroot" ;;
            0) echo -e "${GREEN}Thanks for using n3xionroot! 👋${NC}"; exit 0 ;;
            *) echo -e "${RED}Invalid option!${NC}"; sleep 1 ;;
        esac
        
        if [ "$choice" != "0" ]; then
            echo ""
            read -p "Press Enter to continue..."
        fi
    done
}

main
