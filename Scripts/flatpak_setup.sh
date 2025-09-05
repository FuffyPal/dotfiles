echo "flatpak installed ?"
read -p "y/n " choice
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
if [[ "$choice" == "y" || "$choice" == "yes" ]]; then
  echo "hmm okey byye :("
  exit 1
elif [[ "$choice" == "n" || "$choice" == "no" ]]; then
  echo "what is your distro?"
  read -p "arch/ubuntu/debian/pop_os etc. please write ? " twochoice
  twochoice=$(echo "$twochoice" | tr '[:upper:]' '[:lower:]')
  if [[ "$twochoice" == "arch" || "$twochoice" == "archlinux" ]]; then
    sudo pacman -S --needed --noconfirm flatpak
    exit 1
  elif [[ "$twochoice" == "ubuntu" || "$twochoice" == "endless" || "$twochoice" == "debian" || "$twochoice" == "popos" || "$twochoice" == "mint" || "$twochoice" == "kubuntu" ||"$twochoice" == "elementary" || "$twochoice" == "zorinos" || "$twochoice" == "zorin" || "$twochoice" == "deepin" || "$twochoice" == "pardus" || "$twochhoice" == "kdeneon" || "$twochoice" == "neon" ]]; then
    sudo apt update
    sudo apt install -y flatpak
    exit 1
  elif [[ "$twochoice" == "fedora" || "$twochoice" == "rocky" || "$twochoice" == "rhel" || "$twochoice" == "mageia" ]]; then
    sudo dnf install -y flatpak
    exit 1
  else
    echo "unsupport distro/os. sooo sorryyyy"
    exit 1
  fi
else
  echo "yes/y or no/n please"
fi
