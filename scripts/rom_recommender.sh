#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo "========================================="
echo "  n3xionroot - ROM Recommendation Engine"
echo "========================================="
echo ""

detect_device() {
    echo -e "${YELLOW}[*]${NC} Detecting device..."
    
    if ! adb devices | grep -q "device$"; then
        echo -e "${YELLOW}[!]${NC} No device connected - manual selection"
        MANUAL_SELECT=true
        return
    fi
    
    DEVICE_CODE=$(adb shell getprop ro.product.device 2>/dev/null | tr -d '\r')
    DEVICE_MODEL=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
    ANDROID_VER=$(adb shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')
    
    echo -e "${GREEN}[✓]${NC} Device: $DEVICE_MODEL ($DEVICE_CODE)"
    echo "    Android: $ANDROID_VER"
    MANUAL_SELECT=false
}

select_device_manual() {
    if [ "$MANUAL_SELECT" = false ]; then
        return
    fi
    
    echo -e "\n${BLUE}Select your device:${NC}"
    echo "  1) Samsung Galaxy S10/S20/S21"
    echo "  2) Google Pixel 4a/5/6"
    echo "  3) Xiaomi Redmi Note 10/Poco F3/Mi 11"
    echo "  4) OnePlus 7 Pro/8"
    echo "  5) Other"
    read -p "Select (1-5): " DEVICE_CHOICE
    
    case $DEVICE_CHOICE in
        1) DEVICE_FAMILY="samsung" ;;
        2) DEVICE_FAMILY="google" ;;
        3) DEVICE_FAMILY="xiaomi" ;;
        4) DEVICE_FAMILY="oneplus" ;;
        5) DEVICE_FAMILY="other" ;;
        *) echo -e "${RED}Invalid choice${NC}"; exit 1 ;;
    esac
}

get_user_preferences() {
    echo -e "\n${BLUE}What's most important to you?${NC}"
    echo "  1) 🔋 Battery life"
    echo "  2) 🎨 Customization"
    echo "  3) ⚡ Performance"
    echo "  4) 🔒 Privacy & Security"
    echo "  5) 📱 Stock Android experience"
    read -p "Select (1-5): " PRIORITY
    
    echo -e "\n${BLUE}Experience level?${NC}"
    echo "  1) Beginner (stable, easy)"
    echo "  2) Intermediate (balanced)"
    echo "  3) Advanced (bleeding edge)"
    read -p "Select (1-3): " EXPERIENCE
}

recommend_roms() {
    echo -e "\n${CYAN}=========================================${NC}"
    echo -e "${CYAN}Recommended ROMs for you:${NC}"
    echo -e "${CYAN}=========================================${NC}\n"
    
    # Priority-based recommendations
    case $PRIORITY in
        1) # Battery life
            echo -e "${GREEN}1. LineageOS${NC}"
            echo "   ✓ Excellent battery optimization"
            echo "   ✓ Clean, minimal bloat"
            echo "   ✓ Regular updates"
            echo "   Download: https://download.lineageos.org"
            echo ""
            echo -e "${GREEN}2. crDroid${NC}"
            echo "   ✓ Battery-focused features"
            echo "   ✓ Customizable"
            echo "   Download: https://crdroid.net"
            ;;
        2) # Customization
            echo -e "${GREEN}1. Pixel Experience Plus${NC}"
            echo "   ✓ Tons of customization"
            echo "   ✓ Pixel features"
            echo "   Download: https://download.pixelexperience.org"
            echo ""
            echo -e "${GREEN}2. Evolution X${NC}"
            echo "   ✓ Massive customization options"
            echo "   ✓ Pixel + custom features"
            echo "   Download: https://evolution-x.org"
            ;;
        3) # Performance
            echo -e "${GREEN}1. Paranoid Android${NC}"
            echo "   ✓ Optimized performance"
            echo "   ✓ Smooth animations"
            echo "   Download: https://paranoidandroid.co"
            echo ""
            echo -e "${GREEN}2. AOSP Extended${NC}"
            echo "   ✓ Performance tweaks"
            echo "   ✓ Customization"
            echo "   Download: https://www.aospextended.com"
            ;;
        4) # Privacy
            echo -e "${GREEN}1. GrapheneOS${NC} (Pixel only)"
            echo "   ✓ Maximum privacy & security"
            echo "   ✓ Hardened Android"
            echo "   Download: https://grapheneos.org"
            echo ""
            echo -e "${GREEN}2. CalyxOS${NC} (Pixel only)"
            echo "   ✓ Privacy-focused"
            echo "   ✓ microG support"
            echo "   Download: https://calyxos.org"
            ;;
        5) # Stock experience
            echo -e "${GREEN}1. Pixel Experience${NC}"
            echo "   ✓ Pure Pixel UI"
            echo "   ✓ Stable & smooth"
            echo "   Download: https://download.pixelexperience.org"
            echo ""
            echo -e "${GREEN}2. LineageOS${NC}"
            echo "   ✓ Clean AOSP"
            echo "   ✓ Minimal additions"
            echo "   Download: https://download.lineageos.org"
            ;;
    esac
    
    echo ""
    echo -e "${BLUE}Universal Recommendations:${NC}"
    echo ""
    echo -e "${YELLOW}3. Resurrection Remix${NC}"
    echo "   ✓ Feature-rich"
    echo "   ✓ Wide device support"
    echo "   Download: https://resurrectionremix.com"
    echo ""
    echo -e "${YELLOW}4. Havoc OS${NC}"
    echo "   ✓ Customization + performance"
    echo "   ✓ Regular updates"
    echo "   Download: https://havoc-os.com"
}

show_installation_guide() {
    echo -e "\n${CYAN}=========================================${NC}"
    echo -e "${CYAN}Installation Steps:${NC}"
    echo -e "${CYAN}=========================================${NC}\n"
    
    echo "1. Backup your data"
    echo "2. Download ROM ZIP file"
    echo "3. Download GApps (optional):"
    echo "   - NikGApps: https://nikgapps.com"
    echo "   - MindTheGapps: https://wiki.lineageos.org/gapps"
    echo "4. Boot into TWRP recovery"
    echo "5. Wipe: System, Data, Cache, Dalvik"
    echo "6. Install ROM ZIP"
    echo "7. Install GApps ZIP (if desired)"
    echo "8. Install Magisk (for root)"
    echo "9. Reboot"
    echo ""
    echo -e "${YELLOW}Tip: Use our ROM flasher script!${NC}"
    echo "     ./scripts/flash_rom.sh"
}

main() {
    detect_device
    select_device_manual
    get_user_preferences
    recommend_roms
    show_installation_guide
    
    echo -e "\n${GREEN}=========================================${NC}"
    echo -e "${GREEN}Happy Flashing!${NC}"
    echo -e "${GREEN}=========================================${NC}\n"
}

main
