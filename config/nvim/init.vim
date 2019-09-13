set rtp+=~/.config/nvim

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.config/nvim/init.vim
endif

call plug#begin('~/.config/nvim/plugged')
  Plug 'airblade/vim-gitgutter'
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'arcticicestudio/nord-vim'
  Plug 'buoto/gotests-vim'
  Plug 'ConradIrwin/vim-bracketed-paste'
  Plug 'cespare/vim-toml', {'for' : 'toml'}
  Plug 'cocopon/iceberg.vim'
  Plug 'ekalinin/Dockerfile.vim', {'for' : 'Dockerfile'}
  Plug 'elzr/vim-json', {'for' : 'json'}
  Plug 'ervandew/supertab'
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  Plug 'fatih/vim-nginx' , {'for' : 'nginx'}
  Plug 'hashivim/vim-terraform'
  Plug 'junegunn/fzf', { 'dir': '~/.config/fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'Raimondi/delimitMate'
  Plug 'rhysd/vim-clang-format'
  Plug 'rust-lang/rust.vim'
  Plug 'sirver/ultisnips'
  Plug 'thomasfaingnaert/vim-lsp-snippets'
  Plug 'thomasfaingnaert/vim-lsp-ultisnips'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  Plug 'tyrannicaltoucan/vim-deep-space'
call plug#end()

"----------------------------------------------------------------------------
" Settings
"----------------------------------------------------------------------------

autocmd ColorScheme * highlight LineNr ctermfg=24 guifg=#008800
autocmd ColorScheme * highlight iCursor guifg=white
autocmd ColorScheme * highlight Cursor guifg=white

filetype off
filetype plugin indent on
set nocompatible
"syntax on
" colorscheme iceberg
" colorscheme nord
colorscheme deep-space
set termguicolors
set encoding=utf-8
set ambiwidth=double
set autoread
set hidden
set autoindent
set backspace=indent,eol,start
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
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END

"----------------------------------------------------------------------------
" Common key mappings
"----------------------------------------------------------------------------

let mapleader = ","
noremap x "_x
noremap <Esc><Esc> :nohl<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <silent> <Space><Space> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>
nnoremap gh :!echo `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line('.')<CR> \| xargs open<CR><CR>

nnoremap Y y$

inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
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
" supertab
"----------------------------------------------------------------------------

let g:SuperTabDefaultCompletionType = "context"

"----------------------------------------------------------------------------
" ultisnips
"----------------------------------------------------------------------------

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"----------------------------------------------------------------------------
" LSP
"----------------------------------------------------------------------------

if executable('gopls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
        \ 'whitelist': ['go'],
        \ })
    autocmd BufWritePre *.go LspDocumentFormatSync
endif

" let g:LanguageClient_serverCommands = {
"     \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
"     \ 'go': ['gopls']
"     \ }

nnoremap <leader>a :LspCodeAction
" nnoremap <leader>d :LspDeclaration
nnoremap <leader>d :LspDefinition<CR>
" nnoremap <leader>d :LspDocumentDiagnostics
" nnoremap <leader>d :LspDocumentFormat
" nnoremap <leader>d :LspDocumentRangeFormat
" nnoremap <leader>d :LspDocumentSymbol
" nnoremap <leader>d :LspHover
" nnoremap <leader>d :LspImplementation
" nnoremap <leader>d :LspNextError
" nnoremap <leader>d :LspNextReference
" nnoremap <leader>d :LspPeekDeclaration
" nnoremap <leader>d :LspPeekDefinition
" nnoremap <leader>d :LspPeekImplementation
" nnoremap <leader>d :LspPeekTypeDefinition
" nnoremap <leader>d :LspPreviousError
" nnoremap <leader>d :LspPreviousReference
" nnoremap <leader>d :LspReferences
" nnoremap <leader>d :LspRename
" nnoremap <leader>d :LspStatus
" nnoremap <leader>d :LspTypeDefinition
" nnoremap <leader>d :LspWorkspaceSymbol

"----------------------------------------------------------------------------
" Go
"----------------------------------------------------------------------------

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"
let g:go_gocode_unimported_packages = 1
let g:go_metalinter_command = "golangci-lint"
let g:go_metalinter_autosave = 1
let g:go_metalinter_enabeld = ['deadcode', 'errcheck', 'gosimple', 'govet', 'staticcheck', 'typecheck', 'unused', 'varcheck']
let g:go_textobj_include_function_doc = 1 
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_def_mode = 'gopls'

" vim-go specific features
augroup go
  nnoremap <C-n> :cnext<CR>
  nnoremap <C-m> :cprevious<CR>
  nnoremap <leader>a :cclose<CR>
  nnoremap <leader>o :GoDecls<CR>
  nnoremap <leader>O :GoDeclsDir<CR>
  nnoremap <leader>D :GoDoc<CR>
  nnoremap <leader>i :GoInfo<CR>
  nnoremap <leader>R :GoRename<CR>
  nnoremap <leader>g :GoImpl<CR>
  nnoremap <leader>I :GoImplements<CR>
  nnoremap <leader>k :GoKeyify<CR>
  nnoremap <leader>f :GoFillStruct<CR>
  nnoremap <leader>t :GoTest<CR>
  nnoremap <leader>T :GoAddTags<CR>
  nnoremap <leader>s :GoRemoveTags<CR>
  nnoremap <leader>r :GoRun<CR>
  nnoremap <Leader>j :GoTestsAll
  :highlight goErr cterm=bold ctermfg=lightblue
  :match goErr /\<err\>/
augroup END

"----------------------------------------------------------------------------
" Rust
"----------------------------------------------------------------------------

let g:rustfmt_autosave = 1

"----------------------------------------------------------------------------
" vim-terraform
"----------------------------------------------------------------------------

let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_remap_spacebar=1
let g:terraform_fmt_on_save = 1

"----------------------------------------------------------------------------
" Kubernetes
"----------------------------------------------------------------------------

autocmd! BufWritePost *.yaml :call Kubeval()

function! Kubeval()
  let result = system('kubeval ' . bufname(""))
  echo result
endfunction