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

au FileType go compiler go
au BufWritePost *.go silent! !ctags -R &

au QuickFixCmdPost [^l]* cwindow
au QuickFixCmdPost l*    lwindow

function! s:clang_format()
  let now_line = line(".")
  exec ":%! clang-format -style=Google"
  exec ":" . now_line
endfunction

if executable('clang-format')
  augroup cpp_clang_format
    autocmd!
    autocmd BufWrite,FileWritePre,FileAppendPre *.[ch]pp call s:clang_format()
  augroup END
endif

function! GoImports()
  let saved_view = winsaveview()
  silent %!goimports
  if v:shell_error > 0
    cexpr getline(1, '$')->map({ idx, val -> val->substitute('<standard input>', expand('%'), '') })
    silent undo
    cwindow
  else
    cclose
  endif
  call winrestview(saved_view)
endfunction

command! GoImports call GoImports()

augroup go_autocmd
  autocmd BufWritePre *.go GoImports
augroup END
