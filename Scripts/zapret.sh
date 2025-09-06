echo "helloowww it is zapret setup im wilkommennnn"
echo "
wget https://github.com/bol-van/zapret/releases/download/v71.4/zapret-v71.4.tar.gz
tar -xvf zapret-v71.4.tar.gz
rm -rf zapret-v71.4.tar.gz
cp ../Config/User_Config/Zapret/config ./zapret-v71.4/config.default
cd zapret-v71.4/
chmod +x install_easy.sh
./install_easy.sh
"
read -p "y/n " choice
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
if [[ "$choice" == "y" || "$choice" == "yes" ]]; then
  wget https://github.com/bol-van/zapret/releases/download/v71.4/zapret-v71.4.tar.gz
  tar -xvf zapret-v71.4.tar.gz
  rm -rf zapret-v71.4.tar.gz
  cp ../Config/User_Config/Zapret/config ./zapret-v71.4/config.default
  cd zapret-v71.4/
  chmod +x install_easy.sh
  ./install_easy.sh
  exit 1
else
  echo "tschüss"
  exit 1
fi
