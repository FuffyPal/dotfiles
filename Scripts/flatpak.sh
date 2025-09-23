echo "helloowww it is flatpak setup and flatpak app installing"
echo "Flatpak installed?"
read -p "y/n " choice
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
if [[ "$choice" == "y" || "$choice" == "yes" ]]; then
  echo "app list"
  echo "
    firefox
    Celluloid ( vlc alternative )
    Kooha ( secrean record )
    localsend_app
    joplin_desktop ( obsidian and logseq alternative )
    Flatseal ( flatpak manager )
    ExtensionManager ( gnome extension manager)
    Thunderbird
    easyeffects
    FluffyChat 
    mcpelauncher ( minecraft bedrock launcher )
    PrismLauncher ( minecraft java launcher )
    Steam
    rewaita
    airshipper ( veloren launcher )
    Vesktop ( discord )
    ente auth
  "
  echo "heyy do u confirm"
  read -p "y/n " twochoice
  twochoice=$(echo "$twochoice" | tr '[:upper:]' '[:lower:]')
  if [[ "$twochoice" == "y" || "$twochoice" == "yes" ]]; then
    #FLATPAK DEFUALT
    FLATPAK_INSTALL="flatpak install -y"
    FLATPAK_REMOVE="flatpak uninstall -y --all"
    FLATPAK_REPO_ADD="flatpak remote-add --if-not-exists --user"

    #FLATPAK REPO LIST
    FRL_FLATHUB="flathub https://dl.flathub.org/repo/flathub.flatpakrepo"
    #FLATPAK APP LIST
    FPL_REAL="--user flathub 
    org.mozilla.firefox
    io.github.celluloid_player.Celluloid
    io.github.seadve.Kooha
    org.localsend.localsend_app
    app/com.github.tchx84.Flatseal
    com.mattjakeman.ExtensionManager
    org.mozilla.Thunderbird
    com.github.wwmm.easyeffects
    io.mrarm.mcpelauncher
    io.github.swordpuffin.rewaita
    org.prismlauncher.PrismLauncher
    im.fluffychat.Fluffychat
    com.valvesoftware.Steam
    net.veloren.airshipper
    dev.vencord.Vesktop
    dev.deedles.Trayscale
    net.cozic.joplin_desktop
    io.ente.auth
    "
    echo "Flatpak repolarrı ekleniyor"
    ${FLATPAK_REPO_ADD} ${FRL_FLATHUB}
    echo "flatpak uygulamaları yükleniyor"
    ${FLATPAK_INSTALL} ${FPL_REAL}
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

