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
set cul
" incrementally highlight searches
set incsearch hlsearch
" wrap @140 chars, highlight @80 chars
set textwidth=140 colorcolumn=80
" fold on indents; don't fold when opening files
set foldmethod=indent nofoldenable
" leave some space around the cursor when moving
set scrolloff=5 sidescroll=20 sidescrolloff=1
" ignore modelines due to security concerns
set modelines=0 nomodeline
" always show file tabs
set showtabline=2

" use 4-space indentation by default
set et ts=4 sw=4
" automatically indent when adding a new line
set autoindent smartindent

" show extra whitespace
set list listchars=tab:▷⋅,trail:⋅,nbsp:☺,extends:→,precedes:←
" trim trailing whitespace on save
au BufWritePre * :%s/\s\+$//e

" include hyphens in words
set iskeyword=@,48-57,_,192-255,-

" set encoding=utf8

let g:python3_host_prog = 'python3'

call plug#begin('~/.local/share/nvim/plugged')

" new plugins to try
" Plug 'ervandew/supertab'
" Plug 'nvim-treesitter/nvim-treesitter'
" Plug 'nvim-telescope/telescope.nvim'
" Plug 'ggandor/lightspeed.nvim'
" Plug 'tpope/vim-sensible'
" TODO: add indent object to wellle/targets.vim?
" Plug 'michaeljsmith/vim-indent-object'
" Plug 'tpope/vim-sleuth'
" Plug 'janko-m/vim-test'
" Plug 'kannokanno/previm'

" enable as needed
" Plug 'tpope/vim-dadbod'
" Plug 'lervag/vimtex'
" let g:tex_flavor = 'latex'

" TODO: treesitter
Plug 'sheerun/vim-polyglot'
" TODO: try builtin LSP or natebosch/vim-lsc
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'easymotion/vim-easymotion'
Plug 'editorconfig/editorconfig-vim'
Plug 'honza/vim-snippets'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'wellle/targets.vim'

" TODO: Also try these for OneDark support
" joshdick/onedark.vim
" navarasu/onedark.nvim
Plug 'chriskempson/base16-vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'ap/vim-css-color'

" included for folding
Plug 'preservim/vim-markdown'

" TODO: hunt down clever indentation inference
Plug 'raimondi/delimitmate'
" TODO: is it worth keeping endwise?
" Plug 'tpope/vim-endwise'

" TODO: compare commentary to tomtom/tcomment_vim
Plug 'tpope/vim-commentary'

" TODO: compare gitgutter to mhinz/vim-signify
Plug 'airblade/vim-gitgutter'
Plug 'andrewradev/linediff.vim'
" " TODO: compare blamer to f-person/git-blame.nvim
" Plug 'APZelos/blamer.nvim'
" TODO: compare fugitive to jreybert/vimagit
Plug 'tpope/vim-fugitive'

" TODO: compare wilder to ctrlp
" Plug 'kien/ctrlp.vim'
" Plug 'dbeecham/ctrlp-commandpalette.vim'
function! UpdateRemotePlugins(...)
    " Needed to refresh runtime files
    let &rtp=&rtp
    UpdateRemotePlugins
endfunction
Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }

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
colorscheme base16-onedark

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
      \     'git-branch': 'FugitiveHead',
      \     'filetype': 'LightlineFiletype'
      \ },
      \ }

function! LightlineFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

let NERDTreeWinSize=60
let NERDTreeShowHidden=1

let mapleader = "\<space>"
let g:user_emmet_leader_key='<c-\>'

" " disable arrow keys; don't be a peasant.
" noremap <up> <nop>
" noremap <down> <nop>
" noremap <left> <nop>
" noremap <right> <nop>

" terminal mode
" quit
tmap <c-q> <c-\><c-n>

" " TODO: change these into a command
" " open new splits
" nmap <leader>t :sp \| te<cr>
" nmap <leader>T :tabnew \| te<cr>

" TODO: fully close terminal on exit without interfering with fzf
" autocmd TermClose * exe 'bdelete! '..expand('<abuf>')
" autocmd TermClose * if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif

" help command abbrevs
" open help in a vertical split
cnoreabbrev hv vert h
" use H to open help in a new tab
cnoreabbrev ht tab h

" clear search highlights
nmap <esc> :noh<cr>
" save all
" TODO: run checktime before this?
nmap <c-s> :wall<cr>

