# Troubleshooting

## Common Issues

### Device Not Detected
**Symptoms:** `adb devices` shows nothing

**Solutions:**
1. Install proper USB drivers
2. Try different USB cable/port
3. Enable USB debugging
4. Revoke USB debugging authorizations and retry
5. Try `adb kill-server` then `adb start-server`

### Bootloader Won't Unlock
**Symptoms:** `fastboot flashing unlock` fails

**Solutions:**
1. Enable "OEM Unlocking" in Developer Options
2. Some carriers lock bootloaders permanently
3. Wait 7 days after enabling OEM unlock (some devices)

### Device Stuck in Bootloop
**Solutions:**
1. Boot to recovery (Power + Volume Up)
2. Factory reset
3. Flash stock firmware via Odin/fastboot
4. If TWRP installed: Wipe cache/dalvik

### Magisk Not Showing Root
**Solutions:**
1. Reinstall Magisk
2. Check if boot image was properly patched
3. Reflash patched boot image
4. Clear Magisk app data

### SafetyNet Fails
**Solutions:**
1. Update Magisk to latest
2. Install Universal SafetyNet Fix module
3. Enable Zygisk in Magisk settings
4. Hide Magisk app

## Emergency Unroot

### Quick Unroot
```bash
# Flash stock boot image
fastboot flash boot stock_boot.img
fastboot reboot
# ADB logcat
adb logcat > logcat.txt

# Magisk logs
# In Magisk Manager > Settings > Save logs

