" vim-sensible overrides
" " automatically indent when adding a new line
" set autoindent smartindent
" leave some space around the cursor when moving
set scrolloff=5
" show extra whitespace
set list listchars=tab:▷\ ,trail:⋅,nbsp:☺,extends:→,precedes:←
" continue comments on new lines
set formatoptions+=ro
" live on the edge!
set noswapfile

" show line numbers
set number
" Highlight current line
set cursorline
" use 4-space indentation by default
set expandtab tabstop=4 shiftwidth=4
" wrap & highlight @140 chars
set textwidth=140 colorcolumn=+0
" don't wrap long lines by default, but be more sensible when wrapping is on
set nowrap linebreak
" ignore case unless there are upper-case characters
set ignorecase smartcase
" split below and to the right, leaving existing panes where they are
set splitbelow splitright
" always show file tabs
set showtabline=2
" include hyphens in words
set iskeyword^=-
" don't redraw while executing commands & using registers
set lazyredraw
" fold on indents; don't fold when opening files
set foldmethod=indent nofoldenable
" ignore modelines due to security concerns
set nomodeline modelines=0

let data_dir = stdpath('data') . '/site'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.local/share/nvim/plugged')
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-scriptease'
Plug 'sheerun/vim-polyglot'
" TODO: try builtin LSP or one of
" Plug 'natebosch/vim-lsc'
" Plug 'ms-jpq/coq_nvim'
" Plug 'autozimu/LanguageClient-neovim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'editorconfig/editorconfig-vim'
Plug 'mhinz/vim-signify'
" TODO: vs jreybert/vimagit
Plug 'tpope/vim-fugitive'

" editing
Plug 'andrewradev/linediff.vim'
Plug 'honza/vim-snippets'
" Plug 'mattn/emmet-vim'
Plug 'pbrisbin/vim-mkdir'
Plug 'phaazon/hop.nvim', { 'branch': 'v1.3' }
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
" TODO: add indent object to wellle/targets.vim?
Plug 'wellle/targets.vim'
Plug 'raimondi/delimitmate'

" new editing
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'mizlan/iswap.nvim'
Plug 'jpalardy/vim-slime'

" ui
Plug 'ap/vim-css-color'
Plug 'Luxed/ayu-vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
" TODO: vs Plug 'tpope/vim-vinegar'
" TODO: vs Plug ms-jpq/chadtree
Plug 'preservim/nerdtree'
Plug 'preservim/vim-markdown' " included for folding
Plug 'ryanoasis/vim-devicons'

" Included separately from polyglot to get commands
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" TODO: vs Plug 'kien/ctrlp.vim'
" TODO: vs Plug 'dbeecham/ctrlp-commandpalette.vim'
function! UpdateRemotePlugins(...)
    " Needed to refresh runtime files
    let &rtp=&rtp
    UpdateRemotePlugins
endfunction
Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }

" new plugins to try
" Plug 'ervandew/supertab'
" Plug 'janko-m/vim-test'
" Plug 'nvim-telescope/telescope.nvim'
" Plug 'ggandor/lightspeed.nvim'
" Plug 'michaeljsmith/vim-indent-object'
" Plug 'kannokanno/previm'
" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
" Plug 'powerman/vim-plugin-AnsiEsc'
" Plug 'nathom/filetype.nvim'
" Plug 'tpope/projectionist'
" Plug 'justinmk/vim-dirvish'
" Plug 'APZelos/blamer.nvim' vs Plug 'f-person/git-blame.nvim'
" Plug 'sjl/gundo.vim'
" Plug 'thaerkh/vim-workspace'

" enable as needed
" Plug 'tpope/vim-dadbod'
" Plug 'lervag/vimtex'
" let g:tex_flavor = 'latex'

if !empty(glob("~/.config/nvim/plugs.os.vim"))
    source ~/.config/nvim/plugs.os.vim
endif
if !empty(glob("~/.config/nvim/plugs.local.vim"))
    source ~/.config/nvim/plugs.local.vim
endif

" here vim-plug runs both `filetype plugin indent on` and `syntax enable`
call plug#end()

" trim trailing whitespace on save
au BufWritePre * :%s/\s\+$//e

nnoremap <c-e> 10<c-e>
nnoremap <c-y> 10<c-y>

set background=dark
set termguicolors
let ayucolor="mirage"
colorscheme ayu

" neovide
set guifont=Hack\ Nerd\ Font\ Mono:h14

