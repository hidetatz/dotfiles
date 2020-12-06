if empty(glob('$HOME/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('$HOME/.vim/plugged')
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-goimports'
  Plug 'mileszs/ack.vim'
  Plug 'ctrlpvim/ctrlp.vim'
call plug#end()

let mapleader = ","

colorscheme peachpuff

set encoding=utf-8
set hidden
set clipboard+=unnamed
set noerrorbells
set number
set incsearch
set hlsearch
set ignorecase
set noswapfile
set nobackup
set autoindent 

hi Comment ctermfg=gray

" open a file at last-closed line
au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
" do not keep being in comment lines when inserting a new line
au FileType * set fo-=c fo-=r fo-=o
" close quickfix automatically when close vim
au WinEnter * if winnr('$') == 1 && &buftype == "quickfix" | q | endif
" always use quickfix to show vimgrep result
au QuickFixCmdPost vimgrep cwindow
" write copyright at the top
au BufNewFile *.go,*.cpp call append(0, "// Copyright © 2020 Hidetatsu Yaginuma. All rights reserved.")

func! s:go_main_template()
  call append(2, 'package main')
  call append(3, '')
  call append(4, 'func main() {')
  call append(5, '')
  call append(6, '}')
endf
au BufNewFile main.go call s:go_main_template()

nnoremap x "_x
nnoremap Y y$
nnoremap <Esc><Esc> :nohl<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <silent> <Space><Space> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>
nnoremap gh :!echo `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line('.')<CR> \| xargs open<CR><CR>
nnoremap gm :!echo `git url`/blob/master/%\#L<C-R>=line('.')<CR> \| xargs open<CR><CR>
nnoremap <C-n> :cnext<CR>
nnoremap <C-p> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" lsp
if executable('gopls')
    au User lsp_setup call lsp#register_server({'name': 'gopls', 'cmd': {server_info->['gopls']}, 'whitelist': ['go']})
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    nmap <buffer> <leader>d <plug>(lsp-definition)
    nmap <buffer> <leader>h <plug>(lsp-hover)
endfunction

augroup lsp_install
    au!
    au User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_enabled = 0
let g:lsp_highlights_enabled = 0
let g:lsp_textprop_enabled = 0
let g:lsp_highlight_references_enabled = 0

" ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMixed'

" ack.vim
cnoreabbrev Ack Ack!

if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

" WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif
