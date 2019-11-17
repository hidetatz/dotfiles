set rtp+=~/.config/nvim

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.config/nvim/init.vim
endif

call plug#begin('~/.config/nvim/plugged')
  Plug 'airblade/vim-gitgutter'
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'buoto/gotests-vim'
  Plug 'ConradIrwin/vim-bracketed-paste'
  Plug 'cespare/vim-toml', {'for' : 'toml'}
  Plug 'dense-analysis/ale'
  Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}
  Plug 'ekalinin/Dockerfile.vim', {'for' : 'Dockerfile'}
  Plug 'elzr/vim-json', {'for' : 'json'}
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go'}
  Plug 'hashivim/vim-terraform'
  Plug 'juliosueiras/vim-terraform-completion'
  Plug 'junegunn/fzf', { 'dir': '~/.config/fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
  Plug 'Raimondi/delimitMate'
  Plug 'rhysd/vim-clang-format'
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'sirver/ultisnips'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  Plug 'tyrannicaltoucan/vim-deep-space'
call plug#end()

let g:deoplete#enable_at_startup = 1

"----------------------------------------------------------------------------
" Settings
"----------------------------------------------------------------------------

autocmd ColorScheme * highlight LineNr ctermfg=24 guifg=#008800

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
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" Open last edited line
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
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
let g:go_fmt_fail_silently = 0
let g:go_list_type = "quickfix"
let g:go_test_timeout = '10s'
let g:go_textobj_include_function_doc = 1
" let g:go_auto_type_info
" let g:go_auto_sameids = 1

let g:go_gocode_unimported_packages = 1
let g:go_linters = [
  \'vet',
  \'errcheck',
  \'golint',
  \'unused',
  \'structcheck',
  \'gosimple',
  \'varcheck',
  \'ineffassign',
  \'deadcode',
  \'typecheck',
  \'bodyclose',
  \'gocyclo',
  \'misspell',
  \'unparam',
  \'staticcheck',
  \]
let g:go_metalinter_enabled          = g:go_linters
let g:go_metalinter_command          = 'golangci-lint'
let g:go_metalinter_autosave         = 1
let g:go_metalinter_autosave_enabled = g:go_linters

let g:go_highlight_types             = 1
let g:go_highlight_fields            = 1
let g:go_highlight_functions         = 1
let g:go_highlight_function_calls    = 1
let g:go_highlight_operators         = 1
let g:go_highlight_extra_types       = 1
let g:go_highlight_generate_tags     = 1
let g:go_highlight_build_constraints = 1
let g:go_def_mode = 'gopls'

let g:deoplete#sources#go#pointer             = 1
let g:deoplete#sources#go#gocode_binary       = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#builtin_objects     = 1
let g:deoplete#sources#go#unimported_packages = 1

autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

nnoremap <C-n> :cnext<CR>
nnoremap <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" vim-go specific features
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <leader>tf <Plug>(go-test-func)
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
autocmd FileType go nmap <Leader>et <Plug>(go-alternate-edit)
autocmd FileType go nmap <Leader>d <Plug>(go-def)
autocmd FileType go nmap <Leader>p <Plug>(go-def-pop)
autocmd FileType go nmap <Leader>s <Plug>(go-def-stack)
autocmd FileType go nmap <Leader>o <Plug>(go-decls-dir)
autocmd FileType go nmap <Leader>doc <Plug>(go-doc)
autocmd FileType go nmap <Leader>ds <Plug>(go-describe)
autocmd FileType go nmap <Leader>i <Plug>(go-implements)
autocmd FileType go nmap <Leader>rn <Plug>(go-rename)
autocmd FileType go nmap <Leader>k <Plug>(go-keyify)
autocmd FileType go nmap <Leader>ig <Plug>(go-impl)
autocmd FileType go nmap <Leader>tg <Plug>(go-add-tags)
autocmd FileType go nmap <Leader>f <Plug>(go-fill-struct)
autocmd FileType go nmap <Leader>cr <Plug>(go-callers)
autocmd FileType go nmap <Leader>ce <Plug>(go-callees)
autocmd FileType go nmap <Leader>rr <Plug>(go-referrers)
:highlight goErr cterm=bold ctermfg=lightblue
:match goErr /\<err\>/

"----------------------------------------------------------------------------
" ALE
"----------------------------------------------------------------------------

let b:ale_linters = {'go': ['golangci-lint']}
let g:golangci_lint_opts = ""
for linter in g:go_linters
  let g:golangci_lint_opts = g:golangci_lint_opts . "--enable=" . linter . " "
endfor
let g:ale_go_golangci_lint_options = g:golangci_lint_opts
let g:ale_go_golangci_lint_package = 0

"----------------------------------------------------------------------------
" vim-terraform
"----------------------------------------------------------------------------

let g:terraform_align          = 1
let g:terraform_fold_sections  = 1
let g:terraform_remap_spacebar = 1
let g:terraform_fmt_on_save    = 1
