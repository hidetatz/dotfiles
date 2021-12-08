syntax enable
filetype plugin on

set noswapfile
set viminfo='100,h
set showmatch
set ignorecase
set smartcase
set hlsearch
set incsearch
set autowrite
set belloff=all
set grepprg=git\ grep\ -I\ --line-number
set smartindent

set path+=**
set wildmenu
set wildignore+=*git/*

nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>

nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>

nnoremap <silent> [l :lprevious<CR>zv
nnoremap <silent> ]l :lnext<CR>zv

let g:netrw_banner=0
let g:netrw_liststyle=3

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

au FileType go compiler go
au QuickFixCmdPost [^l]* cwindow
au QuickFixCmdPost l*    lwindow

au BufWritePost *.go silent! !ctags -R &
