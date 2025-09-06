if which git &>/dev/null; then
  git clone https://github.com/dpejoh/Adwaita-colors
  cd Adwaita-colors
  ./setup -i
  cd ../
  rm -rf Adwaita-colors
else
  echo "pleassee installl git"
fi
