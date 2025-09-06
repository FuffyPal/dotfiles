#!/bin/bash

if which conda &>/dev/null; then
  conda_app="true"
  echo "$conda_app"
  conda install -y python-lsp-server
else
  conda_app="false"
  echo "$conda_app"
  exit 1
fi

if which npm &>/dev/null; then
  npm_app="true"
  echo "$npm_app"
  sudo npm i -g @taplo/cli yaml-language-server marksman bash-language-server
else
  npm_app="false"
  echo "$npm_app"
  exit 1
fi

if which rust-analyzer &>/dev/null; then
  rust_analyzer_app="true"
  echo "$rust_analyzer_app"
else
  rust_analyzer_app="false"
  echo "$rust_analyzer_app"
  exit 1
fi
