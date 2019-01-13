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

" live on the edge!
set noswapfile
set autoread

set splitbelow
set splitright

set nowrap

" Highlight current column and line
set cuc cul

" incrementally highlight searches
set incsearch
set hlsearch

" netrw
let g:netrw_liststyle=3 " thin/long/wide/tree

let mapleader = ","
let maplocalleader = ";"

" exit terminal-mode more easily
tnoremap <Leader><Esc> <C-\><C-n>

" sane window shifting shortcuts
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

nnoremap <Leader>> :tabnext<cr>
nnoremap <Leader>< :tabprevious<cr>
nnoremap <Leader>] :tabmove +1<cr>
nnoremap <Leader>[ :tabmove -1<cr>

" disable arrow keys.
" don't be a peasant.
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" search for selected text
vnoremap // y/<C-R>"<CR>

" clear search highlights
nnoremap <Leader>? :noh<cr>

" better ctag bindings
nnoremap gd :tag <c-r><c-w><cr>
nnoremap <c-]> :tag<cr>
nnoremap <c-[> :pop<cr>

" get new file changes from disk
nnoremap <Leader>g :checktime<cr>

" open NeoVim config
nnoremap <Leader><Leader>c :tabnew ~/.config/nvim/init.vim<cr>

" vim-plug
call plug#begin('~/.local/share/nvim/plugged')

" other plugins to check out:

" tpope/vim-unimpaired
" tpope/vim-endwise
" SirVer/ultisnips
" honza/vim-snippets
" vim-gitgutter
" Shougo/deoplete.nvim
" nelstrom/vim-markdown-folding
" pangloss/vim-javascript
" mattn/emmet-vim
" elixir-editors/vim-elixir

" ervandew/supertab
" janko-m/vim-test
" jremmen/vim-ripgrep
" tpope/vim-sleuth
" valloric/youcompleteme

" rizzatti/dash.vim
" jceb/vim-orgmode

" general

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='solarized'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#ale#enabled = 1

Plug 'w0rp/ale'
let g:ale_fix_on_save = 0
let g:ale_fixers = {}
let g:ale_fixers.javascripit = ['eslint', 'prettier']
let g:ale_fixers.json = ['prettier']
let g:ale_fixers.yaml = ['prettier']

" info
nnoremap <Leader>i :ALEDetail<cr>
" lint
nnoremap <Leader>l :ALEFix<cr>

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

Plug 'easymotion/vim-easymotion'
map <Space> <Plug>(easymotion-s)
nmap <Space> <Plug>(easymotion-overwin-f)

Plug 'tpope/vim-fugitive'
nnoremap <Leader>d :Gdiff<cr>

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
nnoremap <Leader>f :Files<cr>
nnoremap <Leader>b :Buffers<cr>
nnoremap <Leader>c :Commits<cr>
nnoremap <Leader>w :Windows<cr>
nnoremap <Leader>r :Rg<cr>
nnoremap <Leader>s :Lines<cr>
nnoremap <Leader>/ :BLines<cr>
nnoremap <Leader>* :BLines <c-r><c-w><cr>

Plug 'ludovicchabant/vim-gutentags'

Plug 'andrewradev/linediff.vim'

Plug 'jceb/vim-orgmode'

Plug 'vim-scripts/paredit.vim'

Plug 'tpope/vim-repeat'

Plug 'iCyMind/NeoSolarized'
let g:neosolarized_contrast = "high"

Plug 'tpope/vim-surround'

" crystal
Plug 'rhysd/vim-crystal', {'for': 'crystal'}
Plug 'elorest/vim-slang', {'for': 'crystal'}

" elixir
Plug 'elixir-editors/vim-elixir', {'for': 'elixir'}
Plug 'mhinz/vim-mix-format', {'for': 'elixir'}

" elm
Plug 'elmcast/elm-vim', {'for': 'elm'}
let g:elm_setup_keybindings = 0

" go
Plug 'fatih/vim-go', {'for': 'go'}

" ruby
Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}
Plug 'tpope/vim-rails', {'for': 'ruby'}

" here vim-plug runs both
" `filetype plugin indent on`
" and
" `syntax enable`
call plug#end()

set background=dark
set termguicolors
colorscheme NeoSolarized

if !empty(glob("~/.config/nvim/init.vim.local"))
  source ~/.config/nvim/init.vim.local
endif
