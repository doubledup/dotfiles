-- TODO: see ins-completion
-- TODO: change listchars multispace when using spaces
-- TODO: find out why this only works after re-sourcing init
-- set keywordprg=:vert\ help
-- TODO: checkout https://github.com/NvChad/NvChad
-- TODO: add indent object to wellle/targets.vim?
-- TODO: add entire document object to wellle/targets.vim?
-- TODO: persist undo history like thaerkh/vim-workspace

--  NOTE: Must happen before plugins are required, otherwise wrong leader will be used
vim.g.mapleader = ' '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        -- latest stable release
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    'editorconfig/editorconfig-vim',

    -- git

    'lewis6991/gitsigns.nvim',
    -- TODO: vs 'jreybert/vimagit',
    'tpope/vim-fugitive',
    -- 'tpope/vim-git',
    -- 'tpope/vim-rhubarb'

    -- TODO: vs builtin LSP or one of
    -- 'williamboman/mason.nvim' -- and
    -- 'williamboman/mason-lspconfig.nvim' -- and
    -- 'neovim/nvim-lspconfig'
    --
    -- 'folke/neodev.nvim'
    -- 'glepnir/lspsaga.nvim',
    -- 'natebosch/vim-lsc',
    -- 'ms-jpq/coq_nvim',
    -- 'autozimu/LanguageClient-neovim',
    -- 'jose-elias-alvarez/null-ls.nvim',
    -- 'ldelossa/litee.nvim',
    { 'neoclide/coc.nvim', branch = 'release' },

    -- ui
    'Luxed/ayu-vim',
    'folke/which-key.nvim',
    'junegunn/fzf',
    'junegunn/fzf.vim',
    -- { 'lukas-reineke/indent-blankline.nvim', config = function () require("ibl").setup() end },
    'norcalli/nvim-colorizer.lua',
    'powerman/vim-plugin-AnsiEsc',
    -- TODO: vs 'nvim-tree/nvim-web-devicons',
    'ryanoasis/vim-devicons',

    -- TODO: vs one of
    -- 'akinsho/bufferline.nvim'
    -- 'nvim-lualine/lualine.nvim',
    {
        'itchyny/lightline.vim',
        config = function()
            vim.o.showmode = false
            vim.g.lightline = {
                colorscheme = 'ayu_mirage',
                active = {
                    left = {
                        { 'mode',     'paste' },
                        { 'readonly', 'modified', 'relativepath' },
                        {},
                    },
                    right = {
                        { 'lineinfo' },
                        { 'filetype' },
                        { 'fileformat', 'fileencoding' },
                    },
                },
                inactive = {
                    left = { { 'relativepath' } },
                    right = {
                        { 'lineinfo' },
                        { 'filetype' },
                        { 'fileformat', 'fileencoding' },
                    },
                },
                -- component = {},
                component_function = {
                    gitbranch = 'LightlineGitHead',
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
                    right = { { 'gitbranch' } },
                },
            }

            function LightlineGitHead()
                return ' ' .. vim.fn.FugitiveHead()
            end

            function LightlineFiletype()
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

            function LightlineTabFileicon(tabnum)
                local bufnr = vim.fn.tabpagebuflist(tabnum)[vim.fn.tabpagewinnr(tabnum)]
                if bufnr then
                    return vim.fn.WebDevIconsGetFileTypeSymbol(vim.fn.bufname(bufnr))
                else
                    return vim.fn.WebDevIconsGetFileTypeSymbol(nil)
                end
            end

            function CwdTrimmed(cwd)
                local home = os.getenv('HOME')
                cwd = cwd:gsub(home, '~')
                return cwd:gsub('.*/([^/]*/[^/]*/[^/]*/[^/]*)$', '%1')
            end

            function LightlineTabFilename(tabnum)
                local bufnr = vim.fn.tabpagebuflist(tabnum)[vim.fn.tabpagewinnr(tabnum)]
                if bufnr then
                    local filename = vim.fn.bufname(bufnr)
                    return CwdTrimmed(filename)
                else
                    return ''
                end
            end

            vim.cmd [[
            function! LightlineGitHead()
                return luaeval('LightlineGitHead()', {})
            endfunction
            function! LightlineFiletype()
                return luaeval('LightlineFiletype()', {})
            endfunction
            function! LightlineTabFileicon(tabnum)
                return luaeval('LightlineTabFileicon(_A.tabnum)', {'tabnum': a:tabnum})
            endfunction
            function! LightlineTabFilename(tabnum)
                return luaeval('LightlineTabFilename(_A.tabnum)', {'tabnum': a:tabnum})
            endfunction
            ]]
        end
    },

    -- TODO: vs one of
    -- 'tpope/vim-vinegar',
    -- 'justinmk/vim-dirvish',
    -- 'nvim-tree/nvim-tree.lua',
    -- 'ms-jpq/chadtree',
    -- 'luukvbaal/nnn.nvim',
    -- 'sidebar-nvim/sidebar.nvim',
    'preservim/nerdtree',

    {
        'gelguy/wilder.nvim',
        build = function()
            vim.cmd [[
            let &rtp=&rtp " Needed to refresh runtime files
            UpdateRemotePlugins
            ]]
        end,
        config = function()
            -- TODO: add fzy https://github.com/gelguy/wilder.nvim#neovim-lua-only-config
            vim.o.wildmenu = false
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
                        file_command = function(_, arg)
                            if arg:sub(1, 1) == '.' then
                                return { 'fd', '-tf', '-H' }
                            else
                                return { 'fd', '-tf' }
                            end
                        end,
                    }),
                    wilder.python_search_pipeline({
                        pattern = 'fuzzy',
                    }),
                    wilder.substitute_pipeline({
                        pipeline = wilder.python_search_pipeline({
                            pattern = 'fuzzy',
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
        end
    },

    -- editing
    'andrewradev/linediff.vim',
    -- TODO: vs 'ggandor/leap.nvim',
    'phaazon/hop.nvim',
    -- 'honza/vim-snippets',
    'jpalardy/vim-slime',
    'mizlan/iswap.nvim',

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    -- languages
                    'c', 'commonlisp', 'dockerfile', 'eex', 'elixir', 'elm', 'erlang', 'javascript',
                    'jsdoc', 'go', 'gomod', 'gowork', 'heex', 'python', 'ruby', 'rust', 'tsx',
                    'typescript', 'zig',
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
                    -- docs 'help',
                    'markdown', 'rst'
                },

                sync_install = false,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                    disable = { 'python' },
                },
            })
        end,
    },

    'pbrisbin/vim-mkdir',
    'raimondi/delimitmate',
    'tpope/vim-abolish',
    -- TODO: vs 'numToStr/Comment.nvim'
    'tpope/vim-commentary',
    'tpope/vim-obsession',
    'tpope/vim-repeat',
    'tpope/vim-sleuth',
    'tpope/vim-surround',
    'tpope/vim-unimpaired',
    'wellle/targets.vim',

    -- included for folding
    -- 'preservim/vim-markdown',
    -- 'elixir-tools/elixir-tools.nvim'
    -- included separately from polyglot to get commands
    { 'fatih/vim-go',      build = ':GoUpdateBinaries' },
    'ChrisWellsWood/roc.vim',

    -- as needed
    -- 'dstein64/vim-startuptime',
    -- 'mattn/emmet-vim',
    -- 'tpope/vim-dadbod',

    -- 'lervag/vimtex', let g:tex_flavor = 'latex'

    -- new plugins to try

    -- 'nvim-telescope/telescope.nvim',
    -- 'mbbill/undotree',
    -- 'her/central.vim',
    -- 'mfussenegger/nvim-dap',
    -- 'ThePrimeagen/harpoon',
    -- 'folke/trouble.nvim',
    -- 'tpope/vim-dispatch',
    -- 'janko-m/vim-test',
    -- 'tpope/vim-rhubarb',
    -- 'tpope/projectionist',
    -- { 'codota/tabnine-nvim', build = './dl_binaries.sh' },
    -- 'jameshiew/nvim-magic',
    -- 'rest-nvim/rest.nvim',
    -- 'kana/vim-textobj-entire',
    -- 'kana/vim-textobj-user',
    -- 'michaeljsmith/vim-indent-object',
    -- { 'glacambre/firenvim', build = function() return vim.fn.firenvim.install(0) end },

    -- 'tpope/vim-afterimage',
    -- 'tpope/vim-eunuch',
    -- 'folke/todo-comments.nvim',
    -- 'wfxr/minimap.vim',
    -- 'kannokanno/previm',
    -- 'nathom/filetype.nvim',
    -- 'APZelos/blamer.nvim',
    -- 'f-person/git-blame.nvim',
    -- 'sjl/gundo.vim',
    -- 'Konfekt/FastFold',

    -- if !empty(glob("~/.config/nvim/plugs.os.vim"))
    --     source ~/.config/nvim/plugs.os.vim
    -- endif
    -- if !empty(glob("~/.config/nvim/plugs.local.vim"))
    --     source ~/.config/nvim/plugs.local.vim
    -- endif

}, {})

