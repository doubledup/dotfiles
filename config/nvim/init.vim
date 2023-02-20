" TODO: see ins-completion
" TODO: change listchars multispace when using spaces
" TODO: find out why this only works after re-sourcing init
" set keywordprg=:vert\ help
" TODO: checkout https://github.com/NvChad/NvChad
" TODO: add indent object to wellle/targets.vim?
" TODO: add entire document object to wellle/targets.vim?
" TODO: persist undo history like thaerkh/vim-workspace

set expandtab tabstop=4 shiftwidth=4 " use 4-space indentation by default
set formatoptions+=ro " continue comments on new lines
set list listchars=tab:▷\ ,trail:⋅,nbsp:☺,extends:→,precedes:← " show extra whitespace
set nowrap linebreak " don't wrap long lines by default, but be more sensible when wrapping is on
set textwidth=120 colorcolumn=+0 " wrap & highlight @120 chars

set ignorecase smartcase " ignore case unless there are upper-case characters
set iskeyword^=- " include hyphens in words
set jumpoptions+=stack " drop forward jumplist locations when moving to a new location
set lazyredraw " don't redraw while executing commands & using registers
set nomodeline modelines=0 " ignore modelines due to security concerns
set noswapfile " live on the edge!
set scrolloff=2 sidescrolloff=15 " leave some space around the cursor when moving
set updatetime=300 " trigger CursorHold sooner

set breakindent breakindentopt=sbr showbreak=↪\  " indent when wrapping with showbreak starting the line
set cursorline " highlight current line
set foldmethod=indent nofoldenable " fold on indents; don't fold when opening files
set showtabline=2 " always show file tabs

set number relativenumber " relative line numbers
augroup insert_relativenumber " absolute line numbers in insert mode
    autocmd!
    autocmd InsertEnter * set norelativenumber
    autocmd InsertLeave * set relativenumber
augroup END

syntax enable
" https://neovim.discourse.group/t/introducing-filetype-lua-and-a-call-for-help/1806
let g:do_filetype_lua = 1
let g:did_load_filetypes = 0

let data_dir = stdpath('data') . '/site' " install vim-plug if necessary
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')

Plug 'editorconfig/editorconfig-vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-sensible' " TODO: vs Plug 'nvim-lua/kickstart.nvim'

" git
Plug 'mhinz/vim-signify' " TODO: vs Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive' " TODO: vs Plug 'jreybert/vimagit'
Plug 'tpope/vim-git'

" TODO: vs builtin LSP or one of
" Plug 'williamboman/mason.nvim' " and
" Plug 'williamboman/mason-lspconfig.nvim' " and
" Plug 'neovim/nvim-lspconfig'
" Plug 'glepnir/lspsaga.nvim'
" Plug 'natebosch/vim-lsc'
" Plug 'ms-jpq/coq_nvim'
" Plug 'autozimu/LanguageClient-neovim'
" Plug 'jose-elias-alvarez/null-ls.nvim'
" Plug 'ldelossa/litee.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" also replace completion
" Plug 'hrsh7th/nvim-cmp'
" Plug 'ervandew/supertab'

" editing
Plug 'andrewradev/linediff.vim'
Plug 'phaazon/hop.nvim' " TODO: vs Plug 'ggandor/leap.nvim'
Plug 'honza/vim-snippets'
Plug 'jpalardy/vim-slime'
Plug 'mizlan/iswap.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'pbrisbin/vim-mkdir'
Plug 'raimondi/delimitmate'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'wellle/targets.vim'

" ui
Plug 'folke/which-key.nvim'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'Luxed/ayu-vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'ryanoasis/vim-devicons' " TODO: vs Plug 'nvim-tree/nvim-web-devicons'

" TODO: vs one of
" Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
" Plug 'nvim-lualine/lualine.nvim'
Plug 'itchyny/lightline.vim'

" TODO: vs one of
" Plug 'tpope/vim-vinegar'
" Plug 'justinmk/vim-dirvish'
" Plug 'nvim-tree/nvim-tree.lua'
" Plug 'ms-jpq/chadtree'
" Plug 'luukvbaal/nnn.nvim'
Plug 'preservim/nerdtree'

function! UpdateRemotePlugins(...)
    let &rtp=&rtp " Needed to refresh runtime files
    UpdateRemotePlugins
