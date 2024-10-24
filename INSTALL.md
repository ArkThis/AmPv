# Installation of MPV as player for URI prefix "hires://"

## Overview

  0. Install required packages
  1. Create a "Desktop Launcher" (.desktop) for the desired application/script to call.
  2. Copy that launcher to `~/.local/share/applications/`
  3. Register that launcher with a certain URI scheme (using xdg-mime)
  4. Install the MPV Lua script for TCP remote control.

NOTE: If for some reason, the Desktop launcher should not be working (eg wrong path/executable) - there will be no error message, no nothing - just simply nothing happening - when you click a "hires://" link in your browser.

So make sure your launcher works properly before debugging the browser side.


## Install required packages

`$ sudo apt install mpv lua-socket php-cli xclip`

NOTE: Open `mpv` player at least once, so it creates its config folder in `~/.config/mpv`.

The package `xclip` is required for the feature "copy timecode to clipboard" to work.


## Download config

Download the `client_config` folder to `/srv/dva-profession/client_config`:

`$ svn checkout https://svn.code.sf.net/p/dva-profession/code/branches/202312-vrecordX/misc/client_config /srv/dva-profession/client_config`

This folder contains all necessary files required to setup ingest clients.


## Copy the desktop launcher

In `hires_player.desktop`, make sure the path/command is correct:

`Exec=/srv/dva-profession/client_config/mpv/hires/hires_player.php %u`


Then copy the file `hires_player.desktop` to `~/.local/share applications`:

`$ cp -av hires_player.desktop ~/.local/share/applications/`


## Register `hires:` URI prefix

Register this desktop launcher as application for the URI prefix "hires://", using "xdg-mime":

`$ xdg-mime default hires_player.desktop x-scheme-handler/hires`


To quickly check if your scheme was registered, run:

`$ cat ~/.config/mimeapps.list | grep hires`


## Install Lua script for remote controlling MPV

`$ cp -av /srv/dva-profession/client_config/mpv/config/* ~/.config/mpv/`

