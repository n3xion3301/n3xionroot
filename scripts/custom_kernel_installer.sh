#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "========================================="
echo "  n3xionroot - Custom Kernel Installer"
echo "========================================="
echo ""

KERNEL_DIR="./kernels"
mkdir -p "$KERNEL_DIR"

detect_device() {
    echo -e "${YELLOW}[*]${NC} Detecting device..."
    DEVICE_CODE=$(adb shell getprop ro.product.device 2>/dev/null | tr -d '\r')
    echo -e "${GREEN}[✓]${NC} Device: $DEVICE_CODE"
}

show_kernel_recommendations() {
    echo -e "\n${BLUE}Popular kernels for your device:${NC}\n"
    
    case $DEVICE_CODE in
        beyond*|x1s|o1s)
            echo "1. ElementalX Kernel"
            echo "   - Battery optimization"
            echo "   - Performance profiles"
            echo ""
            echo "2. Kirisakura Kernel"
            echo "   - Balanced performance"
            echo "   - Custom governors"
            ;;
        sunfish|redfin|oriole)
            echo "1. Kirisakura Kernel"
            echo "   - Pixel optimized"
            echo "   - Performance boost"
            echo ""
            echo "2. Proton Kernel"
            echo "   - Battery life"
            echo "   - Smooth performance"
            ;;
        *)
            echo "Check XDA Forums for your device"
            ;;
    esac
}

flash_kernel() {
    echo -e "\n${YELLOW}[*]${NC} Kernel installation..."
    echo "Place kernel ZIP in: $KERNEL_DIR/"
    read -p "Kernel ZIP filename: " KERNEL_ZIP
    
    if [ ! -f "$KERNEL_DIR/$KERNEL_ZIP" ]; then
        echo -e "${RED}[!]${NC} File not found"
        exit 1
    fi
    
    adb push "$KERNEL_DIR/$KERNEL_ZIP" /sdcard/
    
    echo -e "${YELLOW}[!]${NC} Boot into TWRP and flash: $KERNEL_ZIP"
    read -p "Press Enter when done..."
}

main() {
    detect_device
    show_kernel_recommendations
    flash_kernel
    
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}Kernel Installation Guide Complete!${NC}"
    echo -e "${GREEN}=========================================${NC}"
}

main
