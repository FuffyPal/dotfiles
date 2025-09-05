echo "helloowww it is zapret config setup"
echo "
sudo rm /opt/zapret/config
sudo cp ../Config/Zapret/config /opt/zapret/config
sudo systemctl enable --now zapret.service 
"
read -p "y/n " choice
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
if [[ "$choice" == "y" || "$choice" == "yes" ]]; then
  sudo rm /opt/zapret/config
  sudo cp ../Config/Zapret/config /opt/zapret/config
  sudo systemctl enable --now zapret.service
  exit 1
else
  echo "tschüss"
  exit 1
fi
