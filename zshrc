autoload -Uz promptinit
promptinit
prompt adam1

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep

autoload -Uz compinit
compinit

# Use Base16 Shell colors
. "$HOME/.dotfiles/downloads/base16-tomorrow-night.sh"

export EDITOR=vim

if [ -f "$HOME/.dotfiles/zshrc_local" ]; then
    source "$HOME/.dotfiles/zshrc_local"
fi
