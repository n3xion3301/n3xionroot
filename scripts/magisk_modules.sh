#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

clear
echo -e "${PURPLE}"
cat << "BANNER"
    ╔═══════════════════════════════════════╗
    ║    MAGISK MODULE MANAGER              ║
    ╚═══════════════════════════════════════╝
BANNER
echo -e "${NC}"

show_menu() {
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${GREEN}Magisk Module Management${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}\n"
    
    echo "  1) 📋 List Installed Modules"
    echo "  2) 🔍 Browse Popular Modules"
    echo "  3) 📥 Download Module"
    echo "  4) 📦 Install Module"
    echo "  5) ✅ Enable Module"
    echo "  6) ❌ Disable Module"
    echo "  7) 🗑️  Remove Module"
    echo "  8) 🔄 Update All Modules"
    echo "  9) 🛡️  Install Essential Modules Pack"
    echo "  0) 🔙 Back to Main Menu"
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════${NC}\n"
}

check_magisk() {
    echo -e "${YELLOW}[*]${NC} Checking Magisk status...\n"
    
    if ! adb devices | grep -q "device$"; then
        echo -e "${RED}[!]${NC} No device connected"
        return 1
    fi
    
    MAGISK_VER=$(adb shell su -c "magisk -v" 2>/dev/null | tr -d '\r')
    
    if [ -z "$MAGISK_VER" ]; then
        echo -e "${RED}[!]${NC} Magisk not installed or no root access"
        return 1
    fi
    
    echo -e "${GREEN}[✓]${NC} Magisk version: $MAGISK_VER"
    return 0
}

list_modules() {
    echo -e "${YELLOW}[*]${NC} Installed Magisk Modules:\n"
    
    if ! check_magisk; then
        return
    fi
    
    echo -e "${CYAN}Active Modules:${NC}"
    adb shell su -c "ls /data/adb/modules" 2>/dev/null | while read module; do
        if [ -n "$module" ]; then
            echo "  📦 $module"
        fi
    done
    echo ""
}

browse_modules() {
    echo -e "${YELLOW}[*]${NC} Popular Magisk Modules:\n"
    
    echo -e "${CYAN}━━━ Essential Modules ━━━${NC}"
    echo ""
    echo "  1. 🛡️  Shamiko (Hide Magisk)"
    echo "     - Hide root from apps"
    echo "     - Pass SafetyNet"
    echo ""
    echo "  2. 🎵 ViPER4Android FX"
    echo "     - Audio enhancement"
    echo "     - Equalizer & effects"
    echo ""
    echo "  3. 📶 WiFi Bonding"
    echo "     - Improve WiFi performance"
    echo "     - Better connectivity"
    echo ""
    echo "  4. 🔋 Advanced Charging Controller"
    echo "     - Battery health protection"
    echo "     - Charging limits"
    echo ""
    echo "  5. 🎨 Systemless Hosts"
    echo "     - Ad blocking"
    echo "     - Privacy protection"
    echo ""
    echo "  6. 📱 Busybox for Android NDK"
    echo "     - Essential Linux tools"
    echo "     - Command line utilities"
    echo ""
    echo "  7. 🔊 Dolby Atmos"
    echo "     - Enhanced audio"
    echo "     - Surround sound"
    echo ""
    echo "  8. 📸 Google Camera Enabler"
    echo "     - Enable GCam features"
    echo "     - Better photos"
    echo ""
    
    echo -e "${CYAN}━━━ Advanced Modules ━━━${NC}"
    echo ""
    echo "  9. 🔐 LSPosed Framework"
    echo "     - Xposed framework"
    echo "     - Module support"
    echo ""
    echo " 10. 🚀 Zygisk - Next"
    echo "     - Zygisk implementation"
    echo "     - Module injection"
    echo ""
    echo " 11. 🎮 Game Optimizer"
    echo "     - Boost gaming performance"
    echo "     - Reduce lag"
    echo ""
    echo " 12. 📊 System Monitor"
    echo "     - CPU/RAM monitoring"
    echo "     - Performance stats"
    echo ""
}

download_module() {
    echo -e "${YELLOW}[*]${NC} Download Magisk Module\n"
    
    echo "Popular module repositories:"
    echo "  1. Magisk Module Repository: https://github.com/Magisk-Modules-Repo"
    echo "  2. XDA Forums: https://forum.xda-developers.com"
    echo ""
    
    read -p "Enter module ZIP URL or path: " MODULE_PATH
    
    if [[ "$MODULE_PATH" == http* ]]; then
        echo "Downloading..."
        MODULE_NAME=$(basename "$MODULE_PATH")
        wget -O "./modules/$MODULE_NAME" "$MODULE_PATH" 2>/dev/null || \
        curl -L -o "./modules/$MODULE_NAME" "$MODULE_PATH" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[✓]${NC} Downloaded: $MODULE_NAME"
        else
            echo -e "${RED}[!]${NC} Download failed"
        fi
    fi
}

