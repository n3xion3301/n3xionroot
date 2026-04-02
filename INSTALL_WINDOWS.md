# n3xionroot - Windows Installation Guide

## For Windows Users (HP, Dell, Lenovo, etc.)

### Prerequisites

1. **Windows 10/11** (64-bit recommended)
2. **USB Cable** for your Android device
3. **Administrator access**

### Step 1: Install ADB and Fastboot

**Option A: Automatic (Recommended)**
1. Download: [SDK Platform Tools](https://developer.android.com/tools/releases/platform-tools)
2. Extract to `C:\platform-tools`
3. Add to PATH:
   - Right-click "This PC" → Properties
   - Advanced System Settings → Environment Variables
   - Edit "Path" → Add `C:\platform-tools`

**Option B: Manual**
```cmd
# Download and extract platform-tools
# Add to system PATH

Step 2: Enable USB Debugging on Android

Go to Settings → About Phone
Tap Build Number 7 times
Go back to Settings → Developer Options
Enable USB Debugging
Enable OEM Unlocking (if available)

Step 3: Download n3xionroot
Option A: Git Clone
git clone https://github.com/n3xion3301/n3xionroot.git
cd n3xionrootInsert at cursor
Option B: Download ZIP

Visit: https://github.com/n3xion3301/n3xionroot
Click "Code" → "Download ZIP"
Extract to C:\n3xionroot

Step 4: Run n3xionroot

Open Command Prompt as Administrator
Navigate to n3xionroot folder:
cd C:\n3xionrootInsert at cursor

Run the toolkit:
n3xionroot.batInsert at cursor


Step 5: Connect Your Device

Connect Android device via USB
On phone, allow USB debugging when prompted
In n3xionroot, select option 2 to verify connection

Troubleshooting
Device Not Detected?

Install device-specific USB drivers
Try different USB cable/port
Restart ADB: adb kill-server then adb start-server

Missing Drivers?

Samsung: [Samsung USB Drivers](https://developer.samsung.com/mobile/android-usb-driver.html)
Google: Included in platform-tools
Others: Check manufacturer website

Permission Denied?

Run Command Prompt as Administrator
Check USB debugging is enabled
Revoke USB debugging authorizations and reconnect

Supported Windows Versions
✅ Windows 11 (All editions)
✅ Windows 10 (1809 or later)
✅ Windows 8.1 (with updates)
⚠️ Windows 7 (limited support)
System Requirements

RAM: 4GB minimum, 8GB recommended
Storage: 2GB free space
USB: USB 2.0 or higher
Internet: For downloading tools

Quick Start for Your Mom's HP

Download platform-tools from Google
Extract to C:\platform-tools
Download n3xionroot ZIP
Extract to C:\n3xionroot
Double-click n3xionroot.bat
Connect phone and follow prompts

Video Tutorial
Coming soon! Check our YouTube channel.
Need Help?

GitHub Issues: https://github.com/n3xion3301/n3xionroot/issues
Discord: Coming soon
Email: support@n3xionroot.com


Copyright (c) 2024 n3xion3301 (Tisra Siphix Til)
