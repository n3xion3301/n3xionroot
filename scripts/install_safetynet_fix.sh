#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "========================================="
echo "  n3xionroot - SafetyNet Fix Installer"
echo "========================================="
echo ""

MODULES_DIR="./modules"
mkdir -p "$MODULES_DIR"

check_root() {
    printf "${YELLOW}[*]${NC} Checking root access...\n"
    
    if ! adb devices | grep -q "device$"; then
        printf "${RED}[!]${NC} No device connected\n"
        exit 1
    fi
    
    ROOT_CHECK=$(adb shell su -c "echo rooted" 2>/dev/null | tr -d '\r')
    
    if [ "$ROOT_CHECK" != "rooted" ]; then
        printf "${RED}[!]${NC} Root access required\n"
        printf "    Root your device first\n"
        exit 1
    fi
    
    printf "${GREEN}[✓]${NC} Root access confirmed\n"
}

check_magisk() {
    printf "${YELLOW}[*]${NC} Checking Magisk installation...\n"
    
    MAGISK_VER=$(adb shell su -c "magisk -v" 2>/dev/null | tr -d '\r')
    
    if [ -z "$MAGISK_VER" ]; then
        printf "${RED}[!]${NC} Magisk not installed\n"
        printf "    SafetyNet fix requires Magisk\n"
        exit 1
    fi
    
    printf "${GREEN}[✓]${NC} Magisk version: $MAGISK_VER\n"
}

check_safetynet_status() {
    printf "\n${YELLOW}[*]${NC} Current SafetyNet status...\n"
    printf "    Open Magisk Manager and check SafetyNet\n"
    printf "    Settings > MagiskHide > Check SafetyNet\n\n"
    
    read -p "Is SafetyNet currently passing? (yes/no): " PASSING
    
    if [ "$PASSING" = "yes" ]; then
        printf "${GREEN}[✓]${NC} SafetyNet already passing!\n"
        read -p "Install fix anyway? (yes/no): " CONTINUE
        if [ "$CONTINUE" != "yes" ]; then
            exit 0
        fi
    else
        printf "${YELLOW}[!]${NC} SafetyNet failing - will install fix\n"
    fi
}

select_fix_method() {
    printf "\n${BLUE}Select SafetyNet fix method:${NC}\n"
    printf "  1) Universal SafetyNet Fix (Recommended)\n"
    printf "  2) Shamiko (Zygisk-based)\n"
    printf "  3) MagiskHide Props Config\n"
    printf "  4) Play Integrity Fix\n"
    printf "  5) All methods (maximum compatibility)\n"
    printf "\nSelect option (1-5): "
    read FIX_METHOD
    
    case $FIX_METHOD in
        1) install_universal_safetynet ;;
        2) install_shamiko ;;
        3) install_props_config ;;
        4) install_play_integrity ;;
        5) install_all_methods ;;
        *)
            printf "${RED}[!]${NC} Invalid option\n"
            exit 1
            ;;
    esac
}

download_module() {
    MODULE_NAME=$1
    MODULE_URL=$2
    MODULE_FILE=$3
    
    printf "\n${YELLOW}[*]${NC} Downloading $MODULE_NAME...\n"
    
    if [ -f "$MODULES_DIR/$MODULE_FILE" ]; then
        printf "${GREEN}[✓]${NC} Module already downloaded\n"
        return
    fi
    
    if command -v wget &> /dev/null; then
        wget -O "$MODULES_DIR/$MODULE_FILE" "$MODULE_URL"
    elif command -v curl &> /dev/null; then
        curl -L -o "$MODULES_DIR/$MODULE_FILE" "$MODULE_URL"
    else
        printf "${RED}[!]${NC} Neither wget nor curl found\n"
        exit 1
    fi
    
    if [ $? -eq 0 ]; then
        printf "${GREEN}[✓]${NC} Downloaded: $MODULE_FILE\n"
    else
        printf "${RED}[!]${NC} Download failed\n"
        exit 1
    fi
}

install_universal_safetynet() {
    printf "\n${BLUE}Installing Universal SafetyNet Fix...${NC}\n"
    
    MODULE_URL="https://github.com/kdrag0n/safetynet-fix/releases/latest/download/safetynet-fix.zip"
    MODULE_FILE="universal-safetynet-fix.zip"
    
    download_module "Universal SafetyNet Fix" "$MODULE_URL" "$MODULE_FILE"
    
    printf "${YELLOW}[*]${NC} Installing module...\n"
    adb push "$MODULES_DIR/$MODULE_FILE" /sdcard/Download/
    adb shell su -c "magisk --install-module /sdcard/Download/$MODULE_FILE"
    
    if [ $? -eq 0 ]; then
        printf "${GREEN}[✓]${NC} Universal SafetyNet Fix installed\n"
    else
        printf "${RED}[!]${NC} Installation failed\n"
    fi
}

install_shamiko() {
    printf "\n${BLUE}Installing Shamiko...${NC}\n"
    
    # Check if Zygisk is enabled
    printf "${YELLOW}[*]${NC} Checking Zygisk status...\n"
    printf "    Shamiko requires Zygisk to be enabled\n"
    printf "    Enable in Magisk: Settings > Zygisk > Enable\n"
    read -p "Is Zygisk enabled? (yes/no): " ZYGISK
    
    if [ "$ZYGISK" != "yes" ]; then
        printf "${YELLOW}[!]${NC} Please enable Zygisk first\n"
        return
    fi
    
    MODULE_URL="https://github.com/LSPosed/LSPosed.github.io/releases/latest/download/Shamiko-release.zip"
    MODULE_FILE="shamiko.zip"
    
    download_module "Shamiko" "$MODULE_URL" "$MODULE_FILE"
    
    printf "${YELLOW}[*]${NC} Installing module...\n"
    adb push "$MODULES_DIR/$MODULE_FILE" /sdcard/Download/
    adb shell su -c "magisk --install-module /sdcard/Download/$MODULE_FILE"
    
    if [ $? -eq 0 ]; then
        printf "${GREEN}[✓]${NC} Shamiko installed\n"
    else
        printf "${RED}[!]${NC} Installation failed\n"
    fi
}

