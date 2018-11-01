let mapleader = ","

" options

" show line numbers
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

" automatically indent when adding a new line
set autoindent
" show extra whitespace
set listchars=tab:▷⋅,trail:⋅,nbsp:☺,extends:→,precedes:←
set list
" remove 2 spaces with backspace
set backspace=2

" better tag navigation
nnoremap gd :tag <c-r><c-w><cr>
nnoremap <c-]> :tag<cr>
nnoremap <c-[> :pop<cr>

" live on the edge!
set noswapfile
set autoread

" split panes open below and to the right
set splitbelow
set splitright

" netrw config
let g:netrw_liststyle=3 " thin/long/wide/tree

" exit terminal-mode more easily
tnoremap <Leader><Esc> <C-\><C-n>

" don't wrap lines
set nowrap

" Highlight current column and line
set cuc cul

" sane pane shifting shortcuts
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

nnoremap <Leader><c-j> <c-w>J
nnoremap <Leader><c-k> <c-w>K
nnoremap <Leader><c-h> <c-w>H
nnoremap <Leader><c-l> <c-w>L

" split pane layouts
nnoremap <Leader>ss :vertical resize 80<cr>
nnoremap <Leader>sl :vertical resize 120<cr>
nnoremap <Leader>sc :new<cr><c-w>L:new<cr><c-w>H<c-w>l

nnoremap <Leader>tn :tabnext<cr>
nnoremap <Leader>tp :tabprevious<cr>
nnoremap <Leader>t> :tabmove +1<cr>
nnoremap <Leader>t< :tabmove -1<cr>

" disable arrow keys.
" don't be a peasant.
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" search for selected text
vnoremap // y/<C-R>"<CR>

" open NeoVim config
nnoremap <Leader><Leader>c :tabnew ~/.config/nvim/init.vim<cr>

nnoremap <Leader>pc :PlugClean<cr>
nnoremap <Leader>pd :PlugDiff<cr>
nnoremap <Leader>pi :PlugInstall<cr>
nnoremap <Leader>ps :PlugStatus<cr>
nnoremap <Leader>pu :PlugUpdate<cr>

" vim-plug plugins
call plug#begin('~/.vim/plugged')

" vim-plug runs both
" `filetype plugin indent on`
" and
" `syntax enable`
" by itself

" other plugins to check out:
"
" Plug 'vim-airline/vim-airline'
" jremmen/vim-ripgrep
" tpope/vim-unimpaired
" ervandew/supertab
" janko-m/vim-test
" rizzatti/dash.vim
" jceb/vim-orgmode
" Plug 'valloric/youcompleteme'
" Plug 'tpope/vim-sleuth'

"" general

Plug 'w0rp/ale'
let g:ale_completion_enabled = 1
let g:ale_completion_delay = 1
let g:ale_fix_on_save = 0

let g:ale_linters = {}
let g:ale_linters.ruby = [
\    'brakeman',
\    'reek',
\    'rubocop',
\    'ruby',
\    'solargraph',
\  ]

let g:ale_fixers = {}
let g:ale_fixers.javascripit = ['eslint']
let g:ale_fixers.json = ['prettier']
let g:ale_fixers.ruby = ['rubocop']
let g:ale_fixers.yaml = ['prettier']

nnoremap <Leader>ad :ALEGoToDefinition<cr>
nnoremap <Leader>aD :ALEGoToDefinitionInTab<cr>
nnoremap <Leader>af :ALEFix<cr>
nnoremap <Leader>ai :ALEInfo<cr>
nnoremap <Leader>ar :ALEFindReferences<cr>
nnoremap <Leader>as :ALEFixSuggest<cr>

Plug 'tpope/vim-commentary'

Plug 'craigemery/vim-autotag'
let g:autotagTagsFile="tags"

Plug 'easymotion/vim-easymotion'
map <Space> <Plug>(easymotion-prefix)

Plug 'tpope/vim-fugitive'
nnoremap <Leader>ge :Gedit
nnoremap <Leader>gs :Gstatus<cr>
nnoremap <Leader>gc :Gcommit<space>--verbose<cr>
nnoremap <Leader>gd :Gdiff<cr>
nnoremap <Leader>gb :Gblame<cr>
nnoremap <Leader>gl :Glog<cr>

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

Plug 'andrewradev/linediff.vim'

Plug 'aklt/plantuml-syntax'

Plug 'tpope/vim-repeat'

Plug 'iCyMind/NeoSolarized'
let g:neosolarized_visibility = "high"

Plug 'tpope/vim-speeddating'

Plug 'tpope/vim-surround'

"" code

"" crystal
Plug 'rhysd/vim-crystal'
nnoremap <Leader>cr :!crystal run %<cr>
nnoremap <Leader>cb :!crystal build %<cr>
Plug 'elorest/vim-slang'

""" elixir
Plug 'elixir-lang/vim-elixir'
Plug 'mhinz/vim-mix-format'
nnoremap <Leader>mf :MixFormat<cr>
nnoremap <Leader>ms :MixFormatDiff<cr>

""" elm
Plug 'elmcast/elm-vim'
let g:elm_setup_keybindings = 0
nnoremap <Leader>lm :! elm make %
nnoremap <Leader>lb :! elm make src/Main.elm<cr>
nnoremap <Leader>lt :ElmTest<cr>
" nnoremap <Leader>lr :ElmRepl<cr>
nnoremap <Leader>le :ElmErrorDetail<cr>
nnoremap <Leader>ld :ElmShowDocs<cr>
nnoremap <Leader>lw :ElmBrowseDocs<cr>
nnoremap <Leader>lf :ElmFormat<cr>

""" go
"""" edit go with tabs at width 4
au BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4
Plug 'fatih/vim-go'
nnoremap <Leader>ob :GoBuild<cr>
nnoremap <Leader>od :GoDoc<cr>
nnoremap <Leader>of :GoFmt<cr>
nnoremap <Leader>or :GoRun<cr>

""" ruby
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
nnoremap <Leader>rr :Rails<cr>

call plug#end()

set background=dark
set termguicolors
colorscheme NeoSolarized

if !empty(glob("~/.config/nvim/init.vim.local"))
  source ~/.config/nvim/init.vim.local
endif
