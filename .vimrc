" vim-plug
" When update, call `:source ~/.vimrc` and `:PlugInstall`
call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go'
Plug 'airblade/vim-gitgutter'
Plug 'elzr/vim-json'
Plug 'tpope/vim-endwise'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'sheerun/vim-polyglot'
Plug 'w0ng/vim-hybrid'
Plug 'tpope/vim-fugitivE'
Plug 'haya14busa/vim-auto-programming'
Plug 'junegunn/vim-easy-align'
" Plug 'Yggdroot/indentLine'
" Plug 'Shougo/neocomplcache'
" Plug 'mattn/webapi-vim'
" Plug 'w0rp/ale'
" Plug 'slim-template/vim-slim'
" Plug 'othree/yajs.vim'
" Plug 'nathanaelkane/vim-indent-guides'
" Plug 'tomasr/molokai'
" Plug 'altercation/vim-colors-solarized'
" Plug 'jeetsukumaran/vim-nefertiti'
" Plug 'KKPMW/moonshine-vim'
" Plug 'nanotech/jellybeans.vim'
" Plug 'cocopon/iceberg.vim'
" Plug 'scrooloose/nerdtree'
call plug#end()

filetype plugin indent on

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
noremap PP "0p
" dont't yank x
noremap x "_x

" hit esc 2 times to disable highlight
noremap <Esc><Esc> :nohl<CR>

set clipboard=autoselect
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

let mapleader = ","
nnoremap <Leader>w :w<CR>

"----------------------------------------------------------------------------
" UI
"----------------------------------------------------------------------------
syntax on
set number
set cursorline
" set nocursorline
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

nnoremap <silent> <Space><Space> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>

"----------------------------------------------------------------------------
" neocomplecache
"----------------------------------------------------------------------------
" let g:neocomplcache_enable_at_startup = 1
" let g:neocomplcache_enable_smart_case = 1
" let g:neocomplcache_min_syntax_length = 3
" let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
" let g:neocomplcache_enable_camel_case_completion = 1
" let g:neocomplcache_enable_underbar_completion = 1

"----------------------------------------------------------------------------
" ale
"----------------------------------------------------------------------------
"let g:ale_fixers = {
"  \ 'ruby': ['rubocop'],
"  \ 'slim': ['slim-lint'],
"  \ 'javascript': ['eslint', 'flow']
"  \}
"let g:ale_linters = {
" \   'javascript': ['eslint', 'flow'],
" \}
""let g:ale_sign_column_always = 1
"let g:ale_statusline_format = ['E %d', 'W %d', 'LGTM']
"let g:ale_lint_on_save = 1
"let g:ale_lint_on_text_changed = 0
"highlight link ALEWarningSign String
"highlight link ALEErrorSign Title

"----------------------------------------------------------------------------
" lightline.vim
"----------------------------------------------------------------------------
set noshowmode
" let g:lightline = {
"   \ 'colorscheme': 'wombat',
"   \ 'active': {
"   \    'left': [
"   \      ['mode', 'paste'],
"   \      ['readonly', 'filename', 'modified'],
"   \      ['ale'],
"   \    ]
"   \ },
"   \ 'component_function': {
"   \   'ale': 'ALEStatus'
"   \ }
" \ }
let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'active': {
  \    'left': [
  \      ['mode', 'paste'],
  \      ['readonly', 'filename', 'modified']
  \    ]
  \ },
\ }

" function! ALEStatus()
"   return ALEGetStatusLine()
" endfunction

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
" let g:gitgutter_sign_added = '∙'
" let g:gitgutter_sign_modified = '∙'
" let g:gitgutter_sign_removed = '∙'
" let g:gitgutter_sign_modified_removed = '∙'

"----------------------------------------------------------------------------
" vim-easy-align
"----------------------------------------------------------------------------
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

"----------------------------------------------------------------------------
" nerdtree
"----------------------------------------------------------------------------
" autocmd vimenter * NERDTree
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" autocmd VimEnter * wincmd p

"----------------------------------------------------------------------------
" indentLine
"----------------------------------------------------------------------------
" let g:indentLine_color_term = 255
" let g:indentLine_char = '|'

"----------------------------------------------------------------------------
" vim-auto-programming
"----------------------------------------------------------------------------
set completefunc=autoprogramming#complete
noremap <C-p> <C-x><C-u>

"----------------------------------------------------------------------------
" colorscheme
"----------------------------------------------------------------------------
set background=dark

" favorite!
" colorscheme moonshine

" favorite!
" colorscheme iceberg

" favorite!
colorscheme hybrid

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
" func! s:rspec_template()
"   call append(3, "require File.expand_path(File.dirname(__FILE__) + '/spec_helper')")
"   call append(4, '')
"   call append(5, 'describe <description> do')
"   call append(6, '')
"   call append(7, 'end')
" endf
" au RubyAutoCmd BufNewFile *_spec.rb call s:rspec_template()

" Rsense
" if !exists('g:neocomplcache_omni_patterns')
"   let g:neocomplcache_omni_patterns = {}
" endif
" let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
" autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
" let g:rsenseHome = expand("/home/ygnmhdtt/.anyenv/envs/rbenv/shims/rsense")
" let g:rsenseUseOmniFunc = 1

"----------------------------------------------------------------------------
" Javascript
"----------------------------------------------------------------------------
augroup JsAutoCmd
  au!
  au FileType javascript set shiftwidth=2 tabstop=2
augroup END

" " Template for flow file {{{
" func! s:flow_template()
"   call append(0, '// @flow')
"   call append(1, "import type { $Request, $Response } from 'express';")
"   call append(2, "import Sequelize from 'sequelize';")
"   call append(3, "import {db} from '../models';")
"   call append(4, "import queryUtils from '../services/query-utils';")
"   call append(5, "import responseUtils from '../services/response-utils';")
"   call append(6, "import {errorMessages} from '../services';")
" endf
" au JsAutoCmd BufNewFile *.js call s:flow_template()

"----------------------------------------------------------------------------
" JSON
"----------------------------------------------------------------------------
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

set completeopt=menu,preview
exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")

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