install_props_config() {
    printf "\n${BLUE}Installing MagiskHide Props Config...${NC}\n"
    
    MODULE_URL="https://github.com/Magisk-Modules-Repo/MagiskHidePropsConf/releases/latest/download/MagiskHidePropsConf.zip"
    MODULE_FILE="props-config.zip"
    
    download_module "Props Config" "$MODULE_URL" "$MODULE_FILE"
    
    printf "${YELLOW}[*]${NC} Installing module...\n"
    adb push "$MODULES_DIR/$MODULE_FILE" /sdcard/Download/
    adb shell su -c "magisk --install-module /sdcard/Download/$MODULE_FILE"
    
    if [ $? -eq 0 ]; then
        printf "${GREEN}[✓]${NC} Props Config installed\n"
        printf "\n${YELLOW}Configuration required:${NC}\n"
        printf "  1. Open terminal on device\n"
        printf "  2. Type: su\n"
        printf "  3. Type: props\n"
        printf "  4. Follow the menu to configure\n"
    else
        printf "${RED}[!]${NC} Installation failed\n"
    fi
}

install_play_integrity() {
    printf "\n${BLUE}Installing Play Integrity Fix...${NC}\n"
    
    MODULE_URL="https://github.com/chiteroman/PlayIntegrityFix/releases/latest/download/PlayIntegrityFix.zip"
    MODULE_FILE="play-integrity-fix.zip"
    
    download_module "Play Integrity Fix" "$MODULE_URL" "$MODULE_FILE"
    
    printf "${YELLOW}[*]${NC} Installing module...\n"
    adb push "$MODULES_DIR/$MODULE_FILE" /sdcard/Download/
    adb shell su -c "magisk --install-module /sdcard/Download/$MODULE_FILE"
    
    if [ $? -eq 0 ]; then
        printf "${GREEN}[✓]${NC} Play Integrity Fix installed\n"
    else
        printf "${RED}[!]${NC} Installation failed\n"
    fi
}

install_all_methods() {
    printf "\n${BLUE}Installing all SafetyNet fixes...${NC}\n"
    
    install_universal_safetynet
    install_shamiko
    install_props_config
    install_play_integrity
}

configure_magisk() {
    printf "\n${YELLOW}[*]${NC} Magisk configuration recommendations...\n\n"
    
    printf "${BLUE}Recommended Magisk settings:${NC}\n"
    printf "  1. Enable Zygisk (Settings > Zygisk)\n"
    printf "  2. Enable 'Enforce DenyList' (Settings > DenyList)\n"
    printf "  3. Configure DenyList:\n"
    printf "     - Google Play Services\n"
    printf "     - Google Play Store\n"
    printf "     - Google Services Framework\n"
    printf "     - Banking apps\n"
    printf "     - Payment apps (Google Pay, etc)\n"
    printf "  4. Hide Magisk app (Settings > Hide Magisk)\n\n"
    
    read -p "Open Magisk Manager to configure? (yes/no): " OPEN_MAGISK
    
    if [ "$OPEN_MAGISK" = "yes" ]; then
        adb shell am start -n com.topjohnwu.magisk/.ui.MainActivity
        printf "Configure settings, then press Enter to continue...\n"
        read
    fi
}

clear_google_play_data() {
    printf "\n${YELLOW}[*]${NC} Clear Google Play Services data...\n"
    printf "    This helps SafetyNet re-check after fixes\n"
    read -p "Clear Google Play data? (yes/no): " CLEAR
    
    if [ "$CLEAR" = "yes" ]; then
        printf "    Clearing data...\n"
        adb shell pm clear com.google.android.gms
        adb shell pm clear com.google.android.gsf
        printf "${GREEN}[✓]${NC} Data cleared\n"
    fi
}

reboot_device() {
    printf "\n${YELLOW}[*]${NC} Reboot required for changes to take effect\n"
    read -p "Reboot now? (yes/no): " REBOOT
    
    if [ "$REBOOT" = "yes" ]; then
        printf "    Rebooting device...\n"
        adb reboot
        printf "${GREEN}[✓]${NC} Device rebooting\n"
        printf "    Wait for boot, then check SafetyNet in Magisk\n"
    else
        printf "${YELLOW}[!]${NC} Remember to reboot manually\n"
    fi
}

verify_safetynet() {
    printf "\n${BLUE}Verify SafetyNet after reboot:${NC}\n"
    printf "  1. Open Magisk Manager\n"
    printf "  2. Settings > Check SafetyNet\n"
    printf "  3. Both 'basicIntegrity' and 'ctsProfile' should pass\n\n"
    
    printf "${YELLOW}If still failing:${NC}\n"
    printf "  - Clear Google Play data again\n"
    printf "  - Wait 10-15 minutes\n"
    printf "  - Recheck SafetyNet\n"
    printf "  - Try different fix method\n"
    printf "  - Check XDA for device-specific solutions\n"
}

main() {
    check_root
    check_magisk
    check_safetynet_status
    select_fix_method
    configure_magisk
    clear_google_play_data
    reboot_device
    verify_safetynet
    
    printf "\n${GREEN}=========================================${NC}\n"
    printf "${GREEN}SafetyNet fix installation complete!${NC}\n"
    printf "\nInstalled modules saved to: $MODULES_DIR/\n"
    printf "${GREEN}=========================================${NC}\n"
}

main