vim.cmd.filetype('plugin indent on')
vim.cmd.syntax('enable')

-- use 4-space indentation by default
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
-- continue comments on new lines
vim.opt.formatoptions:append('ro')
-- show extra whitespace
vim.o.list = true
vim.o.listchars = 'tab:▷\\ ,trail:⋅,nbsp:☺,extends:→,precedes:←'
-- don't wrap long lines by default, but be more sensible when wrapping is on
vim.o.wrap = false
vim.o.linebreak = true
-- wrap & highlight @100 chars
vim.o.textwidth = 100
vim.o.colorcolumn = '+0'
-- always show signcolumn
vim.o.signcolumn = 'yes'

-- ignore case unless there are upper-case characters
vim.o.ignorecase = true
vim.o.smartcase = true
-- include hyphens in words
vim.opt.iskeyword:prepend('-')
-- drop forward jumplist locations when moving to a new location
vim.opt.jumpoptions:append('stack')
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
vim.o.updatetime = 200

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

-- save undo history
-- vim.o.undofile = true

-- always show the popup menu and require manual selection
-- vim.o.completeopt = 'menuone,noselect'

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
vim.keymap.set('n', '<cr>', '&buftype ==# \'quickfix\' ? "\\<cr>" : ":checktime\\<cr>:wall\\<cr>"',
    { expr = true, remap = false })

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

