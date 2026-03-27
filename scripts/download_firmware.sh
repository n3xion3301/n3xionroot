#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "========================================="
echo "  n3xionroot - Stock Firmware Downloader"
echo "========================================="
echo ""

FIRMWARE_DIR="./firmware"
mkdir -p "$FIRMWARE_DIR"

detect_device() {
    printf "${YELLOW}[*]${NC} Detecting connected device...\n"
    
    if adb devices | grep -q "device$"; then
        DEVICE_CODE=$(adb shell getprop ro.product.device 2>/dev/null | tr -d '\r')
        DEVICE_MODEL=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
        DEVICE_BRAND=$(adb shell getprop ro.product.manufacturer 2>/dev/null | tr -d '\r')
        BUILD_ID=$(adb shell getprop ro.build.id 2>/dev/null | tr -d '\r')
        ANDROID_VER=$(adb shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')
        
        printf "${GREEN}[✓]${NC} Device detected:\n"
        printf "    Brand: $DEVICE_BRAND\n"
        printf "    Model: $DEVICE_MODEL\n"
        printf "    Codename: $DEVICE_CODE\n"
        printf "    Android: $ANDROID_VER\n"
        printf "    Build: $BUILD_ID\n\n"
        AUTO_DETECTED=true
    else
        printf "${YELLOW}[!]${NC} No device connected\n"
        AUTO_DETECTED=false
    fi
}

select_manufacturer() {
    printf "${BLUE}Select manufacturer:${NC}\n"
    printf "  1) Samsung\n"
    printf "  2) Google (Pixel)\n"
    printf "  3) Xiaomi\n"
    printf "  4) OnePlus\n"
    printf "  5) Motorola\n"
    printf "\nSelect option (1-5): "
    read MANUFACTURER_OPTION
    
    case $MANUFACTURER_OPTION in
        1) MANUFACTURER="samsung" ;;
        2) MANUFACTURER="google" ;;
        3) MANUFACTURER="xiaomi" ;;
        4) MANUFACTURER="oneplus" ;;
        5) MANUFACTURER="motorola" ;;
        *)
            printf "${RED}[!]${NC} Invalid option\n"
            exit 1
            ;;
    esac
}

download_samsung_firmware() {
    printf "\n${YELLOW}[*]${NC} Samsung Firmware Download\n\n"
    
    printf "Enter device model (e.g., SM-G973F): "
    read MODEL
    
    printf "Enter CSC/Region code (e.g., DBT for Germany, XAA for USA): "
    read CSC
    
    printf "\n${BLUE}Samsung Firmware Sources:${NC}\n"
    printf "  1) SamFw.com (Recommended)\n"
    printf "  2) Samfrew.com\n"
    printf "  3) Frija Tool (Windows)\n"
    printf "  4) Samloader (Command line)\n"
    
    printf "\nRecommended method: SamFw.com\n"
    printf "  1. Visit: https://samfw.com\n"
    printf "  2. Search for: $MODEL\n"
    printf "  3. Select region: $CSC\n"
    printf "  4. Download latest firmware\n"
    printf "  5. Save to: $FIRMWARE_DIR/\n\n"
    
    printf "Alternative: Use Samloader\n"
    printf "  Install: pip3 install samloader\n"
    printf "  Usage: samloader -m $MODEL -r $CSC download\n\n"
    
    read -p "Open SamFw.com in browser? (yes/no): " OPEN_BROWSER
    
    if [ "$OPEN_BROWSER" = "yes" ]; then
        if command -v xdg-open &> /dev/null; then
            xdg-open "https://samfw.com/search/$MODEL" 2>/dev/null
        elif command -v open &> /dev/null; then
            open "https://samfw.com/search/$MODEL" 2>/dev/null
        else
            printf "Please visit: https://samfw.com/search/$MODEL\n"
        fi
    fi
}

