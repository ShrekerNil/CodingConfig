#!/bin/bash

echo -e 'backing up settings.json ...\n'
cp /c/Users/Shreker/AppData/Roaming/Code/User/settings.json ./settings/settings.json

echo -e 'backing up keybindings.json ...\n'
cp /c/Users/Shreker/AppData/Roaming/Code/User/keybindings.json ./settings/keybindings.json

echo -e '\n'
read -p "PRESSING ENTER TO EXIT ... "
