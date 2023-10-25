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

Plug 'preservim/vim-markdown' " included for folding
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

lua << EOF
-- sequester lua heredoc config due to vim parsing bug:
-- https://github.com/neovim/neovim/issues/16136#issuecomment-950358277

-- TODO: see ins-completion
-- TODO: change listchars multispace when using spaces
-- TODO: find out why this only works after re-sourcing init
-- set keywordprg=:vert\ help
-- TODO: checkout https://github.com/NvChad/NvChad
-- TODO: add indent object to wellle/targets.vim?
-- TODO: add entire document object to wellle/targets.vim?
-- TODO: persist undo history like thaerkh/vim-workspace

-- use 4-space indentation by default
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
-- continue comments on new lines
vim.o.formatoptions = vim.o.formatoptions and vim.o.formatoptions .. 'ro' or vim.o.formatoptions
-- show extra whitespace
vim.o.list = true
vim.o.listchars = 'tab:▷\\ ,trail:⋅,nbsp:☺,extends:→,precedes:←'
-- don't wrap long lines by default, but be more sensible when wrapping is on
vim.o.wrap = false
vim.o.linebreak = true
-- wrap & highlight @120 chars
vim.o.textwidth = 120
vim.o.colorcolumn = '+0'
-- always show signcolumn
vim.o.signcolumn = 'yes'

-- ignore case unless there are upper-case characters
vim.o.ignorecase = true
vim.o.smartcase = true
-- include hyphens in words
vim.o.iskeyword = '-,' .. vim.o.iskeyword
-- drop forward jumplist locations when moving to a new location
vim.cmd.set('jumpoptions+=stack')
-- don't redraw while executing commands & using registers
vim.o.lazyredraw = true
-- ignore modelines due to security concerns
vim.o.modeline = false
vim.o.modelines = 0
-- live on the edge!
vim.o.swapfile = false
-- leave some space around the cursor when moving
vim.o.scrolloff = 2
vim.o.sidescrolloff = 15
-- trigger CursorHold sooner
vim.o.updatetime = 300

-- indent when wrapping with showbreak starting the line
vim.o.breakindent = true
vim.o.breakindentopt = 'sbr'
vim.o.showbreak = '↪ '
-- highlight current line
vim.o.cursorline = true
-- fold on indents; don't fold when opening files
vim.o.foldmethod = 'indent'
vim.o.foldenable = false
-- always show file tabs
vim.o.showtabline = 2
-- give more space for displaying messages
vim.o.cmdheight = 2

-- show line numbers
vim.o.number = true

-- skip filetype.lua so that roc.vim's ftdetect works
-- https://neovim.discourse.group/t/introducing-filetype-lua-and-a-call-for-help/1806
-- vim.g.do_filetype_lua = 1
-- vim.g.did_load_filetypes = 0

vim.o.termguicolors = true
vim.g.ayucolor = 'mirage'
vim.cmd.colorscheme('ayu')

vim.keymap.set('n', '<c-n>', ':tabn<cr>')
vim.keymap.set('n', '<c-p>', ':tabp<cr>')
vim.keymap.set('n', '<c-.>', ':tabmove +1<cr>')
vim.keymap.set('n', '<c-,>', ':tabmove -1<cr>')
vim.keymap.set('n', 'gm', ':tabmove<space>')

vim.keymap.set('n', 'gz', ':q<cr>')
vim.keymap.set('n', 'gZ', ':tabclose<cr>')
vim.keymap.set('n', 'g<c-z>', ':qa<cr>')
vim.keymap.set('n', '<c-w>t', ':tabonly<cr>')

vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')

-- horizontal scrolling
vim.keymap.set('n', 'zh', '40zh', { remap = false })
vim.keymap.set('n', 'zl', '40zl', { remap = false })

-- open file under cursor
-- TODO: interpret relative paths as relative to current file location
vim.keymap.set('n', 'gf', ':edit <cfile><cr>')

-- enter to save all buffers, except in quickfix lists
vim.keymap.set('n', '<cr>', '&buftype ==# \'quickfix\' ? "\\<cr>" : ":checktime\\<cr>:wall\\<cr>"', { expr = true, remap = false })

