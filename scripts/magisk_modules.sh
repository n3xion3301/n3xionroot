#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "========================================="
echo "   n3xionroot - Magisk Module Manager"
echo "========================================="
echo ""

check_magisk() {
    echo -e "${YELLOW}[*]${NC} Checking Magisk installation..."
    
    MAGISK_VER=$(adb shell su -c "magisk -v" 2>/dev/null | tr -d '\r')
    if [ -z "$MAGISK_VER" ]; then
        echo -e "${RED}[!]${NC} Magisk not installed"
        exit 1
    fi
    
    echo -e "${GREEN}[✓]${NC} Magisk version: $MAGISK_VER"
}

list_installed_modules() {
    echo ""
    echo -e "${YELLOW}[*]${NC} Installed Magisk modules..."
    echo ""
    
    adb shell su -c "ls /data/adb/modules" 2>/dev/null | while read module; do
        if [ "$module" != "lost+found" ]; then
            MODULE_NAME=$(adb shell su -c "cat /data/adb/modules/$module/module.prop 2>/dev/null | grep 'name=' | cut -d'=' -f2" | tr -d '\r')
            MODULE_VER=$(adb shell su -c "cat /data/adb/modules/$module/module.prop 2>/dev/null | grep 'version=' | cut -d'=' -f2" | tr -d '\r')
            
            echo "  📦 $MODULE_NAME (v$MODULE_VER)"
            echo "     ID: $module"
            echo ""
        fi
    done
}

install_module() {
    echo ""
    echo -e "${BLUE}Popular Magisk Modules:${NC}"
    echo "  - Universal SafetyNet Fix"
    echo "  - Busybox for Android NDK"
    echo "  - ViPER4Android FX"
    echo "  - Systemless Hosts"
    echo ""
    
    echo "Place module ZIP in current directory as 'module.zip'"
    read -p "Press Enter when ready..."
    
    if [ ! -f "module.zip" ]; then
        echo -e "${RED}[!]${NC} module.zip not found"
        exit 1
    fi
    
    echo -e "${YELLOW}[*]${NC} Installing module..."
    adb push module.zip /sdcard/Download/
    adb shell su -c "magisk --install-module /sdcard/Download/module.zip"
    
    echo -e "${GREEN}[✓]${NC} Module installed"
    echo -e "${YELLOW}[!]${NC} Reboot required"
    
    read -p "Reboot now? (yes/no): " REBOOT
    if [ "$REBOOT" = "yes" ]; then
        adb reboot
    fi
}

remove_module() {
    echo ""
    list_installed_modules
    read -p "Enter module ID to remove: " MODULE_ID
    
    if [ -z "$MODULE_ID" ]; then
        echo -e "${RED}[!]${NC} No module ID provided"
        return
    fi
    
    adb shell su -c "rm -rf /data/adb/modules/$MODULE_ID"
    echo -e "${GREEN}[✓]${NC} Module removed (reboot required)"
}

toggle_module() {
    echo ""
    list_installed_modules
    read -p "Enter module ID: " MODULE_ID
    
    DISABLED=$(adb shell su -c "[ -f /data/adb/modules/$MODULE_ID/disable ] && echo 'yes' || echo 'no'" | tr -d '\r')
    
    if [ "$DISABLED" = "yes" ]; then
        adb shell su -c "rm /data/adb/modules/$MODULE_ID/disable"
        echo -e "${GREEN}[✓]${NC} Module enabled"
    else
        adb shell su -c "touch /data/adb/modules/$MODULE_ID/disable"
        echo -e "${GREEN}[✓]${NC} Module disabled"
    fi
    
    echo -e "${YELLOW}[!]${NC} Reboot required"
}

main() {
    check_magisk
    
    echo ""
    echo -e "${BLUE}Module Manager Options:${NC}"
    echo "  1) List installed modules"
    echo "  2) Install module"
    echo "  3) Remove module"
    echo "  4) Enable/Disable module"
    echo "  5) Exit"
    echo ""
    read -p "Select option (1-5): " OPTION
    
    case $OPTION in
        1) list_installed_modules ;;
        2) install_module ;;
        3) remove_module ;;
        4) toggle_module ;;
        5) exit 0 ;;
        *) echo -e "${RED}[!]${NC} Invalid option" ;;
    esac
}

main
