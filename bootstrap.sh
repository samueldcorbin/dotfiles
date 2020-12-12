#!/bin/bash
# Bootstraps/updates samueldcorbin's preferred working environment

echo "Updating packages..."
sudo apt-get -y update
sudo apt-get -y install zsh tmux vim git unzip wget
echo "...done."

if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo "No default SSH key found, generating new default:"
    mkdir -m 700 -p "$HOME/.ssh"
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
    git config --global push.default "simple"
    git config --global core.autocrlf "input"

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
    echo "Adding base16-tomorrow-night vim colorscheme."
    wget -O "$HOME/.dotfiles/downloads/base16-tomorrow-night.vim" "https://raw.githubusercontent.com/chriskempson/base16-vim/master/colors/base16-tomorrow-night.vim"
    mkdir -p "$HOME/.vim/colors"
    ln -s "$HOME/.dotfiles/downloads/base16-tomorrow-night.vim" "$HOME/.vim/colors/base16-tomorrow-night.vim"
    echo "...done."
fi

if [ $SHELL != "/bin/zsh" ]; then
    echo "Setting shell to zsh."
    chsh -s "/bin/zsh"
    echo "Restart to change shell."
fi

echo "All done."
