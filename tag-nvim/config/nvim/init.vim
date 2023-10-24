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
set cmdheight=2 " give more space for displaying messages

set number " show line numbers

" skip filetype.lua so that roc.vim's ftdetect works
" https://neovim.discourse.group/t/introducing-filetype-lua-and-a-call-for-help/1806
" let g:do_filetype_lua = 1
" let g:did_load_filetypes = 0

" install vim-plug if necessary
let data_dir = stdpath('data') . '/site'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.local/share/nvim/plugged')

Plug 'editorconfig/editorconfig-vim'
Plug 'nvim-lua/plenary.nvim'
" Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-sensible' " TODO: vs Plug 'nvim-lua/kickstart.nvim'

" git
" Plug 'mhinz/vim-signify' " switch to signify for non-git repos
" hack to add/reset hunk under the cursor
" nmap <leader>ga :Gdiffsplit<cr>do:wq<cr>
" nmap <leader>gr :Gdiffsplit<cr>dp:wq<cr>
" omap id <plug>(signify-motion-inner-pending)
" xmap id <plug>(signify-motion-inner-visual)
" omap ad <plug>(signify-motion-outer-pending)
" xmap ad <plug>(signify-motion-outer-visual)
" nmap <leader>gi :SignifyHunkDiff<cr>

Plug 'lewis6991/gitsigns.nvim'
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

" ui
Plug 'Luxed/ayu-vim'
Plug 'folke/which-key.nvim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'powerman/vim-plugin-AnsiEsc'
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
" Plug 'sidebar-nvim/sidebar.nvim'
Plug 'preservim/nerdtree'

function! UpdateRemotePlugins(...)
    let &rtp=&rtp " Needed to refresh runtime files
    UpdateRemotePlugins
endfunction
Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }

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

" Plug 'preservim/vim-markdown' " included for folding
" Plug 'elixir-tools/elixir-tools.nvim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' } " included separately from polyglot to get commands
Plug 'ChrisWellsWood/roc.vim'

" as needed
" Plug 'dstein64/vim-startuptime'
" Plug 'mattn/emmet-vim'
" Plug 'tpope/vim-dadbod'

" Plug 'lervag/vimtex'
" let g:tex_flavor = 'latex'

" new plugins to try

" Plug 'nvim-telescope/telescope.nvim'
" Plug 'mbbill/undotree'
" Plug 'her/central.vim'
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

" Plug 'tpope/vim-afterimage'
" Plug 'tpope/vim-eunuch'
" Plug 'folke/todo-comments.nvim'
" Plug 'wfxr/minimap.vim'
" Plug 'kannokanno/previm'
" Plug 'nathom/filetype.nvim'
" Plug 'APZelos/blamer.nvim' vs Plug 'f-person/git-blame.nvim'
" Plug 'sjl/gundo.vim'
" Plug 'Konfekt/FastFold'

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
endfunction

set termguicolors
let ayucolor="mirage"
colorscheme ayu

nmap <c-n> :tabn<cr>
nmap <c-p> :tabp<cr>
nmap <c-.> :tabmove +1<cr>
nmap <c-,> :tabmove -1<cr>
nmap gm :tabmove<space>

nmap gz :q<cr>
nmap gZ :tabclose<cr>
nmap g<c-z> :qa<cr>
nmap <c-w>t :tabonly<cr>

nmap <c-h> <c-w>h
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-l> <c-w>l

" horizontal scrolling
nnoremap zh 40zh
nnoremap zl 40zl

" open file under cursor
" TODO: interpret relative paths as relative to current file location
nmap gf :edit <cfile><cr>

" enter to save all buffers, except in quickfix lists
nnoremap <expr> <cr> &buftype ==# 'quickfix' ? "\<cr>" : ":checktime\<cr>:wall\<cr>"

" keep cursor in place when joining lines
nnoremap J mzJ`z
nnoremap gJ mzgJ`z

" split line before/after cursor
nmap [<cr> ha<cr><esc>kg_
nmap ]<cr> a<cr><esc>kg_
" add blank lines, but respect existing auto-insertion like comments
" TODO: make this work with .
nmap [<space> O<esc>j
nmap ]<space> o<esc>k

" substitute: replace all, confirm and don't ignore case
nmap <c-s> :%s/\v<<c-r><c-w>>/<c-r><c-w>/gcI<left><left><left><left>
xmap <c-s> :s/\v/gI<left><left><left>

nnoremap <esc> :nohlsearch<cr>
nmap ^ ggVG

" move selected lines around
vmap <c-j> :m '>+1<cr>gv=gv
vmap <c-k> :m '<-2<cr>gv=gv

" search for selected text
vmap * "zy/\V<c-r>z<cr>

cnoreabbrev h vert h
cnoreabbrev hs hor h
cnoreabbrev ht tab h

