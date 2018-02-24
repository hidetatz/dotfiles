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
let g:ale_statusline_format = ['E: %d', 'W: %d', ':+1:']
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0

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
augroup FtlAutoCmd
  au!
  au BufNewFile,BufRead *.ftl set filetype=ftl
  au BufNewFile,BufRead *.ftl set syntax=html
  au FileType ftl set shiftwidth=2 tabstop=2
  au FileTYpe ftl nnoremap <silent> <C-c><C-v> :call s:toggleSyntaxBetweenFtlAndHtml()<CR>
augroup END

func! s:toggleSyntaxBetweenFtlAndHtml()
  if &syntax ==# 'html'
    set syntax=ftl
  else
    set syntax=html
  endif
endf

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
