#!/bin/bash
# Bootstraps/updates samueldcorbin's preferred working environment

# Disable screen lock first so we don't get locked out while updating packages
if [ "$(gsettings get "org.gnome.desktop.screensaver" "lock-enabled")" = "true" ]; then
    gsettings set "org.gnome.desktop.screensaver" "lock-enabled" "false"
    echo "Disabled screen lock."
fi
if [ "$(gsettings get "org.gnome.desktop.session" "idle-delay")" != "uint32 900" ]; then
    gsettings set "org.gnome.desktop.session" "idle-delay" "900"
    echo "Set to turn screen off when inactive for 15 minutes."
fi
if [ "$(gsettings get "com.canonical.indicator.datetime" "time-format")" != "'24-hour'" ]; then
    gsettings set "com.canonical.indicator.datetime" "time-format" "24-hour"
    echo "Set clock to 24-hour."
fi
if [ "$(gsettings get "com.canonical.Unity.Launcher" "favorites")" != "['application://gnome-terminal.desktop', 'application://ubiquity.desktop', 'application://org.gnome.Nautilus.desktop', 'application://firefox.desktop', 'application://unity-control-center.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices']" ]; then
    gsettings set "com.canonical.Unity.Launcher" "favorites" "['application://gnome-terminal.desktop', 'application://ubiquity.desktop', 'application://org.gnome.Nautilus.desktop', 'application://firefox.desktop', 'application://unity-control-center.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices']"
    if [ "$(gsettings get "com.canonical.Unity.Devices" "blacklist")" != "['Floppy Disk']" ]; then
        echo "Floppy disk!"
        gsettings set "com.canonical.Unity.Devices" "blacklist" "['Floppy Disk']"
    fi
    echo "Set Launcher favorites."
fi

echo "Updating packages..."
sudo apt-get -y update
sudo apt-get -y dist-upgrade
sudo apt-get -y install zsh tmux vim git unzip wget
sudo apt-get -y autoremove
sudo apt-get -y autoclean
echo "...done."

if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo "No default SSH key found, generating new default:"
    ssh-keygen -f "$HOME/.ssh/id_rsa"
    echo "Public key:"
    cat "$HOME/.ssh/id_rsa.pub"
    echo "GitHub:    https://github.com/settings/keys"
    echo "Bitbucket: https://bitbucket.org/account/user/samueldcorbin/ssh-keys/"
    read -n 1 -p "Add key to GitHub/Bitbucket, then press any key to continue. "
    echo ""
fi

# Generate gitconfig here so we can get the paths right
if [ ! -h "$HOME/.gitconfig" ]; then
    echo "Generating gitconfig..."
    git config --global user.name "samueldcorbin" 
    git config --global user.email "samueldcorbin@gmail.com"
    git config --global pull.rebase "preserve"
    git config --global merge.ff "false"
    git config --global core.excludesfile "$HOME/.gitignore_global"
    git config --global format.pretty "short"
    git config --global log.abbrevCommit "true"
    git config --global log.decorate "auto"
    git config --global status.short "true"
    git config --global status.branch "true"
    git config --global merge.tool "vimdiff"
    git config --global mergetool.keepBackup "false"
    git config --global merge.conflictStyle "diff3"

    echo "...done."
fi

echo "Updating dotfiles..."
if [ ! -d "$HOME/.dotfiles" ]; then
    git clone "git@github.com:samueldcorbin/dotfiles.git" "$HOME/.dotfiles"
    # Remove loose bootstrap file
    if [ -f "bootstrap.sh" ]; then
        echo "Removing bootstrap.sh (tracked version in ~/.dotfiles/)."
        rm bootstrap.sh
    fi
else
    git -C "$HOME/.dotfiles" pull
fi

dotfiles="gitignore_global tmux.conf vimrc zshrc"
for file in $dotfiles; do
    if [ ! -h "$HOME/.$file" ]; then
        echo "Symlinking $file to home."
        ln -s "$HOME/.dotfiles/$file" "$HOME/.$file"
    fi
done
echo "...done."

if [ ! -h "$HOME/.fonts/Inconsolata-g.ttf" ]; then
    echo "Adding Inconsolata-g font."
    wget -O "$HOME/.dotfiles/downloads/inconsolata-g_font.zip" "http://www.fantascienza.net/leonardo/ar/inconsolatag/inconsolata-g_font.zip"
    unzip "$HOME/.dotfiles/downloads/inconsolata-g_font.zip" "Inconsolata-g.ttf" -d "$HOME/.dotfiles/downloads/"
    rm "$HOME/.dotfiles/downloads/inconsolata-g_font.zip"
    mkdir -p "$HOME/.fonts"
    ln -s "$HOME/.dotfiles/downloads/Inconsolata-g.ttf" "$HOME/.fonts/Inconsolata-g.ttf"
    echo "...done."
fi

if [ ! -f "$HOME/.vim/colors/base16-tomorrow-night.vim" ]; then
    echo "Adding base16-tomorrow-night colorscheme."
    wget -O "$HOME/.dotfiles/downloads/base16-tomorrow-night.vim" "https://raw.githubusercontent.com/chriskempson/base16-vim/master/colors/base16-tomorrow-night.vim"
    mkdir -p "$HOME/.vim/colors"
    ln -s "$HOME/.dotfiles/downloads/base16-tomorrow-night.vim" "$HOME/.vim/colors/base16-tomorrow-night.vim"
    wget -O "$HOME/.dotfiles/downloads/base16-tomorrow-night.sh" "https://raw.githubusercontent.com/chriskempson/base16-shell/master/scripts/base16-tomorrow-night.sh"
    # No easy way to detect if theme is already installed, so just do it at the same time as vim
    "$HOME/.dotfiles/gnome_terminal_theme.sh"
    echo "...done."
    echo "Restart terminal to fix colorscheme."
fi

restart_confirmation () {
    local confirm
    read -n 1 -p "Do you want to restart now? [y/n] " confirm
    confirm=$(echo "$confirm" | cut -c 1)
    echo ""
    if [ "$confirm" = "y" ]; then
        shutdown -r now
    elif [ "$confirm" = "n" ]; then
        true
    else
        restart_confirmation
    fi
}

# This must be last.
if [ $SHELL != "/bin/zsh" ]; then
    echo "Setting login-shell to zsh."
    chsh -s "/bin/zsh"
    restart_confirmation    
fi

echo "Done."