" sacrilegious bindings for command mode
cmap <c-a> <Home>
cmap <c-b> <left>
cmap <c-f> <right>
cmap <esc>b <s-left>
cmap <esc>f <s-right>

set mousescroll=hor:1
noremap <ScrollWheelUp> <c-y>
noremap <ScrollWheelDown> <c-e>

if exists("g:neovide")
    set guifont=Hack\ Nerd\ Font:h13
    let g:neovide_scroll_animation_length = 0.09
    let g:neovide_cursor_animation_length = 0.09
    let g:neovide_refresh_rate_idle = 1
    let g:neovide_input_macos_alt_is_meta = v:true
    let g:neovide_cursor_vfx_mode = "ripple"
    map <D-n> :silent !neovide --multigrid&<cr>
endif

augroup onsave
    autocmd!
    " trim trailing whitespace on save
    autocmd BufWrite * :%s/\s\+$//e
    " TODO: autosave? See thaerkh/vim-workspace
    " autocmd InsertLeave,TextChanged * :wall
augroup END

command BuffersDeleteHidden call BuffersDeleteHidden()
function! BuffersDeleteHidden()
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

command BuffersDeleteUnnamed call BuffersDeleteUnnamed()
function! BuffersDeleteUnnamed()
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
" TODO: nvr for avoiding nested terminals
" quit, then move to start of line to preserve display of curses-like output
tmap <c-q> <c-\><c-n>0
nmap <leader>ts :25sp \| te<cr>a
nmap <leader>tv :85vsp \| te<cr>a
nmap <leader>tt :tabnew \| te<cr>a
augroup terminal_settings
    autocmd!
    " no line numbers in terminals
    autocmd TermOpen term://* setlocal nonumber norelativenumber scrolloff=0

    " ignore various filetypes (fzf, ranger & coc) as those will close terminal automatically
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
      \ 'colorscheme': 'ayu_mirage',
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

" slime
let g:slime_target = "neovim"
let g:slime_no_mappings = 1
nmap <leader>tc <plug>SlimeConfig
nmap <leader>tx <plug>SlimeMotionSend
xmap <leader>tx <plug>SlimeRegionSend<cr>
nmap <leader>tl <plug>SlimeLineSend
" TODO: choose from active terminals
" nmap <leader>ti :call SlimeGetTermId()<cr>
" command SlimeGetTermId call SlimeGetTermId()
" function! SlimeGetTermId ()
"     if b:terminal_job_id
"         echo b:terminal_job_id
"     endif
" endfunction

" sequester lua heredoc config due to vim parsing bug:
" https://github.com/neovim/neovim/issues/16136#issuecomment-950358277

lua << EOF

-- TODO: contribute this to unimpaired
-- unimpaired extensions for encoding & decoding
vim.keymap.set('n', '[44', '!!base64<cr>')
vim.keymap.set('n', ']44', '!!base64 -d<cr>')
vim.keymap.set('v', '[4', '"zc<c-r>=system("echo \'<c-r>z\' | base64 | tr -d \'\\n\'")<cr><esc>')
vim.keymap.set('v', ']4', '"zc<c-r>=system("echo \'<c-r>z\' | base64 -d | tr -d \'\\n\'")<cr><esc>')

vim.keymap.set('n', '[66', 'VU!!sed -E \'s/(.*)/obase=16;\\1/\' | bc<cr>')
vim.keymap.set('n', ']66', 'VU!!sed -E \'s/(.*)/ibase=16;\\1/\' | bc<cr>')
vim.keymap.set('v', '[6', 'Ugv"zc<c-r>=system("echo \'obase=16;<c-r>z\' | bc | tr -d \'\\n\'")<cr><esc>')
vim.keymap.set('v', ']6', 'Ugv"zc<c-r>=system("echo \'ibase=16;<c-r>z\' | bc | tr -d \'\\n\'")<cr><esc>')

vim.keymap.set('n', '[88', 'VU!!sed -E \'s/(.*)/obase=8;\\1/\' | bc<cr>')
vim.keymap.set('n', ']88', 'VU!!sed -E \'s/(.*)/ibase=8;\\1/\' | bc<cr>')
vim.keymap.set('v', '[8', 'Ugv"zc<c-r>=system("echo \'obase=8;<c-r>z\' | bc | tr -d \'\\n\'")<cr><esc>')
vim.keymap.set('v', ']8', 'Ugv"zc<c-r>=system("echo \'ibase=8;<c-r>z\' | bc | tr -d \'\\n\'")<cr><esc>')

vim.keymap.set('n', '[22', 'VU!!sed -E \'s/(.*)/obase=2;\\1/\' | bc<cr>')
vim.keymap.set('n', ']22', 'VU!!sed -E \'s/(.*)/ibase=2;\\1/\' | bc<cr>')
vim.keymap.set('v', '[2', 'Ugv"zc<c-r>=system("echo \'obase=2;<c-r>z\' | bc | tr -d \'\\n\'")<cr><esc>')
vim.keymap.set('v', ']2', 'Ugv"zc<c-r>=system("echo \'ibase=2;<c-r>z\' | bc | tr -d \'\\n\'")<cr><esc>')

