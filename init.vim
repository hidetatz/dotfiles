set nocompatible
set viminfo+=n~/.config/nvim/viminfo

call plug#begin('~/.config/nvim/plugged')
  Plug 'airblade/vim-gitgutter'
  Plug 'cocopon/iceberg.vim'
  Plug 'hashivim/vim-terraform'
  Plug 'junegunn/fzf.vim'
  Plug 'SirVer/ultisnips'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitivE' 
  Plug 'tpope/vim-surround'

  " lsp and go
  Plug 'fatih/vim-go'
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-gocode.vim'
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
set hidden

" set expandtab
set autoindent
set backspace=indent,eol,start
set clipboard+=unnamed

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
" Common key mappings
"----------------------------------------------------------------------------
noremap x "_x
noremap <Esc><Esc> :nohl<CR>
nnoremap <Leader>w :w<CR>
nnoremap <silent> <Space><Space> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>
nnoremap <leader>o :!echo `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line('.')<CR> \| xargs open<CR><CR>
nnoremap Y y$

"----------------------------------------------------------------------------
" fzf.vim
"----------------------------------------------------------------------------
" for fzf installed by homebrew
set rtp+=/usr/local/opt/fzf

nnoremap ; :Buffers
nnoremap t :Files

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
" Go
"----------------------------------------------------------------------------

let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

let g:go_gocode_unimported_packages = 1
let g:go_metalinter_autosave = 1
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']

if executable('go-langserver')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'go-langserver',
    \ 'cmd': {server_info->['go-langserver', 
    \   '-gocodecompletion', 
    \   '-format-tool=goimports', 
    \   '-diagnostics', 
    \   '-lint-tool=golint'
    \ ]},
    \ 'whitelist': ['go'],
    \ })
endif

call asyncomplete#register_source(asyncomplete#sources#gocode#get_source_options({
  \ 'name': 'gocode',
  \ 'whitelist': ['go'],
  \ 'completor': function('asyncomplete#sources#gocode#completor'),
  \ 'config': {
  \    'gocode_path': expand('~/ghq/bin/gocode')
  \  },
  \ }))

au FileType go :highlight goErr cterm=bold ctermfg=lightblue
au FileType go :match goErr /\<err\>/

"----------------------------------------------------------------------------
" vim-lsp
"----------------------------------------------------------------------------

let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1

nmap <Leader>d :LspDefinition<CR>
nmap <Leader>D :LspDocumentDiagnostics<CR>
nmap <Leader>f :LspDocumentFormat<CR>
nmap <Leader>s :LspDocumentSymbol<CR>
nmap <Leader>h :LspHover<CR>
nmap <Leader>i :LspImplementation<CR>
nmap <Leader>n :LspNextError<CR>
nmap <Leader>p :LspPreviousError<CR>
nmap <Leader>R :LspReferences<CR>
nmap <Leader>r :LspRename<CR>
nmap <Leader>S :LspStatus<CR>
" currently not working
" nmap <Leader>a :LspCodeAction<CR>
" nmap <Leader>e :LspDeclaration<CR>
" nmap <Leader>a :LspDocumentRangeFormat<CR>
" nmap <Leader>a :LspTypeDefinition<CR>
" nmap <Leader>a :LspWorkspaceSymbol<CR>

"----------------------------------------------------------------------------
" vim-terraform
"----------------------------------------------------------------------------
let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_remap_spacebar=1
let g:terraform_fmt_on_save = 1
