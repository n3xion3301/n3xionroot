<div align="center">

# 🔓 n3xionroot

### Professional Android Rooting Toolkit

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Devices](https://img.shields.io/badge/Devices-12-blue.svg)](#supported-devices)
[![Features](https://img.shields.io/badge/Features-20-green.svg)](#features)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey.svg)](#installation)

**The most comprehensive, user-friendly Android rooting solution**

[Features](#features) • [Supported Devices](#supported-devices) • [Installation](#installation) • [Usage](#usage) • [Documentation](#documentation)

</div>

---

## 📱 What is n3xionroot?

n3xionroot is a complete, automated Android rooting toolkit that makes rooting your device as simple as running a single command. With support for 12 popular devices and 20+ powerful features, it's the ultimate solution for Android enthusiasts, developers, and power users.

### ✨ Why Choose n3xionroot?

- 🚀 **One-Click Rooting** - Auto-detect your device and root with a single command
- 🛡️ **Safety First** - Automatic backups before any modifications
- ☁️ **Cloud Integration** - Backup to Google Drive, Dropbox, or OneDrive
- 🎨 **Smart ROM Recommendations** - Get personalized ROM suggestions
- 🔧 **Auto TWRP Installation** - Automatically downloads and installs the correct recovery
- 📦 **Complete Toolkit** - Everything you need in one place
- 🎯 **Beginner Friendly** - Clear menus and step-by-step guidance
- 💻 **Cross-Platform** - Works on Linux, macOS, and Windows

---

## 🎯 Features

### Core Features
- ✅ **On-The-Go Root** - Automatic device detection and rooting
- ✅ **Manual Root** - Device-specific rooting scripts
- ✅ **Complete Unroot** - Safely remove root access
- ✅ **Root Verification** - Check root status and Magisk version

### System Tools
- 💾 **Device Backup** - Backup boot, recovery, and system partitions
- ☁️ **Cloud Backup Manager** - Sync backups to cloud storage
- 🔄 **Custom ROM Flasher** - Flash custom ROMs with ease
- 💡 **ROM Recommender** - Get personalized ROM suggestions
- ⚙️ **Kernel Manager** - Manage and flash custom kernels
- 📦 **Magisk Module Manager** - Install and manage Magisk modules

### Downloads & Installation
- 📥 **Recovery Downloader** - Download TWRP, OrangeFox, LineageOS Recovery
- 🔨 **Auto TWRP Installer** - One-click TWRP installation
- 📥 **Firmware Downloader** - Download stock firmware for all manufacturers
- 🔧 **ADB/Fastboot Installer** - Automatic platform-tools installation

### Advanced Features
- 🚫 **OTA Control** - Block or unblock system updates
- 🛡️ **SafetyNet Fix** - Pass SafetyNet checks (4 methods included)
- 📚 **Complete Documentation** - Guides, troubleshooting, and FAQs

---

## 📱 Supported Devices

### Samsung (3 devices)
- Galaxy S10 (beyond1lte/beyond0lte/beyond2lte)
- Galaxy S20 (x1s)
- Galaxy S21 (o1s)

### Google Pixel (3 devices)
- Pixel 4a (sunfish)
- Pixel 5 (redfin)
- Pixel 6 (oriole)

### Xiaomi (3 devices)
- Redmi Note 10 (mojito)
- Poco F3 (alioth)
- Mi 11 (venus)

### OnePlus (2 devices)
- 7 Pro (guacamole)
- 8 (instantnoodle)

### Motorola (1 device)
- Moto G Power (sofia)

**Total: 12 devices supported** | [Request a device](../../issues/new)

---

## 🚀 Installation

### Prerequisites
- USB cable
- USB Debugging enabled on your device
- Unlocked bootloader (for most devices)
- 50%+ battery charge

### Quick Install

#### Linux / macOS
```bash
# Clone the repository
git clone https://github.com/n3xion3301/n3xionroot.git

# Navigate to directory
cd n3xionroot

# Make executable
chmod +x n3xionroot.sh

# Run the toolkit
./n3xionroot.sh

Windows


# Clone the repository
git clone https://github.com/n3xion3301/n3xionroot.git

# Navigate to directory
cd n3xionroot

# Run the toolkit
bash n3xionroot.sh

Install ADB/Fastboot (if not installed)


# Run from the main menu
./n3xionroot.sh
# Select option 16: Install ADB/Fastboot

📖 Usage

Quick Start - On-The-Go Root



Connect your device via USB

Enable USB Debugging (Settings > Developer Options)

Run n3xionroot

./n3xionroot.sh
Insert at cursor



Select Option 1 - On-The-Go Root

Follow the prompts - The script will auto-detect and root your device

Manual Root

For more control over the rooting process:

./n3xionroot.sh
# Select option 3: Root Device (Manual)

Backup Before Rooting

Always backup your device first:

./n3xionroot.sh
# Select option 6: Backup Device
# Or option 7: Cloud Backup Manager
Insert at cursor

Install TWRP Recovery


./n3xionroot.sh
# Select option 14: Auto Install TWRP
Insert at cursor

Get ROM Recommendations


./n3xionroot.sh
# Select option 9: ROM Recommender

📚 Documentation

Guides


[Installation Guide](docs/installation-guide.md)
[Supported Devices](docs/supported-devices.md)
[Troubleshooting](docs/troubleshooting.md)
[FAQ](docs/faq.md)

Device-Specific Guides

Each device has its own README in the exploits/ directory:

[Samsung Galaxy S10](exploits/samsung/galaxy_s10/README.md)
[Google Pixel 4a](exploits/google/pixel_4a/README.md)
[Xiaomi Redmi Note 10](exploits/xiaomi/redmi_note_10/README.md)
[OnePlus 7 Pro](exploits/oneplus/oneplus_7_pro/README.md)
And more...

⚠️ Disclaimer

IMPORTANT: READ BEFORE USING
Rooting your Android device:


❌ VOIDS YOUR WARRANTY


❌ May BRICK YOUR DEVICE if done incorrectly

❌ Can cause DATA LOSS


❌ May violate terms of service with your carrier

❌ Can prevent OTA updates

❌ May break banking apps and SafetyNet

YOU are choosing to make these modifications. The authors and contributors are NOT responsible for:

Bricked devices
Data loss
Warranty void
Any other damage or issues

Use at your own risk. Always backup your data first.

🛠️ Advanced Usage

Command-Line Options

On-The-Go Root with Options


cd scripts
./otg_root.sh --auto          # Skip prompts
./otg_root.sh --skip-backup   # Skip backup step
./otg_root.sh --quick         # Fast mode

Direct Script Execution


# Root specific device
cd scripts
./root_device.sh

# Download recovery
./download_recovery.sh

# Install SafetyNet fix
./install_safetynet_fix.sh

🤝 Contributing

Contributions are welcome! Here's how you can help:


Add Device Support - Submit device-specific root scripts

Report Bugs - Open an issue with details

Suggest Features - Share your ideas

Improve Documentation - Fix typos, add guides

Share - Star the repo and tell others

How to Contribute


Fork the repository
Create your feature branch (git checkout -b feature/AmazingFeature)
Commit your changes (git commit -m 'Add some AmazingFeature')
Push to the branch (git push origin feature/AmazingFeature)
Open a Pull Request

📊 Project Stats



Total Scripts: 16+

Supported Devices: 12

Menu Options: 20

Lines of Code: 2,500+

License: MIT

Platform: Cross-platform (Linux, macOS, Windows)

🔗 Resources

Official Links


[GitHub Repository](https://github.com/n3xion3301/n3xionroot)
[Issue Tracker](https://github.com/n3xion3301/n3xionroot/issues)
[Discussions](https://github.com/n3xion3301/n3xionroot/discussions)

External Resources


[XDA Developers](https://forum.xda-developers.com)
[Magisk](https://github.com/topjohnwu/Magisk)
[TWRP](https://twrp.me)
[LineageOS](https://lineageos.org)

📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
MIT License

Copyright (c) 2024 n3xion3301

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

🙏 Acknowledgments



Magisk - The universal systemless interface

TWRP Team - Custom recovery development

LineageOS - Custom ROM development

XDA Developers - Android development community

All Contributors - Thank you for your support!

📞 Support

Get Help



📖 [Documentation](docs/)


💬 [Discussions](https://github.com/n3xion3301/n3xionroot/discussions)


🐛 [Report Bug](https://github.com/n3xion3301/n3xionroot/issues/new)


💡 [Request Feature](https://github.com/n3xion3301/n3xionroot/issues/new)

Community


Join the discussion on XDA Developers
Share your experience
Help other users



⭐ Star History

If you find this project useful, please consider giving it a star! ⭐

Made with ❤️ by [n3xion3301](https://github.com/n3xion3301)
[⬆ Back to Top](#-n3xionroot)

