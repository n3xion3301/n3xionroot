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
        echo -e "${RED}[!]${NC} ADB not found. Install Android platform-tools"
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
        # Samsung
        "beyond1lte"|"beyond0lte"|"beyond2lte")
            EXPLOIT_PATH="../exploits/samsung/galaxy_s10/root.sh"
            DEVICE_NAME="Samsung Galaxy S10"
            ;;
        # Google
        "sunfish")
            EXPLOIT_PATH="../exploits/google/pixel_4a/root.sh"
            DEVICE_NAME="Google Pixel 4a"
            ;;
        # OnePlus
        "guacamole")
            EXPLOIT_PATH="../exploits/oneplus/oneplus_7_pro/root.sh"
            DEVICE_NAME="OnePlus 7 Pro"
            ;;
        # Xiaomi
        "mojito")
            EXPLOIT_PATH="../exploits/xiaomi/redmi_note_10/root.sh"
            DEVICE_NAME="Xiaomi Redmi Note 10"
            ;;
        # Motorola
        "sofia")
            EXPLOIT_PATH="../exploits/motorola/moto_g_power/root.sh"
            DEVICE_NAME="Motorola Moto G Power"
            ;;
        *)
            echo -e "${RED}[!]${NC} Device not supported: $DEVICE_CODE"
            echo "    Supported devices:"
            echo "      - Samsung Galaxy S10 series"
            echo "      - Google Pixel 4a"
            echo "      - OnePlus 7 Pro"
            echo "      - Xiaomi Redmi Note 10"
            echo "      - Motorola Moto G Power"
            echo ""
            echo "    See docs/supported-devices.md for full list"
            exit 1
            ;;
    esac
    
    echo -e "${GREEN}[✓]${NC} Device supported: $DEVICE_NAME"
}

run_exploit() {
    if [ ! -f "$EXPLOIT_PATH" ]; then
        echo -e "${RED}[!]${NC} Exploit script not found: $EXPLOIT_PATH"
        exit 1
    fi
    
    echo -e "${YELLOW}[*]${NC} Launching device-specific rooting script..."
    echo ""
    bash "$EXPLOIT_PATH"
}

preflight_checks() {
    echo -e "${YELLOW}[*]${NC} Running pre-flight checks..."
    
    if ! command -v fastboot &> /dev/null; then
        echo -e "${RED}[!]${NC} Fastboot not found"
        exit 1
    fi
    
    BATTERY=$(adb shell dumpsys battery | grep level | awk '{print $2}')
    if [ "$BATTERY" -lt 50 ]; then
        echo -e "${YELLOW}[!]${NC} Battery low: ${BATTERY}% (recommend >50%)"
        read -p "Continue anyway? (yes/no): " CONTINUE
        if [ "$CONTINUE" != "yes" ]; then
            exit 0
        fi
    fi
    
    echo -e "${GREEN}[✓]${NC} Pre-flight checks passed"
    echo ""
}

main() {
    detect_device
    preflight_checks
    check_support
    
    echo -e "${YELLOW}=========================================${NC}"
    echo -e "${RED}WARNING:${NC}"
    echo "  - This will void your warranty"
    echo "  - Backup your data first"
    echo "  - Ensure battery is >50%"
    echo "  - Process may take 10-30 minutes"
    echo -e "${YELLOW}=========================================${NC}"
    echo ""
    
    read -p "Proceed with rooting? (yes/no): " CONFIRM
    if [ "$CONFIRM" != "yes" ]; then
        echo "Aborted."
        exit 0
    fi
    
    run_exploit
}

main
