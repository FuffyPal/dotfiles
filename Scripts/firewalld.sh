echo "helloowww it is firewalld settings setup"
echo "Firewalld Installed ?"
read -p "y/n " choice
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
if [[ "$choice" == "y" || "$choice" == "yes" ]]; then
  ip -br a
  echo "what is yourr interface??"
  read -p "enter pleasee: " interface
  echo "defualt zone block and your $interface home zone."
  echo "localsend app for 53317/tcp and 53317/udp opened"
  echo "kdeconnect app for 1714 to 1764 and tcp/udp opened"
  echo "steam remote game for UDP ports 27031 and 27036 , TCP ports 27036 and 27037  last one For VR Streaming, UDP ports 10400 and 10401"
  read -p "y/n " twochoice
  twochoice=$(echo "$twochoice" | tr '[:upper:]' '[:lower:]')
  if [[ "$twochoice" == "y" || "$twochoice" == "yes" ]]; then
    sudo firewall-cmd --set-default-zone=block
    sudo firewall-cmd --remove-interface=$interface --zone=block
    sudo firewall-cmd --add-interface=$interface --zone=home
    sudo firewall-cmd --zone=home --add-port=53317/tcp
    sudo firewall-cmd --zone=home --add-port=53317/udp 
    sudo firewall-cmd --zone=home --add-port=1714-1764/tcp
    sudo firewall-cmd --zone=home --add-port=1714-1764/udp
    sudo firewall-cmd --zone=home --add-port=27031/udp
    sudo firewall-cmd --zone=home --add-port=27036/udp
    sudo firewall-cmd --zone=home --add-port=27036/tcp
    sudo firewall-cmd --zone=home --add-port=27037/tcp
    sudo firewall-cmd --zone=home --add-port=10401/udp
    sudo firewall-cmd --zone=home --add-port=10400/udp
    sudo firewall-cmd --runtime-to-permanent
    sudo firewall-cmd --reload
  else
    exit 1
  fi

elif [[ "$choice" == "n" || "$choice" == "no" ]]; then
  echo "okey tschüüss"
else
  echo "plsss enterrr y/n"
  exit 1
fi
