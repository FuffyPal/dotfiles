echo "script for linux mint cinnamon edi~"

Add_repos="

"

Add_package="
gnome-session
gnome-shell
gnome-core
gnome-tweaks
pipewire
pipewire-pulse
wireplumber
"

Remove_package="
gnome-calculator
gnome-calendar
gnome-contacts
gnome-sushi
eog
celluloid
xreader*
ufw
libreoffice-*
thunderbird*
firefox*
transmission*
rhythmbox*
onboard*
pix*
warpinator
ubuntu-session
evince
simple-scan
mintbackup
mintinstall
mintmenu
mintstick
mintwelcome
mintupdate
mint-upgrade-info
hypnotix
drawing
xed
gnome-shell-extensions
gnome-shell-extension-prefs
sticky
cinnamon*
lightdm*
"

Update_defualt="sudo apt update"
Upgrade_defualt="sudo apt upgrade -y"
Install_defualt="sudo apt install -y"
Remove_defualt="sudo apt remove --purge --auto-remove -y"
