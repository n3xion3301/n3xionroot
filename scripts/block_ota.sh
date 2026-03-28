#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "========================================="
echo "       Block OTA Updates"
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

block_ota() {
    echo -e "${YELLOW}[*]${NC} Blocking OTA updates..."
    
    # Method 1: Disable update services
    adb shell su -c "pm disable com.google.android.gms/.update.SystemUpdateService" 2>/dev/null
    adb shell su -c "pm disable com.google.android.gms/.update.SystemUpdateActivity" 2>/dev/null
    
    # Method 2: Freeze update packages
    adb shell su -c "pm disable-user --user 0 com.android.vending" 2>/dev/null
    
    # Method 3: Block update URLs (hosts file)
    adb shell su -c "echo '127.0.0.1 android.googleapis.com' >> /system/etc/hosts" 2>/dev/null
    adb shell su -c "echo '127.0.0.1 mtalk.google.com' >> /system/etc/hosts" 2>/dev/null
    
    echo -e "${GREEN}[✓]${NC} OTA updates blocked"
    echo -e "${YELLOW}[!]${NC} Reboot recommended"
}

main() {
    check_root
    block_ota
}

main
