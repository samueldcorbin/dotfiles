set nocompatible

filetype indent plugin on
syntax enable

set termguicolors
colorscheme base16-tomorrow-night

let &t_SI = "\<Esc>[5 q"
let &t_SR = "\<Esc>[3 q"
let &t_EI = "\<Esc>[2 q"
autocmd VimEnter * silent exec '!echo -ne "\e[2 q"' | redraw!
autocmd VimLeave * silent !echo -ne "\e[5 q"

set ttimeoutlen=100

set belloff=all

set autoindent
set smartindent
set backspace=indent,eol,start
set complete-=i
set smarttab
set nrformats-=octal
set incsearch
set laststatus=2
set ruler
set wildmenu
set scrolloff=1
set sidescrolloff=5
set display+=lastline
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set formatoptions+=j

set autoread
set history=1000
set tabpagemax=50

set sessionoptions-=options

set showcmd
set ignorecase
set smartcase
set nostartofline
set ruler
set cmdheight=2
set number

set hlsearch
set incsearch
set lazyredraw
set showmatch
set matchtime=2
set wrap

set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