endfunction
Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }

Plug 'preservim/vim-markdown' " included for folding
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' } " included separately from polyglot to get commands

" new plugins to try

" Plug 'nvim-telescope/telescope.nvim'
" Plug 'mbbill/undotree'
" Plug 'mfussenegger/nvim-dap'
" Plug 'ThePrimeagen/harpoon'
" Plug 'folke/trouble.nvim'
" Plug 'tpope/vim-dispatch'
" Plug 'janko-m/vim-test'
" Plug 'tpope/vim-rhubarb'
" Plug 'tpope/projectionist'
" Plug 'codota/tabnine-nvim', { 'do': './dl_binaries.sh' }
" Plug 'jameshiew/nvim-magic'
" Plug 'rest-nvim/rest.nvim'
" Plug 'kana/vim-textobj-entire'
" Plug 'kana/vim-textobj-user'
" Plug 'michaeljsmith/vim-indent-object'
" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

" Plug 'tpope/vim-eunuch'
" Plug 'folke/todo-comments.nvim'
" Plug 'wfxr/minimap.vim'
" Plug 'kannokanno/previm'
" Plug 'nathom/filetype.nvim'
" Plug 'APZelos/blamer.nvim' vs Plug 'f-person/git-blame.nvim'
" Plug 'sjl/gundo.vim'
" Plug 'Konfekt/FastFold'

" enable as needed
" Plug 'dstein64/vim-startuptime'
" Plug 'mattn/emmet-vim'
" Plug 'tpope/vim-dadbod'

" let g:tex_flavor = 'latex'
" Plug 'lervag/vimtex'

if !empty(glob("~/.config/nvim/plugs.os.vim"))
    source ~/.config/nvim/plugs.os.vim
endif
if !empty(glob("~/.config/nvim/plugs.local.vim"))
    source ~/.config/nvim/plugs.local.vim
endif

" here vim-plug runs both `filetype plugin indent on` and `syntax enable`
call plug#end()

command Update call Update()
function! Update ()
    execute('PlugUpgrade')
    execute('PlugUpdate')
    execute('CocUpdate')
    execute('TSUpdate')
endfunction

set termguicolors
let ayucolor="mirage"
colorscheme ayu

nnoremap <c-e> 10<c-e>
nnoremap <c-y> 10<c-y>

nnoremap zh 40zh " horizontal scolling
nnoremap zl 40zl

map gf :edit <cfile><cr>

noremap <up> :echo "All your arrow are belong to us!"<cr>
noremap <down> :echo "All your arrow are belong to us!"<cr>
noremap <left> :echo "All your arrow are belong to us!"<cr>
noremap <right> :echo "All your arrow are belong to us!"<cr>

set mousescroll=hor:1
map <ScrollWheelUp> <c-y>
map <ScrollWheelDown> <c-e>

cnoreabbrev h vert h
cnoreabbrev hx hor h
cnoreabbrev ht tab h

nnoremap <esc> :nohlsearch<cr>
nnoremap <cr> :checktime<cr>:wall<cr>

augroup onsave
    autocmd!
    autocmd BufWrite * :%s/\s\+$//e " trim trailing whitespace on save
    " TODO: autosave? See thaerkh/vim-workspace
    " autocmd InsertLeave,TextChanged * :wall
augroup END

nmap <c-n> :tabn<cr>
nmap <c-p> :tabp<cr>
nmap <c-.> :tabmove +1<cr>
nmap <c-,> :tabmove -1<cr>
nmap gm :tabmove<space>

" keep cursor in place when joining lines
nnoremap J mzJ`z
nnoremap gJ mzgJ`z

" move selected lines around
vmap <c-j> :m '>+1<cr>gv=gv
vmap <c-k> :m '<-2<cr>gv=gv

command DeleteHiddenBuffers call DeleteHiddenBuffers()
function! DeleteHiddenBuffers()
    let shownBuffers = {}
    for i in range(1, tabpagenr('$'))
        for j in tabpagebuflist(i)
            let shownBuffers[j] = 1
        endfor
    endfor

    let hiddenBuffers = []
    for i in range(1, bufnr('$'))
        if buflisted(i) && bufexists(i) && !has_key(shownBuffers, i)
            call add(hiddenBuffers, i)
        endif
    endfor

    if len(hiddenBuffers) > 0
        exe 'bdelete' join(hiddenBuffers)
    endif
