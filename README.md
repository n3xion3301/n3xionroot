# n3xionroot

🚀 **Android Rooting Toolkit** - Automated rooting solution for multiple Android devices

[![License](https://img.shields.io/badge/license-Private-red.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Android-green.svg)](https://www.android.com/)
[![Root](https://img.shields.io/badge/root-Magisk-blue.svg)](https://github.com/topjohnwu/Magisk)

## ⚠️ DISCLAIMER

**READ THIS BEFORE PROCEEDING:**

- ❌ Rooting **VOIDS YOUR WARRANTY**
- ❌ May **BRICK YOUR DEVICE** if done incorrectly
- ❌ Can cause **DATA LOSS**
- ✅ Use at your **OWN RISK**
- ✅ For **EDUCATIONAL PURPOSES** only
- ✅ **BACKUP YOUR DATA** before proceeding

## 📱 Supported Devices

| Manufacturer | Device | Codename | Status |
|-------------|--------|----------|--------|
| Samsung | Galaxy S10 | beyond1lte | ✅ Tested |
| Google | Pixel 4a | sunfish | ✅ Tested |
| Xiaomi | Redmi Note 10 | mojito | ✅ Tested |
| OnePlus | 7 Pro | guacamole | ⚠️ Beta |
| Motorola | Moto G Power | sofia | ⚠️ Beta |

**Legend:**
- ✅ Tested - Fully working
- ⚠️ Beta - Works but needs testing
- 🚧 WIP - Work in progress

See [docs/supported-devices.md](docs/supported-devices.md) for full list.

## ✨ Features

### 🎯 Quick Actions
- **On-The-Go Root** - Auto-detect device and root in one command
- **Device Info** - View detailed device information
- **Root Verification** - Check root status

### 🔧 Root Management
- **Root Device** - Manual rooting with device-specific scripts
- **Unroot Device** - Complete unroot with multiple methods
- **Backup/Restore** - Critical partition backup

### 🛠️ Advanced Tools
- **Custom ROM Flasher** - Flash LineageOS, Pixel Experience, etc.
- **Kernel Manager** - Flash and manage custom kernels
- **Magisk Modules** - Install and manage Magisk modules
- **OTA Blocker** - Block/unblock system updates

## 🚀 Quick Start

### Prerequisites

1. **Android Platform Tools** (ADB & Fastboot)
   ```bash
   # Download from:
   # https://developer.android.com/studio/releases/platform-tools

USB Drivers (Windows only)

Samsung: Samsung USB Driver
Google: Google USB Driver
Universal: Minimal ADB and Fastboot



Device Preparation

Enable Developer Options (tap Build Number 7 times)
Enable USB Debugging
Enable OEM Unlocking



Installation


# Clone repository
git clone https://github.com/n3xion3301/n3xionroot.git
cd n3xionroot

# Make scripts executable
chmod +x n3xionroot.sh
chmod +x scripts/*.sh

# Run main menu
./n3xionroot.sh

One-Command Root (Fastest)


# Auto-detect and root
cd scripts
./otg_root.sh

# Quick mode (no prompts, no backup)
./otg_root.sh --quick

# Auto mode with backup
./otg_root.sh --auto

📖 Usage

Interactive Menu


./n3xionroot.sh
Insert at cursor

This launches the interactive menu with all features.
Manual Device Root


# Universal auto-detection
cd scripts
./root_device.sh

# Device-specific
cd exploits/samsung/galaxy_s10
./root.sh

Backup Device


cd scripts
./backup_device.sh

# Options:
# 1) Quick - Boot + Recovery
# 2) Standard - Boot + Recovery + EFS
# 3) Full - All partitions + app data
Insert at cursor

Unroot Device


cd scripts
./unroot_device.sh

# Includes:
# - Magisk uninstall
# - Stock boot restore
# - Factory reset option
# - Bootloader relock option
Insert at cursor

Block OTA Updates
cd scripts
./block_ota.sh

# Methods:
# 1) Manufacturer-specific
# 2) Generic blocking
# 3) Aggressive (all methods)

Flash Custom ROM


cd scripts
./flash_rom.sh

# Supports:
# - LineageOS
# - Pixel Experience
# - Paranoid Android
# - Evolution X
# - crDroid
# - Custom ROMs
Insert at cursor

Kernel Manager


cd scripts
./kernel_manager.sh

# Features:
# - Backup current kernel
# - Flash custom kernel
# - Restore stock kernel
# - Kernel tweaks (CPU, GPU, I/O)

Magisk Modules


cd scripts
./magisk_modules.sh

# Options:
# - List installed modules
# - Install new module
# - Remove module
# - Enable/disable module
Insert at cursor


📁 Project Structure


n3xionroot/
├── n3xionroot.sh          # Main menu launcher
├── README.md              # This file
├── LICENSE                # License file
├── docs/                  # Documentation
│   ├── supported-devices.md
│   ├── installation-guide.md
│   └── troubleshooting.md
├── scripts/               # Main scripts
│   ├── otg_root.sh       # On-the-go root
│   ├── root_device.sh    # Universal root
│   ├── unroot_device.sh  # Unroot tool
│   ├── backup_device.sh  # Backup utility
│   ├── block_ota.sh      # OTA blocker
│   ├── unblock_ota.sh    # OTA unblocker
│   ├── flash_rom.sh      # ROM flasher
│   ├── kernel_manager.sh # Kernel manager
│   └── magisk_modules.sh # Module manager
├── exploits/              # Device-specific exploits
│   ├── samsung/
│   ├── google/
│   ├── xiaomi/
│   ├── oneplus/
│   └── motorola/
├── tools/                 # Required binaries
├── recovery/              # Custom recovery images
└── backups/               # Backup storage
Insert at cursor


🔒 Safety & Security

Before Rooting



✅ Backup all data (photos, contacts, apps)

✅ Charge battery to at least 70%

✅ Download stock firmware for your device

✅ Read device-specific guide in exploits folder

✅ Understand the risks


Critical Backups

The backup script saves these critical partitions:


boot - Kernel and ramdisk

recovery - Recovery partition

EFS - IMEI and baseband (CRITICAL!)

persist - Device-specific data

⚠️ NEVER LOSE YOUR EFS BACKUP! It contains your IMEI.

🆘 Troubleshooting

Device Not Detected


# Check ADB connection
adb devices

# Restart ADB server
adb kill-server
adb start-server

# Check USB debugging is enabled
# Check device is authorized
Insert at cursor

Bootloop After Root


# Boot to recovery
# Factory reset
# Or flash stock firmware
Insert at cursor

Lost Root After Update


# Re-patch boot image with Magisk
# Or re-run root script
Insert at cursor

See [docs/troubleshooting.md](docs/troubleshooting.md) for detailed solutions.

🤝 Contributing

Want to add support for your device? See [CONTRIBUTING.md](CONTRIBUTING.md)
Requirements:

Unlockable bootloader
Available custom recovery OR extractable boot.img
Documented root method
Testing on actual device


📚 Resources



XDA Developers: https://forum.xda-developers.com


Magisk: https://github.com/topjohnwu/Magisk


TWRP: https://twrp.me


LineageOS: https://lineageos.org



⚖️ License

This project is private and for educational purposes only.
All rights reserved.

🙏 Credits



Magisk - topjohnwu

TWRP - Team Win Recovery Project

XDA Community - Device-specific guides

Contributors - See CONTRIBUTORS.md


📞 Support

For issues and questions:

Check [docs/troubleshooting.md](docs/troubleshooting.md)

Search XDA Developers forum
Create an issue on GitHub


Remember: With great power comes great responsibility. Root wisely! 🚀
