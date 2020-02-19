set rtp+=$XDG_CONFIG_HOME/config/nvim

if empty(glob('$XDG_CONFIG_HOME/nvim/autoload/plug.vim'))
  silent !curl -fLo $XDG_CONFIG_HOME/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $XDG_CONFIG_HOME/nvim/init.vim
endif

call plug#begin('$XDG_CONFIG_HOME/nvim/plugged')
  " general
  Plug 'junegunn/fzf', { 'dir': '$DOT_FILES/fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  Plug 'airblade/vim-gitgutter'
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'ConradIrwin/vim-bracketed-paste'
  Plug 'ervandew/supertab'

  " colorscheme
  Plug 'tyrannicaltoucan/vim-deep-space'
  Plug 'cocopon/iceberg.vim'
  Plug 'tlhr/anderson.vim'
  Plug 'fcpg/vim-orbital'
  Plug 'nanotech/jellybeans.vim'
  Plug 'morhetz/gruvbox'

  " LSP
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/vim-lsp'

  " Language specific
  Plug 'rhysd/vim-clang-format'
  Plug 'cespare/vim-toml', {'for' : 'toml'}
  Plug 'buoto/gotests-vim'

  " AsyncRun
  Plug 'skywind3000/asyncrun.vim'
  Plug 'mh21/errormarker.vim'

  " Snippets
  Plug 'Shougo/neosnippet.vim'
  Plug 'Shougo/neosnippet-snippets'
  Plug 'prabirshrestha/asyncomplete-neosnippet.vim'

call plug#end()

"----------------------------------------------------------------------------
" Settings
"----------------------------------------------------------------------------

filetype off
filetype plugin indent on
" colorscheme deep-space
" colorscheme iceberg
" colorscheme anderson
" colorscheme orbital
colorscheme gruvbox
" colorscheme jellybeans
" set termguicolors
set encoding=utf-8
" set ambiwidth=double
set hidden
set autoindent
set clipboard+=unnamed
set noerrorbells
set number
set ruler
set background=dark
set showcmd
set incsearch
set hlsearch
set ignorecase
set ttimeout
set ttimeoutlen=50
set noswapfile
set updatetime=100
set autowrite
set pumheight=10
set conceallevel=2
set nocursorcolumn
set shortmess+=c
set belloff+=ctrlg
set nobackup
set splitright
set splitbelow
set tabstop=4
set shiftwidth=4
set expandtab
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)
set viminfo+=n$XDG_CONFIG_HOME/nvim/viminfo

" Open last edited line
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END

" Close QuickFix when try to close Vim
augroup QFClose
  au!
  au WinEnter * if winnr('$') == 1 && &buftype == "quickfix"|q|endif
augroup END

"----------------------------------------------------------------------------
" Common key mappings
"----------------------------------------------------------------------------

let mapleader = ","
noremap x "_x
nnoremap Y y$
noremap <Esc><Esc> :nohl<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <silent> <Space><Space> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>
nnoremap gh :!echo `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line('.')<CR> \| xargs open<CR><CR>
nnoremap <C-n> :cnext<CR>
nnoremap <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
" inoremap <C-j> <Down>
" inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

"----------------------------------------------------------------------------
" fzf.vim
"----------------------------------------------------------------------------

set rtp+=$DOT_FILES/fzf/bin

nnoremap ; :Buffers
nnoremap t :Files

let g:fzf_layout = { 'down': '~30%' }

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)
nmap m :GGrep

command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

"----------------------------------------------------------------------------
" PHP
"----------------------------------------------------------------------------

" \ 'cmd': {server_info->['node', expand('PATH_TO_GLOBAL_NODE_MODULES/intelephense/lib/intelephense.js'), '--stdio']},
au User lsp_setup call lsp#register_server({
    \ 'name': 'intelephense',
    \ 'cmd': {server_info->['intelephense', '--stdio']},
    \ 'initialization_options': {'storagePath': $XDG_DATA_HOME . '/intelephense'},
    \ 'whitelist': ['php'],
    \ 'workspace_config': { 'intelephense': {
    \   'files.associations': ['*.php'],
    \ }},
    \ })

"----------------------------------------------------------------------------
" c++
"----------------------------------------------------------------------------

function! CPPRun()
  :AsyncRun -strip g++ -std=c++17 -Wall --pedantic-errors -o main "%:p" && ./main
endfunction

if executable('clangd')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'clangd',
    \ 'cmd': {server_info->['clangd', '-background-index']},
    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
    \ })
  au FileType c,cpp,objc,objcpp,cc setlocal omnifunc=lsp#complete
endif

autocmd BufWritePost *.cpp :LspDocumentFormat
autocmd BufWritePost *.h :LspDocumentFormat
autocmd FileType cpp nmap <leader>r :<C-u>call CPPRun()<CR>

"----------------------------------------------------------------------------
" Go
"----------------------------------------------------------------------------

function! GoFmt()
  :silent !gofumports -w %
  :silent !gofumpt -s -w %
  :edit
endfunction

function! GoRun()
  :AsyncRun -strip go run "%:p:h" 
endfunction

function! GoBuildAndLint()
  :AsyncRun! -strip go build <root>/... && find <cwd> -name '*_test.go' | xargs gofmt -e > /dev/null && golangci-lint run "%:p:h"
    \ --disable-all 
    \ --no-config
    \ --enable=vet
    \ --enable=errcheck
    \ --enable=golint
    \ --enable=unused
    \ --enable=structcheck
    \ --enable=gosimple
    \ --enable=varcheck
    \ --enable=ineffassign
    \ --enable=deadcode
    \ --enable=typecheck
    \ --enable=bodyclose
    \ --enable=gocyclo
    \ --enable=misspell
    \ --enable=unparam
    \ --enable=staticcheck
endfunction

function! GoTest()
  :AsyncRun -strip go test -timeout 30s -count=1 <root>/...
endfunction

autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd BufWritePost *.go :call GoFmt()
autocmd BufWritePost *.go :call GoBuildAndLint()
autocmd FileType go nmap <leader>t :<C-u>call GoTest()<CR>
autocmd FileType go nmap <leader>r :<C-u>call GoRun()<CR>
:highlight goErr cterm=bold ctermfg=lightblue
:match goErr /\<err\>/

if executable('gopls')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'gopls',
    \ 'cmd': {server_info->['gopls']},
    \ 'whitelist': ['go'],
    \ })
endif

"----------------------------------------------------------------------------
" asyncrun 
"----------------------------------------------------------------------------

let g:asyncrun_auto = "make"
let g:asyncrun_open = 1
let g:asyncrun_open = 10

"----------------------------------------------------------------------------
" supertab
"----------------------------------------------------------------------------

let g:SuperTabDefaultCompletionType = "<c-n>"

"----------------------------------------------------------------------------
" Neosnippet
"----------------------------------------------------------------------------
let g:neosnippet#snippets_directory='$XDG_CONFIG_HOME/nvim/snippets/'

call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
    \ 'name': 'neosnippet',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#neosnippet#completor'),
    \ }))

imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

"----------------------------------------------------------------------------
" vim-lsp
"----------------------------------------------------------------------------

autocmd FileType * nmap <leader>d :LspDefinition<CR>
let g:lsp_async_completion = 1
let g:lsp_diagnostics_enabled = 0
let g:lsp_insert_text_enabled = 0
let g:lsp_text_edit_enabled = 0
let g:lsp_signs_enabled = 0
let g:lsp_virtual_text_enabled = 0
let g:lsp_highlights_enabled = 0
let g:lsp_textprop_enabled = 0
let g:lsp_signature_help_enabled = 0
let g:lsp_fold_enabled = 0
