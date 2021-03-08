if empty(glob('$HOME/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('$HOME/.vim/plugged')
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'tyru/current-func-info.vim'
  Plug 'Yggdroot/LeaderF'

  Plug 'prabirshrestha/vim-lsp'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/asyncomplete-gocode.vim'
call plug#end()

let mapleader = ","
colorscheme peachpuff
set encoding=utf-8
set hidden
set clipboard+=unnamed
set noerrorbells
set visualbell
set number
set incsearch
set hlsearch
set ignorecase
set noswapfile
set nobackup
set autoindent 
set completeopt=menuone,noinsert
set grepprg=git\ grep\ -I\ --line-number
set backspace=indent,eol,start

highlight Comment ctermfg=gray

" open a file at last-closed line
au! BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif

" do not inherit comment line
au! FileType * set fo-=c fo-=r fo-=o

" close quickfix automatically when close vim
au! WinEnter * if winnr('$') == 1 && &buftype == "quickfix" | q | endif

" always use quickfix to show grep result
au! QuickFixCmdPost *grep* cwindow

nnoremap x "_x
nnoremap Y y$
nnoremap <Esc><Esc> :nohl<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <silent> <Space><Space> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>
nnoremap <C-n> :cnext<CR>
nnoremap <C-p> :cprevious<CR>
nnoremap <C-n> :lnext<CR>
nnoremap <C-p> :lprevious<CR>
nnoremap <leader>a :cclose<CR>
nnoremap <leader>a :lclose<CR>
" don't append a new line on Enter hit in completion
inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"

" lsp
if executable('gopls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls']},
        \ 'whitelist': ['go'],
        \ })
endif

if executable('clangd-9')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd-9', '-background-index']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'proto'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes

    nmap <buffer> <leader>d <plug>(lsp-definition)
    nmap <buffer> <leader>g <plug>(lsp-document-diagnostics)

    autocmd BufWritePre *.go call execute('LspCodeActionSync source.organizeImports')
    autocmd BufWritePre *.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    au User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_document_highlight_enabled = 0
let g:lsp_diagnostics_echo_cursor = 1

" Leaderf
let g:Lf_CommandMap = {'<C-k>': ['<C-p>'], '<C-J>': ['<C-n>']}
let g:Lf_WindowPosition = 'popup'
let g:Lf_ShowDevIcons = 0
let g:Lf_PreviewInPopup = 1
let g:Lf_UseCache = 0
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_ShortcutF = "<leader>ff"
noremap <leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>

" WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif
