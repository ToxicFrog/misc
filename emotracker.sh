#!/usr/bin/env bash
# A simple shell script to install and run EmoTracker in Wine.
# Tested with Wine 4.0 RC2 and Winetricks 20181203, but will probably work in
# older versions as long as they support .NET 4.6.x.
# Sets up EmoTracker in its own wineprefix so that it doesn't conflict with
# other stuff you might have installed that uses 4.0 or older versions of .NET.
# To uninstall, run as "emotracker.sh uninstall". It'll delete the wineprefix
# and the start menu entries. Your downloaded trackers and saved games will
# be left alone.
#
# Note: the installation process is unattended (no windows/dialogs) and VERY
# SLOW; you may need to wait ten minutes or more for it to complete. It also
# requires a net connection, since it downloads both EmoTracker and .NET.

# Install location. Edit as desired. Must be an absolute path!
export WINEPREFIX="$HOME/Games/EmoTracker"

# Actual install script starts here.
set -e

function install_emotracker {
  mkdir -p "$WINEPREFIX"
  winetricks -q dotnet462
  curl https://emotracker.net/service/install/emotracker_setup.exe > /tmp/$$.exe
  wine /tmp/$$.exe /VERYSILENT
  rm -f /tmp/$$.exe
  echo "Installation of EmoTracker complete!"
}

function uninstall_emotracker {
  rm -rf "$WINEPREFIX" ~/.local/share/applications/wine/EmoTracker
}

if [[ $1 == "uninstall" ]]; then
  echo "Uninstalling EmoTracker..."
  uninstall_emotracker
  exit $?
fi

if [[ ! -d $WINEPREFIX ]]; then
  echo "Emotracker doesn't appear to be installed. Installing it..."
  install_emotracker
fi

echo "Starting EmoTracker..."
wine 'C:/windows/command/start.exe' /wait 'c:/ProgramData/Microsoft/Windows/Start Menu/Programs/EmoTracker/EmoTracker.lnk'
