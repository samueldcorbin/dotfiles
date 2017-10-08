autoload -Uz promptinit
promptinit
prompt adam1

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -v

autoload -Uz compinit
compinit

# Use Base16 Shell colors
. "$HOME/.dotfiles/downloads/base16-tomorrow-night.sh"

export EDITOR=vim
export VISUAL=vim
