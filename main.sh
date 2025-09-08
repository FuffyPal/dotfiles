echo "what is system??"
read -p "arch/fedora " choice
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
if [[ "$choice" == "arch" || "$choice" == "archlinux" ]]; then 
    chmod +x ./Scripts/Arch\ Linux/*
    echo "Is your system nvidia graphics card"
    read -p "y/n" twochoice
    twochoice=$(echo "$twochoice" | tr '[:upper:]' '[:lower:]')
    if [[ "$twochoice" == "y" || "$twochoice" == "yes" ]]; then 
        ./Scripts/Arch\ Linux/yay\ setup.sh
        ./Scripts/Arch\ Linux/App\ Install\ \{nvidia\}.sh

    elif [[ "$twochoice" == "n" || "$twochoice" == "no" ]]; then 
        ./Scripts/Arch\ Linux/yay\ setup.sh
        ./Scripts/Arch\ Linux/App\ Install.sh

elif [[ "$choice" == "fedora" || "$choice" == "fedora linux" ]]; then 
    chmod +x ./Scripts/Fedora/*
    echo "Is your system nvidia graphics card"
    read -p "y/n" twochoice
    twochoice=$(echo "$twochoice" | tr '[:upper:]' '[:lower:]')
    if [[ "$twochoice" == "y" || "$twochoice" == "yes" ]]; then 
        ./Scripts/Fedora/App\ Install\ \(nvidia\).sh

    elif [[ "$twochoice" == "n" || "$twochoice" == "no" ]]; then 
        ./Scripts/Fedora/App\ install.sh
else
    echo "unsupport distro"
    exit 1
fi
chmod +x ./Scripts/*
cd Scripts/
./flatpak.sh
./theme.sh
./zapret.sh
./dns.sh
./miniconda.sh
./langserver.sh 
./firewalld.sh