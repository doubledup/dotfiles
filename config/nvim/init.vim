" show line numbers
set number
" ignore case unless there are upper-case characters
set ignorecase smartcase
" split below and to the right, leaving existing panes where they are
set splitbelow splitright
" live on the edge!
set noswapfile nobackup nowritebackup autoread
" don't wrap long lines by default, but be more sensible when wrapping is on
set nowrap linebreak
" don't redraw while executing commands & using registers
set lazyredraw
" Highlight current column and line
set cuc cul
" incrementally highlight searches
set incsearch hlsearch
" wrap @140 chars, highlight @80 chars
set textwidth=140 colorcolumn=80
" use global clipboard by default
set clipboard^=unnamedplus
" fold on indents; don't fold when opening files
set foldmethod=indent nofoldenable
" leave some space around the cursor when moving
set scrolloff=5 sidescroll=20 sidescrolloff=1
" ignore modelines due to security concerns
set modelines=0 nomodeline

" make existing tabs an obnoxious 8 chars; use 2-space indentation by default
set ts=8 sts=2 sw=2 et
" automatically indent when adding a new line
set autoindent smartindent

" show extra whitespace
set list listchars=tab:▷⋅,trail:⋅,nbsp:☺,extends:→,precedes:←

" trim trailing whitespace on save
au BufWritePre * :%s/\s\+$//e

call plug#begin('~/.local/share/nvim/plugged')

" new plugins to try
" Plug 'tomtom/tcomment_vim'
" Plug 'tpope/vim-sensible'
" Plug 'jaxbot/semantic-highlight.vim'
" Plug 'ervandew/supertab'
" Plug 'tpope/vim-sleuth'
" Plug 'c9s/vikube.vim'
" Plug 'janko-m/vim-test'
" Plug 'HerringtonDarkholme/yats.vim'
" Plug 'michaeljsmith/vim-indent-object'
" Plug 'kien/ctrlp.vim'
" Plug 'dbeecham/ctrlp-commandpalette.vim'
" Plug 'ggandor/lightspeed.nvim'

" enable as needed
" Plug 'tpope/vim-dadbod'
" Plug 'lervag/vimtex'
" let g:tex_flavor = 'latex'
" Plug 'aklt/plantuml-syntax'

" general

" endwise & delimitmate seem similar
Plug 'airblade/vim-gitgutter'
Plug 'andrewradev/linediff.vim'
" Plug 'flazz/vim-colorschemes'
" Plug 'https://gitlab.com/protesilaos/tempus-themes-vim.git'
Plug 'chriskempson/base16-vim'
Plug 'easymotion/vim-easymotion'
Plug 'editorconfig/editorconfig-vim'
Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim'
" Plug 'jreybert/vimagit'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'mattn/emmet-vim'
Plug 'nelstrom/vim-markdown-folding'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
" TODO: fix {<cr> behaviour
Plug 'raimondi/delimitmate'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'wellle/targets.vim'

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

" vim-markdown-folding
" Already set up by vim-plug. Uncomment this if switching to a package
" manager that doesn't run it.
" if has("autocmd")
"   filetype plugin indent on
" endif

set background=dark
set termguicolors
colorscheme base16-monokai

set noshowmode
let g:lightline = {
      \ 'colorscheme': 'one',
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

let NERDTreeWinSize=60
let NERDTreeShowHidden=1

let mapleader = "\<space>"
let maplocalleader = ","
let g:user_emmet_leader_key='<c-\>'

" disable arrow keys; don't be a peasant.
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" terminal mode
" open new splits
nmap <leader>t :sp \| te<cr>
nmap <leader>T :tabnew \| te<cr>
" nmap <c-:> :sp \| te<cr>
" quit
tmap <c-q> <c-\><c-n>

" help command abbrevs
" open help in a vertical split
cnoreabbrev hv vert h
" use H to open help in a new tab
cnoreabbrev ht tab h

" clear search highlights
nmap <esc> :noh<cr>
" save all
nmap <c-s> :wall<cr>

" nmap <c-n> :call setreg("s", &filetype)<cr>:!bash -c 'open "https://duckduckgo.com/?q=<c-r>s+<c-r><c-w>&ia=web"'<cr>
nmap <c-j> :m .+1<cr>==
nmap <c-k> :m .-2<cr>==
vmap <c-j> :m '>+1<cr>gv=gv
vmap <c-k> :m '<-2<cr>gv=gv
nmap <c-l> :tabn<cr>
nmap <c-h> :tabp<cr>
nmap <leader><c-l> :tabmove +1<cr>
nmap <leader><c-h> :tabmove -1<cr>
nmap gt :tabmove<space>

" get new file changes from disk
nmap <leader>d :checktime<cr>

nmap <leader>ot :tabon<cr>
nmap <leader>oT :tabon!<cr>

nmap <leader>c :tabnew ~/.config/nvim/init.vim<cr>
nmap <leader>cc :so ~/.config/nvim/init.vim<cr>

" copy filename
nmap <leader>n :let @+=@%<cr>

" base64 encoding
nmap [dd !!base64<cr>
nmap ]dd !!base64 -d<cr>
vmap [d c<c-r>=system("echo '<c-r>"' \| base64 \| tr -d '\n'")<cr><esc>
vmap ]d c<c-r>=system("echo '<c-r>"' \| base64 -d \| tr -d '\n'")<cr><esc>

" vim-plug
nmap <leader>u :CocUpdate<cr>:PlugUpgrade<cr>:PlugUpdate<cr>
" :CocCommand tabnine.updateTabNine<cr>

nmap ' <Plug>(easymotion-overwin-f)

" fugitive
nmap <leader>vs :vert Git<cr>
nmap <leader>vd :Gvdiffsplit<cr>
nmap <leader>vb :Git blame<cr>
nmap <leader>vf :Git fetch<cr>
nmap <leader>vp :Git pull<cr>
nmap <leader>vm :tab Git commit -v<cr>
nmap <leader>vc :Git checkout<space>
nmap <leader>vl :Git clean<space>
nmap <leader>vr :Git reset<space>

" fzf
nmap <c-p> :Files<cr>
" TODO: buffer deletion
nmap <leader>b :Buffers<cr>
nmap <leader>h :History<cr>
nmap <leader>m :Commits<cr>
nmap <leader>w :Windows<cr>
nmap <leader>r :Rg<cr>
nmap <leader>s :Lines<cr>
nmap <leader>/ :BLines<cr>
nmap <leader>* :BLines <c-r><c-w><cr>

nmap - :NERDTreeToggle<cr>
nmap _ :NERDTreeFind<cr>

" nmap <leader>v :Magit<cr>

" search for selected text
vmap * y/<c-r>"<cr>
" search
" vmap <c-n> y:call setreg("s", &filetype)<cr>:!bash -c 'open "https://duckduckgo.com/?q=<c-r>s+$(echo <c-r>" \| sed '"'"'s/ /+/g'"'"')&ia=web"'<cr>
vmap <leader>/ y:BLines <c-r>"<cr>
vmap <leader>r y:Rg <c-r>"<cr>


if filereadable(expand("~/.config/nvim/coc-settings.vim"))
  source ~/.config/nvim/coc-settings.vim
endif
if filereadable(expand("~/.config/nvim/init.os.vim"))
  source ~/.config/nvim/init.os.vim
endif
if filereadable(expand("~/.config/nvim/init.local.vim"))
  source ~/.config/nvim/init.local.vim
endif
