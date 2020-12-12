# Prompt
autoload -Uz promptinit
promptinit
prompt adam1

# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Beep
unsetopt beep

# Vim-like bindings
bindkey -v
# Allow backspace beyond start of append
bindkey -v '^?' backward-delete-char
bindkey -v '^h' backward-delete-char
# Decrease delay on switch to Normal mode
export KEYTIMEOUT=1

# Autocomplete
# Smartcase
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}'
autoload -Uz compinit
compinit

# Set default editor
export EDITOR=vim
