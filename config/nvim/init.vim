set number
set relativenumber

" set up tabs
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
" show extra whitespace
set listchars=tab:▷⋅,trail:⋅,nbsp:☺,extends:→,precedes:←
set list
" trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" ignore case unless there are upper-case characters
set ignorecase
set smartcase

" live on the edge!
set noswapfile
set autoread

set nowrap

" don't redraw while executing commands & using registers
set lazyredraw

" Highlight current column and line
set cuc cul

" incrementally highlight searches
set incsearch
set hlsearch

" netrw
let g:netrw_liststyle=3 " thin/long/wide/tree
let g:netrw_browse_split=2 " horizontal/vertical/tab/window
let g:netrw_winsize=25 " size as screen %

" sane window shifting shortcuts
noremap <c-j> <c-w>j
noremap <c-k> <c-w>k
noremap <c-h> <c-w>h
noremap <c-l> <c-w>l

" disable arrow keys.
" don't be a peasant.
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" search for selected text
vnoremap // y/<c-r>"<cr>

" clear search highlights
nnoremap <esc> :noh<cr>

" leader key mappings

" #Packages
" Plug: p
" ALE (lint): l
" Dash/Zeal (doc): d
" Fugitive (version control): v
" FZF: {fbcwrs/*}

" #Other
" Quickfix: q
" Reload file (get changes): g
" Close other windows/tabs: o{wt}
" Editor config/reload: e{cr}
" Copy: y

" Visual
" FZF: r

" filetype leader mappings
" Execute file: x
" Build (make): m
" Test all/single file: t/tt

" localleader mappings
" Edit config/reload: e{cr}

let mapleader = "\<space>"
let maplocalleader = "\<c-space>"

" windows
nnoremap <Leader><c-j> <c-w>J
nnoremap <Leader><c-k> <c-w>K
nnoremap <Leader><c-h> <c-w>H
nnoremap <Leader><c-l> <c-w>L

" tabs
nnoremap <Leader>] :tabn<cr>
nnoremap <Leader>[ :tabp<cr>
nnoremap <Leader>} :tabmove +1<cr>
nnoremap <Leader>{ :tabmove -1<cr>

" quickfix
nnoremap <Leader>qc :cc
nnoremap <Leader>qn :cn<cr>
nnoremap <Leader>qp :cp<cr>

" get new file changes from disk
nnoremap <Leader>g :checktime<cr>

" close all other windows / tabs
nnoremap <Leader>ow :on<cr>
nnoremap <Leader>oW :on!<cr>
nnoremap <Leader>ot :tabon<cr>
nnoremap <Leader>oT :tabon!<cr>

" NeoVim config
nnoremap <Leader>ec :tabnew ~/.config/nvim/init.vim<cr>
nnoremap <Leader>er :so ~/.config/nvim/init.vim<cr>

" copy
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y

" vim-plug
nnoremap <Leader>pu :PlugUpdate<cr>
nnoremap <Leader>pg :PlugUpgrade<cr>
nnoremap <Leader>pi :PlugInstall<cr>
nnoremap <Leader>pc :PlugClean<cr>
nnoremap <Leader>ps :PlugStatus<cr>
call plug#begin('~/.local/share/nvim/plugged')

" tpope/vim-endwise
" tpope/vim-rails
" autozimu/languageclient-neovim
" jaxbot/semantic-highlight.vim
" c9s/vikube.vim

" ervandew/supertab
" janko-m/vim-test
" jremmen/vim-ripgrep
" mattn/emmet-vim
" nelstrom/vim-markdown-folding
" neoclide/coc.nvim
" pangloss/vim-javascript
" tpope/vim-sleuth
" tpope/vim-unimpaired
" valloric/youcompleteme
" vim-gitgutter

" general

" lightline

Plug 'itchyny/lightline.vim'
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'relativepath', 'modified' ] ],
      \ }
      \ }

Plug 'w0rp/ale'
let g:ale_fix_on_save = 0
let g:ale_fixers = {
\   '*': ['remove_trailing_lines'],
\}
nnoremap <Leader>ld :ALEDetail<cr>
nnoremap <Leader>lf :ALEFix<cr>
nnoremap <Leader>ln :ALENextWrap<cr>
nnoremap <Leader>lp :ALEPreviousWrap<cr>

Plug 'tpope/vim-commentary'

" deoplete
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }

Plug 'easymotion/vim-easymotion'
nmap <cr> <Plug>(easymotion-overwin-f)

Plug 'tpope/vim-fugitive'
nnoremap <Leader>vs :Git<cr>
nnoremap <Leader>vd :Gvdiff<cr>
nnoremap <Leader>vb :Gblame<cr>
nnoremap <Leader>vp :G pull<cr>
nnoremap <Leader>vc :G checkout<space>
nnoremap <Leader>vl :G clean<space>

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
nnoremap <Leader>f :Files<cr>
nnoremap <Leader>b :Buffers<cr>
nnoremap <Leader>c :Commits<cr>
nnoremap <Leader>w :Windows<cr>
nnoremap <Leader>r :Rg<cr>
nnoremap <Leader>s :Lines<cr>
nnoremap <Leader>/ :BLines<cr>
nnoremap <Leader>* :BLines <c-r><c-w><cr>
vnoremap <Leader>r y:Rg <c-r>"<cr>

Plug 'roman/golden-ratio'

Plug 'ludovicchabant/vim-gutentags'

Plug 'andrewradev/linediff.vim'

Plug 'aklt/plantuml-syntax'

Plug 'tpope/vim-repeat'

" Plug 'jaxbot/semantic-highlight.vim'

Plug 'honza/vim-snippets'

Plug 'tpope/vim-surround'

" Plug 'lervag/vimtex'

Plug 'sirver/ultisnips'

Plug 'flazz/vim-colorschemes'

" elixir
Plug 'elixir-editors/vim-elixir', {'for': 'elixir'}
Plug 'slashmili/alchemist.vim', {'for': 'elixir'}

" elm
Plug 'doubledup/elm-vim', {'for': 'elm'}
let g:elm_setup_keybindings = 0

" go
Plug 'fatih/vim-go', {'for': 'go'}

" ruby
Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}

if !empty(glob("~/.config/nvim/plugs.os.vim"))
  source ~/.config/nvim/plugs.os.vim
endif

if !empty(glob("~/.config/nvim/plugs.local.vim"))
  source ~/.config/nvim/plugs.local.vim
endif

" here vim-plug runs both
" `filetype plugin indent on`
" and
" `syntax enable`
call plug#end()

" set background=dark
" set termguicolors
colorscheme hybrid

if !empty(glob("~/.config/nvim/init.local.vim"))
  source ~/.config/nvim/init.local.vim
endif
