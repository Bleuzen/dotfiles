#!/bin/bash

#!/bin/bash

if [[ $EUID -eq 0 ]];
then
    echo "Do not run this as root"
    exit
fi

echo "To apply the changes, you will be logged out. Save all of your work now!"
read -p "Press enter to continue..."

function change_konsole_shell_fish {
    kwriteconfig5 --file "/home/$USER/.local/share/konsole/Fish.profile" --group General --key Name --type string "Fish"
    kwriteconfig5 --file "/home/$USER/.local/share/konsole/Fish.profile" --group General --key Command --type string /usr/bin/fish
    kwriteconfig5 --file "/home/$USER/.config/konsolerc" --group "Desktop Entry" --key "DefaultProfile" --type string "Fish.profile"
}

function kde_configs {
    kwriteconfig5 --file kcminputrc --group Keyboard --key NumLock --type int 0
    kwriteconfig5 --file klipperrc --group General --key KeepClipboardContents --type bool false
    kwriteconfig5 --file ksmserverrc --group General --key confirmLogout --type bool false
    kwriteconfig5 --file ksmserverrc --group General --key loginMode --type string emptySession
    kwriteconfig5 --file kwinrc --group NightColor --key Active --type bool true
    kwriteconfig5 --file kwinrc --group MouseBindings --key CommandAllKey --type string Meta
    kwriteconfig5 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft --type string MF
    kwriteconfig5 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight --type string IAX
    kwriteconfig5 --file kwinrc --group Plugins --key CommandAllKey --type string Meta
    kwriteconfig5 --file kwinrc --group Plugins --key blurEnabled --type bool true
    kwriteconfig5 --file kwinrc --group Plugins --key sheetEnabled --type bool true
    kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_dimscreenEnabled --type bool true
}

function global_shortcuts {
    sed -i 's/Expose=Ctrl+F9,/Expose=Ctrl+F9\\\tMeta+A,/g' ~/.config/kglobalshortcutsrc
    sed -i 's/Window Close=Alt+F4,/Window Close=Alt+F4\\\tMeta+Q,/g' ~/.config/kglobalshortcutsrc
    sed -i 's/Window Maximize=Meta+PgUp,/Window Maximize=Meta+PgUp\\\tMeta+W,/g' ~/.config/kglobalshortcutsrc
}

function logout {
    qdbus org.kde.ksmserver /KSMServer logout 0 3 3
}

change_konsole_shell_fish
kde_configs
global_shortcuts
logout
