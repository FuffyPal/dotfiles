echo "hellowww how are u what anyway"
echo "you os archlinux or not"
read -p "y/n " choice
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
if [[ "$choice" == "y" || "$choice" == "yes" ]]; then
    echo "hello world ..."
    echo "
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ../
    rm -rf yay"
    echo "heyy do u confirm"
    read -p "y/n" twochoice
    twochoice=$(echo "$twochoice" | tr '[:upper:]' '[:lower:]')
    if [[ "$twochoice" == "y" || "$twochoice" == "yes" ]]; then
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ../
        rm -rf yay
        echo "yay setupppp finshhh tschüssss ... "
        exit 1
    else
        echo "byyyy ... "
        exit 1
    fi

elif [[ "$choice" == "n" || "$choice" == "no" ]]; then
    echo "Owwww okey tchüss ..."
    exit 1 
else
    echo "Please Y or N ..."
fi
