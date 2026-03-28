#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "========================================="
echo "       Unblock OTA Updates"
echo "========================================="
echo ""

check_root() {
    echo -e "${YELLOW}[*]${NC} Checking root..."
    ROOT_CHECK=$(adb shell su -c "echo rooted" 2>/dev/null | tr -d '\r')
    if [ "$ROOT_CHECK" != "rooted" ]; then
        echo -e "${RED}[!]${NC} Root required"
        exit 1
    fi
    echo -e "${GREEN}[✓]${NC} Root access confirmed"
}

unblock_ota() {
    echo -e "${YELLOW}[*]${NC} Unblocking OTA updates..."
    
    # Re-enable update services
    adb shell su -c "pm enable com.google.android.gms/.update.SystemUpdateService" 2>/dev/null
    adb shell su -c "pm enable com.google.android.gms/.update.SystemUpdateActivity" 2>/dev/null
    adb shell su -c "pm enable com.android.vending" 2>/dev/null
    
    # Remove hosts entries
    adb shell su -c "sed -i '/android.googleapis.com/d' /system/etc/hosts" 2>/dev/null
    adb shell su -c "sed -i '/mtalk.google.com/d' /system/etc/hosts" 2>/dev/null
    
    echo -e "${GREEN}[✓]${NC} OTA updates unblocked"
    echo -e "${YELLOW}[!]${NC} Reboot recommended"
}

main() {
    check_root
    unblock_ota
}

main
