#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "========================================="
echo "  n3xionroot - ADB/Fastboot Installer"
echo "========================================="
echo ""

TOOLS_DIR="./tools"
mkdir -p "$TOOLS_DIR"

detect_os() {
    printf "${YELLOW}[*]${NC} Detecting operating system...\n"
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        printf "${GREEN}[✓]${NC} OS: Linux\n"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="mac"
        printf "${GREEN}[✓]${NC} OS: macOS\n"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
        printf "${GREEN}[✓]${NC} OS: Windows\n"
    else
        printf "${RED}[!]${NC} Unknown OS: $OSTYPE\n"
        exit 1
    fi
}

check_existing() {
    printf "\n${YELLOW}[*]${NC} Checking for existing installation...\n"
    
    if command -v adb &> /dev/null; then
        ADB_VERSION=$(adb version | head -1)
        printf "${GREEN}[✓]${NC} ADB found: $ADB_VERSION\n"
        ADB_EXISTS=true
    else
        printf "${YELLOW}[!]${NC} ADB not found\n"
        ADB_EXISTS=false
    fi
    
    if command -v fastboot &> /dev/null; then
        FASTBOOT_VERSION=$(fastboot --version | head -1)
        printf "${GREEN}[✓]${NC} Fastboot found: $FASTBOOT_VERSION\n"
        FASTBOOT_EXISTS=true
    else
        printf "${YELLOW}[!]${NC} Fastboot not found\n"
        FASTBOOT_EXISTS=false
    fi
}

download_platform_tools() {
    printf "\n${YELLOW}[*]${NC} Downloading Android Platform Tools...\n"
    
    case $OS in
        linux)
            URL="https://dl.google.com/android/repository/platform-tools-latest-linux.zip"
            ;;
        mac)
            URL="https://dl.google.com/android/repository/platform-tools-latest-darwin.zip"
            ;;
        windows)
            URL="https://dl.google.com/android/repository/platform-tools-latest-windows.zip"
            ;;
    esac
    
    OUTPUT_FILE="$TOOLS_DIR/platform-tools.zip"
    
    printf "    URL: $URL\n"
    printf "    Downloading...\n"
    
    if command -v wget &> /dev/null; then
        wget -O "$OUTPUT_FILE" "$URL"
    elif command -v curl &> /dev/null; then
        curl -L -o "$OUTPUT_FILE" "$URL"
    else
        printf "${RED}[!]${NC} Neither wget nor curl found\n"
        exit 1
    fi
    
    if [ $? -eq 0 ]; then
        printf "${GREEN}[✓]${NC} Download complete\n"
    else
        printf "${RED}[!]${NC} Download failed\n"
        exit 1
    fi
}

extract_tools() {
    printf "\n${YELLOW}[*]${NC} Extracting platform tools...\n"
    
    cd "$TOOLS_DIR"
    
    if command -v unzip &> /dev/null; then
        unzip -o platform-tools.zip
    else
        printf "${RED}[!]${NC} unzip not found. Please install unzip\n"
        exit 1
    fi
    
    if [ $? -eq 0 ]; then
        printf "${GREEN}[✓]${NC} Extraction complete\n"
        rm platform-tools.zip
    else
        printf "${RED}[!]${NC} Extraction failed\n"
        exit 1
    fi
    
    cd - > /dev/null
}

install_linux() {
    printf "\n${YELLOW}[*]${NC} Installing on Linux...\n"
    
    printf "Select installation method:\n"
    printf "  1) System-wide (requires sudo)\n"
    printf "  2) User directory (~/.local/bin)\n"
    printf "  3) Keep in tools directory only\n"
    read -p "Select option (1-3): " INSTALL_METHOD
    
    case $INSTALL_METHOD in
        1)
            printf "    Installing to /usr/local/bin...\n"
            sudo cp $TOOLS_DIR/platform-tools/adb /usr/local/bin/
            sudo cp $TOOLS_DIR/platform-tools/fastboot /usr/local/bin/
            sudo chmod +x /usr/local/bin/adb
            sudo chmod +x /usr/local/bin/fastboot
            printf "${GREEN}[✓]${NC} Installed system-wide\n"
            ;;
        2)
            mkdir -p ~/.local/bin
            cp $TOOLS_DIR/platform-tools/adb ~/.local/bin/
            cp $TOOLS_DIR/platform-tools/fastboot ~/.local/bin/
            chmod +x ~/.local/bin/adb
            chmod +x ~/.local/bin/fastboot
            
            printf "${GREEN}[✓]${NC} Installed to ~/.local/bin\n"
            printf "${YELLOW}[!]${NC} Add to PATH if not already:\n"
            printf "    echo 'export PATH=\$PATH:~/.local/bin' >> ~/.bashrc\n"
            printf "    source ~/.bashrc\n"
            ;;
        3)
            printf "${GREEN}[✓]${NC} Tools available in: $TOOLS_DIR/platform-tools/\n"
            printf "${YELLOW}[!]${NC} Add to PATH:\n"
            printf "    export PATH=\$PATH:$(pwd)/$TOOLS_DIR/platform-tools\n"
            ;;
    esac
}

