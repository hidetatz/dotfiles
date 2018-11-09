set nocompatible

call plug#begin('~/.vim/plugged')
  Plug 'airblade/vim-gitgutter'
  Plug 'cocopon/iceberg.vim'
	Plug 'ctrlpvim/ctrlp.vim'
  Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
  Plug 'hashivim/vim-terraform'
  Plug 'junegunn/fzf.vim'
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitivE'
  Plug 'tpope/vim-surround'
  Plug 'w0rp/ale'
  Plug 'w0ng/vim-hybrid'
	Plug 'zchee/deoplete-go', { 'do': 'make'}
call plug#end()

filetype plugin indent on

"----------------------------------------------------------------------------
" Edit
"----------------------------------------------------------------------------
let mapleader = ","
set encoding=utf-8
set ambiwidth=double
set tabstop=2
set shiftwidth=2
set autoindent

" yank to remote
let g:y2r_config = {
  \   'tmp_file': '/tmp/exchange_file',
  \   'key_file': expand('$HOME') . '/.exchange.key',
  \   'host': 'localhost',
  \   'port': 52224,
  \}

function Yank2Remote()
  call writefile(split(@", '\n'), g:y2r_config.tmp_file, 'b')
  let s:params = ['cat %s %s | timeout 1 nc %s %s']
  for s:item in ['key_file', 'tmp_file', 'host', 'port']
      let s:params += [shellescape(g:y2r_config[s:item])]
  endfor
  let s:ret = system(call(function('printf'), s:params))
endfunction
nnoremap <unique> <Leader>f :call Yank2Remote()<CR>

augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END

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
noremap x "_x
noremap <Esc><Esc> :nohl<CR>
nnoremap <Leader>w :w<CR>
nnoremap <silent> <Space><Space> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>


"----------------------------------------------------------------------------
" deoplete
"----------------------------------------------------------------------------
let g:deoplete#enable_at_startup = 1

"----------------------------------------------------------------------------
" deoplete-go
"----------------------------------------------------------------------------
let g:deoplete#sources#go#gocode_binary	= "$GOPATH/bin/gocode"
let g:deoplete#sources#go#package_dot = 0
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#cgo	= 1
let g:deoplete#sources#go#pointer = 1
let g:deoplete#sources#go#auto_goos = 1
let g:deoplete#sources#go#source_importer	= 1
let g:deoplete#sources#go#builtin_objects	= 1

"----------------------------------------------------------------------------
" ale
"----------------------------------------------------------------------------
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 0


"----------------------------------------------------------------------------
" ctrlp
"----------------------------------------------------------------------------
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

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
