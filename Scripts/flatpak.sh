echo "helloowww it is flatpak setup and flatpak app installing"
echo "Flatpak installed?"
read -p "y/n " choice
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
if [[ "$choice" == "y" || "$choice" == "yes" ]]; then
  echo "app list"
  echo "
    librewolf (firefox fork)
    Celluloid ( vlc alternative )
    Kooha ( secrean record )
    localsend_app
    spotify
    joplin_desktop ( obsidian and logseq alternative )
    Flatseal ( flatpak manager )
    ExtensionManager ( gnome extension manager)
    Thunderbird
    easyeffects
    FluffyChat
    mcpelauncher ( minecraft bedrock launcher )
    PrismLauncher ( minecraft java launcher )
    Steam
    telegram
    rewaita
    airshipper ( veloren launcher )
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
    io.gitlab.librewolf-community
    com.github.rafostar.Clapper
    io.github.seadve.Kooha
    org.telegram.desktop
    org.localsend.localsend_app
    app/com.github.tchx84.Flatseal
    com.github.maoschanz.drawing
    com.mattjakeman.ExtensionManager
    org.mozilla.Thunderbird
    com.github.wwmm.easyeffects
    io.github.swordpuffin.rewaita
    org.gtkhash.gtkhash
    org.gnome.Loupe
    im.fluffychat.Fluffychat
    de.haeckerfelix.Fragments
    com.spotify.Client
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