install_mac() {
    printf "\n${YELLOW}[*]${NC} Installing on macOS...\n"
    
    printf "Select installation method:\n"
    printf "  1) System-wide (requires sudo)\n"
    printf "  2) User directory (~/.local/bin)\n"
    printf "  3) Keep in tools directory only\n"
    read -p "Select option (1-3): " INSTALL_METHOD
    
    case $INSTALL_METHOD in
        1)
            printf "    Installing to /usr/local/bin...\n"
            sudo cp $TOOLS_DIR/platform-tools/adb /usr/local/bin/
            sudo cp $TOOLS_DIR/platform-tools/fastboot /usr/local/bin/
            sudo chmod +x /usr/local/bin/adb
            sudo chmod +x /usr/local/bin/fastboot
            printf "${GREEN}[✓]${NC} Installed system-wide\n"
            ;;
        2)
            mkdir -p ~/.local/bin
            cp $TOOLS_DIR/platform-tools/adb ~/.local/bin/
            cp $TOOLS_DIR/platform-tools/fastboot ~/.local/bin/
            chmod +x ~/.local/bin/adb
            chmod +x ~/.local/bin/fastboot
            
            printf "${GREEN}[✓]${NC} Installed to ~/.local/bin\n"
            printf "${YELLOW}[!]${NC} Add to PATH if not already:\n"
            printf "    echo 'export PATH=\$PATH:~/.local/bin' >> ~/.zshrc\n"
            printf "    source ~/.zshrc\n"
            ;;
        3)
            printf "${GREEN}[✓]${NC} Tools available in: $TOOLS_DIR/platform-tools/\n"
            printf "${YELLOW}[!]${NC} Add to PATH:\n"
            printf "    export PATH=\$PATH:$(pwd)/$TOOLS_DIR/platform-tools\n"
            ;;
    esac
}

install_windows() {
    printf "\n${YELLOW}[*]${NC} Installing on Windows...\n"
    
    printf "${GREEN}[✓]${NC} Tools extracted to: $TOOLS_DIR/platform-tools/\n"
    printf "\n${YELLOW}To add to PATH:${NC}\n"
    printf "  1. Press Win + X, select 'System'\n"
    printf "  2. Click 'Advanced system settings'\n"
    printf "  3. Click 'Environment Variables'\n"
    printf "  4. Under 'User variables', select 'Path', click 'Edit'\n"
    printf "  5. Click 'New' and add: $(pwd)/$TOOLS_DIR/platform-tools\n"
    printf "  6. Click 'OK' on all windows\n"
    printf "  7. Restart terminal\n"
}

verify_installation() {
    printf "\n${YELLOW}[*]${NC} Verifying installation...\n"
    
    # Reload PATH
    export PATH="$PATH:$TOOLS_DIR/platform-tools"
    
    if command -v adb &> /dev/null; then
        ADB_VERSION=$(adb version 2>&1 | head -1)
        printf "${GREEN}[✓]${NC} ADB installed: $ADB_VERSION\n"
    else
        printf "${RED}[!]${NC} ADB not found in PATH\n"
    fi
    
    if command -v fastboot &> /dev/null; then
        FASTBOOT_VERSION=$(fastboot --version 2>&1 | head -1)
        printf "${GREEN}[✓]${NC} Fastboot installed: $FASTBOOT_VERSION\n"
    else
        printf "${RED}[!]${NC} Fastboot not found in PATH\n"
    fi
}

main() {
    detect_os
    check_existing
    
    if [ "$ADB_EXISTS" = true ] && [ "$FASTBOOT_EXISTS" = true ]; then
        printf "\n${GREEN}ADB and Fastboot already installed!${NC}\n"
        read -p "Reinstall anyway? (yes/no): " REINSTALL
        
        if [ "$REINSTALL" != "yes" ]; then
            exit 0
        fi
    fi
    
    download_platform_tools
    extract_tools
    
    case $OS in
        linux)
            install_linux
            ;;
        mac)
            install_mac
            ;;
        windows)
            install_windows
            ;;
    esac
    
    verify_installation
    
    printf "\n${GREEN}=========================================${NC}\n"
    printf "${GREEN}Installation complete!${NC}\n"
    printf "\nTest with:\n"
    printf "  adb version\n"
    printf "  fastboot --version\n"
    printf "${GREEN}=========================================${NC}\n"
}

main
