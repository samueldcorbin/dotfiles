#!/bin/bash
# Bootstraps/updates samueldcorbin's preferred working environment

echo "Updating packages..."
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install zsh tmux vim git wget
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

echo "Adding Tomorrow-Night colorscheme."
if [ ! -f "$HOME/.vim/colors/Tomorrow-Night.vim" ]; then
    mkdir -p "$HOME/.vim/colors"
    wget -O "$HOME/.dotfiles/downloads/Tomorrow-Night.vim" "https://raw.githubusercontent.com/chriskempson/tomorrow-theme/master/vim/colors/Tomorrow-Night.vim"
    ln -s "$HOME/.dotfiles/downloads/Tomorrow-Night.vim" "$HOME/.vim/colors/Tomorrow-Night.vim"
fi
if [ ! -f "$HOME/.dotfiles/downloads/setup-theme.sh" ]; then
    wget -O "$HOME/.dotfiles/downloads/setup-theme.sh" "https://raw.githubusercontent.com/chriskempson/tomorrow-theme/master/Gnome-Terminal/setup-theme.sh"
    chmod +x "$HOME/.dotfiles/downloads/setup-theme.sh"
    "$HOME/.dotfiles/downloads/setup-theme.sh"
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