-- unimpaired extension for folding
vim.keymap.set('n', '[of', ':set foldenable<cr>')
vim.keymap.set('n', ']of', ':set nofoldenable<cr>')
vim.keymap.set('n', 'yof', ':set invfoldenable<cr>')

-- wilder
-- TODO: add fzy https://github.com/gelguy/wilder.nvim#neovim-lua-only-config
vim.o.wildmenu = False
local wilder = require('wilder')
wilder.setup({
    modes = { ':', '/', '?' },
    accept_key = '<c-e>',
    reject_key = '<c-c>',
    next_key = '<tab>',
    previous_key = '<s-tab>',
})

wilder.set_option('pipeline', {
    wilder.branch(
        wilder.python_file_finder_pipeline({
            dir_command = { 'fd', '-td' },
            file_command = function (_ctx, arg) return arg:sub(1, 1) == '.' and { 'fd', '-tf', '-H' } or { 'fd', '-tf' } end,
        }),
        wilder.python_search_pipeline({
            pattern = 'fuzzy',
        }),
        wilder.substitute_pipeline({
            pipeline = wilder.python_search_pipeline({
                patter = 'fuzzy',
            })
        }),
        wilder.cmdline_pipeline({
            fuzzy = 2,
        })
    )
})

wilder.set_option('renderer', wilder.renderer_mux({
    [':'] = wilder.popupmenu_renderer({
        highlighter = wilder.basic_highlighter(),
        left = { ' ', wilder.popupmenu_devicons() },
        right = { ' ', wilder.popupmenu_scrollbar() },
    }),
    ['/'] = wilder.wildmenu_renderer(
        wilder.wildmenu_lightline_theme({
            highlights = { default = 'StatusLine' },
            highlighter = wilder.basic_highlighter(),
            separator = ' | ',
        })
    ),
}))

-- gitsigns
require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>ga', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>gr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>gA', gs.stage_buffer)
    map('n', '<leader>gR', gs.reset_buffer)
    map('n', '<leader>gi', gs.preview_hunk)
    map('n', '<leader>gv', gs.undo_stage_hunk)

    -- map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    -- map('n', '<leader>tb', gs.toggle_current_line_blame)
    -- map('n', '<leader>hd', gs.diffthis)
    -- map('n', '<leader>hD', function() gs.diffthis('~') end)
    -- map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'id', ':<C-U>Gitsigns select_hunk<CR>')
    -- omap id :<c-u>Gitsigns select_hunk<cr>
    -- xmap id :<c-u>Gitsigns select_hunk<cr>
    -- omap ad <plug>(signify-motion-outer-pending)
    -- xmap ad <plug>(signify-motion-outer-visual)
    -- nmap <leader>gi :SignifyHunkDiff<cr>
  end
})

-- hop
vim.g.vimsyn_embed = 'l'

require'hop'.setup()
vim.keymap.set('n', '\'', '<cmd>HopChar2MW<cr>', { noremap = true })
vim.keymap.set('o', 'z', "<cmd>lua require'hop'.hint_char1({ current_line_only = true, inclusive_jump = true })<cr>", { noremap = true })
vim.keymap.set('v', 'z', "<cmd>lua require'hop'.hint_char2({ inclusive_jump = true })<cr>", { noremap = true })

-- treesitter
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'c', 'c_sharp', 'commonlisp', 'cpp', 'dockerfile', 'eex', 'elixir', 'elm', 'erlang', 'go', 'gomod', 'gowork', 'heex', 'python', 'ruby', 'rust', 'solidity', 'tsx', 'typescript', 'zig',
    'diff', 'git_rebase', 'gitattributes', 'gitcommit', 'gitignore',
    'css', 'html', 'http', 'javascript', 'jsdoc',
    'hcl', 'ini', 'json', 'nix', 'toml', 'yaml', -- config formats
    'bash', 'fish', 'jq', 'lua', --scripting
    'graphql', 'sql', -- query languages
    'regex',
    'markdown', 'rst',
    'help', 'vim'
  },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = {'diff', 'git_rebase', 'gitcommit'},
  },

  indent = { enable = true, disable = { 'python' } },
}

-- which-key
vim.o.timeoutlen = 400
require("which-key").setup {}
EOF

if filereadable(expand("~/.config/nvim/coc-settings.vim"))
    source ~/.config/nvim/coc-settings.vim
endif
if filereadable(expand("~/.config/nvim/init.os.vim"))
    source ~/.config/nvim/init.os.vim
endif
if filereadable(expand("~/.config/nvim/init.local.vim"))
    source ~/.config/nvim/init.local.vim
endif
