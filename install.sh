#!/bin/bash
set -e

# --- Color definitions ---
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

# --- Language detection ---
case "$LANG" in
    pl*) L="PL" ;;
    es*|pt*) L="ES" ;;
    de*) L="DE" ;;
    fr*) L="FR" ;;
    *) L="EN" ;;
esac


# If You are reading this, I suggest sending me an e-mail about how the installation went.
# Contact me at: jakubjaki55@gmail.com

# --- Translations ---
if [ "$L" == "PL" ]; then
    MSG_PLUG="Proszę podłączyć kierownicę Thrustmaster przed kontynuacją."
    MSG_UN_PLUG="Proszę odłączyć kierownicę Thrustmaster przed kontynuacją."
    MSG_DETECTION="Wykrywanie dystrybucji Linux..."
    MSG_DONE="Instalacja zakończona sukcesem!"
    MSG_ENTER="Naciśnij ENTER, aby kontynuować..."
    MSG_UNINSTALLING="Deinstalacja sterowników T150 i TMDRV."
    MSG_INSTALLING_DKHD="Instalowanie nagłówków jądra i DKMS."
    MSG_STOP_SERVICE="Zatrzymywanie i usuwanie usług systemowych."
    MSG_UNINSTALL_CMPLT="Deinstalacja przebiegła pomyślnie."
    MSG_UNSUPPORTED_SYS="System nie jest obsługiwany."
    MSG_PACKAGE_MGR="Twój menadżer pakietów to: "
    MSG_T150_DVR="Pobieranie sterownika T150 (potrzebny do TMX)!"
    MSG_SRV_DONE="Usługa skonfigurowana i uruchomiona."
    MSG_SRV_SETUP="Konfigurowanie usługi TMDRV."
    MSG_DWNLD_TMDRV="Pobieranie TMDRV."

elif [ "$L" == "ES" ]; then
    MSG_PLUG="Por favor, conecte el volante Thrustmaster antes de continuar."
    MSG_UN_PLUG="Por favor, desconecte el volante Thrustmaster antes de continuar."
    MSG_DETECTION="Detectando distribución de Linux..."
    MSG_DONE="¡Instalación completada con éxito!"
    MSG_ENTER="Presione ENTER para continuar..."
    MSG_UNINSTALLING="Desinstalando controladores T150 y TMDRV."
    MSG_INSTALLING_DKHD="Instalando cabeceras del núcleo y DKMS."
    MSG_STOP_SERVICE="Deteniendo y eliminando servicios del sistema."
    MSG_UNINSTALL_CMPLT="Desinstalación completada con éxito."
    MSG_UNSUPPORTED_SYS="Sistema no compatible."
    MSG_PACKAGE_MGR="Su gestor de paquetes es: "
    MSG_T150_DVR="¡Descargando el controlador T150 (necesario para TMX)!"
    MSG_SRV_DONE="Servicio configurado y en funcionamiento."
    MSG_SRV_SETUP="Configurando el servicio TMDRV."
    MSG_DWNLD_TMDRV="Descargando TMDRV."

elif [ "$L" == "FR" ]; then
    MSG_PLUG="Veuillez connecter votre volant Thrustmaster avant de continuer."
    MSG_UN_PLUG="Veuillez déconnecter votre volant Thrustmaster avant de continuer."
    MSG_DETECTION="Détection de la distribution Linux..."
    MSG_DONE="Installation terminée avec succès !"
    MSG_ENTER="Appuyez sur ENTRÉE pour continuer..."
    MSG_UNINSTALLING="Désinstallation des pilotes T150 et TMDRV."
    MSG_INSTALLING_DKHD="Installation des en-têtes du noyau et de DKMS."
    MSG_STOP_SERVICE="Arrêt et suppression des services système."
    MSG_UNINSTALL_CMPLT="Désinstallation terminée avec succès."
    MSG_UNSUPPORTED_SYS="Système non pris en charge."
    MSG_PACKAGE_MGR="Votre gestionnaire de paquets est : "
    MSG_T150_DVR="Téléchargement du pilote T150 (nécessaire pour le TMX) !"
    MSG_SRV_DONE="Service configuré et en cours d’exécution."
    MSG_SRV_SETUP="Configuration du service TMDRV."
    MSG_DWNLD_TMDRV="Téléchargement de TMDRV."

