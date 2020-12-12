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
export KEYTIMEOUT=10

# Autocomplete
# Smartcase
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}'
autoload -Uz compinit
compinit

# Set default editor
export EDITOR=vim

# vi-mode cursors
zle-line-init() {
    echo -ne "\e[5 q"
}
zle-keymap-select() {
    if [[ $KEYMAP == "vicmd" ]]; then
        echo -ne "\e[2 q"
    else
        echo -ne "\e[5 q"
    fi
}
zle -N zle-keymap-select
