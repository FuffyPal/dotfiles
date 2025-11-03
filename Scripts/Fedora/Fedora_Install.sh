#!/bin/bash

echo "Enable rpm fusion"
rpmfusion="
https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
"

sudo dnf install -y $rpmfusion
if [ $? -eq 0 ]; then
    echo "Rpm Fusion successful ... "
else
    echo "Rpm Fusion  unsuccessful !!!"
    exit 1
fi

echo "enable terra repo"
sudo dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release 
if [ $? -eq 0 ]; then
    echo "terra repo successful ... "
else
    echo "terra repo  unsuccessful !!!"
    exit 1
fi

echo "google chrome and nvidia driver repo"
sudo dnf install -y fedora-workstation-repositories
sudo dnf config-manager setopt google-chrome.enabled=1
sudo dnf config-manager setopt rpmfusion-nonfree-nvidia-driver.enabled=1

if [ $? -eq 0 ]; then
    echo "google chrome and nvidia driver repo successful ... "
else
    echo "google chrome and nvidia driver repo  unsuccessful !!!"
    exit 1
fi

package="
podman
firewalld
firewall-config
firewall-applet
flatpak
vim
gnome-tweaks
papirus-icon-theme
kmodtool
akmods
mokutil
openssl
steam-devices
bzip3
zed
btrfs-assistant
git-lfs
git
tailscale
rustup
rust-analyzer
nodejs-npm
ptyxis
syncthing
helix
lolcat
yt-dlp
yt-dlp-bash-completion
ffmpeg-free
gnome-console
"

nvidia="
akmod-nvidia
xorg-x11-drv-nvidia-cuda
xorg-x11-drv-nvidia-cuda-libs
vulkan
libva-utils
vdpauinfo
"

echo "Installing basic packages..."
sudo dnf install -y $package
if [ $? -eq 0 ]; then
    echo "Basic Packages successful ... "
else
    echo "Basic Packages  unsuccessful !!!"
    exit 1
fi

echo "Secure boot enable ..."
echo "Secure boot ASCII en keybord"
sudo kmodgenca -a
if [ $? -eq 0 ]; then
	echo "Secure boot import"
	sudo mokutil --import /etc/pki/akmods/certs/public_key.der
	if [ $? -eq 0 ]; then
		echo "secure boot successfull ..."
	else 
		echo "secure boot unsuccessfull ... error import area"
		exit 1
	fi
else 
	echo "sucre boot unseccesfull ... error generade"
	sudo kmodgenca -a --force
	if [ $? -eq 0 ]; then
		echo "secure boot import"
		sudo mokutil --import /etc/pki/akmods/certs/public_key.der
		if  [ $? -eq 0 ]; then
			echo "sucre boot successfull ... but force mod"
		else 
			echo "secure boot unseccessfull .. error import area"
			exit 1
		fi
	else 
		echo "secure boot unseccesfull ... error gnerade force mode"
		exit 1
	fi
fi

echo "system upgrade"
sudo dnf update -y
if [ $? -eq 0 ]; then
    echo "system upgrade successfull ..."
else
    echo "system upgrade unsuccsessfull !!!"
    exit 1
fi
 
if command -v lspci > /dev/null; then
    if lspci | grep -i nvidia > /dev/null; then
        echo "NVIDIA GPU found"
        echo "Installing Nvidia"
        sudo dnf install -y $nvidia
        if [ $? -eq 0 ]; then
            echo "NVIDIA GPU successful ... "
        else
            echo "NVIDIA GPU  unsuccessful !!!"
            exit 1
        fi

    else
        echo "Nvidia GPU not found"
    fi
else
    echo "lspci command not found"
fi
