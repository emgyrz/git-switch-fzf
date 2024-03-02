#!/bin/bash

set -e

SH_RC_FILE="$HOME/.bashrc"
GSF="git-switch-fzf"
SHARE_DIR="$HOME/.local/share/"
BIN_DIR="$HOME/.local/bin/"

msg() {
  echo "[$GSF/install.sh]: $1"
}

if [ -f "$HOME/.zshrc" ]; then
    SH_RC_FILE="$HOME/.zshrc"
fi

if [ ! -e "$SH_RC_FILE" ]; then
   msg "error: cannot get shell rc file"
else
  msg "shell rc file is $SH_RC_FILE"
fi


if ! [ -d "$SHARE_DIR" ]; then
  msg "create dir $SHARE_DIR"
  mkdir -p "$SHARE_DIR"
fi

if [ -d "$SHARE_DIR$GSF" ]; then
  msg "remove old $GSF repo"
  rm -rfI "$SHARE_DIR$GSF"
fi

msg "clone repo"
git clone --depth=1 https://github.com/emgyrz/git-switch-fzf "$SHARE_DIR$GSF"

if ! [ -d "$BIN_DIR" ]; then
  msg "create $BIN_DIR"
  mkdir -p "$BIN_DIR"
fi

msg "create symbolic link to $SHARE_DIR$GSF/$GSF script in $BIN_DIR"
rm -rfI "$BIN_DIR$GSF"

ln -s "$SHARE_DIR$GSF/$GSF" "$BIN_DIR$GSF"


if ! [[ $PATH == *"$BIN_DIR"* ]]; then
  msg "add $BIN_DIR to \$PATH variable"
  echo "export PATH=\$PATH:$BIN_DIR" >> "$SH_RC_FILE"
  
  if [[ $SH_RC_FILE == *".bashrc" ]]; then
    msg "update current env"
    . $SH_RC_FILE
  else
     msg "WARNING! dont forget to update your current env if you want to use $GSF immediately, e.g. 'source ~/.zshrc'" 
  fi
    
fi


msg "done"