download_google_firmware() {
    printf "\n${YELLOW}[*]${NC} Google Pixel Firmware Download\n\n"
    
    if [ "$AUTO_DETECTED" = true ]; then
        printf "Detected device: $DEVICE_CODE\n"
    else
        printf "Enter device codename (e.g., sunfish, redfin): "
        read DEVICE_CODE
    fi
    
    FACTORY_URL="https://developers.google.com/android/images"
    OTA_URL="https://developers.google.com/android/ota"
    
    printf "\n${BLUE}Google Factory Images:${NC}\n"
    printf "  Factory Images: $FACTORY_URL\n"
    printf "  OTA Images: $OTA_URL\n\n"
    
    printf "Steps:\n"
    printf "  1. Visit: $FACTORY_URL\n"
    printf "  2. Find your device: $DEVICE_CODE\n"
    printf "  3. Download latest image\n"
    printf "  4. Extract to: $FIRMWARE_DIR/\n\n"
    
    printf "Flash commands:\n"
    printf "  cd $FIRMWARE_DIR/[extracted-folder]\n"
    printf "  ./flash-all.sh (Linux/Mac)\n"
    printf "  flash-all.bat (Windows)\n\n"
    
    read -p "Open Google Factory Images page? (yes/no): " OPEN_BROWSER
    
    if [ "$OPEN_BROWSER" = "yes" ]; then
        if command -v xdg-open &> /dev/null; then
            xdg-open "$FACTORY_URL" 2>/dev/null
        elif command -v open &> /dev/null; then
            open "$FACTORY_URL" 2>/dev/null
        else
            printf "Please visit: $FACTORY_URL\n"
        fi
    fi
}

download_xiaomi_firmware() {
    printf "\n${YELLOW}[*]${NC} Xiaomi Firmware Download\n\n"
    
    if [ "$AUTO_DETECTED" = true ]; then
        printf "Detected device: $DEVICE_CODE\n"
    else
        printf "Enter device codename (e.g., mojito, alioth): "
        read DEVICE_CODE
    fi
    
    printf "\n${BLUE}Xiaomi Firmware Sources:${NC}\n"
    printf "  1) Xiaomi Firmware Updater (Recommended)\n"
    printf "  2) Official MIUI Downloads\n"
    printf "  3) XiaomiROM.com\n\n"
    
    XFU_URL="https://xiaomifirmwareupdater.com/archive/miui/$DEVICE_CODE/"
    OFFICIAL_URL="https://c.mi.com/oc/miuidownload/detail?device=$DEVICE_CODE"
    
    printf "Recommended: Xiaomi Firmware Updater\n"
    printf "  URL: $XFU_URL\n"
    printf "  - Select your region (Global/China/India/etc)\n"
    printf "  - Download latest stable or weekly\n"
    printf "  - Save to: $FIRMWARE_DIR/\n\n"
    
    printf "Flash with Mi Flash Tool:\n"
    printf "  1. Download Mi Flash Tool\n"
    printf "  2. Extract firmware ZIP\n"
    printf "  3. Boot device to fastboot mode\n"
    printf "  4. Select firmware folder in Mi Flash\n"
    printf "  5. Click 'flash'\n\n"
    
    read -p "Open Xiaomi Firmware Updater? (yes/no): " OPEN_BROWSER
    
    if [ "$OPEN_BROWSER" = "yes" ]; then
        if command -v xdg-open &> /dev/null; then
            xdg-open "$XFU_URL" 2>/dev/null
        elif command -v open &> /dev/null; then
            open "$XFU_URL" 2>/dev/null
        else
            printf "Please visit: $XFU_URL\n"
        fi
    fi
}

