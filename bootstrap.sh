#!/bin/bash
# Bootstraps/updates samueldcorbin's preferred working environment

echo "Updating packages..."
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install zsh tmux vim git curl
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
    ln -s "$HOME/.doftiles/zshrc" "$HOME/.zshrc"
fi
echo "...done."

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
