#!/bin/bash
# Bootstraps/updates samueldcorbin's preferred working environment

echo "Updating packages..."
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install zsh tmux vim git wget unzip
sudo apt-get -y autoremove
sudo apt-get -y autoclean
echo "...done."

if [ ! "$(git config --global user.email)" = "samueldcorbin@gmail.com" ]; then
    echo "Set git global user.email to samueldcorbin@gmail.com"
    git config --global user.email "samueldcorbin@gmail.com"
fi
if [ ! "$(git config --global user.name)" = "samueldcorbin" ]; then
    echo "Set git global user.name to samueldcorbin"
    git config --global user.name "samueldcorbin"
fi

if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo "No default SSH key found, generating new default:"
    ssh-keygen -f "$HOME/.ssh/id_rsa"
    echo "Public key:"
    cat "$HOME/.ssh/id_rsa.pub"
    echo "GitHub: https://github.com/settings/keys"
    echo "Bitbucket: https://bitbucket.org/account/user/samueldcorbin/ssh-keys/"
    read -n 1 -p "Add key to GitHub/Bitbucket, then press any key to continue. "
    echo ""
fi

echo "Updating dotfiles..."
if [ ! -d "$HOME/.dotfiles" ]; then
    git clone "git@github.com:samueldcorbin/dotfiles.git" "$HOME/.dotfiles"
    if [ -f "bootstrap.sh" ]; then
        echo "Removing bootstrap.sh (tracked version in ~/.dotfiles/)."
        rm bootstrap.sh
    fi
else
    git -C "$HOME/.dotfiles" pull
fi

if [ ! -h "$HOME/.tmux.conf" ]; then
    echo "Symlinking tmux.conf to home."
    ln -s "$HOME/.dotfiles/tmux.conf" "$HOME/.tmux.conf"
fi
if [ ! -h "$HOME/.vimrc" ]; then
    echo "Symlinking vimrc to home."
    ln -s "$HOME/.dotfiles/vimrc" "$HOME/.vimrc"
fi
if [ ! -h "$HOME/.zshrc" ]; then
    echo "Symlinking zshrc to home."
    ln -s "$HOME/.dotfiles/zshrc" "$HOME/.zshrc"
fi
echo "...done."

if [ ! -h "$HOME/.fonts/Inconsolata-g.ttf" ]; then
    echo "Adding Inconsolata-g font."
    if [ ! -f "$HOME/.dotfiles/downloads/inconsolata-g_font.zip" ]; then
        wget -O "$HOME/.dotfiles/downloads/inconsolata-g_font.zip" "http://www.fantascienza.net/leonardo/ar/inconsolatag/inconsolata-g_font.zip"
    fi
    mkdir -p "$HOME/.fonts"
    unzip "$HOME/.dotfiles/downloads/inconsolata-g_font.zip" "Inconsolata-g.ttf" -d "$HOME/.dotfiles/downloads/"
    ln -s "$HOME/.dotfiles/downloads/Inconsolata-g.ttf" "$HOME/.fonts/Inconsolata-g.ttf"
    echo "...done."
fi

if [ ! -f "$HOME/.vim/colors/Tomorrow-Night.vim" ]; then
    echo "Adding Tomorrow-Night colorscheme."
    mkdir -p "$HOME/.vim/colors"
    wget -O "$HOME/.dotfiles/downloads/Tomorrow-Night.vim" "https://raw.githubusercontent.com/chriskempson/tomorrow-theme/master/vim/colors/Tomorrow-Night.vim"
    ln -s "$HOME/.dotfiles/downloads/Tomorrow-Night.vim" "$HOME/.vim/colors/Tomorrow-Night.vim"
    # No easy way to detect if theme is already installed, so just do it at the same time as vim
    "$HOME/.dotfiles/gnome_terminal_theme.sh"
    echo "...done."
fi

restart_confirmation () {
    local confirm
    read -p "Do you want to restart now? [y/n] " confirm
    confirm=$(echo $confirm | cut -c 1)
    if [ $confirm = "y" ]; then
        shutdown -r now
    elif [ $confirm = "n" ]; then
        true
    else
        restart_confirmation
    fi
}

# This must be last.
if [ ! $SHELL = "/bin/zsh" ]; then
    echo "Setting login-shell to zsh."
    chsh -s "/bin/zsh"
    restart_confirmation    
fi

echo "Done."