endfunction

command DeleteUnnamedBuffers call DeleteUnnamedBuffers()
function! DeleteUnnamedBuffers()
    let emptyBuffers = []
    for i in range(1, bufnr('$'))
        if buflisted(i) && bufexists(i) && bufname(i) == ''
            call add(emptyBuffers, i)
        endif
    endfor

    if len(emptyBuffers) > 0
        exe 'bdelete' join(emptyBuffers)
    endif
endfunction

nmap gz :q<cr>
nmap gZ :tabclose<cr>
nmap g<c-z> :qa<cr>
nmap <c-w>t :tabonly<cr>

nmap <c-h> <c-w>h
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-l> <c-w>l

cmap <c-a> <c-b>

nmap <c-s> :%s/\v<<c-r><c-w>>/<c-r><c-w>/gcI<left><left><left><left>
" TODO: substitute selection xmap s :s/\v<<c-r><c-w>>/<c-r><c-w>/gI<left><left><left>

" split line before/after cursor
nmap [<cr> ha<cr><esc>kg_
nmap ]<cr> a<cr><esc>kg_

" add blank lines, but respect existing auto-insertion like comments
" TODO: make this work with .
nmap [<space> O<esc>j
nmap ]<space> o<esc>k

" search for selected text
vmap * "zy/\V<c-r>z<cr>

if exists("g:neovide")
    let g:neovide_cursor_vfx_mode = "ripple"
    set guifont=Hack\ Nerd\ Font:h14
endif

let mapleader = " "

" config
nmap <leader>, :tabnew<cr>:tcd ~/.dotfiles<cr>:e ~/.config/nvim/init.vim<cr>
nmap <leader><leader>, :so ~/.config/nvim/init.vim<cr>
nmap <leader>; :execute 'tabnew ~/.config/nvim/ftplugin/' . &ft . '.vim'<cr>
nmap <leader><leader>. :so %<cr>

" clipboard
" copy filename to system clipboard
nmap <leader>5 :let @+=@%<cr>
" copy current register to system clipboard
nmap <leader>" :let @+=@"<cr>
nmap <leader>y "+y
xmap <leader>y "+y
nmap <leader>Y "+Y
nmap <leader>p "+p
xmap <leader>p "+p
nmap <leader>P "+P
" change, delete or paste  without touching the unnamed register
nmap <leader>c "_c
xmap <leader>c "_c
nmap <leader>d "_d
xmap <leader>d "_d
xmap <leader><c-p> "_dp

" terminal
" quit
tmap <c-q> <c-\><c-n>
nmap <leader>tx :25sp \| te<cr>a
nmap <leader>tv :80vsp \| te<cr>a
nmap <leader>tt :-1tabnew \| te<cr>a
augroup terminal_settings
    autocmd!

    " Ignore various filetypes (fzf, ranger & coc) as those will close terminal automatically
    autocmd TermClose term://*
        \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") |
        \   call nvim_input('<CR>')  |
        \ endif
augroup END

" plugins

" commentary
imap <c-/> <c-o>:Commentary<cr>
nmap <c-/> :Commentary<cr>
xmap <c-/> :Commentary<cr>

" delimitmate
let delimitMate_balance_matchpairs = 1
let delimitMate_excluded_ft = ""
let delimitMate_excluded_regions = ""
let delimitMate_expand_cr = 2
let delimitMate_expand_inside_quotes = 1
let delimitMate_expand_space = 1
let delimitMate_jump_expansion = 1

" editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" fugitive
nmap <leader>gs :-1tab Git<cr>
nmap <leader>gf :Git! fetch<cr>
nmap <leader>gz :Git stash<space>
nmap <leader>gp :Git! pull<space>
nmap <leader>gu :Git! push<space>
nmap <leader>go :Git checkout<space>
nmap <leader>gc :tab Git commit -v<cr>
nmap <leader>gb :Git branch<space>
nmap <leader>gl :Commits!<cr>
nmap <leader>gd :Gvdiffsplit<cr>
nmap <leader>gm :Git blame<cr>
" hack to add/reset hunk under the cursor
nmap <leader>ga :Gdiffsplit<cr>do:wq<cr>
nmap <leader>gr :Gdiffsplit<cr>dp:wq<cr>

