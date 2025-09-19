#!/bin/bash

./Fedora_Install.sh
yes | ../dns.sh
../firewalld.sh
yes | ../flatpak.sh
yes | ../miniconda.sh
yes | ../zapret.sh
yes | ../langserver.sh
../theme.sh