-- keep cursor in place when joining lines
vim.keymap.set('n', 'J', 'mzJ`z', { remap = false })
vim.keymap.set('n', 'gJ', 'mzgJ`z', { remap = false })

-- split line before/after cursor
vim.keymap.set('n', '[<cr>', 'ha<cr><esc>kg_')
vim.keymap.set('n', ']<cr>', 'a<cr><esc>kg_')
-- add blank lines, but respect existing auto-insertion like comments
-- TODO: make this work with . and keep cursor position
vim.keymap.set('n', '[<space>', 'O<esc>j')
vim.keymap.set('n', ']<space>', 'o<esc>k')

-- substitute: replace all, confirm and don't ignore case
vim.keymap.set('n', '<c-s>', ':%s/\v<<c-r><c-w>>/<c-r><c-w>/gcI<left><left><left><left>')
vim.keymap.set('x', '<c-s>', ':s/\v/gI<left><left><left>')

vim.keymap.set('n', '<esc>', ':nohlsearch<cr>', { remap = false })
vim.keymap.set('n', '^', 'ggVG')

-- move selected lines around
vim.keymap.set('v', '<c-j>', ':m \'>+1<cr>gv=gv')
vim.keymap.set('v', '<c-k>', ':m \'<-2<cr>gv=gv')

-- search for selected text
vim.keymap.set('v', '*', '"zy/\\V<c-r>z<cr>')

vim.cmd.cnoreabbrev('h', 'vert h')
vim.cmd.cnoreabbrev('hs', 'hor h')
vim.cmd.cnoreabbrev('ht', 'tab h')

-- sacrilegious bindings for command mode
vim.keymap.set('c', '<c-a>', '<Home>')
vim.keymap.set('c', '<c-b>', '<left>')
vim.keymap.set('c', '<c-f>', '<right>')
vim.keymap.set('c', '<esc>b', '<s-left>')
vim.keymap.set('c', '<esc>f', '<s-right>')

-- TODO:
vim.g.mousescroll='hor:1'
vim.keymap.set('n', '<ScrollWheelUp>', '<c-y>')
vim.keymap.set('n', '<ScrollWheelDown>', '<c-e>')

if vim.g.neovide then
    vim.o.guifont='Hack Nerd Font:h13'
    vim.g.neovide_scroll_animation_length = 0.09
    vim.g.neovide_cursor_animation_length = 0.09
    vim.g.neovide_refresh_rate_idle = 1
    vim.g.neovide_input_macos_alt_is_meta = true
    vim.g.neovide_cursor_vfx_mode = "ripple"
    vim.keymap.set('', '<D-n>', ':silent !neovide --multigrid&<cr>')
end

vim.g.mapleader = " "

-- config
vim.keymap.set('n', '<leader>,', ':tabnew<cr>:tcd ~/.dotfiles<cr>:e ~/.config/nvim/init.vim<cr>')
vim.keymap.set('n', '<leader><leader>,', ':so ~/.config/nvim/init.vim<cr>')
vim.keymap.set('n', '<leader>;', ':execute \'tabnew ~/.config/nvim/ftplugin/\' . &ft . \'.vim\'<cr>')
vim.keymap.set('n', '<leader><leader>.', ':so %<cr>')

