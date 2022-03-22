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
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [Q :cfirst<CR>
nnoremap <silent> ]Q :clast<CR>

nnoremap <silent> [l :lprevious<CR>zv
nnoremap <silent> ]l :lnext<CR>zv
nnoremap <silent> [L :lfirst<CR>zv
nnoremap <silent> ]L :llast<CR>zv

nnoremap <silent> [t :tprevious<CR>zv
nnoremap <silent> ]t :tnext<CR>zv
nnoremap <silent> [T :tfirst<CR>zv
nnoremap <silent> ]T :tlast<CR>zv

let g:netrw_liststyle=3

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

au QuickFixCmdPost [^l]* cwindow
au QuickFixCmdPost l*    lwindow

au FileType go compiler go
au BufWritePost *.go silent! !ctags -R &

" copied from :h hex-editing
augroup Binary
  au!
  au BufReadPre  *.bin,*.out let &bin=1
  au BufReadPost *.bin,*.out  if &bin | %!xxd
  au BufReadPost *.bin,*.out  set ft=xxd | endif
  au BufWritePre *.bin,*.out  if &bin | %!xxd -r
  au BufWritePre *.bin,*.out  endif
  au BufWritePost *.bin,*.out  if &bin | %!xxd
  au BufWritePost *.bin,*.out  set nomod | endif
augroup END
