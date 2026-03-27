# Installation Guide

## Prerequisites

### Required Software
1. **ADB and Fastboot** (Android Platform Tools)
   - Download: https://developer.android.com/studio/releases/platform-tools
   - Add to PATH

2. **USB Drivers** (Windows only)
   - Samsung: Samsung USB Driver
   - Google: Google USB Driver
   - Universal: Minimal ADB and Fastboot

### Device Preparation
1. **Enable Developer Options**
   - Settings > About Phone
   - Tap "Build Number" 7 times

2. **Enable USB Debugging**
   - Settings > Developer Options
   - Enable "USB Debugging"
   - Enable "OEM Unlocking"

3. **Backup Your Data**
   - All data will be wiped during bootloader unlock
   - Use Google Backup or local backup

## Installation Steps

### Method 1: Automatic (Recommended)
```bash
cd n3xionroot/scripts
./root_device.sh
Method 2: Manual (Device-Specific)


cd n3xionroot/exploits/[manufacturer]/[device]
./root.sh
Insert at cursor

Post-Root Setup



Install Magisk Manager

Download latest from GitHub
Install APK



Verify Root

Open Magisk Manager
Check for "Installed" version



Hide Root (Optional)

Magisk > Settings > Hide Magisk
For banking apps, etc.



Troubleshooting

See [troubleshooting.md](troubleshooting.md)
