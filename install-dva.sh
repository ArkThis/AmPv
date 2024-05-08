#!/bin/bash

# This script is used to install AmPv as QC-check player in a DVA-Profession environment.
# See [Project Website](https://www.av-rd.com/products/dva-profession/) for details.

MPV_CONF="$HOME/.config/mpv"                    # User config for MPV
DIR_LAUNCHERS="/usr/share/applications"         # Collection of application launchers

DVA_DIR="/srv/dva-profession"                   # Local DVA base folder
DVA_WORKFLOW="$DVA_DIR/workflow"                # Workflow structure
DVA_CLIENT_CONFIG="$DVA_DIR/client_config"      # Configuration for the ingest client

# -------------------------------------------


# Abort execution if any error occurs:
set -e

echo ""
echo "Installing required packages..."
sudo apt install mpv lua-socket php-cli

echo ""
echo "Copy the hires-URI launcher to local pool in '$DIR_LAUNCHERS'..." 
sudo cp -v hires/hires_player.desktop $DIR_LAUNCHERS

echo ""
echo "And associate the URI prefix 'hires://' with it..."
xdg-mime default hires_player.desktop x-scheme-handler/hires

echo ""
echo "If the next line shows an entry with x-scheme-handler and hires, we're good:"
cat $HOME/.config/mimeapps.list | grep hires

echo ""
echo "Symlinking MPVs local user config to DVA folder..."
if [ -h "$MPV_CONF" ]; then
    echo "MPV user config already is a symbolic link. Deleting it."
    rm $MPV_CONF
fi

if [ -d "$MPV_CONF" ]; then
    echo "MPV user config already exists. Moving it to ~/MPV_config-OLD:"
    mv -v $MPV_CONF "$HOME/MPV_config-OLD"
fi

# Creating symbolic link to config to avoid confusion and consistent behavior:
ln -sv "$DVA_CLIENT_CONFIG/mpv/config" "$MPV_CONF"