" fzf
nmap <leader>f :Files!<cr>
" TODO: buffer deletion
nmap <leader>b :Buffers!<cr>
nmap <leader>i :History!<cr>
nmap <leader>w :Windows!<cr>
" regex commands
nmap <leader>x :Rg!<cr>
vmap <leader>x y:Rg! <c-r>"<cr>
nmap <leader>/ :BLines!<cr>
vmap <leader>/ y:BLines! <c-r>"<cr>
nmap <leader>* :BLines! <c-r><c-w><cr>
vmap <leader>* y:BLines! <c-r>"<cr>
nmap <leader>: :History:!<cr>

" go
let g:go_code_completion_enabled = 0
let g:go_doc_keywordprg_enabled = 0
let g:go_fmt_autosave = 0
let g:go_def_mapping_enabled = 0
let g:go_term_mode = "split"
let g:go_term_reuse = 1
let g:go_term_enabled = 1
let g:go_term_close_on_exit = 0
let g:go_gopls_enabled = 0

" iswap
nmap <leader>h :ISwapNodeWithLeft<cr>
nmap <leader>l :ISwapNodeWithRight<cr>
nmap <leader>j :ISwapNodeWith<cr>
nmap <leader>k :ISwapNode<cr>

" lightline
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'one',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'git-branch-symbol', 'git-branch' ],
      \             [ 'readonly', 'modified', 'relativepath' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'fileformat', 'fileencoding', 'percent' ],
      \              [ 'filetype' ]],
      \ },
      \ 'inactive': {
      \   'left': [ [ 'relativepath' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'fileformat', 'fileencoding', 'percent' ],
      \              [ 'filetype' ]],
      \ },
      \ 'component': {
      \   'git-branch-symbol': '',
      \ },
      \ 'component_function': {
      \   'git-branch': 'FugitiveHead',
      \   'filetype': 'LightlineFiletype',
      \ },
      \ 'tab_component_function': {
      \   'tabfileicon': 'LightlineTabFileicon',
      \   'tabfilename': 'LightlineTabFilename',
      \ },
      \ 'tab': {
      \   'active': [ 'tabfileicon', 'tabnum', 'readonly', 'tabfilename', 'modified' ],
      \   'inactive': [ 'tabfileicon', 'tabnum', 'readonly', 'tabfilename', 'modified' ],
      \ },
      \ 'tabline': {
      \   'left': [ [ 'tabs' ] ],
      \   'right': [  ],
      \ },
      \ }

function! CwdTrimmed(cwd)
    return substitute(substitute(a:cwd,getenv('HOME'),'~',''),'\v.*/([^/]*/[^/]*/[^/]*/[^/]*)$','\1','g')
endfunction

function! LightlineFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction
function! LightlineTabFileicon(tabnum)
    return WebDevIconsGetFileTypeSymbol(bufname(tabpagebuflist(a:tabnum)[tabpagewinnr(a:tabnum)-1]))
endfunction
function! LightlineTabFilename(tabnum)
    let filename = bufname(tabpagebuflist(a:tabnum)[tabpagewinnr(a:tabnum)-1])
    " let dirname = fnamemodify(filename, ":h")
    return CwdTrimmed(filename)
endfunction

" linediff
vmap <leader>l :Linediff<cr>

" markdown
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
let NERDTreeWinSize=41
nmap - :NERDTreeToggle<cr>
nmap <leader>- :NERDTreeFind<cr>
" quit when NERDTree is the last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" obsession
nmap <leader>st :Obsession<cr>
nmap <leader>sl :source Session.vim<cr>

" signify
omap id <plug>(signify-motion-inner-pending)
xmap id <plug>(signify-motion-inner-visual)
omap ad <plug>(signify-motion-outer-pending)
xmap ad <plug>(signify-motion-outer-visual)
nmap <leader>gi :SignifyHunkDiff<cr>

