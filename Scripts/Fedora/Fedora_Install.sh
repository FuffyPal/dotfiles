#!/bin/bash

echo "Enable rpm fusion"
Repos="
https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

"
sudo dnf install -y $Repos
if [ $? -eq 0 ]; then
    echo "Rpm Fusion successful ... "
else
    echo "Rpm Fusion  unsuccessful !!!"
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
steam-devices
bzip3
git-lfs
git
rust-analyzer
nodejs-npm
gnome-terminal
nextcloud-client
nextcloud-client-nautilus
helix
yt-dlp
yt-dlp-bash-completion
ffmpeg-free
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
