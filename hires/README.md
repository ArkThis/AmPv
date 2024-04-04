# How to register custom command for "hires://"

## Overview

  1. Create a "Desktop Launcher" (.desktop) for the desired application/script to call.
  2. Copy that launcher to `~/.local/share/applications/`
  3. Register that launcher with a certain URI scheme (using xdg-mime)


NOTE: If for some reason, the Desktop launcher should not be working (eg wrong path/executable) - there will be no error message, no nothing - just simply nothing happening - when you click a "hires://" link in your browser.

So make sure your launcher works properly before debugging the browser side.


## Details

Create the following `hires_player.desktop` file somewhere:

```
[Desktop Entry]
Name=Hires Player
Exec=/path/to/wherever/it/is/hires_player.php %u
Icon=emacs-icon
Type=Application
Terminal=true
MimeType=x-scheme-handler/hires;
```

Copy that launcher to the user's local application-launchers folder:

`$ cp -av hires_player.desktop ~/.local/share/applications/`


Register that application for the URI prefix "hires://", using "xdg-mime":

`$ xdg-mime default hires_player.desktop x-scheme-handler/hires`


The user's local `mimeapps.list` should now contain this handle for "hires://" now:

```
[Default Applications]
...
x-scheme-handler/hires=hires_player.desktop
```

To quickly check if your scheme was registered, run:

`$ cat ~/.config/mimeapps.list | grep hires`




## Infos

https://wiki.archlinux.org/title/XDG_MIME_Applications
