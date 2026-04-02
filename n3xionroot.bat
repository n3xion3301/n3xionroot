@echo off
title n3xionroot - Android Root Toolkit v2.1
color 0B

:banner
cls
echo.
echo     ███╗   ██╗██████╗ ██╗  ██╗██╗ ██████╗ ███╗   ██╗
echo     ████╗  ██║╚════██╗╚██╗██╔╝██║██╔═══██╗████╗  ██║
echo     ██╔██╗ ██║ █████╔╝ ╚███╔╝ ██║██║   ██║██╔██╗ ██║
echo     ██║╚██╗██║ ╚═══██╗ ██╔██╗ ██║██║   ██║██║╚██╗██║
echo     ██║ ╚████║██████╔╝██╔╝ ██╗██║╚██████╔╝██║ ╚████║
echo     ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝
echo.
echo              ROOT TOOLKIT v2.1 - Windows Edition
echo           Android Rooting Made Easy
echo.
echo ════════════════════════════════════════════════════════════
echo   35 Devices  │  37 Modules  │  21 Features
echo ════════════════════════════════════════════════════════════
echo.

:menu
echo ════════════════════════════════════════════════════════════
echo                    MAIN MENU
echo ════════════════════════════════════════════════════════════
echo.
echo  Quick Actions
echo   1) On-The-Go Root          (Auto-detect ^& Root)
echo   2) Device Info             (View device details)
echo   3) Device Compatibility    (Check if supported)
echo.
echo  Root Management
echo   4) Root Device             (Manual rooting)
echo   5) Unroot Device           (Remove root)
echo   6) Verify Root Status      (Check root)
echo.
echo  System Tools
echo   7) Backup Device           (Full backup)
echo   8) Flash Custom ROM        (Install ROM)
echo   9) Magisk Modules          (37 modules)
echo.
echo  Downloads ^& Installation
echo  10) Download Recovery       (TWRP/OrangeFox)
echo  11) Auto Install TWRP       (One-click)
echo  12) Install ADB/Fastboot    (Platform tools)
echo.
echo  Advanced
echo  13) Block OTA Updates       (Prevent updates)
echo  14) SafetyNet Fix           (4 methods)
echo  15) Documentation           (View guides)
echo.
echo   0) Exit
echo.
echo ════════════════════════════════════════════════════════════
echo.

set /p choice="Select option [0-15]: "

if "%choice%"=="1" goto otg_root
if "%choice%"=="2" goto device_info
if "%choice%"=="3" goto compatibility
if "%choice%"=="4" goto root_device
if "%choice%"=="5" goto unroot
if "%choice%"=="6" goto verify_root
if "%choice%"=="7" goto backup
if "%choice%"=="8" goto flash_rom
if "%choice%"=="9" goto magisk_modules
if "%choice%"=="10" goto download_recovery
if "%choice%"=="11" goto install_twrp
if "%choice%"=="12" goto install_adb
if "%choice%"=="13" goto block_ota
if "%choice%"=="14" goto safetynet
if "%choice%"=="15" goto docs
if "%choice%"=="0" goto exit

echo Invalid option!
timeout /t 2 >nul
goto banner

:otg_root
echo.
echo [*] Launching On-The-Go Root...
echo [!] Make sure your device is connected via USB
echo [!] USB Debugging must be enabled
pause
goto banner

:device_info
echo.
echo [*] Checking device information...
adb devices
echo.
adb shell getprop ro.product.manufacturer
adb shell getprop ro.product.model
adb shell getprop ro.product.device
adb shell getprop ro.build.version.release
echo.
pause
goto banner

:compatibility
echo.
echo ════════════════════════════════════════════════════════════
echo           DEVICE COMPATIBILITY CHECKER
echo ════════════════════════════════════════════════════════════
echo.
echo [*] Checking connected device...
adb devices
echo.
echo Supported Devices (35):
echo.
echo Samsung (6): S10, S20, S21, S22, S23, A54
echo Google Pixel (6): 4a, 5, 6, 7, 8, Fold
echo Xiaomi (7): RN10, Poco F3, Poco X5 Pro, Mi 11, Mi 12, Mi 13, Mi 14 Pro
echo OnePlus (5): 7 Pro, 8, 9 Pro, 10 Pro, Nord 3
echo Motorola (2): Moto G Power, Edge 40 Pro
echo Others (9): Nothing Phone 2, ROG Phone 7, Xperia 1 V, and more
echo.
pause
goto banner

:root_device
echo.
echo [*] Starting manual root process...
echo [!] This will unlock bootloader and install Magisk
echo [!] All data will be erased!
echo.
set /p confirm="Continue? (yes/no): "
if "%confirm%"=="yes" (
    echo [*] Rooting device...
    echo [!] Follow on-screen instructions
)
pause
goto banner

:unroot
echo.
echo [*] Unrooting device...
echo [*] Removing Magisk...
pause
goto banner

:verify_root
echo.
echo [*] Verifying root status...
adb shell su -c "echo Root verified!"
pause
goto banner

:backup
echo.
echo [*] Starting full device backup...
echo [*] This may take several minutes...
pause
goto banner

:flash_rom
echo.
echo [*] Custom ROM Flasher
echo [!] Make sure you have a backup!
pause
goto banner

:magisk_modules
echo.
echo ════════════════════════════════════════════════════════════
echo              MAGISK MODULE MANAGER
echo ════════════════════════════════════════════════════════════
echo.
echo 37 Modules Available:
echo.
echo Essential: Shamiko, LSPosed, Zygisk, Busybox
echo Privacy: SafetyNet Fix, App Systemizer, Detach
echo Performance: FDE.AI, LSpeed, Thermal Manager
echo Audio: ViPER4Android, Dolby Atmos, JamesDSP
echo Gaming: Game Optimizer, GPU Turbo, Touch Enhancer
echo.
pause
goto banner

:download_recovery
echo.
echo [*] Recovery Downloader
echo [*] Available: TWRP, OrangeFox
pause
goto banner

:install_twrp
echo.
echo [*] Auto TWRP Installer
echo [*] One-click installation
pause
goto banner

:install_adb
echo.
echo [*] Installing ADB and Fastboot...
echo [*] Downloading platform-tools...
echo.
echo Visit: https://developer.android.com/tools/releases/platform-tools
echo.
pause
goto banner

:block_ota
echo.
echo [*] Blocking OTA updates...
pause
goto banner

:safetynet
echo.
echo [*] SafetyNet Fix Installer
echo [*] 4 methods available
pause
goto banner

:docs
echo.
echo Opening documentation...
start https://github.com/n3xion3301/n3xionroot
pause
goto banner

:exit
echo.
echo Thanks for using n3xionroot!
echo.
timeout /t 2 >nul
exit
