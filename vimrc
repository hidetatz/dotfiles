set nocompatible

call plug#begin('~/.vim/plugged')
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'cocopon/iceberg.vim'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
  Plug 'hashivim/vim-terraform'
  Plug 'junegunn/fzf.vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'rhysd/vim-clang-format'
  Plug 'SirVer/ultisnips'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitivE'
  Plug 'tpope/vim-surround'
  " Plug 'w0rp/ale'

  " for deoplete
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
	Plug 'zchee/deoplete-go', { 'do': 'make'}
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
set expandtab
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
" Key mappings
"----------------------------------------------------------------------------
noremap x "_x
noremap <Esc><Esc> :nohl<CR>
nnoremap <Leader>w :w<CR>
nnoremap <silent> <Space><Space> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>
nnoremap <leader>o :!echo `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line('.')<CR> \| xargs open<CR><CR>

"----------------------------------------------------------------------------
" ale
"----------------------------------------------------------------------------
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 0

"----------------------------------------------------------------------------
" deoplete
"----------------------------------------------------------------------------
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#package_dot = 1
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#pointer = 1
let g:deoplete#sources#go#cgo = 1
let g:deoplete#sources#go#source_importer = 1

"----------------------------------------------------------------------------
" ctrlp
"----------------------------------------------------------------------------
" let g:ctrlp_map = '<c-p>'
" let g:ctrlp_cmd = 'CtrlP'

"----------------------------------------------------------------------------
" fzf.vim
"----------------------------------------------------------------------------
" for fzf installed by homebrew
set rtp+=/usr/local/opt/fzf

nnoremap <Leader>r :History:
nnoremap <Leader>e :History
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
" vim-gitgutter
"----------------------------------------------------------------------------
let g:gitgutter_sign_added = '∙'
let g:gitgutter_sign_modified = '∙'
let g:gitgutter_sign_removed = '∙'
let g:gitgutter_sign_modified_removed = '∙'

"----------------------------------------------------------------------------
" vim-commentary
"----------------------------------------------------------------------------
" autocmd BufRead,BufNewFile *.tf setfiletype terraform
" autocmd BufRead,BufNewFile *.tfvars setfiletype terraform
" autocmd FileType terraform setlocal commentstring=//\ %s

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

let g:go_gocode_unimported_packages = 1
let g:go_metalinter_autosave = 1

map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
autocmd FileType go nmap <Leader>i <Plug>(go-info)

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

augroup GoAutoCmd
  au!
  au FileType go :highlight goErr cterm=bold ctermfg=lightblue
  au FileType go :match goErr /\<err\>/
augroup END

"----------------------------------------------------------------------------
" vim-clang-format
"----------------------------------------------------------------------------
autocmd FileType proto ClangFormatAutoEnable

"----------------------------------------------------------------------------
" vim-terraform
"----------------------------------------------------------------------------
let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_remap_spacebar=1
let g:terraform_fmt_on_save = 1

"----------------------------------------------------------------------------
" vim-easy-align
"----------------------------------------------------------------------------
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

"----------------------------------------------------------------------------
" ultisnips
"----------------------------------------------------------------------------
" memo: 
"
" errp -> if err != nil { panic() }
" errn -> if err != nil { return err }
" errl -> if err != nil { log.Fatal(err) }
" errt -> if err != nil { t.Fatal(err) }
"
" fn -> fmt.Println()
" ff -> fmt.Printf()
" ln -> log.Println()
" lf -> log.Printf()
"
" br -> break
" cn -> continue
" df -> defer ...
" iota -> const ( ... iota )
"
" if
" for
" func
" case
"
" json
" yaml
"
" ok
"
" rt
" st
" sp
"
" others: https://github.com/fatih/vim-go/blob/master/gosnippets/UltiSnips/go.snippets
