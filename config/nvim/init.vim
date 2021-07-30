" make existing tabs obvious
set tabstop=8
" but edit with a different tab width
set softtabstop=2
" when indenting with '>'
set shiftwidth=2
" when tab is pressed, expand with spaces
set expandtab
" remove 2 spaces with backspace
set backspace=2
" automatically indent when adding a new line
set autoindent

" show line numbers
set number

" show extra whitespace
set listchars=tab:▷⋅,trail:⋅,nbsp:☺,extends:→,precedes:←
set list

" ignore case unless there are upper-case characters
set ignorecase
set smartcase
" split below and to the right, leaving existing panes where they are
set splitbelow
set splitright
" live on the edge!
set noswapfile
set autoread
" don't wrap long lines
set nowrap
" don't redraw while executing commands & using registers
set lazyredraw
" Highlight current column and line
set cuc cul
" incrementally highlight searches
set incsearch
set hlsearch
" highlight column 140
set colorcolumn=140

" trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" " quicker line movement
" nnoremap <c-j> :m .+1<cr>==
" nnoremap <c-k> :m .-2<cr>==
vnoremap <c-j> :m '>+1<cr>gv=gv
vnoremap <c-k> :m '<-2<cr>gv=gv

" terminal remappings
tnoremap <c-q> <C-\><C-n>

nnoremap <c-n> :call setreg("s", &filetype)<cr>:!bash -c 'open "https://duckduckgo.com/?q=<c-r>s+<c-r><c-w>&ia=web"'<cr>
vnoremap <c-n> y:call setreg("s", &filetype)<cr>:!bash -c 'open "https://duckduckgo.com/?q=<c-r>s+$(echo <c-r>" \| sed '"'"'s/ /+/g'"'"')&ia=web"'<cr>

" disable arrow keys.
" don't be a peasant.
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" search for selected text
vnoremap // y/<c-r>"<cr>

" clear search highlights
nnoremap <c-c> :noh<cr>

nnoremap <c-s> :wall<cr>

let mapleader = "\<space>"
let maplocalleader = ","

" tabs
nnoremap <c-l> :tabn<cr>
nnoremap <c-h> :tabp<cr>
nnoremap <Leader><c-l> :tabmove +1<cr>
nnoremap <Leader><c-h> :tabmove -1<cr>

" get new file changes from disk
nnoremap <Leader>d :checktime<cr>

" close all other windows / tabs
nnoremap <Leader>ow :on<cr>
nnoremap <Leader>oW :on!<cr>
nnoremap <Leader>ot :tabon<cr>
nnoremap <Leader>oT :tabon!<cr>

" NeoVim config
nnoremap <Leader>c :tabnew ~/.config/nvim/init.vim<cr>
nnoremap <Leader>cc :so ~/.config/nvim/init.vim<cr>

" copy/paste
nnoremap Y "+y
vnoremap Y "+y
nnoremap P "+p
vnoremap P "+p
nnoremap <Leader>n :let @+=@%<cr>

" vim-plug / packages
nnoremap <Leader>u :PlugUpgrade<cr>:PlugUpdate<cr>:CocUpdate<cr>:CocCommand tabnine.updateTabNine<cr>
nnoremap <Leader>i :PlugInstall<cr>
nnoremap <Leader>l :PlugClean<cr>
nnoremap <Leader>t :PlugStatus<cr>

call plug#begin('~/.local/share/nvim/plugged')

" try next
" tomtom/tcomment_vim
" tpope/vim-sensible

" language / framework / tool integration
" c9s/vikube.vim
" janko-m/vim-test

" new
" jaxbot/semantic-highlight.vim
" ervandew/supertab
" tpope/vim-sleuth

" general

Plug 'tpope/vim-abolish'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'tpope/vim-commentary'

Plug 'raimondi/delimitmate'

Plug 'easymotion/vim-easymotion'
nmap <cr> <Plug>(easymotion-overwin-f)

Plug 'editorconfig/editorconfig-vim'

Plug 'mattn/emmet-vim'
let g:user_emmet_leader_key='<c-\>'

Plug 'tpope/vim-endwise'

Plug 'tpope/vim-fugitive'
nnoremap <Leader>vs :vert Git<cr>
nnoremap <Leader>vd :Gvdiffsplit<cr>
nnoremap <Leader>vb :Git blame<cr>
nnoremap <Leader>vf :Git fetch<cr>
nnoremap <Leader>vp :Git pull<cr>
cnoreabbrev H tab h
nnoremap <Leader>vm :tab Git commit -v<cr>
nnoremap <Leader>vc :Git checkout<space>
nnoremap <Leader>vl :Git clean<space>
nnoremap <Leader>vr :Git reset<space>

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
nnoremap <Leader>f :Files<cr>
nnoremap <Leader>b :Buffers<cr>
nnoremap <Leader>h :History<cr>
nnoremap <Leader>m :Commits<cr>
nnoremap <Leader>w :Windows<cr>
nnoremap <Leader>r :Rg<cr>
nnoremap <Leader>s :Lines<cr>
nnoremap <Leader>/ :BLines<cr>
vnoremap <Leader>/ y:BLines <c-r>"<cr>
nnoremap <Leader>* :BLines <c-r><c-w><cr>
vnoremap <Leader>r y:Rg <c-r>"<cr>

Plug 'airblade/vim-gitgutter'

Plug 'chriskempson/base16-vim'

Plug 'itchyny/lightline.vim'
set noshowmode

let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'git-branch-symbol', 'git-branch', 'readonly',  'modified' ],
      \             [ 'relativepath' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [  'fileformat', 'fileencoding', 'filetype', 'charvalue', 'charvaluehex' ] ]
      \ },
      \ 'component': {
      \     'git-branch-symbol': '',
      \     'charvaluehex': '0x%B'
      \ },
      \ 'component_function': {
      \     'git-branch': 'FugitiveHead'
      \ },
      \ }

Plug 'andrewradev/linediff.vim'

Plug 'nelstrom/vim-markdown-folding'
set nocompatible
if has("autocmd")
  filetype plugin indent on
endif

Plug 'aklt/plantuml-syntax'

Plug 'sheerun/vim-polyglot'

Plug 'tpope/vim-repeat'

Plug 'honza/vim-snippets'

Plug 'tpope/vim-surround'

Plug 'wellle/targets.vim'

Plug 'lervag/vimtex'
let g:tex_flavor = 'latex'

Plug 'tpope/vim-unimpaired'

Plug 'preservim/nerdtree'
let NERDTreeWinSize=60
let NERDTreeShowHidden=1
nnoremap - :NERDTreeToggle<cr>
nnoremap _ :NERDTreeFind<cr>

if !empty(glob("~/.config/nvim/plugs.vim.os"))
  source ~/.config/nvim/plugs.vim.os
endif
if !empty(glob("~/.config/nvim/plugs.vim.local"))
  source ~/.config/nvim/plugs.vim.local
endif

" here vim-plug runs both
" `filetype plugin indent on`
" and
" `syntax enable`
call plug#end()

set background=dark
set termguicolors
colorscheme base16-gruvbox-dark-medium

if !empty(glob("~/.config/nvim/coc-settings.vim"))
  source ~/.config/nvim/coc-settings.vim
endif
if !empty(glob("~/.config/nvim/init.os.vim"))
  source ~/.config/nvim/init.os.vim
endif
if !empty(glob("~/.config/nvim/init.local.vim"))
  source ~/.config/nvim/init.local.vim
endif
