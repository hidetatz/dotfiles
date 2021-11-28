set nocompatible

syntax enable
filetype plugin on

set belloff=all
set grepprg=git\ grep\ -I\ --line-number
set smartindent

set path+=**
set wildmenu
set wildignore+=*git/*

set cst

let g:netrw_banner=0
let g:netrw_liststyle=3
