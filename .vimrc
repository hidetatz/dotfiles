" vim-plug
" When update, call `:source ~/.vimrc` and `:PlugInstall`
call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go'
Plug 'Shougo/neocomplcache'
Plug 'airblade/vim-gitgutter'
Plug 'elzr/vim-json'
Plug 'mattn/webapi-vim'
Plug 'w0rp/ale'
Plug 'tpope/vim-endwise'
Plug 'slim-template/vim-slim'
Plug 'itchyny/lightline.vim'
Plug 'othree/yajs.vim'
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'sheerun/vim-polyglot'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'tomasr/molokai'
Plug 'altercation/vim-colors-solarized'
Plug 'w0ng/vim-hybrid'
Plug 'jeetsukumaran/vim-nefertiti'
Plug 'KKPMW/moonshine-vim'
Plug 'nanotech/jellybeans.vim'
Plug 'cocopon/iceberg.vim'
call plug#end()

filetype plugin indent on

set rtp+=~/.fzf

"----------------------------------------------------------------------------
" Edit
"----------------------------------------------------------------------------
set fenc=utf-8
set encoding=utf-8
set nobackup
set noswapfile
set autoread
set hidden
set showcmd
" dont't yank x
noremap PP "0p
noremap x "_x

set clipboard=unnamed,autoselect
set backspace=indent,eol,start

" Removing white spaces on end of line when saved file
autocmd BufWritePre * :call Rstrip()

function! Rstrip()
  let s:tmppos = getpos(".")
  if &filetype == "markdown"
    %s/\v(\s{2})?(\s+)?$/\1/e
    match Underlined /\s\{2}$/
  else
    %s/\v\s+$//e
  endif
  call setpos(".", s:tmppos)
endfunction

" open at last modified line
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END

"----------------------------------------------------------------------------
" UI
"----------------------------------------------------------------------------

syntax on
set number
set cursorline
set virtualedit=onemore
set smartindent
set visualbell
set showmatch
set laststatus=2
"set wildmode=list:longest
"set list

"----------------------------------------------------------------------------
" Tab
"----------------------------------------------------------------------------
set expandtab
set tabstop=2
set shiftwidth=2

"----------------------------------------------------------------------------
" Search
"----------------------------------------------------------------------------
set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch

"----------------------------------------------------------------------------
" neocomplecache
"----------------------------------------------------------------------------
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1

"----------------------------------------------------------------------------
" ale
"----------------------------------------------------------------------------
let g:ale_fixers = {
  \ 'ruby': ['rubocop'],
  \ 'slim': ['slim-lint'],
  \ 'javascript': ['eslint', 'flow']
  \}
let g:ale_linters = {
 \   'javascript': ['eslint', 'flow'],
 \}
"let g:ale_sign_column_always = 1
let g:ale_statusline_format = ['E %d', 'W %d', 'LGTM']
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
highlight link ALEWarningSign String
highlight link ALEErrorSign Title

"----------------------------------------------------------------------------
" lightline.vim
"----------------------------------------------------------------------------
set noshowmode
let g:lightline = {
  \ 'colorscheme': 'jellybeans',
  \ 'active': {
  \    'left': [
  \      ['mode', 'paste'],
  \      ['readonly', 'filename', 'modified'],
  \      ['ale'],
  \    ]
  \ },
  \ 'component_function': {
  \   'ale': 'ALEStatus'
  \ }
\ }

function! ALEStatus()
  return ALEGetStatusLine()
endfunction

"----------------------------------------------------------------------------
" fzf.vim
"----------------------------------------------------------------------------

nmap ; :Buffers
nmap t :Files

"----------------------------------------------------------------------------
" vim-gitgutter
"----------------------------------------------------------------------------

let g:gitgutter_sign_added = '∙'
let g:gitgutter_sign_modified = '∙'
let g:gitgutter_sign_removed = '∙'
let g:gitgutter_sign_modified_removed = '∙'

"----------------------------------------------------------------------------
" colorscheme
"----------------------------------------------------------------------------
set background=dark

" favorite!
" colorscheme moonshine
"
" favorite!
" colorscheme iceberg

" favorite!
colorscheme hybrid
"
" colorscheme molokai
" colorscheme solarized
" colorscheme jellybeans

"----------------------------------------------------------------------------
" Ruby
"----------------------------------------------------------------------------
augroup RubyAutoCmd
  au!
  au FileType ruby set shiftwidth=2 tabstop=2
augroup END

" Template for rspec file {{{
func! s:rspec_template()
  call append(3, "require File.expand_path(File.dirname(__FILE__) + '/spec_helper')")
  call append(4, '')
  call append(5, 'describe <description> do')
  call append(6, '')
  call append(7, 'end')
endf
au RubyAutoCmd BufNewFile *_spec.rb call s:rspec_template()

" Rsense
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:rsenseHome = expand("/home/ygnmhdtt/.anyenv/envs/rbenv/shims/rsense")
let g:rsenseUseOmniFunc = 1

"----------------------------------------------------------------------------
" Javascript
"----------------------------------------------------------------------------

augroup JsAutoCmd
  au!
  au FileType javascript set shiftwidth=2 tabstop=2
augroup END

" Template for flow file {{{
func! s:flow_template()
  call append(0, '// @flow')
  call append(1, "import type { $Request, $Response } from 'express';")
  call append(2, "import Sequelize from 'sequelize';")
  call append(3, "import {db} from '../models';")
  call append(4, "import queryUtils from '../services/query-utils';")
  call append(5, "import responseUtils from '../services/response-utils';")
  call append(6, "import {errorMessages} from '../services';")
endf
au JsAutoCmd BufNewFile *.js call s:flow_template()


"----------------------------------------------------------------------------
" JSON
"----------------------------------------------------------------------------
"
let g:vim_json_syntax_conceal = 0

"----------------------------------------------------------------------------
" Golang
"----------------------------------------------------------------------------
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

autocmd FileType go :highlight goErr cterm=bold ctermfg=lightblue
autocmd FileType go :match goErr /\<err\>/

"----------------------------------------------------------------------------
" Haskell
"----------------------------------------------------------------------------
augroup HaskellAutoCmd
  au!
  au FileType haskell set shiftwidth=2 tabstop=2
augroup END

"----------------------------------------------------------------------------
" Java
"----------------------------------------------------------------------------
au FileType java set shiftwidth=4 tabstop=4
au FileType java setlocal noexpandtab

"----------------------------------------------------------------------------
" Shell script
"----------------------------------------------------------------------------
augroup ShellScriptAutoCmd
  au!
  au FileType sh set shiftwidth=2 tabstop=2
augroup END

"----------------------------------------------------------------------------
" Vim script
"----------------------------------------------------------------------------
augroup VimScriptAutoCmd
  au!
  au FileType vim set shiftwidth=2 tabstop=2
augroup END

"----------------------------------------------------------------------------
" Makefile
"----------------------------------------------------------------------------
autocmd FileType make setlocal noexpandtab
