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
nnoremap <silent> [t :tprevious<CR>zv
nnoremap <silent> ]t :tnext<CR>zv

let g:netrw_liststyle=3

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

au QuickFixCmdPost [^l]* cwindow
au QuickFixCmdPost l*    lwindow

if expand('%:e') == 'c' || expand('%:e') == 'cc' || expand('%:e') == 'h'
	set expandtab tabstop=2 softtabstop=2 shiftwidth=2
	set formatprg=clang-format
	au BufWritePost * normal gggqG
endif

if expand('%:e') == 'py'
	set formatprg=yapf
	au BufWritePost * normal gggqG
endif

if expand('%:e') == 'go'
	set formatprg=goimports
	au BufWritePost * normal gggqG
endif
