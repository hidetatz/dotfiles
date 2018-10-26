set nocompatible

call plug#begin('~/.vim/plugged')
  Plug 'airblade/vim-gitgutter'
  Plug 'cocopon/iceberg.vim'
  Plug 'fatih/vim-go'
  Plug 'hashivim/vim-terraform'
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitivE'
  Plug 'tpope/vim-surround'
  Plug 'w0rp/ale'
  Plug 'w0ng/vim-hybrid'
call plug#end()

filetype plugin indent on

"----------------------------------------------------------------------------
" Edit
"----------------------------------------------------------------------------
set encoding=utf-8
set ambiwidth=double
set tabstop=2
set shiftwidth=2
set autoindent

"----------------------------------------------------------------------------
" UI
"----------------------------------------------------------------------------
syntax on
set number
set ruler
set statusline=%<%f\ %{fugitive#statusline()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set background=dark
set showcmd
colorscheme iceberg

"----------------------------------------------------------------------------
" etc
"----------------------------------------------------------------------------
set incsearch
set hlsearch
set ignorecase
set ttimeout
set ttimeoutlen=50

"----------------------------------------------------------------------------
" Key mappings
"----------------------------------------------------------------------------
let mapleader = ","
noremap x "_x
noremap <Esc><Esc> :nohl<CR>
nnoremap <Leader>w :w<CR>
nnoremap <silent> <Space><Space> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>

"----------------------------------------------------------------------------
" ale
"----------------------------------------------------------------------------
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 0

"----------------------------------------------------------------------------
" fzf.vim
"----------------------------------------------------------------------------
" for fzf installed by homebrew
set rtp+=/usr/local/opt/fzf

nmap ; :Buffers
nmap t :Files
" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~30%' }

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)
nmap m :GGrep

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

"----------------------------------------------------------------------------
" vim-gitgutter
"----------------------------------------------------------------------------
let g:gitgutter_sign_added = '∙'
let g:gitgutter_sign_modified = '∙'
let g:gitgutter_sign_removed = '∙'
let g:gitgutter_sign_modified_removed = '∙'

"----------------------------------------------------------------------------
" vim-commentary
"----------------------------------------------------------------------------
autocmd BufRead,BufNewFile *.tf setfiletype terraform
autocmd BufRead,BufNewFile *.tfvars setfiletype terraform
autocmd FileType terraform setlocal commentstring=//\ %s

"----------------------------------------------------------------------------
" Golang
"----------------------------------------------------------------------------
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_autosave = 1
let g:go_gocode_unimported_packages = 1
let g:go_fmt_command = "goimports"

augroup GoAutoCmd
  au!
  au FileType go :highlight goErr cterm=bold ctermfg=lightblue
  au FileType go :match goErr /\<err\>/
augroup END

"----------------------------------------------------------------------------
" vim-terraform
"----------------------------------------------------------------------------
let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_remap_spacebar=1
let g:terraform_fmt_on_save = 1