" slime
" TODO: choose from active terminals
let g:slime_target = "neovim"
let g:slime_no_mappings = 1
xmap <leader>ts y:SlimeSend1 <c-r>"<cr>
nmap <leader>ts <plug>SlimeMotionSend
" SlimeLineSend
nmap <leader><leader>s <plug>SlimeConfig
command SlimeSetTermId call SlimeSetTermId()
function! SlimeSetTermId ()
    if b:terminal_job_id
        SlimeConfig(b:terminal_job_id)
    endif
endfunction

" unimpaired extensions for encoding & decoding
nmap [44 !!base64<cr>
nmap ]44 !!base64 -d<cr>
vmap [4 "z<c-r>=system("echo '<c-r>z' \| base64 \| tr -d '\n'")<cr><esc>
vmap ]4 "zc<c-r>=system("echo '<c-r>z' \| base64 -d \| tr -d '\n'")<cr><esc>

nmap [66 VU!!sed -E 's/(.*)/obase=16;\1/' \| bc<cr>
nmap ]66 VU!!sed -E 's/(.*)/ibase=16;\1/' \| bc<cr>
vmap [6 Ugv"zc<c-r>=system("echo 'obase=16;<c-r>z' \| bc \| tr -d '\n'")<cr><esc>
vmap ]6 Ugv"zc<c-r>=system("echo 'ibase=16;<c-r>z' \| bc \| tr -d '\n'")<cr><esc>

nmap [88 !!sed -E 's/(.*)/obase=8;\1/' \| bc<cr>
nmap ]88 !!sed -E 's/(.*)/ibase=8;\1/' \| bc<cr>
vmap [8 "zc<c-r>=system("echo 'obase=8;<c-r>z' \| bc \| tr -d '\n'")<cr><esc>
vmap ]8 "zc<c-r>=system("echo 'ibase=8;<c-r>z' \| bc \| tr -d '\n'")<cr><esc>

nmap [22 !!sed -E 's/(.*)/obase=2;\1/' \| bc<cr>
nmap ]22 !!sed -E 's/(.*)/ibase=2;\1/' \| bc<cr>
vmap [2 "zc<c-r>=system("echo 'obase=2;<c-r>z' \| bc \| tr -d '\n'")<cr><esc>
vmap ]2 "zc<c-r>=system("echo 'ibase=2;<c-r>z' \| bc \| tr -d '\n'")<cr><esc>

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

" sequester lua heredoc config due to vim parsing bug:
" https://github.com/neovim/neovim/issues/16136#issuecomment-950358277

" hop
let g:vimsyn_embed = 'l'
lua << EOF
require'hop'.setup()
vim.keymap.set('n', '\'', '<cmd>HopChar2MW<cr>', { noremap = true })
vim.keymap.set('o', 'z', "<cmd>lua require'hop'.hint_char1({ current_line_only = true, inclusive_jump = true })<cr>", { noremap = true })
vim.keymap.set('v', 'z', "<cmd>lua require'hop'.hint_char2({ inclusive_jump = true })<cr>", { noremap = true })
EOF

" " leap
" lua << EOF
" require('leap').add_default_mappings()
" EOF
" " vim.keymap.set({ 'n' }, '\'', '<Plug>(leap-cross-window)')
" " vim.keymap.set('o', 'z', "<Plug>(leap-forward-to)", { noremap = true })
" " vim.keymap.set('v', 'z', "<Plug>(leap-forward-to)", { noremap = true })

" which-key
set timeoutlen=400
lua << EOF
require("which-key").setup {}
EOF

" " todo-comments
" lua << EOF
"     require("todo-comments").setup {
"     -- your configuration comes here
"     -- or leave it empty to use the default settings
"     -- refer to the configuration section below
"     }
" EOF

" " tabnine
" lua << EOF
" require('tabnine').setup({
"   disable_auto_comment=true,
"   accept_keymap="<c-]>",
"   dismiss_keymap = "<c-\\>",
"   debounce_ms = 300,
"   suggestion_color = {gui = "#808080", cterm = 244},
"   execlude_filetypes = {"TelescopePrompt"}
" })
" EOF

if filereadable(expand("~/.config/nvim/coc-settings.vim"))
    source ~/.config/nvim/coc-settings.vim
endif
if filereadable(expand("~/.config/nvim/init.os.vim"))
    source ~/.config/nvim/init.os.vim
endif
if filereadable(expand("~/.config/nvim/init.local.vim"))
    source ~/.config/nvim/init.local.vim
endif