" nmap <c-j> :m .+1<cr>==
" nmap <c-k> :m .-2<cr>==
vmap ]e :m '>+1<cr>gv=gv
vmap [e :m '<-2<cr>gv=gv
nmap <c-n> :tabn<cr>
nmap <c-p> :tabp<cr>
nmap <leader><c-n> :tabmove +1<cr>
nmap <leader><c-p> :tabmove -1<cr>
nmap gt :tabmove<space>

nmap <c-h> <c-w>h
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-l> <c-w>l

" nmap <leader>ot :tabon<cr>
" nmap <leader>oT :tabon!<cr>

nmap <leader>, :tabnew ~/.config/nvim/init.vim<cr>
nmap <leader>,, :so ~/.config/nvim/init.vim<cr>

" copy filename
nmap <leader>% :let @+=@%<cr>

" clipboard
nmap <leader>p "+p
vmap <leader>p "+p
nmap <leader>P "+P
nmap <leader>y "+y
vmap <leader>y "+y
nmap <leader>Y "+Y

" base64 encoding
nmap [dd !!base64<cr>
nmap ]dd !!base64 -d<cr>
vmap [d c<c-r>=system("echo '<c-r>"' \| base64 \| tr -d '\n'")<cr><esc>
vmap ]d c<c-r>=system("echo '<c-r>"' \| base64 -d \| tr -d '\n'")<cr><esc>

" split line before/after cursor
nmap [<cr> i<cr><esc>
nmap ]<cr> a<cr><esc>

" search for selected text
vmap * y/<c-r>"<cr>
" search
" nmap <c-n> :call setreg("s", &filetype)<cr>:!bash -c 'open "https://duckduckgo.com/?q=<c-r>s+<c-r><c-w>&ia=web"'<cr>
" vmap <c-n> y:call setreg("s", &filetype)<cr>:!bash -c 'open "https://duckduckgo.com/?q=<c-r>s+$(echo <c-r>" \| sed '"'"'s/ /+/g'"'"')&ia=web"'<cr>

" vim-plug
nmap <leader>u :CocUpdate<cr>:PlugUpgrade<cr>:PlugUpdate<cr>

nmap ' <Plug>(easymotion-overwin-f2)
omap z <Plug>(easymotion-f)

" delimitmate
let delimitMate_balance_matchpairs = 1
let delimitMate_expand_cr = 2
let delimitMate_expand_inside_quotes = 1
let delimitMate_expand_space = 1
let delimitMate_jump_expansion = 1
let delimitMate_excluded_regions = "String"
let delimitMate_excluded_ft = ""

" fugitive
" status
nmap <leader>g<space> :Git<space>
nmap <leader>gs :Git<cr>
nmap <leader>gd :Gvdiffsplit<cr>
nmap <leader>gb :Git blame<cr>
" inline preview
nmap <leader>gi <Plug>(GitGutterPreviewHunk)
" add hunk
nmap <leader>ga <Plug>(GitGutterStageHunk)
nmap <leader>gu <Plug>(GitGutterUndoHunk)
nmap <leader>gm :tab Git commit -v<cr>
nmap <leader>gz :Git stash<space>
nmap <leader>gf :Git fetch<cr>
nmap <leader>gp :Git pull<space>
nmap <leader>gc :Git checkout<space>
nmap <leader>gg :Git<space>
" git log
nmap <leader>gl :Commits!<cr>

" fzf
" TODO: use fzf env vars for preview
" command! -bang -nargs=? -complete=dir Files
"     \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0)
nmap <leader>f :Files!<cr>
" TODO: buffer deletion
nmap <leader>b :Buffers!<cr>
nmap <leader>h :History!<cr>
nmap <leader>w :Windows!<cr>

" regex
nmap <leader>e :Rg!<cr>
vmap <leader>e y:Rg! <c-r>"<cr>
nmap <leader>/ :BLines!<cr>
vmap <leader>/ y:BLines! <c-r>"<cr>
nmap <leader>* :BLines! <c-r><c-w><cr>
vmap <leader>* y:BLines! <c-r>"<cr>
nmap <leader>: :Commands!<cr>

" gitgutter
" let g:gitgutter_map_keys = 0
nmap [c <Plug>(GitGutterPrevHunk)
nmap ]c <Plug>(GitGutterNextHunk)

" " LineDiff
" vmap <leader>l :LineDiff<cr>

" vim-markdown
let g:vim_markdown_folding_level = 2
let g:vim_markdown_no_default_key_mappings = 1

" NERDTree
nmap \\ :NERDTreeToggle<cr>
nmap \. :NERDTreeFind<cr>

" wilder
set nowildmenu
call wilder#setup({
      \ 'modes': [':', '/', '?'],
      \ 'accept_key': '<c-y>',
      \ 'reject_key': '<c-e>',
      \ })
call wilder#set_option('pipeline', [
      \   wilder#branch(
      \     wilder#cmdline_pipeline({
      \       'fuzzy': 1,
      \       'set_pcre2_pattern': 1,
      \     }),
      \     wilder#python_search_pipeline({
      \       'pattern': 'fuzzy',
      \     }),
      \   ),
      \ ])

call wilder#set_option('renderer', wilder#popupmenu_renderer({
      \ 'highlighter': wilder#basic_highlighter(),
      \ 'left': [
      \   ' ', wilder#popupmenu_devicons(),
      \ ],
      \ 'right': [
      \   ' ', wilder#popupmenu_scrollbar(),
      \ ],
      \ }))

if filereadable(expand("~/.config/nvim/coc-settings.vim"))
    source ~/.config/nvim/coc-settings.vim
endif
if filereadable(expand("~/.config/nvim/init.os.vim"))
    source ~/.config/nvim/init.os.vim
endif
if filereadable(expand("~/.config/nvim/init.local.vim"))
    source ~/.config/nvim/init.local.vim
endif