install_module() {
    echo -e "${YELLOW}[*]${NC} Install Magisk Module\n"
    
    if ! check_magisk; then
        return
    fi
    
    mkdir -p ./modules
    
    echo "Available modules in ./modules/:"
    ls -1 ./modules/*.zip 2>/dev/null || echo "  (none)"
    echo ""
    
    read -p "Enter module ZIP filename: " MODULE_ZIP
    
    if [ ! -f "./modules/$MODULE_ZIP" ]; then
        echo -e "${RED}[!]${NC} File not found"
        return
    fi
    
    echo "Pushing module to device..."
    adb push "./modules/$MODULE_ZIP" /sdcard/Download/
    
    echo -e "${YELLOW}[!]${NC} Installation Methods:"
    echo "  1. Via Magisk Manager (Recommended)"
    echo "  2. Via Command Line"
    echo ""
    
    read -p "Select method (1/2): " METHOD
    
    case $METHOD in
        1)
            echo ""
            echo -e "${CYAN}Instructions:${NC}"
            echo "  1. Open Magisk Manager app"
            echo "  2. Tap 'Modules' tab"
            echo "  3. Tap 'Install from storage'"
            echo "  4. Select: $MODULE_ZIP"
            echo "  5. Reboot when prompted"
            ;;
        2)
            echo "Installing via command line..."
            adb shell su -c "magisk --install-module /sdcard/Download/$MODULE_ZIP"
            echo -e "${GREEN}[✓]${NC} Module installed"
            echo -e "${YELLOW}[!]${NC} Reboot required"
            ;;
    esac
}

enable_module() {
    echo -e "${YELLOW}[*]${NC} Enable Module\n"
    
    if ! check_magisk; then
        return
    fi
    
    echo "Installed modules:"
    adb shell su -c "ls /data/adb/modules" 2>/dev/null
    echo ""
    
    read -p "Enter module ID to enable: " MODULE_ID
    
    adb shell su -c "rm /data/adb/modules/$MODULE_ID/disable" 2>/dev/null
    echo -e "${GREEN}[✓]${NC} Module enabled (reboot required)"
}

disable_module() {
    echo -e "${YELLOW}[*]${NC} Disable Module\n"
    
    if ! check_magisk; then
        return
    fi
    
    echo "Installed modules:"
    adb shell su -c "ls /data/adb/modules" 2>/dev/null
    echo ""
    
    read -p "Enter module ID to disable: " MODULE_ID
    
    adb shell su -c "touch /data/adb/modules/$MODULE_ID/disable" 2>/dev/null
    echo -e "${GREEN}[✓]${NC} Module disabled (reboot required)"
}

remove_module() {
    echo -e "${YELLOW}[*]${NC} Remove Module\n"
    
    if ! check_magisk; then
        return
    fi
    
    echo "Installed modules:"
    adb shell su -c "ls /data/adb/modules" 2>/dev/null
    echo ""
    
    read -p "Enter module ID to remove: " MODULE_ID
    
    echo -e "${RED}WARNING: This will permanently remove the module${NC}"
    read -p "Continue? (yes/no): " CONFIRM
    
    if [ "$CONFIRM" = "yes" ]; then
        adb shell su -c "rm -rf /data/adb/modules/$MODULE_ID" 2>/dev/null
        echo -e "${GREEN}[✓]${NC} Module removed (reboot required)"
    fi
}

install_essentials() {
    echo -e "${YELLOW}[*]${NC} Install Essential Modules Pack\n"
    
    echo -e "${CYAN}Essential Pack Includes:${NC}"
    echo "  1. Shamiko (Hide root)"
    echo "  2. Systemless Hosts (Ad blocking)"
    echo "  3. Busybox NDK (Linux tools)"
    echo ""
    
    echo "These modules will be downloaded and installed."
    read -p "Continue? (yes/no): " CONFIRM
    
    if [ "$CONFIRM" = "yes" ]; then
        echo "Feature coming soon - manual installation required"
        echo "Visit: https://github.com/Magisk-Modules-Repo"
    fi
}

main() {
    while true; do
        show_menu
        read -p "Select option: " choice
        echo ""
        
        case $choice in
            1) list_modules ;;
            2) browse_modules ;;
            3) download_module ;;
            4) install_module ;;
            5) enable_module ;;
            6) disable_module ;;
            7) remove_module ;;
            8) echo "Update feature - check Magisk Manager for updates" ;;
            9) install_essentials ;;
            0) exit 0 ;;
            *) echo -e "${RED}Invalid option${NC}" ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
        clear
        echo -e "${PURPLE}"
        cat << "BANNER"
    ╔═══════════════════════════════════════╗
    ║    MAGISK MODULE MANAGER              ║
    ╚═══════════════════════════════════════╝
BANNER
        echo -e "${NC}"
    done
}

main

# Additional popular modules (appended)
show_extended_modules() {
    echo -e "${CYAN}━━━ Privacy & Security ━━━${NC}"
    echo ""
    echo " 13. 🔒 Universal SafetyNet Fix"
    echo " 14. 🛡️  App Systemizer"
    echo " 15. 🔐 Detach (Prevent Play Store updates)"
    echo ""
    
    echo -e "${CYAN}━━━ Performance ━━━${NC}"
    echo ""
    echo " 16. ⚡ FDE.AI (AI performance)"
    echo " 17. 🚀 LSpeed (Speed optimizer)"
    echo " 18. 💨 Thermal Throttle Manager"
    echo ""
    
    echo -e "${CYAN}━━━ Customization ━━━${NC}"
    echo ""
    echo " 19. 🎨 Substratum Theme Engine"
    echo " 20. 🖼️  Icon Pack Enabler"
    echo " 21. 🔤 Font Manager"
    echo ""
    
    echo -e "${CYAN}━━━ Utilities ━━━${NC}"
    echo ""
    echo " 22. 📡 WiFi Bonding+"
    echo " 23. 🔋 Battery Charge Limit"
    echo " 24. 📸 Camera2 API Enabler"
    echo " 25. 🎮 Game Turbo Enabler"
}
