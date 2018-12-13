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

" netrw
let g:netrw_liststyle=3 " thin/long/wide/tree

let mapleader = ","

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

" better ctag bindings
nnoremap gd :tag <c-r><c-w><cr>
nnoremap <c-]> :tag<cr>
nnoremap <c-[> :pop<cr>

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

nnoremap <Leader>ad :ALEDetail<cr>
nnoremap <Leader>af :ALEFix<cr>
nnoremap <Leader>ai :ALEInfo<cr>
nnoremap <Leader>as :ALEFixSuggest<cr>

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
map <Space> <Plug>(easymotion-prefix)

Plug 'tpope/vim-fugitive'
nnoremap <Leader>ge :Gedit
nnoremap <Leader>gs :Gstatus<cr>
nnoremap <Leader>gc :Gcommit<space>--verbose<cr>
nnoremap <Leader>gd :Gdiff<cr>
nnoremap <Leader>gb :Gblame<cr>

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
nnoremap <Leader>ff :Files<cr>
nnoremap <Leader>fb :Buffers<cr>
nnoremap <Leader>fc :Commits<cr>
nnoremap <Leader>fw :Windows<cr>
nnoremap <Leader>fr :Rg<cr>
nnoremap <Leader>fs :Lines<cr>
nnoremap <Leader>f/ :BLines<cr>
nnoremap <Leader>f* :BLines <c-r><c-w><cr>

Plug 'ludovicchabant/vim-gutentags'

Plug 'andrewradev/linediff.vim'

Plug 'tpope/vim-repeat'

Plug 'iCyMind/NeoSolarized'
let g:neosolarized_contrast = "high"

Plug 'tpope/vim-surround'

" crystal
Plug 'rhysd/vim-crystal', {'for': 'crystal'}
nnoremap <Leader>cr :!crystal run %<cr>
nnoremap <Leader>cb :!crystal build %<cr>
Plug 'elorest/vim-slang', {'for': 'crystal'}

" elixir
Plug 'elixir-editors/vim-elixir', {'for': 'elixir'}
Plug 'mhinz/vim-mix-format', {'for': 'elixir'}
nnoremap <Leader>mf :MixFormat<cr>
nnoremap <Leader>ms :MixFormatDiff<cr>

" elm
Plug 'elmcast/elm-vim', {'for': 'elm'}
let g:elm_setup_keybindings = 0
nnoremap <Leader>lm :! elm make %
nnoremap <Leader>lb :! elm make src/Main.elm<cr>
nnoremap <Leader>lt :ElmTest<cr>
" nnoremap <Leader>lr :ElmRepl<cr>
nnoremap <Leader>le :ElmErrorDetail<cr>
nnoremap <Leader>ld :ElmShowDocs<cr>
nnoremap <Leader>lw :ElmBrowseDocs<cr>
nnoremap <Leader>lf :ElmFormat<cr>

" go
" edit go with tabs at width 4
au BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4
Plug 'fatih/vim-go', {'for': 'go'}
nnoremap <Leader>ob :GoBuild<cr>
nnoremap <Leader>od :GoDoc<cr>
nnoremap <Leader>of :GoFmt<cr>
nnoremap <Leader>or :GoRun<cr>

" ruby
Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}
Plug 'tpope/vim-rails', {'for': 'ruby'}
nnoremap <Leader>rr :Rails<cr>

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
