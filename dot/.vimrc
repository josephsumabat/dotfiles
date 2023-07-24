"Install plugged if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"Load Plugins
call plug#begin('~/.vim/plugged')
"fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/seoul256.vim'


"Colorscheme
Plug 'romainl/flattened'
Plug 'altercation/vim-colors-solarized'

"indent lines
Plug 'Yggdroot/indentLine'

"git
Plug 'tpope/vim-fugitive'

Plug 'dhruvasagar/vim-table-mode'

"git diff in gutter
Plug 'mhinz/vim-signify'
"marks in gutter
Plug 'kshenoy/vim-signature'

"Language server
"Plug 'autozimu/LanguageClient-neovim', {
"    \ 'branch': 'next',
"    \ 'do': 'bash install.sh',
"    \ }
"Plug 'Shougo/deoplete.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-tsserver'
Plug 'ms-jpq/coq.nvim'


Plug 'neovimhaskell/haskell-vim'
Plug 'alx741/yesod.vim'
Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }

"Markdown and latex
"Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'lervag/vimtex'

"Vimwiki"
Plug 'vimwiki/vimwiki'

"Hindent
Plug 'alx741/vim-hindent'

Plug 'leafgarland/typescript-vim'

call plug#end()

"Config for signify
let g:signify_vcs_list = ['git']
let g:signify_sign_delete_first_line = '_'
let g:signify_sign_change = '~'
let g:signify_sign_changedelete = '~_'
let g:signify_sign_show_count = 0
"let g:indentLine_conceallevel = 0

"solarized theme
colorscheme seoul256
set background=dark

syntax on
filetype plugin indent on
let g:haskell_classic_highlighting=1

"Highlighting for GitGutter symbols
highlight SignifySignAdd ctermbg=none ctermfg=64
highlight SignifySignChange ctermbg=none ctermfg=136
highlight SignifySignDelete ctermbg=none ctermfg=160

highlight CocFloating ctermbg=0

 "Make gutter clear
 highlight clear SignColumn

let g:tex_conceal = ""

set relativenumber
set number

set wildmode=longest,list,full
set wildmenu
set ignorecase
set smartcase

set number
set relativenumber
set ruler
set showcmd

set autoindent
set tabstop=4
set shiftwidth=2
set expandtab
set smarttab
set laststatus=2

set scrolloff=7

set cursorline
hi clear CursorLine
hi CursorLine cterm=underline
set showtabline=2

command! W w
command! Wq wq

" moving between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

"fzf commands
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 0, <bang>0)

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg  --ignore-file .gitignore --line-number --no-heading '.shellescape(<q-args>), 0,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

let mapleader = " "

nnoremap <leader><tab> :Buffer<CR>
nnoremap <leader>s :GFiles<CR>
nnoremap <leader>f :Rg<CR>
nnoremap <leader>x :bdelete<CR>

nnoremap <leader>gw :CocSearch 

"<TAB>: completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

"javascript linting on :make
autocmd FileType javascript setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m
autocmd FileType javascript setlocal makeprg=eslint\ %\ -f\ compact\ --quiet

"typescript linting on :make
autocmd FileType typescript setlocal errorformat=ERROR:\ %f:%l:%c\ -\ %m
autocmd FileType typescript setlocal makeprg=tslint\ --quiet\ %\

autocmd QuickFixCmdPost [^l]* cwindow

filetype plugin on
set omnifunc=syntaxcomplete#Complete

let g:vimtex_view_general_viewer = 'zathura'

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\

let g:sessions_dir = '~/vim-sessions'
exec 'nnoremap <Leader>gs :mks! ' . g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'
exec 'nnoremap <Leader>gr :so ' . g:sessions_dir. '/*.vim<C-D><BS><BS><BS><BS><BS>'

let g:hindent_on_save = 0

" Required for operations modifying multiple buffers like rename.
set hidden

"let g:LanguageClient_serverCommands = {
"    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
"    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
"    \ 'haskell': ['halfsp'],
"    \ }

"" note that if you are using Plug mapping you should not use `noremap` mappings.
"nmap <F5> <Plug>(lcn-menu)
"" Or map each action separately
"nmap <silent>K <Plug>(lcn-hover)
"nmap <silent> gd <Plug>(lcn-definition)
"nmap <silent> gy <Plug>(lcn-type-definition)
"nmap <silent> gi <Plug>(lcn-implementation)
"nmap <silent> gr <Plug>(lcn-references)
"nmap <silent> <F2> <Plug>(lcn-rename)

"let g:deoplete#enable_at_startup = 1 

" coc only (TODO: move to new file?)
"========================================================================
" GoTo code navigation for Coc (deprecated)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

"autocmd FileType haskell nnoremap <buffer> <C-]> <Plug>(coc-definition)
autocmd FileType haskell nnoremap <buffer> <C-^> <Plug>(coc-references)

"inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
"inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

nmap cp :cp<CR>
nmap cn :cn<CR>
nmap <F6> :cn<CR>
nmap cf :cf ghcid.txt<CR>


let g:vim_json_conceal=0
let g:markdown_syntax_conceal=0


" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)
