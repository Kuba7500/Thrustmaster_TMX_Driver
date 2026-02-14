# DISCLAIMER

This repository contains `install.sh`, a script authored by me to automate installation of:

- [T150 Driver](https://github.com/scarburato/t150_driver)
- [TMDRV](https://github.com/her001/tmdrv)

- Note: Tested and works on **Arch Linux / CachyOS / Linux Mint / Ubuntu / Debian and Arch - based distors** 
  automatically installs approporiate headers for your installed kernel, (for example zen kernel - linux-zen-headers)

**Disclaimer:** I am NOT the author of T150 Driver or TMDRV. This script is provided as-is to simplify installation. Use at your own risk.

## Installation
To install drivers for your Thrustmaster TMX you need to follow those few, simple steps:

**Note:**
Always use sudo bash ./install.sh – direct sudo ./install.sh will fail because sudo excludes the current directory from PATH for security reasons.
Follow the on-screen instructions. When everything is done, restart your computer or reconnect the wheel – full Force Feedback should work automatically.

1. **Clone this repository:**

- In terminal of your choice type: git clone https://github.com/Kuba7500/Thrustmaster_TMX_Driver.git

2. **Run the installation script**

- To install it, run this command in the terminal: **sudo bash ./install.sh**
  It's very important to not forget that **bash**

3. **Follow the instructions shown in your terminal**
- When everything is done, close the window and your steering wheel should work.

4. **If there is an error related to no permissions**
- If you want to get rid of the permissions issue, go to your cloned folder and
  type: **chmod +x install.sh** , after doing so, there should be no permission issue.

## Uninstalling

- To uninstall drivers for your Thrustamster TMX you need to type out just 1, simple command:
  **sudo bash ./install.sh uninstall** (Dont forget that "uninstall" argument!)

If you encounter any issues installing, please contact me through e-mail or discord.
jakubjaki55@gmail.com - email or kxzrt123 - discord