set noshowmode
let g:lightline = {
      \ 'colorscheme': 'one',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'git-branch-symbol', 'git-branch' ],
      \             [ 'readonly', 'modified', 'relativepath' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'fileformat', 'fileencoding', 'percent' ],
      \              [ 'filetype' ]]
      \ },
      \ 'component': {
      \     'git-branch-symbol': ''
      \ },
      \ 'component_function': {
      \     'git-branch': 'FugitiveHead',
      \     'filetype': 'LightlineFiletype'
      \ },
      \ }

function! LightlineFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

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
augroup terminal_settings
  autocmd!

  " BufWinEnter,
  autocmd WinEnter,TermOpen term://* startinsert
  autocmd BufLeave term://* stopinsert

  " Ignore various filetypes as those will close terminal automatically
  " Ignore fzf, ranger, coc
  autocmd TermClose term://*
        \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") |
        \   call nvim_input('<CR>')  |
        \ endif
augroup END
" " TODO: change these into a command
" " open new splits
nmap <leader>` :sp \| te<cr>
nmap <leader>~ :-1tabnew \| te<cr>

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

nmap <leader>, :tabnew<cr>:tcd ~/.dotfiles<cr>:e config/nvim/init.vim<cr>
nmap <leader><leader>, :so ~/.config/nvim/init.vim<cr>
nmap <leader>; :execute 'tabnew ~/.config/nvim/ftplugin/' . &ft . '.vim'<cr>
nmap <leader><leader>. :so %<cr>

" copy filename
nmap <leader>5 :let @+=@%<cr>
" clipboard
nmap <leader>' :let @+=@"<cr>
nmap <leader>p "+p
vmap <leader>p "+p
nmap <leader>P "+P

" unimpaired extensions
"" encoding / decoding
nmap [44 !!base64<cr>
nmap ]44 !!base64 -d<cr>
vmap [4 "4c<c-r>=system("echo '<c-r>4' \| base64 \| tr -d '\n'")<cr><esc>
vmap ]4 "4c<c-r>=system("echo '<c-r>4' \| base64 -d \| tr -d '\n'")<cr><esc>

nmap [66 !!sed -E 's/(.*)/obase=16;\1/' \| bc<cr>
nmap ]66 !!sed -E 's/(.*)/ibase=16;\1/' \| bc<cr>
vmap [6 "6c<c-r>=system("echo 'obase=16;<c-r>6' \| bc \| tr -d '\n'")<cr><esc>
vmap ]6 "6c<c-r>=system("echo 'ibase=16;<c-r>6' \| bc \| tr -d '\n'")<cr><esc>

nmap [88 !!sed -E 's/(.*)/obase=8;\1/' \| bc<cr>
nmap ]88 !!sed -E 's/(.*)/ibase=8;\1/' \| bc<cr>
vmap [8 "8c<c-r>=system("echo 'obase=8;<c-r>8' \| bc \| tr -d '\n'")<cr><esc>
vmap ]8 "8c<c-r>=system("echo 'ibase=8;<c-r>8' \| bc \| tr -d '\n'")<cr><esc>

nmap [22 !!sed -E 's/(.*)/obase=2;\1/' \| bc<cr>
nmap ]22 !!sed -E 's/(.*)/ibase=2;\1/' \| bc<cr>
vmap [2 "2c<c-r>=system("echo 'obase=2;<c-r>2' \| bc \| tr -d '\n'")<cr><esc>
vmap ]2 "2c<c-r>=system("echo 'ibase=2;<c-r>2' \| bc \| tr -d '\n'")<cr><esc>

"" split line before/after cursor
nmap [<cr> i<cr><esc>
nmap ]<cr> a<cr><esc>

"" add blank lines, but respect existing auto-insertion like comments
nmap [<space> O<esc>j
nmap ]<space> o<esc>k

" search for selected text
vmap * y/<c-r>"<cr>

" vim-plug
func! UpdateAll ()
    exec 'PlugUpgrade'
    exec 'PlugUpdate'
    exec 'CocUpdate'
    exec 'TSUpdate'
endfunc
nmap <leader>u :call UpdateAll()<cr>

" commentary
imap <c-c> <esc>:Commentary<cr>a
nmap <c-c> :Commentary<cr>
xmap <c-c> :Commentary<cr>

" delimitmate
let delimitMate_balance_matchpairs = 1
let delimitMate_expand_cr = 2
let delimitMate_expand_inside_quotes = 1
let delimitMate_expand_space = 1
let delimitMate_jump_expansion = 1
let delimitMate_excluded_regions = ""
let delimitMate_excluded_ft = ""

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" git
" fugitive
" set updatetime=100
" :-1tab Git<cr> still opens after the current tab
nmap <leader>gs :-1tabnew<cr>:Git<cr><c-w><c-o>
nmap <leader>gd :Gvdiffsplit<cr>
nmap <leader>gb :Git blame<cr>
nmap <leader>gf :Git! fetch<cr>
nmap <leader>gz :Git stash<space>
nmap <leader>gp :Git! pull<space>
nmap <leader>gu :Git! push<space>
nmap <leader>go :Git checkout<space>
nmap <leader>gc :tab Git commit -v<cr>
" fzf
nmap <leader>gl :Commits!<cr>
" signify
nmap <leader>gi :SignifyHunkDiff<cr>
" hack to add/unstage hunk under the cursor
nmap <leader>ga :Gdiffsplit<cr>do:wq<cr>
nmap <leader>gu :Gdiffsplit<cr>dp:wq<cr>
omap id <plug>(signify-motion-inner-pending)
xmap id <plug>(signify-motion-inner-visual)
omap ad <plug>(signify-motion-outer-pending)
xmap ad <plug>(signify-motion-outer-visual)

" fzf
" TODO: use fzf env vars for preview
" command! -bang -nargs=? -complete=dir Files
"     \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0)
nmap <leader>f :Files!<cr>
" TODO: buffer deletion
nmap <leader>b :Buffers!<cr>
nmap <leader>i :History!<cr>
nmap <leader>w :Windows!<cr>
" regex commands
nmap <leader>e :Rg!<cr>
vmap <leader>e y:Rg! <c-r>"<cr>
nmap <leader>/ :BLines!<cr>
vmap <leader>/ y:BLines! <c-r>"<cr>
nmap <leader>* :BLines! <c-r><c-w><cr>
vmap <leader>* y:BLines! <c-r>"<cr>
nmap <leader>: :History:!<cr>

" fatih/vim-go
let g:go_code_completion_enabled = 0
let g:go_doc_keywordprg_enabled = 0
let g:go_fmt_autosave = 0
let g:go_def_mapping_enabled = 0
let g:go_term_mode = "split"
let g:go_term_reuse = 1
let g:go_term_enabled = 1
let g:go_term_close_on_exit = 0
let g:go_gopls_enabled = 0

" regex
nmap <leader>e :Rg!<cr>
vmap <leader>e y:Rg! <c-r>"<cr>
nmap <leader>/ :BLines!<cr>
vmap <leader>/ y:BLines! <c-r>"<cr>
nmap <leader>* :BLines! <c-r><c-w><cr>
vmap <leader>* y:BLines! <c-r>"<cr>
nmap <leader>: :History:!<cr>

" " LineDiff
" vmap <leader>l :LineDiff<cr>

" hop
let g:vimsyn_embed = 'l'
lua <<EOF
require'hop'.setup()
vim.api.nvim_set_keymap('n', '\'', '<cmd>HopChar2MW<cr>', { noremap = true })
vim.api.nvim_set_keymap('o', 'z', "<cmd>lua require'hop'.hint_char1({ current_line_only = true, inclusive_jump = true })<cr>", { noremap = true })
vim.api.nvim_set_keymap('v', 'z', "<cmd>lua require'hop'.hint_char2({ inclusive_jump = true })<cr>", { noremap = true })
EOF

" vim-markdown
let g:vim_markdown_folding_level = 2
let g:vim_markdown_toc_autofit = 1
autocmd BufEnter *{.md,.mdx} set wrap
function! ToggleMdOutline() abort
  let b:md_outline_present = get(b:, 'md_outline_present', 0)

  if b:md_outline_present == 1
    execute 'Toc'
    execute 'bdelete %'
    let b:md_outline_present = 0
  else
    execute 'Toc'
    wincmd p
    let b:md_outline_present = 1
  endif
endfunction
autocmd BufEnter *{.md,.mdx} nnoremap <buffer> <leader>o :call ToggleMdOutline()<cr>

" NERDTree
let NERDTreeShowHidden=1
nmap - :NERDTreeToggle<cr>
nmap <leader>- :NERDTreeFind<cr>

" wilder
let g:python3_host_prog = '~/.asdf/shims/python'
set nowildmenu
call wilder#setup({
      \ 'modes': [':', '/', '?'],
      \ 'accept_key': '<c-e>',
      \ 'reject_key': '<c-c>',
      \ 'next_key': '<tab>',
      \ 'previous_key': '<s-tab>',
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
