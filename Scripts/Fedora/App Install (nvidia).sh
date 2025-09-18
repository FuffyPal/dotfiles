echo "Enable rpm fusion"
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
echo "system "update"
sudo dnf update -y
sudo dnf install -y podman firewalld firewall-config firewall-applet flatpak vim gnome-tweaks papirus-icon-theme steam-devices bzip3 git-lfs git  rust-analyzer nodejs-npm  nextcloud-client nextcloud-client-nautilus helix yt-dlp yt-dlp-bash-completion ffmpeg-free
sudo dnf install akmod-nvidia-open xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-cuda-libs vulkan libva-utils vdpauinfo -y