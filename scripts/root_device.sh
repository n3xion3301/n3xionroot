#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "========================================="
echo "       n3xionroot - Universal Root"
echo "========================================="
echo ""

detect_device() {
    echo -e "${YELLOW}[*]${NC} Detecting device..."
    
    if ! command -v adb &> /dev/null; then
        echo -e "${RED}[!]${NC} ADB not found"
        exit 1
    fi
    
    DEVICE_MODEL=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
    DEVICE_CODE=$(adb shell getprop ro.product.device 2>/dev/null | tr -d '\r')
    ANDROID_VER=$(adb shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')
    
    if [ -z "$DEVICE_MODEL" ]; then
        echo -e "${RED}[!]${NC} No device detected"
        exit 1
    fi
    
    echo -e "${GREEN}[✓]${NC} Device detected:"
    echo "    Model: $DEVICE_MODEL"
    echo "    Codename: $DEVICE_CODE"
    echo "    Android: $ANDROID_VER"
    echo ""
}

check_support() {
    case "$DEVICE_CODE" in
        beyond1lte|beyond0lte|beyond2lte)
            EXPLOIT_PATH="../exploits/samsung/galaxy_s10/root.sh"
            DEVICE_NAME="Samsung Galaxy S10" ;;
        x1s)
            EXPLOIT_PATH="../exploits/samsung/galaxy_s20/root.sh"
            DEVICE_NAME="Samsung Galaxy S20" ;;
        o1s)
            EXPLOIT_PATH="../exploits/samsung/galaxy_s21/root.sh"
            DEVICE_NAME="Samsung Galaxy S21" ;;
        r0s)
            EXPLOIT_PATH="../exploits/samsung/galaxy_s22/root.sh"
            DEVICE_NAME="Samsung Galaxy S22" ;;
        sunfish)
            EXPLOIT_PATH="../exploits/google/pixel_4a/root.sh"
            DEVICE_NAME="Google Pixel 4a" ;;
        redfin)
            EXPLOIT_PATH="../exploits/google/pixel_5/root.sh"
            DEVICE_NAME="Google Pixel 5" ;;
        oriole)
            EXPLOIT_PATH="../exploits/google/pixel_6/root.sh"
            DEVICE_NAME="Google Pixel 6" ;;
        panther)
            EXPLOIT_PATH="../exploits/google/pixel_7/root.sh"
            DEVICE_NAME="Google Pixel 7" ;;
        mojito)
            EXPLOIT_PATH="../exploits/xiaomi/redmi_note_10/root.sh"
            DEVICE_NAME="Xiaomi Redmi Note 10" ;;
        alioth)
            EXPLOIT_PATH="../exploits/xiaomi/poco_f3/root.sh"
            DEVICE_NAME="Xiaomi Poco F3" ;;
        venus)
            EXPLOIT_PATH="../exploits/xiaomi/mi_11/root.sh"
            DEVICE_NAME="Xiaomi Mi 11" ;;
        cupid)
            EXPLOIT_PATH="../exploits/xiaomi/mi_12/root.sh"
            DEVICE_NAME="Xiaomi Mi 12" ;;
        guacamole)
            EXPLOIT_PATH="../exploits/oneplus/oneplus_7_pro/root.sh"
            DEVICE_NAME="OnePlus 7 Pro" ;;
        instantnoodle)
            EXPLOIT_PATH="../exploits/oneplus/oneplus_8/root.sh"
            DEVICE_NAME="OnePlus 8" ;;
        lemonadep)
            EXPLOIT_PATH="../exploits/oneplus/oneplus_9_pro/root.sh"
            DEVICE_NAME="OnePlus 9 Pro" ;;
        sofia)
            EXPLOIT_PATH="../exploits/motorola/moto_g_power/root.sh"
            DEVICE_NAME="Motorola Moto G Power" ;;
        *)
            echo -e "${RED}[!]${NC} Device not supported: $DEVICE_CODE"
            echo "    Supported devices (16 total):"
            echo "      Samsung: S10, S20, S21, S22"
            echo "      Google Pixel: 4a, 5, 6, 7"
            echo "      Xiaomi: Redmi Note 10, Poco F3, Mi 11, Mi 12"
            echo "      OnePlus: 7 Pro, 8, 9 Pro"
            echo "      Motorola: Moto G Power"
            exit 1 ;;
    esac
    
    echo -e "${GREEN}[✓]${NC} Device supported: $DEVICE_NAME"
}

run_exploit() {
    if [ ! -f "$EXPLOIT_PATH" ]; then
        echo -e "${RED}[!]${NC} Exploit script not found"
        exit 1
    fi
    echo -e "${YELLOW}[*]${NC} Launching rooting script..."
    bash "$EXPLOIT_PATH"
}

preflight_checks() {
    echo -e "${YELLOW}[*]${NC} Pre-flight checks..."
    if ! command -v fastboot &> /dev/null; then
        echo -e "${RED}[!]${NC} Fastboot not found"
        exit 1
    fi
    BATTERY=$(adb shell dumpsys battery | grep level | awk '{print $2}')
    if [ "$BATTERY" -lt 50 ]; then
        echo -e "${YELLOW}[!]${NC} Battery: ${BATTERY}% (recommend >50%)"
        read -p "Continue? (yes/no): " CONTINUE
        if [ "$CONTINUE" != "yes" ]; then exit 0; fi
    fi
    echo -e "${GREEN}[✓]${NC} Checks passed"
}

main() {
    detect_device
    preflight_checks
    check_support
    echo -e "${YELLOW}=========================================${NC}"
    echo -e "${RED}WARNING: Warranty void, data may be lost${NC}"
    echo -e "${YELLOW}=========================================${NC}"
    read -p "Proceed? (yes/no): " CONFIRM
    if [ "$CONFIRM" != "yes" ]; then exit 0; fi
    run_exploit
}

main
