" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" source ~/.vimrc

" options

" show line numbers
set number

" set up tabs
" make existing tabs obvious
set tabstop=8
" but edit with a different tab width
set softtabstop=2
" when indenting with '>'
set shiftwidth=2
" when tab is pressed, expand with spaces
set expandtab
" automatically indent when adding a new line
set autoindent

set backspace=2

" live on the edge!
set noswapfile
set autoread

" split panes open below and to the right
set splitbelow
set splitright

set nowrap

" Highlight current column and line
set cuc cul

" mappings

let mapleader = ","

" sane pane shifting shortcuts
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

nnoremap <Leader><c-j> <c-w>J
nnoremap <Leader><c-k> <c-w>K
nnoremap <Leader><c-h> <c-w>H
nnoremap <Leader><c-l> <c-w>L

" disable arrow keys.
" don't be a peasant.
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" vim-plug plugins
call plug#begin('~/.vim/plugged')

" vim-plug should run both
" `filetype plugin indent on`
" and
" `syntax enable`
" by itself

" other plugins to check out:
"
" vim-airline/vim-airline
" scrooloose/nerdtree
" jremmen/vim-ripgrep
" tpope/vim-unimpaired
" ervandew/supertab
" janko-m/vim-test
" rizzatti/dash.vim
" jceb/vim-orgmode

"" general
Plug 'w0rp/ale'
let g:ale_completion_enabled = 1
let g:ale_completion_delay = 1
let g:ale_fix_on_save = 1
let g:ale_fixers = {
\  'ruby': [
\    'rubocop',
\  ]
\}
nnoremap <Leader>af :ALEFix<cr>

" Plug 'vim-airline/vim-airline'

Plug 'tpope/vim-commentary'

Plug 'easymotion/vim-easymotion'
map <Space> <Plug>(easymotion-prefix)

Plug 'tpope/vim-fugitive'
nnoremap <Leader>ge :Gedit
nnoremap <Leader>gs :Gstatus<cr>
nnoremap <Leader>gc :Gcommit<cr>
nnoremap <Leader>gd :Gdiff<cr>
nnoremap <Leader>gb :Gblame<cr>
nnoremap <Leader>gl :Glog<cr>

" TODO: set this up with rg
Plug 'junegunn/fzf.vim'
Plug '/usr/local/opt/fzf'
nnoremap <Leader>ff :Files<cr>
nnoremap <Leader>fb :Buffers<cr>
nnoremap <Leader>fc :Commits<cr>

Plug 'tpope/vim-repeat'

Plug 'lifepillar/vim-solarized8'

Plug 'tpope/vim-surround'

"" code
Plug 'vim-ruby/vim-ruby'
" Plug 'tpope/vim-rails'

call plug#end()

set background=light
set termguicolors
colorscheme solarized8