elif [ "$L" == "DE" ]; then
    MSG_PLUG="Bitte schließen Sie Ihr Thrustmaster-Lenkrad an, bevor Sie fortfahren."
    MSG_UN_PLUG="Bitte trennen Sie Ihr Thrustmaster-Lenkrad, bevor Sie fortfahren."
    MSG_DETECTION="Linux-Distribution wird erkannt..."
    MSG_DONE="Installation erfolgreich abgeschlossen!"
    MSG_ENTER="Drücken Sie ENTER, um fortzufahren..."
    MSG_UNINSTALLING="Deinstallieren der T150- und TMDRV-Treiber."
    MSG_INSTALLING_DKHD="Kernel-Header und DKMS werden installiert."
    MSG_STOP_SERVICE="Systemdienste werden gestoppt und entfernt."
    MSG_UNINSTALL_CMPLT="Deinstallation erfolgreich abgeschlossen."
    MSG_UNSUPPORTED_SYS="System wird nicht unterstützt."
    MSG_PACKAGE_MGR="Ihr Paketmanager ist: "
    MSG_T150_DVR="T150-Treiber wird heruntergeladen (benötigt für TMX)!"
    MSG_SRV_DONE="Dienst konfiguriert und gestartet."
    MSG_SRV_SETUP="TMDRV-Dienst wird konfiguriert."
    MSG_DWNLD_TMDRV="TMDRV wird heruntergeladen."

else # EN
    MSG_PLUG="Please plug in your Thrustmaster wheel before continuing."
    MSG_UN_PLUG="Please unplug your Thrustmaster wheel before uninstalling."
    MSG_DETECTION="Detecting your Linux distribution..."
    MSG_DONE="Installation completed successfully!"
    MSG_ENTER="Press ENTER to continue..."
    MSG_UNINSTALLING="Uninstalling T150 Driver and TMDRV"
    MSG_INSTALLING_DKHD="Installing headers and DKMS."
    MSG_STOP_SERVICE="Stopping and disabling system services."
    MSG_UNINSTALL_CMPLT="Uninstalling completed."
    MSG_UNSUPPORTED_SYS="Unsupported system."
    MSG_PACKAGE_MGR="Your package manager is: "
    MSG_T150_DVR="Downloading T150 driver (needed for TMX)!"
    MSG_SRV_DONE="Service configured and running."
    MSG_SRV_SETUP="Setting up the service for TMDRV"
    MSG_DWNLD_TMDRV="Downloading TMDRV."
fi

# --- Uninstall option ---
if [ "$1" == "uninstall" ]; then
    echo -e "${YELLOW}$MSG_UN_PLUG${RESET}"
    read -rp "$MSG_ENTER"

    echo -e "${YELLOW}$MSG_UNINSTALLING${RESET}"

    # Stop and disable service if exists
    if systemctl is-active --quiet tmdrv.service; then
        echo -e "${YELLOW}$MSG_STOP_SERVICE${RESET}"
        sudo systemctl stop tmdrv.service
        sudo systemctl disable tmdrv.service
    fi
    sudo rm -f /etc/systemd/system/tmdrv.service
    sudo systemctl daemon-reload

    # T150 Driver
    if [ -d "t150_driver" ]; then
        sudo rm -rf t150_driver
    fi

    # TMDRV
    if [ -d "tmdrv" ]; then
        sudo rm -rf tmdrv
    fi

    echo -e "${GREEN}$MSG_UNINSTALL_CMPLT${RESET}"
    exit 0