download_oneplus_firmware() {
    printf "\n${YELLOW}[*]${NC} OnePlus Firmware Download\n\n"
    
    printf "Enter device model (e.g., OnePlus 7 Pro): "
    read MODEL
    
    OFFICIAL_URL="https://www.oneplus.com/support/softwareupgrade"
    
    printf "\n${BLUE}OnePlus Firmware Sources:${NC}\n"
    printf "  1) Official OnePlus Downloads\n"
    printf "  2) Oxygen Updater (App)\n"
    printf "  3) MSM Download Tool (Unbrick)\n\n"
    
    printf "Official Downloads:\n"
    printf "  URL: $OFFICIAL_URL\n"
    printf "  - Select your device\n"
    printf "  - Download OxygenOS ROM\n"
    printf "  - Save to: $FIRMWARE_DIR/\n\n"
    
    printf "Flash via Local Upgrade:\n"
    printf "  1. Copy ROM ZIP to device storage\n"
    printf "  2. Settings > System > System Updates\n"
    printf "  3. Tap gear icon > Local upgrade\n"
    printf "  4. Select ROM ZIP\n\n"
    
    printf "MSM Download Tool (Unbrick):\n"
    printf "  - Search XDA for MSM tool for your device\n"
    printf "  - Complete stock restore tool\n"
    printf "  - Use only if device is bricked\n\n"
    
    read -p "Open OnePlus Downloads page? (yes/no): " OPEN_BROWSER
    
    if [ "$OPEN_BROWSER" = "yes" ]; then
        if command -v xdg-open &> /dev/null; then
            xdg-open "$OFFICIAL_URL" 2>/dev/null
        elif command -v open &> /dev/null; then
            open "$OFFICIAL_URL" 2>/dev/null
        else
            printf "Please visit: $OFFICIAL_URL\n"
        fi
    fi
}

download_motorola_firmware() {
    printf "\n${YELLOW}[*]${NC} Motorola Firmware Download\n\n"
    
    printf "Enter device model (e.g., Moto G Power): "
    read MODEL
    
    printf "\n${BLUE}Motorola Firmware Sources:${NC}\n"
    printf "  1) LOLINET Mirrors (Recommended)\n"
    printf "  2) Motorola Firmware\n"
    printf "  3) XDA Forums\n\n"
    
    LOLINET_URL="https://mirrors.lolinet.com/firmware/moto/"
    
    printf "LOLINET Mirrors:\n"
    printf "  URL: $LOLINET_URL\n"
    printf "  - Browse to your device\n"
    printf "  - Download latest firmware\n"
    printf "  - Save to: $FIRMWARE_DIR/\n\n"
    
    printf "Flash with RSD Lite:\n"
    printf "  1. Download RSD Lite\n"
    printf "  2. Extract firmware XML\n"
    printf "  3. Boot device to fastboot\n"
    printf "  4. Load XML in RSD Lite\n"
    printf "  5. Click 'Start'\n\n"
    
    read -p "Open LOLINET Mirrors? (yes/no): " OPEN_BROWSER
    
    if [ "$OPEN_BROWSER" = "yes" ]; then
        if command -v xdg-open &> /dev/null; then
            xdg-open "$LOLINET_URL" 2>/dev/null
        elif command -v open &> /dev/null; then
            open "$LOLINET_URL" 2>/dev/null
        else
            printf "Please visit: $LOLINET_URL\n"
        fi
    fi
}

main() {
    detect_device
    
    if [ "$AUTO_DETECTED" = false ]; then
        select_manufacturer
    else
        MANUFACTURER=$(echo "$DEVICE_BRAND" | tr '[:upper:]' '[:lower:]')
    fi
    
    case $MANUFACTURER in
        samsung)
            download_samsung_firmware
            ;;
        google)
            download_google_firmware
            ;;
        xiaomi)
            download_xiaomi_firmware
            ;;
        oneplus)
            download_oneplus_firmware
            ;;
        motorola)
            download_motorola_firmware
            ;;
        *)
            printf "${RED}[!]${NC} Unsupported manufacturer: $MANUFACTURER\n"
            printf "    Search XDA Developers for your device firmware\n"
            ;;
    esac
    
    printf "\n${GREEN}=========================================${NC}\n"
    printf "${GREEN}Firmware download guide complete!${NC}\n"
    printf "Save firmware to: $FIRMWARE_DIR/\n"
    printf "${GREEN}=========================================${NC}\n"
}

main
