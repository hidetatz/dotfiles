set nocompatible
set runtimepath=$XDG_CONFIG_HOME/vim,$XDG_CONFIG_HOME/vim/after,$VIM,$VIMRUNTIME
set viminfo+=n$XDG_CONFIG_HOME/vim/viminfo

call plug#begin('~/.config/vim/plugged')
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'cocopon/iceberg.vim'
  Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
  Plug 'hashivim/vim-terraform'
  Plug 'junegunn/fzf.vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'rhysd/vim-clang-format'
  Plug 'SirVer/ultisnips'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitivE' 
  Plug 'tpope/vim-surround'
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'

  " go lsp
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'natebosch/vim-lsc'

  " terraform
  Plug 'vim-syntastic/syntastic'
  Plug 'juliosueiras/vim-terraform-completion'
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

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

" go lsp
let g:lsp_async_completion = 1
if executable('go-langserver')
  au User lsp_setup call lsp#register_server({
      \ 'name': 'go-langserver',
      \ 'cmd': {server_info->['go-langserver', '-gocodecompletion']},
      \ 'whitelist': ['go'],
      \ })
endif

au FileType go :highlight goErr cterm=bold ctermfg=lightblue
au FileType go :match goErr /\<err\>/
autocmd FileType go setlocal omnifunc=lsp#complete
autocmd FileType go nmap <leader>a :cclose<CR>
autocmd FileType go nmap <leader>u <Plug>(go-run)
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <Leader>d :LspDefinition<CR>
autocmd FileType go nmap <Leader>f :LspReferences<CR>
autocmd FileType go nmap <Leader>i :LspImplementation<CR>
autocmd FileType go nmap <Leader>t :LspTypeDefinition<CR>
autocmd FileType go nmap <silent> <Leader>s :split \| :LspDefinition <CR>
autocmd FileType go nmap <silent> <Leader>v :vsplit \| :LspDefinition <CR>
" autocmd FileType go nmap <C-n> :cnext<CR>
" autocmd FileType go nmap <C-m> :cprevious<CR>
" autocmd FileType go nmap <Leader>i <Plug>(go-info)
" autocmd FileType go nmap <Leader>p :LspHover<CR>
" autocmd FileType go nmap <Leader>n :LspNextError<CR>
" autocmd FileType go nmap <Leader>p :LspPreviousError<CR>

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
nmap ga <Plug>(EasyAlign)

"----------------------------------------------------------------------------
" deoplete.nvim
"----------------------------------------------------------------------------
" let g:deoplete#omni_patterns = {}
" let g:deoplete#omni_patterns.terraform = '[^ *\t"{=$]\w*'
" let g:deoplete#enable_at_startup = 1
" call deoplete#initialize()

" call deoplete#initialize()

"----------------------------------------------------------------------------
" vim-terraform-completion
"----------------------------------------------------------------------------
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

" (Optional)Remove Info(Preview) window
set completeopt-=preview

" (Optional)Hide Info(Preview) window after completions
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" (Optional) Enable terraform plan to be include in filter
let g:syntastic_terraform_tffilter_plan = 1

" (Optional) Default: 0, enable(1)/disable(0) plugin's keymapping
let g:terraform_completion_keys = 1

" (Optional) Default: 1, enable(1)/disable(0) terraform module registry completion
let g:terraform_registry_module_completion = 0

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