fi

# --- Disclaimer ---
echo -e "${YELLOW}Disclaimer:${RESET}"
echo -e "${YELLOW}This script (install.sh) is authored by me to automate installation of T150 Driver and TMDRV.${RESET}"
echo -e "${YELLOW}I am NOT the author of the original T150 Driver[](https://github.com/scarburato/t150_driver) or TMDRV[](https://github.com/her001/tmdrv).${RESET}"
echo -e "${YELLOW}Use at your own risk. This script simply automates their installation.${RESET}\n"

# --- Warning about steering wheel ---
echo -e "${YELLOW}$MSG_PLUG${RESET}"
read -rp "$MSG_ENTER"

# --- Detect package manager ---
echo -e "${YELLOW}$MSG_DETECTION${RESET}"
if [ -f /etc/debian_version ]; then
    PM="apt"
    UPDATE="sudo apt update"
    # Installing system dependencies for Debian/Ubuntu
    INSTALL="sudo apt install -y git python3 python3-pip"
elif [ -f /etc/arch-release ]; then
    PM="pacman"
    UPDATE="sudo pacman -Sy"
    # Installing system dependencies for Arch
    INSTALL="sudo pacman -S --noconfirm git python python-pip base-devel linuxconsole"
else
    echo -e "${RED}$MSG_UNSUPPORTED_SYS${RESET}"
    exit 1
fi
echo -e "${GREEN}$MSG_PACKAGE_MGR $PM${RESET}"

# --- Update and Install ---
$UPDATE
$INSTALL

# --- Install DKMS and kernel headers ---
echo -e "${YELLOW}$MSG_INSTALLING_DKHD${RESET}"
if [ "$PM" == "pacman" ]; then
    # Automatically sellecting system headers for diffrent linux kernels
    KERNEL_PKG=$(pacman -Qqo "/usr/lib/modules/$(uname -r)/pkgbase" 2>/dev/null || echo "linux")
    sudo pacman -S --noconfirm dkms "${KERNEL_PKG}-headers"
else
    KERNEL_VER=$(uname -r)
    sudo apt install -y linux-headers-"$KERNEL_VER" dkms
fi

# --- Check python-libusb1 ---
if ! python3 -c "import usb1" &>/dev/null; then
    echo -e "${YELLOW}python-libusb1...${RESET}"
    if [ "$PM" == "pacman" ]; then
        sudo pacman -S --noconfirm python-libusb1
    else
        sudo apt install -y python3-libusb1 || pip3 install python-libusb1 --break-system-packages
    fi
fi

# --- Download and install T150 Driver ---
echo -e "${GREEN}$MSG_T150_DVR${RESET}"
git clone https://github.com/scarburato/t150_driver.git
cd t150_driver
sudo ./install.sh
cd ..

# --- Download TMDRV ---
echo -e "${GREEN}$MSG_DWNLD_TMDRV${RESET}"
git clone https://github.com/her001/tmdrv.git


# --- Setup Systemd Service ---
echo -e "${YELLOW}$MSG_SRV_SETUP${RESET}"

USER_NAME=$(whoami)
sudo usermod -aG input "$USER_NAME"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cat <<EOF | sudo tee /etc/systemd/system/tmdrv.service > /dev/null
[Unit]
Description=Thrustmaster TMX Force Feedback Daemon (TMDRV)
After=multi-user.target

[Service]
Type=simple
WorkingDirectory=$SCRIPT_DIR/tmdrv
ExecStartPre=/bin/sleep 1
ExecStart=/usr/bin/python3 $SCRIPT_DIR/tmdrv/tmdrv.py -d thrustmaster_tmx
Restart=always
RestartSec=5
User=$USER_NAME
Group=input

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable tmdrv.service
sudo systemctl restart tmdrv.service

echo -e "${GREEN}$MSG_SRV_DONE${RESET}"
echo -e "${GREEN}$MSG_DONE${RESET}"
