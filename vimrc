set rtp+=~/.config/vim
set nocompatible
set viminfo+=n~/.config/vim/viminfo

call plug#begin('~/.config/vim/plugged')
  Plug 'airblade/vim-gitgutter'
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'cocopon/iceberg.vim'
  Plug 'hashivim/vim-terraform'
  Plug 'junegunn/fzf.vim'
  Plug 'SirVer/ultisnips'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitivE' 
  Plug 'tpope/vim-surround'

  " go
  Plug 'fatih/vim-go'
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}
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
" set clipboard+=unnamed
set clipboard=unnamedplus,autoselect,exclude:cons\\\\|linux


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
set rtp+=~/ghq/src/github.com/junegunn/fzf

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
" deoplete.nvim
"----------------------------------------------------------------------------
let g:deoplete#enable_at_startup = 1

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
let g:go_metalinter_autosave = 1
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_textobj_include_function_doc = 1 
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_play_open_browser = 0 " don't open the go playground url automatically
" let g:go_auto_type_info = 1
" let g:go_auto_sameids = 1

augroup go
  nnoremap <C-n> :cnext<CR>
  nnoremap <C-m> :cprevious<CR>
  nnoremap <leader>a :cclose<CR>
  nnoremap <leader>o :GoDecls<CR>
  nnoremap <leader>O :GoDeclsDir<CR>
  nnoremap <leader>d :GoDef<CR>
  nnoremap <leader>D :GoDoc<CR>
  nnoremap <leader>i :GoInfo<CR>
  nnoremap <leader>R :GoRename<CR>
  nnoremap <leader>g :GoImpl<CR>
  nnoremap <leader>I :GoImplements<CR>
  nnoremap <leader>k :GoKeyify<CR>
  nnoremap <leader>f :GoFillStruct<CR>
  nnoremap <leader>t :GoAddTags
  nnoremap <leader>s :GoRemoveTags<CR>
  nnoremap <leader>r <Plug>(go-run)
  nnoremap <Leader>c <Plug>(go-coverage-toggle)
  nnoremap <leader>b :<C-u>call <SID>build_go_files()<CR>
  :highlight goErr cterm=bold ctermfg=lightblue
  :match goErr /\<err\>/
augroup END

"----------------------------------------------------------------------------
" vim-terraform
"----------------------------------------------------------------------------
let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_remap_spacebar=1
let g:terraform_fmt_on_save = 1