vim.keymap.set('n', '<esc>', function()
    vim.cmd('nohlsearch')
    vim.cmd('echo ""')
end, { remap = false })
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
vim.g.mousescroll = 'hor:1'
vim.keymap.set('n', '<ScrollWheelUp>', '<c-y>')
vim.keymap.set('n', '<ScrollWheelDown>', '<c-e>')

if vim.g.neovide then
    vim.o.guifont = 'Hack Nerd Font:h13'
    vim.g.neovide_scroll_animation_length = 0.09
    vim.g.neovide_cursor_animation_length = 0.09
    vim.g.neovide_refresh_rate_idle = 1
    vim.g.neovide_input_macos_alt_is_meta = true
    vim.g.neovide_cursor_vfx_mode = "ripple"
    vim.keymap.set('', '<D-n>', ':silent !neovide --multigrid&<cr>')
end

-- config
vim.keymap.set('n', '<leader>,', ':tabnew<cr>:tcd ~/.dotfiles<cr>:e ~/.config/nvim/init.lua<cr>')
vim.keymap.set('n', '<leader><leader>,', function()
    vim.cmd('source ~/.config/nvim/init.lua')
    -- suppress "Reloading your config is not supported" message as source does actually reload
    -- (non-package) config
    vim.cmd('echo ""')
end)
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
vim.cmd [[
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

function Update()
    vim.cmd.CocUpdate()
end

function BuffersDeleteHidden()
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

function BuffersDeleteUnnamed()
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

vim.cmd [[
command! Update call luaeval('Update()')
command! BuffersDeleteHidden call luaeval('BuffersDeleteHidden()')
command! BuffersDeleteUnnamed call luaeval('BuffersDeleteUnnamed()')

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
-- match <c-w> prefix
vim.g.fzf_action = {
    ['ctrl-s'] = 'split',
    ['ctrl-v'] = 'vsplit',
    ['ctrl-t'] = 'tab split'
}

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
        map('n', ']d', function()
            if vim.wo.diff then return ']d' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end, { expr = true })

        map('n', '[d', function()
            if vim.wo.diff then return '[d' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end, { expr = true })

        -- Actions
        map({ 'n', 'v' }, '<leader>ga', ':Gitsigns stage_hunk<CR>')
        map({ 'n', 'v' }, '<leader>gr', ':Gitsigns reset_hunk<CR>')
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
        map({ 'o', 'x' }, 'id', ':<C-U>Gitsigns select_hunk<CR>')
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

require 'hop'.setup()
vim.keymap.set('n', '\'', '<cmd>HopChar2MW<cr>', { noremap = true })
vim.keymap.set('o', 'z', "<cmd>lua require'hop'.hint_char1({ current_line_only = true, inclusive_jump = true })<cr>",
    { noremap = true })
vim.keymap.set('v', 'z', "<cmd>lua require'hop'.hint_char2({ inclusive_jump = true })<cr>", { noremap = true })

-- iswap
vim.keymap.set('n', '<leader>h', ':ISwapNodeWithLeft<cr>')
vim.keymap.set('n', '<leader>l', ':ISwapNodeWithRight<cr>')
vim.keymap.set('n', '<leader>j', ':ISwapNodeWith<cr>')
vim.keymap.set('n', '<leader>k', ':ISwapNode<cr>')

-- linediff
vim.keymap.set('v', '<leader>l', ':Linediff<cr>')

-- markdown
vim.g.vim_markdown_folding_level = 2
vim.g.vim_markdown_toc_autofit = 1
vim.cmd [[
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
vim.cmd [[ autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif ]]
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
vim.o.timeoutlen = 0
require("which-key").setup {}

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
