#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "========================================="
echo "     n3xionroot - OTA Update Blocker"
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

detect_manufacturer() {
    MANUFACTURER=$(adb shell getprop ro.product.manufacturer 2>/dev/null | tr -d '\r' | tr '[:upper:]' '[:lower:]')
    echo -e "${YELLOW}[*]${NC} Manufacturer: $MANUFACTURER"
}

block_ota_generic() {
    echo -e "${YELLOW}[*]${NC} Blocking OTA updates (generic method)..."
    
    # Disable OTA update services
    adb shell su -c "pm disable com.google.android.gms/.update.SystemUpdateService"
    adb shell su -c "pm disable com.google.android.gms/.update.SystemUpdateService\$Receiver"
    adb shell su -c "pm disable com.google.android.gms/.update.SystemUpdateService\$SecretCodeReceiver"
    
    # Freeze update apps
    adb shell su -c "pm disable-user --user 0 com.android.vending" 2>/dev/null
    
    echo -e "${GREEN}[✓]${NC} Generic OTA blocking applied"
}

block_ota_samsung() {
    echo -e "${YELLOW}[*]${NC} Blocking Samsung OTA updates..."
    
    # Disable Samsung update services
    adb shell su -c "pm disable com.wssyncmldm"
    adb shell su -c "pm disable com.ws.dm"
    adb shell su -c "pm disable com.samsung.android.app.omcagent"
    adb shell su -c "pm disable com.samsung.sdm.sdmviewer"
    adb shell su -c "pm disable com.samsung.android.sdm.config"
    
    # Freeze FOTA
    adb shell su -c "pm disable com.sec.android.soagent"
    
    echo -e "${GREEN}[✓]${NC} Samsung OTA blocking applied"
}

block_ota_xiaomi() {
    echo -e "${YELLOW}[*]${NC} Blocking Xiaomi/MIUI OTA updates..."
    
    # Disable MIUI updater
    adb shell su -c "pm disable com.android.updater"
    adb shell su -c "pm disable com.xiaomi.updater"
    
    # Disable system update service
    adb shell su -c "pm disable-user --user 0 com.miui.systemAdSolution"
    
    echo -e "${GREEN}[✓]${NC} Xiaomi OTA blocking applied"
}

block_ota_google() {
    echo -e "${YELLOW}[*]${NC} Blocking Google Pixel OTA updates..."
    
    # Disable system updates
    adb shell su -c "pm disable com.google.android.gms/.update.SystemUpdateActivity"
    adb shell su -c "pm disable com.google.android.gms/.update.SystemUpdateService"
    
    echo -e "${GREEN}[✓]${NC} Google OTA blocking applied"
}

block_ota_oneplus() {
    echo -e "${YELLOW}[*]${NC} Blocking OnePlus OTA updates..."
    
    # Disable OnePlus system update
    adb shell su -c "pm disable com.oneplus.opbackup"
    adb shell su -c "pm disable com.oneplus.ota"
    adb shell su -c "pm disable net.oneplus.odm"
    
    echo -e "${GREEN}[✓]${NC} OnePlus OTA blocking applied"
}

freeze_update_packages() {
    echo -e "${YELLOW}[*]${NC} Freezing update-related packages..."
    
    # Common update packages
    PACKAGES=(
        "com.android.vending"
        "com.google.android.gms"
        "com.google.android.gsf"
    )
    
    for pkg in "${PACKAGES[@]}"; do
        adb shell su -c "pm disable-user --user 0 $pkg" 2>/dev/null
        echo "    Frozen: $pkg"
    done
}

create_dummy_ota() {
    echo -e "${YELLOW}[*]${NC} Creating dummy OTA files..."
    
    # Create dummy update files to prevent downloads
    adb shell su -c "mkdir -p /data/ota_package"
    adb shell su -c "touch /data/ota_package/update.zip"
    adb shell su -c "chmod 000 /data/ota_package/update.zip"
    
    echo -e "${GREEN}[✓]${NC} Dummy OTA files created"
}

block_update_urls() {
    echo -e "${YELLOW}[*]${NC} Blocking update URLs via hosts file..."
    
    # Backup original hosts
    adb shell su -c "cp /system/etc/hosts /system/etc/hosts.backup" 2>/dev/null
    
    # Add update server blocks
    cat > /tmp/ota_block_hosts << 'HOSTS'
# OTA Update Blocking
127.0.0.1 android.googleapis.com
127.0.0.1 mtalk.google.com
127.0.0.1 ota.googlezip.net
127.0.0.1 update.googleapis.com
127.0.0.1 fota-cloud-dn.ospserver.net
127.0.0.1 fota-secure-dn.ospserver.net
HOSTS
    
    adb push /tmp/ota_block_hosts /sdcard/
    adb shell su -c "mount -o rw,remount /system"
    adb shell su -c "cat /sdcard/ota_block_hosts >> /system/etc/hosts"
    adb shell su -c "mount -o ro,remount /system"
    
    rm /tmp/ota_block_hosts
    echo -e "${GREEN}[✓]${NC} Update URLs blocked"
}

install_ota_blocker_module() {
    echo -e "${YELLOW}[*]${NC} Installing Magisk OTA blocker module..."
    
    # Check if Magisk is installed
    MAGISK_VER=$(adb shell su -c "magisk -v" 2>/dev/null | tr -d '\r')
    if [ -z "$MAGISK_VER" ]; then
        echo -e "${YELLOW}[!]${NC} Magisk not detected, skipping module"
        return
    fi
    
    echo "    Recommended: Install 'OTA Survival' module from Magisk Manager"
    read -p "Open Magisk Manager to install module? (yes/no): " INSTALL
    
    if [ "$INSTALL" = "yes" ]; then
        adb shell am start -n com.topjohnwu.magisk/.ui.MainActivity
    fi
}

main() {
    echo -e "${YELLOW}=========================================${NC}"
    echo "This will block OTA system updates"
    echo "You can manually update via custom recovery"
    echo -e "${YELLOW}=========================================${NC}"
    echo ""
    
    read -p "Continue? (yes/no): " CONFIRM
    if [ "$CONFIRM" != "yes" ]; then
        exit 0
    fi
    
    check_root
    detect_manufacturer
    
    echo ""
    echo "Select blocking method:"
    echo "  1) Manufacturer-specific (recommended)"
    echo "  2) Generic blocking"
    echo "  3) Aggressive (all methods)"
    read -p "Select option (1-3): " METHOD
    
    case $METHOD in
        1)
            case $MANUFACTURER in
                "samsung")
                    block_ota_samsung
                    ;;
                "xiaomi")
                    block_ota_xiaomi
                    ;;
                "google")
                    block_ota_google
                    ;;
                "oneplus")
                    block_ota_oneplus
                    ;;
                *)
                    echo -e "${YELLOW}[!]${NC} Unknown manufacturer, using generic method"
                    block_ota_generic
                    ;;
            esac
            ;;
        2)
            block_ota_generic
            ;;
        3)
            block_ota_generic
            case $MANUFACTURER in
                "samsung") block_ota_samsung ;;
                "xiaomi") block_ota_xiaomi ;;
                "google") block_ota_google ;;
                "oneplus") block_ota_oneplus ;;
            esac
            freeze_update_packages
            create_dummy_ota
            block_update_urls
            install_ota_blocker_module
            ;;
        *)
            echo -e "${RED}[!]${NC} Invalid option"
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}[✓] OTA updates blocked!${NC}"
    echo ""
    echo "To re-enable updates:"
    echo "  ./unblock_ota.sh"
    echo -e "${GREEN}=========================================${NC}"
}

main
