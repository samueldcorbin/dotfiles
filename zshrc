autoload -Uz promptinit
promptinit
prompt adam1

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep

autoload -Uz compinit
compinit

export EDITOR=vim
