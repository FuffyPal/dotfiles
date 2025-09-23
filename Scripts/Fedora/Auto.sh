#!/bin/bash

./Fedora_Install.sh
cd ../
./dns.sh
./firewalld.sh
yes | ./flatpak.sh
yes | ./miniconda.sh
./zapret.sh
yes | ./langserver.sh
./theme.sh