-- clipboard
-- copy filename to system clipboard
vim.keymap.set('n', '<leader>5', ':let @+=@%<cr>')
-- copy current register to system clipboard
vim.keymap.set('n', '<leader>"', ':let @+=@"<cr>')
vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('x', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>Y', '"+Y')
vim.keymap.set('n', '<leader>p', '"+p')
vim.keymap.set('x', '<leader>p', '"+p')
vim.keymap.set('n', '<leader>P', '"+P')
-- change, delete or paste  without touching the unnamed register
vim.keymap.set('n', '<leader>c', '"_c')
vim.keymap.set('x', '<leader>c', '"_c')
vim.keymap.set('n', '<leader>d', '"_d')
vim.keymap.set('x', '<leader>d', '"_d')
vim.keymap.set('x', '<leader><c-p>', '"_dp')

-- terminal
-- TODO: nvr for avoiding nested terminals
-- quit, then move to start of line to preserve display of curses-like output
vim.keymap.set('t', '<c-q>', '<c-\\><c-n>0')
vim.keymap.set('n', '<leader>ts', ':25sp | te<cr>a')
vim.keymap.set('n', '<leader>tv', ':85vsp | te<cr>a')
vim.keymap.set('n', '<leader>tt', ':tabnew | te<cr>a')
vim.cmd[[
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
]]

-- commands & augroups

function update()
    vim.cmd.PlugUpgrade()
    vim.cmd.PlugUpdate()
    vim.cmd.CocUpdate()
end

function buffers_delete_hidden()
    local shownBuffers = {}
    for i = 1, vim.fn.tabpagenr('$') do
        for _, j in pairs(vim.fn.tabpagebuflist(i)) do
            shownBuffers[j] = true
        end
    end

    local hiddenBuffers = {}
    for i = 1, vim.fn.bufnr('$') do
        if vim.fn.buflisted(i) and vim.fn.bufexists(i) and not shownBuffers[i] then
            table.insert(hiddenBuffers, i)
        end
    end

    if #hiddenBuffers > 0 then
        vim.cmd.bdelete(table.concat(hiddenBuffers, ' '))
    end
end

function buffers_delete_unnamed()
    local emptyBuffers = {}
    for i = 1, vim.fn.bufnr('$') do
        if vim.fn.buflisted(i) and vim.fn.bufexists(i) and vim.fn.bufname(i) == '' then
            table.insert(emptyBuffers, i)
        end
    end

    if #emptyBuffers > 0 then
        vim.cmd.bdelete(table.concat(emptyBuffers, ' '))
    end
end

vim.cmd[[
command! Update call luaeval('update()')
command! BuffersDeleteHidden call luaeval('buffers_delete_hidden()')
command! BuffersDeleteUnnamed call luaeval('buffers_delete_unnamed()')

augroup onsave
    autocmd!
    " trim trailing whitespace on save
    autocmd BufWrite * :%s/\s\+$//e
    " TODO: autosave? See thaerkh/vim-workspace
    " autocmd InsertLeave,TextChanged * :wall
augroup END
]]

-- plugins

-- delimitmate
vim.g.delimitMate_balance_matchpairs = 1
vim.g.delimitMate_excluded_ft = ""
vim.g.delimitMate_excluded_regions = ""
vim.g.delimitMate_expand_cr = 2
vim.g.delimitMate_expand_inside_quotes = 1
vim.g.delimitMate_expand_space = 1
vim.g.delimitMate_jump_expansion = 1

-- editorconfig
vim.g.EditorConfig_exclude_patterns = { 'fugitive://.*' }

-- fugitive
vim.keymap.set('n', '<leader>gs', ':-1tab Git<cr>')
vim.keymap.set('n', '<leader>gf', ':Git! fetch<cr>')
vim.keymap.set('n', '<leader>gz', ':Git stash<space>')
vim.keymap.set('n', '<leader>gp', ':Git! pull<space>')
vim.keymap.set('n', '<leader>gu', ':Git! push<space>')
vim.keymap.set('n', '<leader>go', ':Git checkout<space>')
vim.keymap.set('n', '<leader>gc', ':tab Git commit -v<cr>')
vim.keymap.set('n', '<leader>gb', ':Git branch<space>')
vim.keymap.set('n', '<leader>gl', ':Commits!<cr>')
vim.keymap.set('n', '<leader>gd', ':Gvdiffsplit<cr>')
vim.keymap.set('n', '<leader>gm', ':Git blame<cr>')

-- fzf
vim.keymap.set('n', '<leader>f', ':Files!<cr>')
-- TODO: buffer deletion
vim.keymap.set('n', '<leader>b', ':Buffers!<cr>')
vim.keymap.set('n', '<leader>i', ':History!<cr>')
vim.keymap.set('n', '<leader>w', ':Windows!<cr>')
vim.keymap.set('n', '<leader>x', ':Rg!<cr>')
vim.keymap.set('v', '<leader>x', 'y:Rg! <c-r>"<cr>')
vim.keymap.set('n', '<leader>/', ':BLines!<cr>')
vim.keymap.set('v', '<leader>/', 'y:BLines! <c-r>"<cr>')
vim.keymap.set('n', '<leader>*', ':BLines! <c-r><c-w><cr>')
vim.keymap.set('v', '<leader>*', 'y:BLines! <c-r>"<cr>')
vim.keymap.set('n', '<leader>:', ':History:!<cr>')

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

-- go
vim.g.go_code_completion_enabled = 0
vim.g.go_doc_keywordprg_enabled = 0
vim.g.go_fmt_autosave = 0
vim.g.go_def_mapping_enabled = 0
vim.g.go_term_mode = "split"
vim.g.go_term_reuse = 1
vim.g.go_term_enabled = 1
vim.g.go_term_close_on_exit = 0
vim.g.go_gopls_enabled = 0

-- hop
vim.g.vimsyn_embed = 'l'

require'hop'.setup()
vim.keymap.set('n', '\'', '<cmd>HopChar2MW<cr>', { noremap = true })
vim.keymap.set('o', 'z', "<cmd>lua require'hop'.hint_char1({ current_line_only = true, inclusive_jump = true })<cr>", { noremap = true })
vim.keymap.set('v', 'z', "<cmd>lua require'hop'.hint_char2({ inclusive_jump = true })<cr>", { noremap = true })

-- iswap
vim.keymap.set('n', '<leader>h', ':ISwapNodeWithLeft<cr>')
vim.keymap.set('n', '<leader>l', ':ISwapNodeWithRight<cr>')
vim.keymap.set('n', '<leader>j', ':ISwapNodeWith<cr>')
vim.keymap.set('n', '<leader>k', ':ISwapNode<cr>')

-- lightline
vim.o.showmode = false
vim.g.lightline = {
    colorscheme = 'ayu_mirage',
    active = {
        left = { { 'mode', 'paste' },
            { 'git-branch-symbol', 'git-branch' },
            { 'readonly', 'modified', 'relativepath' } },
        right = { { 'lineinfo' },
            { 'fileformat', 'fileencoding', 'percent' },
            { 'filetype' } },
    },
    inactive = {
        left = { { 'relativepath' } },
        right = { { 'lineinfo' },
            { 'fileformat', 'fileencoding', 'percent' },
            { 'filetype' }
        },
    },
    component = {
        ['git-branch-symbol'] = '',
    },
    component_function = {
        ['git-branch'] = 'FugitiveHead',
        filetype = 'LightlineFiletype',
    },
    tab_component_function = {
        tabfileicon = 'LightlineTabFileicon',
        tabfilename = 'LightlineTabFilename',
    },
    tab = {
        active = { 'tabfileicon', 'tabnum', 'readonly', 'tabfilename', 'modified' },
        inactive = { 'tabfileicon', 'tabnum', 'readonly', 'tabfilename', 'modified' },
    },
    tabline = {
        left = { { 'tabs' } },
        right = { },
    },
}

function lightline_filetype()
    if vim.fn.winwidth(0) > 70 then
        if #vim.bo.filetype > 0 then
            return vim.bo.filetype .. ' ' .. vim.fn.WebDevIconsGetFileTypeSymbol()
        else
            return 'no ft'
        end
    else
        return ''
    end
end

function lightline_tab_fileicon(tabnum)
    local bufnr = vim.fn.tabpagebuflist(tabnum)[vim.fn.tabpagewinnr(tabnum)]
    if bufnr then
        return vim.fn.WebDevIconsGetFileTypeSymbol(vim.fn.bufname(bufnr))
    else
        return vim.fn.WebDevIconsGetFileTypeSymbol(nil)
    end
end

function cwd_trimmed(cwd)
    local home = os.getenv('HOME')
    cwd = cwd:gsub(home, '~')
    return cwd:gsub('.*/([^/]*/[^/]*/[^/]*/[^/]*)$', '%1')
end
function lightline_tab_filename(tabnum)
    local bufnr = vim.fn.tabpagebuflist(tabnum)[vim.fn.tabpagewinnr(tabnum)]
    if bufnr then
        local filename = vim.fn.bufname(bufnr)
        return cwd_trimmed(filename)
    else
        return ''
    end
end

vim.cmd[[
function! LightlineFiletype()
    return luaeval('lightline_filetype()', {})
endfunction
function! LightlineTabFileicon(tabnum)
    return luaeval('lightline_tab_fileicon(_A.tabnum)', {'tabnum': a:tabnum})
endfunction
function! LightlineTabFilename(tabnum)
    return luaeval('lightline_tab_filename(_A.tabnum)', {'tabnum': a:tabnum})
endfunction
]]

-- linediff
vim.keymap.set('v', '<leader>l', ':Linediff<cr>')

-- markdown
vim.g.vim_markdown_folding_level = 2
vim.g.vim_markdown_toc_autofit = 1
vim.cmd[[
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
]]

-- NERDTree
vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeWinSize = 41
-- quit when NERDTree is the last window
vim.cmd[[ autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif ]]
vim.keymap.set('n', '-', ':NERDTreeToggle<cr>')
vim.keymap.set('n', '<leader>-', ':NERDTreeFind<cr>')

-- obsession
vim.keymap.set('n', '<leader>st', ':Obsession<cr>')
vim.keymap.set('n', '<leader>sl', ':source Session.vim<cr>')

-- slime
vim.g.slime_target = "neovim"
vim.g.slime_no_mappings = 1
vim.keymap.set('n', '<leader>tc', '<plug>SlimeConfig')
vim.keymap.set('n', '<leader>tx', '<plug>SlimeMotionSend')
vim.keymap.set('x', '<leader>tx', '<plug>SlimeRegionSend')
vim.keymap.set('n', '<leader>tl', '<plug>SlimeLineSend')
-- TODO: choose from active terminals b:terminal_job_id

-- tabnine
-- require('tabnine').setup({
--   disable_auto_comment=true,
--   accept_keymap="<c-]>",
--   dismiss_keymap = "<c-\\>",
--   debounce_ms = 300,
--   suggestion_color = {gui = "#808080", cterm = 244},
--   execlude_filetypes = {"TelescopePrompt"}
-- })

-- todo-comments
-- require("todo-comments").setup {
-- -- your configuration comes here
-- -- or leave it empty to use the default settings
-- -- refer to the configuration section below
-- }

-- treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    -- languages
    'c', 'c_sharp', 'commonlisp', 'cpp', 'dockerfile', 'eex', 'elixir', 'elm', 'erlang', 'javascript', 'jsdoc', 'go',
    'gomod', 'gowork', 'heex', 'python', 'ruby', 'rust', 'solidity', 'tsx', 'typescript', 'zig',
    -- version control
    'diff', 'git_rebase', 'gitattributes', 'gitcommit', 'gitignore',
    -- web
    'css', 'html', 'http',
    -- config
    'hcl', 'ini', 'json', 'nix', 'toml', 'yaml',
    -- scripting
    'bash', 'fish', 'jq', 'lua', 'vim',
    -- queries
    'graphql', 'regex', 'sql',
    -- docs
    'help', 'markdown', 'rst'
  },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = {'diff', 'git_rebase', 'gitcommit'},
  },

  indent = { enable = true, disable = { 'python' } },
}

-- unimpaired extensions for encoding & decoding
-- TODO: contribute this to unimpaired
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

-- which-key
vim.o.timeoutlen = 400
require("which-key").setup {}

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

local coc_settings = vim.fn.expand("~/.config/nvim/coc-settings.vim")
if vim.fn.filereadable(coc_settings) == 1 then
    vim.cmd.source(coc_settings)
end
local os_settings = vim.fn.expand("~/.config/nvim/init.os.vim")
if vim.fn.filereadable(os_settings) == 1 then
    vim.cmd.source(os_settings)
end
local local_settings = vim.fn.expand("~/.config/nvim/init.local.vim")
if vim.fn.filereadable(local_settings) == 1 then
    vim.cmd.source(local_settings)
end

EOF
