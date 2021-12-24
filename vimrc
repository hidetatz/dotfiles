syntax enable
filetype plugin on

set noswapfile
set viminfo='100,h
set showmatch
set ignorecase
set smartcase
set hlsearch
set incsearch
set autowrite
set belloff=all
set grepprg=git\ grep\ -I\ --line-number
set smartindent

set path+=**
set wildmenu
set wildignore+=*git/*

nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [Q :cfirst<CR>
nnoremap <silent> ]Q :clast<CR>

nnoremap <silent> [l :lprevious<CR>zv
nnoremap <silent> ]l :lnext<CR>zv
nnoremap <silent> [L :lfirst<CR>zv
nnoremap <silent> ]L :llast<CR>zv

nnoremap <silent> [t :tprevious<CR>zv
nnoremap <silent> ]t :tnext<CR>zv
nnoremap <silent> [T :tfirst<CR>zv
nnoremap <silent> ]T :tlast<CR>zv

let g:netrw_liststyle=3

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

au QuickFixCmdPost [^l]* cwindow
au QuickFixCmdPost l*    lwindow

au FileType go compiler go
au BufWritePost *.go silent! !ctags -R &

if executable('gopls')
    au User lsp_setup call lsp#register_server({'name': 'gopls', 'cmd': {server_info->['gopls']}, 'allowlist': ['go']})
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    let g:lsp_format_sync_timeout = 1000
    let g:lsp_document_highlight_enabled = 0
    autocmd BufWritePre *.go call execute('LspCodeActionSync source.organizeImports')
    autocmd BufWritePre * call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:ctrlp_root_markers = ['go.mod']
