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
" Highlight current line
set cul
" incrementally highlight searches
set incsearch hlsearch
" wrap & highlight @140 chars
set textwidth=140 colorcolumn=+0
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
set list listchars=tab:▷\\x20,trail:⋅,nbsp:☺,extends:→,precedes:←
" trim trailing whitespace on save
au BufWritePre * :%s/\s\+$//e
" include hyphens in words
set iskeyword=@,48-57,_,192-255,-
" continue comments on enter or o
set formatoptions+=ro

let g:python3_host_prog = '~/.asdf/shims/python'

let data_dir = stdpath('data') . '/site'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.local/share/nvim/plugged')

" new plugins to try
" Plug 'ervandew/supertab'
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'janko-m/vim-test'
" Plug 'nvim-telescope/telescope.nvim'
" Plug 'ggandor/lightspeed.nvim'
" Plug 'tpope/vim-sensible'
" Plug 'tpope/vim-vinegar'
" TODO: add indent object to wellle/targets.vim?
" Plug 'michaeljsmith/vim-indent-object'
" Plug 'kannokanno/previm'
" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
" Plug 'powerman/vim-plugin-AnsiEsc'
" Plug 'nathom/filetype.nvim'
" Plug 'tpope/projectionist'
" Plug 'justinmk/vim-dirvish'

" enable as needed
" Plug 'tpope/vim-dadbod'
" Plug 'lervag/vimtex'
" let g:tex_flavor = 'latex'

Plug 'sheerun/vim-polyglot'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" TODO: try builtin LSP or natebosch/vim-lsc
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'phaazon/hop.nvim', { 'branch': 'v1.3' }
Plug 'editorconfig/editorconfig-vim'
Plug 'honza/vim-snippets'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'wellle/targets.vim'
Plug 'mhinz/vim-signify'
Plug 'andrewradev/linediff.vim'
Plug 'pbrisbin/vim-mkdir'

Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'ap/vim-css-color'
" included for folding
Plug 'preservim/vim-markdown'
Plug 'chriskempson/base16-vim'

" TODO: hunt down clever indentation inference
Plug 'raimondi/delimitmate'
" TODO: is it worth keeping endwise?
" Plug 'tpope/vim-endwise'

" TODO: compare commentary to tomtom/tcomment_vim
Plug 'tpope/vim-commentary'

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

if !empty(glob("~/.config/nvim/plugs.os.vim"))
    source ~/.config/nvim/plugs.os.vim
endif
if !empty(glob("~/.config/nvim/plugs.local.vim"))
    source ~/.config/nvim/plugs.local.vim
endif

" here vim-plug runs both `filetype plugin indent on` and `syntax enable`
call plug#end()

" TODO: go through https://www.youtube.com/watch?v=434tljD-5C8
nmap <leader>Q :bufdo bdelete<cr>
map g<c-f> :edit <cfile><cr>
imap ;; <esc>A;<esc>
imap ,, <esc>A,<esc>
" nmap <c-e> 5<c-e>
" nmap <c-y> 5<c-y>

set background=dark
set termguicolors
colorscheme base16-onedark

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

" " TODO: change these into a command
" " open new splits
" nmap <leader>` :sp \| te<cr>
" nmap <leader>~ :tabnew \| te<cr>

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
nmap <leader><leader>, :so ~/.config/nvim/init.vim<cr>
nmap <leader>; :execute 'tabnew ~/.config/nvim/ftplugin/' . &ft . '.vim'<cr>
nmap <leader><leader>; :so %<cr>

" copy filename
nmap <leader>% :let @+=@%<cr>

" clipboard
nmap <leader>p "+p
vmap <leader>p "+p
nmap <leader>P "+P
nmap <leader>y "+y
vmap <leader>y "+y
nmap <leader>Y "+Y
nmap <leader>x "+x
vmap <leader>x "+x
nmap <leader>X "+X

" encoding / decoding, similar to unimpaired
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

" split line before/after cursor
nmap [<cr> i<cr><esc>
nmap ]<cr> a<cr><esc>

" search for selected text
vmap * y/<c-r>"<cr>
" search
" nmap <c-n> :call setreg("s", &filetype)<cr>:!bash -c 'open "https://duckduckgo.com/?q=<c-r>s+<c-r><c-w>&ia=web"'<cr>
" vmap <c-n> y:call setreg("s", &filetype)<cr>:!bash -c 'open "https://duckduckgo.com/?q=<c-r>s+$(echo <c-r>" \| sed '"'"'s/ /+/g'"'"')&ia=web"'<cr>

" vim-plug
func! UpdateAll ()
    exec 'PlugUpgrade'
    exec 'PlugUpdate'
    exec 'CocUpdate'
endfunc
nmap <leader>u :call UpdateAll()<cr>

let g:vimsyn_embed = 'l'
lua <<EOF
require'hop'.setup()
vim.api.nvim_set_keymap('n', '\'', '<cmd>HopChar2MW<cr>', { noremap = true })
vim.api.nvim_set_keymap('o', 'z', "<cmd>lua require'hop'.hint_char1({ current_line_only = true, inclusive_jump = true })<cr>", { noremap = true })
vim.api.nvim_set_keymap('v', 'z', "<cmd>lua require'hop'.hint_char2({ inclusive_jump = true })<cr>", { noremap = true })
EOF

" delimitmate
let delimitMate_balance_matchpairs = 1
let delimitMate_expand_cr = 2
let delimitMate_expand_inside_quotes = 1
let delimitMate_expand_space = 1
let delimitMate_jump_expansion = 1
let delimitMate_excluded_regions = "String"
let delimitMate_excluded_ft = ""

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" fugitive/signify
set updatetime=100
nmap <leader>g<space> :Git<space>
nmap <leader>gs :Git<cr>
nmap <leader>gd :Gvdiffsplit<cr>
nmap <leader>gb :Git blame<cr>
nmap <leader>gi :SignifyHunkDiff<cr>
omap id <plug>(signify-motion-inner-pending)
xmap id <plug>(signify-motion-inner-visual)
omap ad <plug>(signify-motion-outer-pending)
xmap ad <plug>(signify-motion-outer-visual)
" add/undo hunk under the cursor hack
nmap <leader>ga :Gdiffsplit<cr>do:wq<cr>
nmap <leader>gu :Gdiffsplit<cr>dp:wq<cr>
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
