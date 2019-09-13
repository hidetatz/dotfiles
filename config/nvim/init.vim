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
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go'}
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

" nnoremap <C-n> :cnext<CR>
" nnoremap <C-m> :cprevious<CR>
nnoremap <silent> ga :cclose<CR>

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

if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
        \ 'whitelist': ['rust'],
        \ })
endif

" For Go, not all features are supported.
" https://github.com/golang/go/wiki/gopls#status

nnoremap <leader>d :LspDefinition<CR>
nnoremap <leader>h :LspHover<CR>
" nnoremap <leader>i :LspImplementation<CR> // Not supported now
nnoremap <C-n> :LspNextError<CR>
nnoremap <C-m> :LspPreviousError<CR>
nnoremap <leader>r :LspReferences<CR>
nnoremap <leader>n :LspRename<CR>
" nnoremap <leader>a :LspCodeAction<CR>          // List of actions
" nnoremap <leader>d :LspDeclaration             // Not supported
" nnoremap <leader>d :LspDocumentDiagnostics<CR> // Automatically run
" nnoremap <leader>d :LspDocumentFormat<CR>      // Automatically run
" nnoremap <leader>d :LspDocumentRangeFormat<CR> // doesn't need
" nnoremap <leader>d :LspDocumentSymbol<CR>      // doesn't need
" nnoremap <leader>d :LspNextReference<CR>
" nnoremap <leader>d :LspPeekDeclaration<CR>
" nnoremap <leader>d :LspPeekDefinition<CR>
" nnoremap <leader>d :LspPeekImplementation<CR>
" nnoremap <leader>d :LspPeekTypeDefinition<CR>
" nnoremap <leader>d :LspPreviousError<CR>
" nnoremap <leader>r :LspPreviousReference<CR>
" nnoremap <leader>d :LspStatus<CR>
" nnoremap <leader>d :LspTypeDefinition<CR>
" nnoremap <leader>d :LspWorkspaceSymbol<CR>

let g:lsp_signs_error = {'text': 'x'}

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
  nnoremap <leader>D :GoDecls<CR>
  nnoremap <leader>O :GoDeclsDir<CR>
  nnoremap <leader>G :GoDoc<CR>
  nnoremap <leader>I :GoImpl<CR>
  nnoremap <leader>i :GoImplements<CR> " the same as LspImplementation
  nnoremap <leader>K :GoKeyify<CR>
  nnoremap <leader>F :GoFillStruct<CR>
  nnoremap <leader>T :GoTest<CR>
  nnoremap <leader>A :GoAddTags<CR>
  " nnoremap <leader>s :GoRemoveTags<CR>
  nnoremap <leader>R :GoRun<CR>
  nnoremap <leader>C :GoCoverage<CR>
  " nnoremap <leader>j :GoTestsAll
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
