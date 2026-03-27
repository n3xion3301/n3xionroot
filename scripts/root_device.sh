#!/bin/bash

# n3xionroot - Universal Device Rooting Script
# Detects device and runs appropriate rooting method

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "       n3xionroot - Universal Root"
echo "========================================="
echo ""

# Detect connected device
detect_device() {
    echo -e "${YELLOW}[*]${NC} Detecting device..."
    
    if ! command -v adb &> /dev/null; then
        echo -e "${RED}[!]${NC} ADB not found. Please install Android platform-tools"
        exit 1
    fi
    
    DEVICE_MODEL=$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')
    DEVICE_CODE=$(adb shell getprop ro.product.device 2>/dev/null | tr -d '\r')
    ANDROID_VER=$(adb shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')
    
    if [ -z "$DEVICE_MODEL" ]; then
        echo -e "${RED}[!]${NC} No device detected"
        echo "    - Enable USB debugging"
        echo "    - Authorize computer on device"
        exit 1
    fi
    
    echo -e "${GREEN}[✓]${NC} Device detected:"
    echo "    Model: $DEVICE_MODEL"
    echo "    Codename: $DEVICE_CODE"
    echo "    Android: $ANDROID_VER"
    echo ""
}

# Check if device is supported
check_support() {
    case "$DEVICE_CODE" in
        "beyond1lte"|"beyond0lte"|"beyond2lte")
            EXPLOIT_PATH="../exploits/samsung/galaxy_s10/root.sh"
            DEVICE_NAME="Samsung Galaxy S10"
            ;;
        "sunfish")
            EXPLOIT_PATH="../exploits/google/pixel_4a/root.sh"
            DEVICE_NAME="Google Pixel 4a"
            ;;
        "guacamole")
            EXPLOIT_PATH="../exploits/oneplus/oneplus_7_pro/root.sh"
            DEVICE_NAME="OnePlus 7 Pro"
            ;;
        *)
            echo -e "${RED}[!]${NC} Device not supported: $DEVICE_CODE"
            echo "    Supported devices: See docs/supported-devices.md"
            exit 1
            ;;
    esac
    
    echo -e "${GREEN}[✓]${NC} Device supported: $DEVICE_NAME"
}

# Run device-specific script
run_exploit() {
    if [ ! -f "$EXPLOIT_PATH" ]; then
        echo -e "${RED}[!]${NC} Exploit script not found: $EXPLOIT_PATH"
        exit 1
    fi
    
    echo -e "${YELLOW}[*]${NC} Launching device-specific rooting script..."
    echo ""
    bash "$EXPLOIT_PATH"
}

# Pre-flight checks
preflight_checks() {
    echo -e "${YELLOW}[*]${NC} Running pre-flight checks..."
    
    # Check for fastboot
    if ! command -v fastboot &> /dev/null; then
        echo -e "${RED}[!]${NC} Fastboot not found"
        exit 1
    fi
    
    # Check USB debugging
    USB_DEBUG=$(adb shell getprop ro.debuggable 2>/dev/null | tr -d '\r')
    if [ "$USB_DEBUG" != "1" ]; then
        echo -e "${YELLOW}[!]${NC} USB debugging may not be enabled"
    fi
    
    echo -e "${GREEN}[✓]${NC} Pre-flight checks passed"
    echo ""
}

# Main
main() {
    detect_device
    preflight_checks
    check_support
    
    echo -e "${YELLOW}=========================================${NC}"
    echo -e "${RED}WARNING:${NC}"
    echo "  - This will void your warranty"
    echo "  - Backup your data first"
    echo "  - Ensure battery is >50%"
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
