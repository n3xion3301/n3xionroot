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

clear

echo -e "${CYAN}${BOLD}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║           DEVICE COMPATIBILITY CHECKER                     ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

check_adb() {
    echo -e "${YELLOW}[*]${NC} Checking ADB connection..."
    if ! command -v adb &> /dev/null; then
        echo -e "${RED}[!]${NC} ADB not found. Please install platform-tools."
        exit 1
    fi
    
    DEVICE_CONNECTED=$(adb devices | grep -w "device" | wc -l)
    if [ "$DEVICE_CONNECTED" -eq 0 ]; then
        echo -e "${RED}[!]${NC} No device connected"
        echo -e "${YELLOW}[!]${NC} Please connect your device and enable USB debugging"
        exit 1
    fi
    echo -e "${GREEN}[✓]${NC} Device connected"
    echo ""
}

get_device_info() {
    echo -e "${CYAN}${BOLD}Device Information:${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    MANUFACTURER=$(adb shell getprop ro.product.manufacturer 2>/dev/null | tr -d '\r' | tr '[:lower:]' '[:upper:]')
    MODEL=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
    DEVICE_CODE=$(adb shell getprop ro.product.device 2>/dev/null | tr -d '\r')
    ANDROID_VER=$(adb shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')
    SDK_VER=$(adb shell getprop ro.build.version.sdk 2>/dev/null | tr -d '\r')
    CHIPSET=$(adb shell getprop ro.board.platform 2>/dev/null | tr -d '\r')
    
    echo -e "${WHITE}Manufacturer:${NC}  $MANUFACTURER"
    echo -e "${WHITE}Model:${NC}         $MODEL"
    echo -e "${WHITE}Codename:${NC}      $DEVICE_CODE"
    echo -e "${WHITE}Android:${NC}       $ANDROID_VER (SDK $SDK_VER)"
    echo -e "${WHITE}Chipset:${NC}       $CHIPSET"
    echo ""
}

check_compatibility() {
    echo -e "${CYAN}${BOLD}Compatibility Check:${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # List of all supported devices
    SUPPORTED_DEVICES=(
        # Samsung
        "beyond0lte" "beyond1lte" "beyond2lte"  # S10 series
        "x1s" "y2s" "z3s"                       # S20 series
        "o1s" "p3s" "t2s"                       # S21 series
        "r0s" "g0s" "b0s"                       # S22 series
        "dm1q" "dm2q" "dm3q"                    # S23 series
        
        # Google Pixel
        "sunfish"                               # Pixel 4a
        "redfin" "bramble"                      # Pixel 5
        "oriole" "raven"                        # Pixel 6
        "panther" "cheetah"                     # Pixel 7
        "shiba" "husky"                         # Pixel 8
        
        # Xiaomi
        "mojito"                                # Redmi Note 10
        "alioth"                                # Poco F3
        "venus" "mars"                          # Mi 11
        "cupid" "zeus"                          # Mi 12
        "fuxi"                                  # Mi 13
        
        # OnePlus
        "guacamole"                             # 7 Pro
        "instantnoodle" "instantnoodlep"        # 8 series
        "lemonade" "lemonadep"                  # 9 Pro
        "ovaltine"                              # 10 Pro
        
        # Nothing
        "Spacewar"                              # Phone (2)
        
        # Asus
        "AI2205"                                # ROG Phone 7
        
        # Motorola
        "borneo"                                # Moto G Power
        
        # Sony
        "pdx234"                                # Xperia 1 V
        
        # Realme
        "RMX3708"                               # GT 3
        
        # Oppo
        "PGEM10"                                # Find X6 Pro
        
        # Vivo
        "V2227A"                                # X90 Pro
        
        # Honor
        "PGT-AN10"                              # Magic 5 Pro
        
        # Nubia
        "NX729J"                                # Red Magic 8 Pro
        
        # ZTE
        "A2023P"                                # Axon 40 Ultra
    )
    
    DEVICE_SUPPORTED=false
    DEVICE_NAME=""
    
    for device in "${SUPPORTED_DEVICES[@]}"; do
        if [ "$DEVICE_CODE" = "$device" ]; then
            DEVICE_SUPPORTED=true
            break
        fi
    done
    
    if [ "$DEVICE_SUPPORTED" = true ]; then
        echo -e "${GREEN}${BOLD}✓ DEVICE SUPPORTED!${NC}"
        echo ""
        
        # Determine device name and brand
        case $DEVICE_CODE in
            beyond*) DEVICE_NAME="Samsung Galaxy S10 Series" ;;
            x1s|y2s|z3s) DEVICE_NAME="Samsung Galaxy S20 Series" ;;
            o1s|p3s|t2s) DEVICE_NAME="Samsung Galaxy S21 Series" ;;
            r0s|g0s|b0s) DEVICE_NAME="Samsung Galaxy S22 Series" ;;
            dm*) DEVICE_NAME="Samsung Galaxy S23 Series" ;;
            sunfish) DEVICE_NAME="Google Pixel 4a" ;;
            redfin|bramble) DEVICE_NAME="Google Pixel 5" ;;
            oriole|raven) DEVICE_NAME="Google Pixel 6" ;;
            panther|cheetah) DEVICE_NAME="Google Pixel 7" ;;
            shiba|husky) DEVICE_NAME="Google Pixel 8" ;;
            mojito) DEVICE_NAME="Xiaomi Redmi Note 10" ;;
            alioth) DEVICE_NAME="Xiaomi Poco F3" ;;
            venus|mars) DEVICE_NAME="Xiaomi Mi 11" ;;
            cupid|zeus) DEVICE_NAME="Xiaomi Mi 12" ;;
            fuxi) DEVICE_NAME="Xiaomi 13" ;;
            guacamole) DEVICE_NAME="OnePlus 7 Pro" ;;
            instantnoodle*) DEVICE_NAME="OnePlus 8 Series" ;;
            lemonade*) DEVICE_NAME="OnePlus 9 Pro" ;;
            ovaltine) DEVICE_NAME="OnePlus 10 Pro" ;;
            Spacewar) DEVICE_NAME="Nothing Phone (2)" ;;
            AI2205) DEVICE_NAME="Asus ROG Phone 7" ;;
            borneo) DEVICE_NAME="Motorola Moto G Power" ;;
            pdx234) DEVICE_NAME="Sony Xperia 1 V" ;;
            RMX3708) DEVICE_NAME="Realme GT 3" ;;
            PGEM10) DEVICE_NAME="Oppo Find X6 Pro" ;;
            V2227A) DEVICE_NAME="Vivo X90 Pro" ;;
            PGT-AN10) DEVICE_NAME="Honor Magic 5 Pro" ;;
            NX729J) DEVICE_NAME="Nubia Red Magic 8 Pro" ;;
            A2023P) DEVICE_NAME="ZTE Axon 40 Ultra" ;;
        esac
        
        echo -e "${WHITE}Detected as:${NC}   ${GREEN}$DEVICE_NAME${NC}"
        echo -e "${WHITE}Status:${NC}        ${GREEN}Ready to root${NC}"
        echo ""
        
        echo -e "${CYAN}Available Features:${NC}"
        echo -e "  ${GREEN}✓${NC} One-click root"
        echo -e "  ${GREEN}✓${NC} Custom recovery support"
        echo -e "  ${GREEN}✓${NC} Magisk installation"
        echo -e "  ${GREEN}✓${NC} Custom ROM flashing"
        echo -e "  ${GREEN}✓${NC} Kernel management"
        echo ""
        
        echo -e "${YELLOW}Next Steps:${NC}"
        echo -e "  1. Use option ${GREEN}1${NC} for automatic rooting"
        echo -e "  2. Or option ${GREEN}4${NC} for manual rooting"
        
    else
        echo -e "${RED}${BOLD}✗ DEVICE NOT SUPPORTED${NC}"
        echo ""
        echo -e "${YELLOW}Your device ($DEVICE_CODE) is not currently supported.${NC}"
        echo ""
        echo -e "${CYAN}Supported Brands (14):${NC}"
        echo -e "  • Samsung (5 models)"
        echo -e "  • Google Pixel (5 models)"
        echo -e "  • Xiaomi (5 models)"
        echo -e "  • OnePlus (4 models)"
        echo -e "  • Sony, Realme, Oppo, Vivo, Honor, Nubia, ZTE"
        echo -e "  • Nothing, Asus, Motorola"
        echo ""
        echo -e "${YELLOW}Total: 29 devices supported${NC}"
        echo ""
        echo -e "${CYAN}Want your device added?${NC}"
        echo -e "  Visit: ${BLUE}https://github.com/n3xion3301/n3xionroot/issues${NC}"
    fi
}

