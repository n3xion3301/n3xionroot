#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "========================================="
echo "    n3xionroot - OTA Update Unblock"
echo "========================================="
echo ""

check_root() {
    echo -e "${YELLOW}[*]${NC} Checking root access..."
    ROOT_CHECK=$(adb shell su -c "echo rooted" 2>/dev/null | tr -d '\r')
    
    if [ "$ROOT_CHECK" != "rooted" ]; then
        echo -e "${RED}[!]${NC} Root access required"
        exit 1
    fi
    echo -e "${GREEN}[✓]${NC} Root access confirmed"
}

restore_hosts() {
    echo -e "${YELLOW}[*]${NC} Restoring original hosts file..."
    
    adb shell su -c "mount -o rw,remount /system"
    adb shell su -c "[ -f /system/etc/hosts.backup ] && cp /system/etc/hosts.backup /system/etc/hosts"
    adb shell su -c "mount -o ro,remount /system"
    
    echo -e "${GREEN}[✓]${NC} Hosts file restored"
}

enable_packages() {
    echo -e "${YELLOW}[*]${NC} Re-enabling update packages..."
    
    PACKAGES=(
        "com.android.vending"
        "com.google.android.gms"
        "com.google.android.gsf"
        "com.wssyncmldm"
        "com.ws.dm"
        "com.samsung.android.app.omcagent"
        "com.sec.android.soagent"
        "com.android.updater"
        "com.xiaomi.updater"
        "com.oneplus.ota"
    )
    
    for pkg in "${PACKAGES[@]}"; do
        adb shell su -c "pm enable $pkg" 2>/dev/null
        echo "    Enabled: $pkg"
    done
}

remove_dummy_files() {
    echo -e "${YELLOW}[*]${NC} Removing dummy OTA files..."
    adb shell su -c "rm -rf /data/ota_package" 2>/dev/null
    echo -e "${GREEN}[✓]${NC} Dummy files removed"
}

main() {
    echo -e "${YELLOW}=========================================${NC}"
    echo "This will re-enable OTA system updates"
    echo -e "${YELLOW}=========================================${NC}"
    echo ""
    
    read -p "Continue? (yes/no): " CONFIRM
    if [ "$CONFIRM" != "yes" ]; then
        exit 0
    fi
    
    check_root
    restore_hosts
    enable_packages
    remove_dummy_files
    
    echo ""
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}[✓] OTA updates re-enabled!${NC}"
    echo "    Check for updates in Settings"
    echo -e "${GREEN}=========================================${NC}"
}

main
