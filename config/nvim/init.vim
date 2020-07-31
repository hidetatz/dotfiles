set rtp+=$XDG_CONFIG_HOME/config/nvim

if empty(glob('$XDG_CONFIG_HOME/nvim/autoload/plug.vim'))
  silent !curl -fLo $XDG_CONFIG_HOME/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  au VimEnter * PlugInstall --sync | source $XDG_CONFIG_HOME/nvim/init.vim
endif

call plug#begin('$XDG_CONFIG_HOME/nvim/plugged')
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'airblade/vim-gitgutter'

  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf', { 'dir': '~/.config/fzf' }
  Plug 'junegunn/fzf.vim'
  Plug 'skywind3000/asyncrun.vim'

  " colorscheme
  Plug 'morhetz/gruvbox'

  Plug 'vim-test/vim-test'

  " LSP
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/vim-lsp'

  Plug 'mattn/vim-goimports'
call plug#end()

"----------------------------------------------------------------------------
" Settings
"----------------------------------------------------------------------------

colorscheme gruvbox
set encoding=utf-8
set hidden
set clipboard+=unnamed
set noerrorbells
set number
set incsearch
set hlsearch
set ignorecase
set noswapfile
set nobackup
set viminfo+=n$XDG_CONFIG_HOME/nvim/viminfo

au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
au FileType * set fo-=c fo-=r fo-=o
au WinEnter * if winnr('$') == 1 && &buftype == "quickfix" | q | endif
au QuickfixCmdPost * if len(getqflist()) != 0 | copen 8 | else | cclose | endif

let mapleader = ","
nnoremap x "_x
nnoremap Y y$
nnoremap <Esc><Esc> :nohl<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <silent> <Space><Space> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>
nnoremap gh :!echo `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line('.')<CR> \| xargs open<CR><CR>
nnoremap <C-n> :cnext<CR>
nnoremap <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
nnoremap <leader>g :!git blame -- %<CR>

"----------------------------------------------------------------------------
" vim-lsp
"----------------------------------------------------------------------------

au FileType * nmap <leader>d :LspDefinition<CR>
au BufWritePost * :LspDocumentFormat
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

"----------------------------------------------------------------------------
" fzf.vim
"----------------------------------------------------------------------------

set rtp+=$XDG_CONFIG_HOME/fzf/bin

nnoremap ; :Buffers
nnoremap t :Files

let g:fzf_layout = { 'down': '~30%' }

command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=* GGrep call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 0, { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)
nmap m :GGrep

"----------------------------------------------------------------------------
" PHP
"----------------------------------------------------------------------------

if executable('intelephense')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'intelephense',
    \ 'whitelist': ['php'],
    \ 'cmd': {server_info->['intelephense', '--stdio']},
    \ 'initialization_options': {'storagePath': $XDG_DATA_HOME . '/intelephense'},
    \ 'workspace_config': {'intelephense': {'files.associations': ['*.php']}},
    \ })
endif

"----------------------------------------------------------------------------
" c++
"----------------------------------------------------------------------------

function! CPPRun()
  :AsyncRun -strip g++ -O2 -std=c++17 -Wall --pedantic-errors -o main "%:p" && ./main
endfunction

if executable('clangd')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'clangd',
    \ 'cmd': {server_info->['clangd', '-background-index']},
    \ 'whitelist': ['c', 'cpp', 'proto'],
    \ })
  au FileType c,cpp,cc setlocal omnifunc=lsp#complete
endif

au FileType cpp nmap <leader>r :<C-u>call CPPRun()<CR>
au BufNewFile,BufRead *.cpp setlocal noexpandtab tabstop=2 shiftwidth=2

"----------------------------------------------------------------------------
" Go
"----------------------------------------------------------------------------

function! GoBuildAndLint()
  " run go build, go test -c, golangci-lint
  :AsyncRun! -strip go build <root>/... &&
    \ go list <root>/... | xargs -r -L 1 -I xxx find $GOPATH/src/xxx -name *_test.go | xargs -r -L 1 dirname | sed "s@$GOPATH/src/@@g" | sort | uniq | xargs -r -L 1 go test -c &&
    \ rm -f <root>/*.test &&
    \ golangci-lint run "%:p:h" --disable-all --no-config --enable=vet --enable=errcheck --enable=golint --enable=unused --enable=structcheck --enable=gosimple
      \ --enable=varcheck --enable=ineffassign --enable=deadcode --enable=typecheck --enable=bodyclose --enable=gocyclo --enable=misspell --enable=unparam --enable=staticcheck
endfunction

function! GoTest()
  :AsyncRun -strip go test -timeout 30s -count=1 <root>/...
endfunction

au BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
au FileType go nmap <leader>t :<C-u>call GoTest()<CR>
au FileType go nmap <leader>b :<C-u>call GoBuildAndLint()<CR>
:highlight goErr cterm=bold ctermfg=lightblue
:match goErr /\<err\>/
let g:goimports = 1

if executable('gopls')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'gopls',
    \ 'cmd': {server_info->['gopls']},
    \ 'whitelist': ['go'],
    \ })
endif