show_all_supported() {
    echo ""
    echo -e "${CYAN}${BOLD}All Supported Devices (29):${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    echo -e "${PURPLE}Samsung (5):${NC}"
    echo "  • Galaxy S10/S10+/S10e"
    echo "  • Galaxy S20/S20+/S20 Ultra"
    echo "  • Galaxy S21/S21+/S21 Ultra"
    echo "  • Galaxy S22/S22+/S22 Ultra"
    echo "  • Galaxy S23/S23+/S23 Ultra"
    echo ""
    
    echo -e "${PURPLE}Google Pixel (5):${NC}"
    echo "  • Pixel 4a"
    echo "  • Pixel 5/5a"
    echo "  • Pixel 6/6 Pro"
    echo "  • Pixel 7/7 Pro"
    echo "  • Pixel 8/8 Pro"
    echo ""
    
    echo -e "${PURPLE}Xiaomi (5):${NC}"
    echo "  • Redmi Note 10"
    echo "  • Poco F3"
    echo "  • Mi 11/11 Pro"
    echo "  • Mi 12/12 Pro"
    echo "  • Mi 13"
    echo ""
    
    echo -e "${PURPLE}OnePlus (4):${NC}"
    echo "  • OnePlus 7 Pro"
    echo "  • OnePlus 8/8 Pro"
    echo "  • OnePlus 9 Pro"
    echo "  • OnePlus 10 Pro"
    echo ""
    
    echo -e "${PURPLE}Others (10):${NC}"
    echo "  • Nothing Phone (2)"
    echo "  • Asus ROG Phone 7"
    echo "  • Motorola Moto G Power"
    echo "  • Sony Xperia 1 V"
    echo "  • Realme GT 3"
    echo "  • Oppo Find X6 Pro"
    echo "  • Vivo X90 Pro"
    echo "  • Honor Magic 5 Pro"
    echo "  • Nubia Red Magic 8 Pro"
    echo "  • ZTE Axon 40 Ultra"
}

main() {
    check_adb
    get_device_info
    check_compatibility
    
    echo ""
    read -p "Show all supported devices? (y/n): " SHOW_ALL
    if [ "$SHOW_ALL" = "y" ] || [ "$SHOW_ALL" = "Y" ]; then
        show_all_supported
    fi
}

main
