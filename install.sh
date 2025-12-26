#!/bin/bash
# --- Uninstall option ---
if [ "$1" == "uninstall" ]; then
    echo -e "${YELLOW}Please unplug your Thrustmaster wheel before uninstalling.${RESET}"
    read -p "Press ENTER to continue with uninstallation..."

    echo -e "${YELLOW}Uninstalling T150 Driver, TMDRV, and Oversteer...${RESET}"
    
    # T150 Driver
    if [ -d "t150_driver" ]; then
        cd t150_driver
        sudo ./uninstall.sh || echo "No uninstall script for T150 Driver, removing folder..."
        cd ..
        sudo rm -rf t150_driver
    fi

    # TMDRV
    if [ -d "tmdrv" ]; then
        sudo rm -rf tmdrv
    fi

    # Oversteer
    if [ -d "oversteer" ]; then
        sudo rm -rf oversteer
    fi

    echo -e "${GREEN}Uninstallation completed.${RESET}"
    exit 0
fi



# --- Color definitions ---
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

# --- Disclaimer ---
echo -e "${YELLOW}Disclaimer:${RESET}"
echo -e "${YELLOW}This script (install.sh) is authored by me to automate installation of T150 Driver and TMDRV.${RESET}"
echo -e "${YELLOW}I am NOT the author of the original T150 Driver (https://github.com/scarburato/t150_driver) or TMDRV (https://github.com/her001/tmdrv).${RESET}"
echo -e "${YELLOW}Use at your own risk. This script simply automates their installation.${RESET}\n"

# --- Check if script is executable ---
if [ ! -x "$0" ]; then
    echo -e "${YELLOW}Warning: This script may not be executable.${RESET}"
    echo -e "${YELLOW}If this is the first time running, run: chmod +x install.sh${RESET}"
fi


# --- Warning about steering wheel ---
echo -e "${YELLOW}Please make sure your Thrustmaster wheel is plugged in before continuing.${RESET}"
read -p "Press ENTER to continue once your wheel is connected..."

# --- Detect package manager ---
echo -e "${YELLOW}Detecting your Linux distribution...${RESET}"

if [ -f /etc/debian_version ]; then
    PM="apt"
    UPDATE="sudo apt update"
    INSTALL="sudo apt install -y git python3 python3-pip joystick"
elif [ -f /etc/arch-release ]; then
    PM="pacman"
    UPDATE="sudo pacman -Sy"
    INSTALL="sudo pacman -S --noconfirm git python python-pip python-pipx joystick"
else
    echo -e "${RED}Unsupported system. Only Debian/Ubuntu and Arch Linux are supported.${RESET}"
    exit 1
fi

echo -e "${GREEN}Detected package manager: $PM${RESET}"

# --- Update system packages ---
echo -e "${YELLOW}Updating system packages...${RESET}"
$UPDATE

# --- Install required packages ---
echo -e "${YELLOW}Installing required packages...${RESET}"
$INSTALL

# --- Check python-libusb1 ---
if ! python3 -c "import usb1" &>/dev/null; then
    echo -e "${YELLOW}Installing python-libusb1...${RESET}"
    if [ "$PM" == "pacman" ]; then
        sudo pacman -S --noconfirm python-libusb1
    else
        pip3 install --user python-libusb1
    fi
fi

# --- Download and install T150 Driver ---
echo -e "${GREEN}Downloading T150 Driver...${RESET}"
if [ -d "t150_driver" ]; then
    echo -e "${YELLOW}Updating existing T150 Driver...${RESET}"
    cd t150_driver
    git pull
    cd ..
else
    git clone https://github.com/scarburato/t150_driver.git
fi

echo -e "${GREEN}Installing T150 Driver...${RESET}"
cd t150_driver
sudo ./install.sh
cd ..

# --- Download and run TMDRV ---
echo -e "${GREEN}Downloading TMDRV...${RESET}"
if [ -d "tmdrv" ]; then
    echo -e "${YELLOW}Updating existing TMDRV...${RESET}"
    cd tmdrv
    git pull
    cd ..
else
    git clone https://github.com/her001/tmdrv.git
fi

# --- tip, install Oversteer ---
echo -e "${YELLOW}Tip: I recommend installing Oversteer for additional functionality with your Thrustmaster wheel.${RESET}"
echo -e "${YELLOW}You can find it here: https://github.com/berarma/oversteer${RESET}"


echo -e "${GREEN}Running TMDRV...${RESET}"
cd tmdrv
python3 ./tmdrv.py -d thrustmaster_tmx
cd ..

echo -e "${GREEN}Installation completed successfully!${RESET}"
