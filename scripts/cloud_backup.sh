#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "========================================="
echo "  n3xionroot - Cloud Backup Manager"
echo "========================================="
echo ""

BACKUP_DIR="./backups"
mkdir -p "$BACKUP_DIR"

select_cloud_provider() {
    echo -e "${BLUE}Select cloud storage provider:${NC}"
    echo "  1) Google Drive (rclone)"
    echo "  2) Dropbox (rclone)"
    echo "  3) OneDrive (rclone)"
    echo "  4) Local backup only"
    read -p "Select (1-4): " PROVIDER
    
    case $PROVIDER in
        1) CLOUD="gdrive" ;;
        2) CLOUD="dropbox" ;;
        3) CLOUD="onedrive" ;;
        4) CLOUD="local" ;;
        *) echo -e "${RED}Invalid${NC}"; exit 1 ;;
    esac
}

check_rclone() {
    if [ "$CLOUD" = "local" ]; then
        return
    fi
    
    echo -e "${YELLOW}[*]${NC} Checking rclone..."
    
    if ! command -v rclone &> /dev/null; then
        echo -e "${YELLOW}[!]${NC} rclone not found"
        echo "    Install: curl https://rclone.org/install.sh | sudo bash"
        read -p "Install now? (yes/no): " INSTALL
        
        if [ "$INSTALL" = "yes" ]; then
            curl https://rclone.org/install.sh | sudo bash
        else
            exit 1
        fi
    fi
    
    echo -e "${GREEN}[✓]${NC} rclone found"
}

configure_rclone() {
    if [ "$CLOUD" = "local" ]; then
        return
    fi
    
    echo -e "${YELLOW}[*]${NC} Configuring rclone..."
    
    if ! rclone listremotes | grep -q "$CLOUD"; then
        echo "    Running rclone config..."
        rclone config
    fi
    
    echo -e "${GREEN}[✓]${NC} rclone configured"
}

create_backup() {
    echo -e "${YELLOW}[*]${NC} Creating backup..."
    
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    BACKUP_NAME="n3xion_backup_$TIMESTAMP"
    BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"
    
    mkdir -p "$BACKUP_PATH"
    
    # Backup boot
    echo "  Backing up boot partition..."
    adb shell su -c "dd if=/dev/block/by-name/boot of=/sdcard/boot.img" 2>/dev/null
    adb pull /sdcard/boot.img "$BACKUP_PATH/" 2>/dev/null
    adb shell rm /sdcard/boot.img
    
    # Backup recovery
    echo "  Backing up recovery partition..."
    adb shell su -c "dd if=/dev/block/by-name/recovery of=/sdcard/recovery.img" 2>/dev/null
    adb pull /sdcard/recovery.img "$BACKUP_PATH/" 2>/dev/null
    adb shell rm /sdcard/recovery.img
    
    # Create archive
    echo "  Creating archive..."
    tar -czf "$BACKUP_PATH.tar.gz" -C "$BACKUP_DIR" "$BACKUP_NAME"
    rm -rf "$BACKUP_PATH"
    
    echo -e "${GREEN}[✓]${NC} Backup created: $BACKUP_PATH.tar.gz"
}

upload_backup() {
    if [ "$CLOUD" = "local" ]; then
        echo -e "${GREEN}[✓]${NC} Local backup complete"
        return
    fi
    
    echo -e "${YELLOW}[*]${NC} Uploading to $CLOUD..."
    
    rclone copy "$BACKUP_PATH.tar.gz" "$CLOUD:n3xionroot_backups/"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[✓]${NC} Uploaded to cloud"
        read -p "Delete local backup? (yes/no): " DELETE
        if [ "$DELETE" = "yes" ]; then
            rm "$BACKUP_PATH.tar.gz"
        fi
    else
        echo -e "${RED}[!]${NC} Upload failed"
    fi
}

main() {
    select_cloud_provider
    check_rclone
    configure_rclone
    create_backup
    upload_backup
    
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}Backup Complete!${NC}"
    echo -e "${GREEN}=========================================${NC}"
}

main
