# Supported Devices

## Currently Supported

### Samsung Galaxy Series
- **Galaxy S10 (SM-G973F)** - Android 9-12
  - Status: ✅ Tested
  - Method: Magisk + TWRP
  - Script: `exploits/samsung/galaxy_s10/root.sh`

### Google Pixel Series
- **Pixel 4a (sunfish)** - Android 11-13
  - Status: ✅ Tested
  - Method: Magisk patched boot
  - Script: `exploits/google/pixel_4a/root.sh`

### OnePlus Series
- **OnePlus 7 Pro (guacamole)** - Android 10-12
  - Status: ⚠️ Beta
  - Method: Custom recovery + Magisk
  - Script: `exploits/oneplus/oneplus_7_pro/root.sh`

### Xiaomi Series
- **Redmi Note 10 (mojito)** - Android 11-13
  - Status: ✅ Tested
  - Method: TWRP + Magisk
  - Script: `exploits/xiaomi/redmi_note_10/root.sh`
  - Note: Requires Mi Unlock Tool (7-day wait)

### Motorola Series
- **Moto G Power (sofia)** - Android 10-11
  - Status: ⚠️ Beta
  - Method: Magisk patched boot
  - Script: `exploits/motorola/moto_g_power/root.sh`

## Device Status Legend
- ✅ Tested - Fully working, tested by maintainers
- ⚠️ Beta - Works but needs more community testing
- 🚧 WIP - Work in progress, may not work
- ❌ Broken - Known issues, do not use

## Quick Start

### Automatic Detection
```bash
cd scripts
./root_device.sh

Manual Device Selection


cd exploits/[manufacturer]/[device]
./root.sh

Adding Your Device

Want to add support for your device? See [CONTRIBUTING.md](../CONTRIBUTING.md)
Requirements:

Unlockable bootloader
Available TWRP/custom recovery OR
Extractable boot.img from stock firmware
Root method documented

Compatibility Notes

Bootloader Unlock Wait Times



Xiaomi: 168 hours (7 days)

Motorola: Instant (with unlock code)

OnePlus: Instant

Samsung: Instant (Exynos only, Snapdragon locked in US)

Google: Instant

Carrier Restrictions

Some carriers lock bootloaders permanently:

Verizon (US)
AT&T (US) - select models
Sprint (US) - select models

Check XDA Developers for your specific model.
