set rtp+=~/.config/nvim

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.config/nvim/init.vim
endif

call plug#begin('~/.config/nvim/plugged')
  " general
  Plug 'junegunn/fzf', { 'dir': '~/.config/fzf', 'do': './install --bin' }
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
  Plug 'SirVer/ultisnips'
  Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
call plug#end()

"----------------------------------------------------------------------------
" Settings
"----------------------------------------------------------------------------

autocmd ColorScheme * highlight LineNr ctermfg=24 guifg=#008800
autocmd ColorScheme * highlight Cursor guifg=green guibg=green

filetype off
filetype plugin indent on
colorscheme deep-space
set termguicolors
set encoding=utf-8
set ambiwidth=double
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
nnoremap <C-j> :cnext<CR>
nnoremap <C-k> :cprevious<CR>
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

" for fzf installed by homebrew
set rtp+=/usr/local/opt/fzf
set rtp+=~/ghq/src/github.com/junegunn/fzf
set rtp+=~/.config/fzf/bin

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
  :AsyncRun -strip go build <root>/... & golangci-lint run "%:p:h" 
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
autocmd FileType go nmap <leader>b :<C-u>call GoBuildAndLint()<CR>
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

augroup vimrc
  " Show quickfix only it's not empty
  autocmd QuickfixCmdPost * if len(getqflist()) != 0 | copen 8 | else | cclose | endif
augroup END

"----------------------------------------------------------------------------
" supertab
"----------------------------------------------------------------------------

let g:SuperTabDefaultCompletionType = "<c-n>"

"----------------------------------------------------------------------------
" UltiSnips
"----------------------------------------------------------------------------

let g:UltiSnipsSnippetDirectories = [$GOPATH . "/src/github.com/yagi5/dotfiles/config/nvim/snippets"]

if has('python3')
  let g:UltiSnipsExpandTrigger = "<c-e>"
  call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
    \ 'name': 'ultisnips',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
    \ }))
endif


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
