-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

--  NOTE: map leader key before plugins are required, else wrong leader will be used
vim.g.mapleader = ' '

-- disable netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("lazy").setup({
    rocks = {
        enabled = false,
    },
    spec = {
    -- 'jreybert/vimagit'
    -- 'tpope/vim-git',
    -- 'tpope/vim-rhubarb'
    'tpope/vim-fugitive',

    {
        'lewis6991/gitsigns.nvim',
        opts = {
            on_attach = function(bufnr)
                local gitsigns = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map('n', ']d', function()
                    if vim.wo.diff then
                        vim.cmd.normal({']d', bang = true})
                    else
                        gitsigns.nav_hunk('next')
                    end
                end)

                map('n', '[d', function()
                  if vim.wo.diff then
                    vim.cmd.normal({'[d', bang = true})
                  else
                    gitsigns.nav_hunk('prev')
                  end
                end)

                -- Actions
                map('n', '<leader>ga', gitsigns.stage_hunk)
                map('v', '<leader>ga', function()
                  gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                end)
                map('n', '<leader>gr', gitsigns.reset_hunk)
                map('v', '<leader>gr', function()
                  gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                end)

                map('n', '<leader>gA', gitsigns.stage_buffer)
                map('n', '<leader>gR', gitsigns.reset_buffer)
                map('n', '<leader>gi', gitsigns.preview_hunk_inline)
                map('n', '<leader>gv', gitsigns.undo_stage_hunk)

                -- Text object
                map({ 'o', 'x' }, 'id', gitsigns.select_hunk)
            end
        }
    },

    -- 'williamboman/mason.nvim' -- and
    -- 'williamboman/mason-lspconfig.nvim' -- and
    -- 'neovim/nvim-lspconfig'
    --
    -- 'ms-jpq/coq_nvim',
    -- 'autozimu/LanguageClient-neovim',
    { 'neoclide/coc.nvim', branch = 'release' },

    -- ui
    {
        'Luxed/ayu-vim',
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.termguicolors = true
            vim.o.background = 'dark'
            vim.g.ayucolor = 'mirage'
            vim.cmd.colorscheme('ayu')
        end
    },

    'folke/which-key.nvim',
    'junegunn/fzf',
    'junegunn/fzf.vim',
    'norcalli/nvim-colorizer.lua',
    'powerman/vim-plugin-AnsiEsc',
    'ryanoasis/vim-devicons',

    {
        -- https://zignar.net/2022/01/21/a-boring-statusline-for-neovim/
        -- 'nvim-lualine/lualine.nvim'
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

    'nvim-tree/nvim-tree.lua',
    'nvim-tree/nvim-web-devicons',

    -- editing
    'andrewradev/linediff.vim',
    { 'smoka7/hop.nvim', opts = {}, },
    'honza/vim-snippets',

    {
        "jpalardy/vim-slime",
        init = function()
            vim.g.slime_no_mappings = 1
        end
    },

    'mizlan/iswap.nvim',
    { 'numToStr/Comment.nvim', opts = {}, lazy = false, },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    -- languages
                    'c', 'commonlisp', 'dockerfile', 'eex', 'elixir', 'elm', 'erlang', 'java',
                    'javascript', 'jsdoc', 'go', 'gomod', 'gowork', 'heex', 'python', 'ruby',
                    'rust', 'tsx', 'typescript', 'zig',
                    -- version control
                    'diff', 'git_rebase', 'gitattributes', 'gitcommit', 'gitignore',
                    -- web
                    'css', 'html', 'http',
                    -- config
                    'hcl', 'ini', 'json', 'jsonc', 'nix', 'terraform', 'toml', 'yaml', 'xml',
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

    {
        "olimorris/codecompanion.nvim",
        opts = {},
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },

    'pbrisbin/vim-mkdir',
    'raimondi/delimitmate',
    'tpope/vim-abolish',
    'tpope/vim-obsession',
    'tpope/vim-repeat',
    'tpope/vim-sleuth',
    'tpope/vim-surround',
    'tpope/vim-unimpaired',
    'wellle/targets.vim',

    -- included for folding
    -- 'preservim/vim-markdown',
    -- 'elixir-tools/elixir-tools.nvim'
    {
        'fatih/vim-go', build = ':GoUpdateBinaries'
    },
    'ChrisWellsWood/roc.vim',

    -- as needed
    -- 'dstein64/vim-startuptime',
    -- 'mattn/emmet-vim',
    -- 'tpope/vim-dadbod',
    -- 'lervag/vimtex', let g:tex_flavor = 'latex'

    -- new plugins to try

    -- {
    --     'nvim-telescope/telescope.nvim',
    --     branch = '0.1.x',
    --     dependencies = { 'nvim-lua/plenary.nvim' }
    -- }

    -- 'iamcco/markdown-preview.nvim'
    -- 'tpope/vim-rsi'
    -- 'mbbill/undotree',
    -- 'her/central.vim',
    -- 'mfussenegger/nvim-dap',
    -- 'ThePrimeagen/harpoon',
    -- 'folke/trouble.nvim',
    -- 'tpope/vim-dispatch',
    -- 'janko-m/vim-test',
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

    -- if !empty(glob('~/.config/nvim/plugs.os.vim'))
    --     source ~/.config/nvim/plugs.os.vim
    -- endif
    -- if !empty(glob('~/.config/nvim/plugs.local.vim'))
    --     source ~/.config/nvim/plugs.local.vim
    -- endif

}, {})

vim.cmd.filetype('plugin indent on')
vim.cmd.syntax('enable')

-- show extra whitespace
vim.o.list = true
vim.o.listchars = 'tab:▷\\ ,trail:⋅,nbsp:☺,extends:→,precedes:←'

-- wrap & highlight @100 chars
vim.o.textwidth = 100
vim.o.colorcolumn = '+0'
-- use sensible boundaries when wrapping text display
vim.o.linebreak = true
-- indent when wrapping with showbreak starting the line
vim.o.breakindent = true
vim.o.breakindentopt = 'sbr'
vim.o.showbreak = '↪ '

-- show line numbers
vim.o.number = true
-- always show signcolumn
vim.o.signcolumn = 'yes'

-- continue comments on new lines
vim.opt.formatoptions:append('ro')

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
-- trigger CursorHold sooner; keep < 300
vim.o.updatetime = 200

-- highlight current line
vim.o.cursorline = true
-- fold on indents; don't fold when opening files
vim.o.foldmethod = 'indent'
vim.o.foldenable = false

-- wildmenu
vim.o.wildmode = 'longest,full'
vim.o.wildoptions = 'fuzzy,pum,tagfile'
vim.keymap.set('c', '<c-f>', '<space><bs><left>')
vim.keymap.set('c', '<c-b>', '<space><bs><right>')

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
-- TODO: expand ~ to $HOME
vim.keymap.set('n', 'gf', ':edit <cfile><cr>')

-- show file format and encoding
vim.keymap.set('n', 'gl', ':set fileformat? fileencoding?<cr>')

-- enter to save all buffers, except in quickfix lists
vim.keymap.set('n', '<cr>', '&buftype ==# "quickfix" ? "\\<cr>" : ":checktime\\<cr>:wall\\<cr>"',
    { expr = true, remap = false })

-- keep cursor in place when joining lines
vim.keymap.set('n', 'J', 'mzJ`z', { remap = false })
vim.keymap.set('n', 'gJ', 'mzgJ`z', { remap = false })

-- split line before/after cursor
vim.keymap.set('n', '[<cr>', 'i<cr><esc>kg_')
vim.keymap.set('n', ']<cr>', 'a<cr><esc>kg_')

-- search for selected text
vim.keymap.set('v', '*', '"zy/\\V\\c\\<<c-r>z\\><cr>')
vim.keymap.set('v', 'g*', '"zy/\\V\\c<c-r>z<cr>')

-- substitute: replace all, ask for confirmation and don't ignore case
vim.keymap.set('n', '<c-s>', ':%s/\\V\\<<c-r><c-w>\\>/<c-r><c-w>/gcI<left><left><left><left>')
vim.keymap.set('n', 'g<c-s>', ':%s/\\V<c-r><c-w>/<c-r><c-w>/gcI<left><left><left><left>')
vim.keymap.set('x', '<c-s>', '"zy:%s/\\V\\<<c-r>z\\>/<c-r>z/gcI<left><left><left><left>')
vim.keymap.set('x', 'g<c-s>', '"zy:%s/\\V<c-r>z/<c-r>z/gcI<left><left><left><left>')

-- clear highlights
vim.keymap.set('n', '<esc>', function()
    vim.cmd.nohlsearch()
    vim.cmd.echo()
end, { remap = false })

-- select all
vim.keymap.set('n', '^', 'ggVG')

vim.cmd.cnoreabbrev('h', 'vert h')
vim.cmd.cnoreabbrev('hs', 'hor h')
vim.cmd.cnoreabbrev('ht', 'tab h')

-- sacrilegious bindings for command mode
vim.keymap.set('c', '<c-a>', '<Home>')
vim.keymap.set('c', '<c-b>', '<left>')
vim.keymap.set('c', '<c-f>', '<right>')
vim.keymap.set('c', '<esc>b', '<s-left>')
vim.keymap.set('c', '<esc>f', '<s-right>')

vim.g.mousescroll = 'hor:1'
vim.keymap.set('n', '<ScrollWheelUp>', '<c-y>')
vim.keymap.set('n', '<ScrollWheelDown>', '<c-e>')

if vim.g.neovide then
    vim.o.guifont = 'Hack Nerd Font:h13'
    vim.g.neovide_scroll_animation_length = 0.09
    vim.g.neovide_cursor_animation_length = 0.09
    vim.g.neovide_refresh_rate_idle = 1
    vim.g.neovide_input_macos_alt_is_meta = true
    vim.g.neovide_cursor_vfx_mode = 'ripple'
    vim.keymap.set('', '<D-n>', ':silent !neovide --multigrid&<cr>')
end

-- config
vim.keymap.set('n', '<leader>,', ':tabnew<cr>:tcd ~/.dotfiles<cr>:e ~/.config/nvim/init.lua<cr>')
vim.keymap.set('n', '<leader><leader>,', function()
    vim.cmd.source('~/.config/nvim/init.lua')
    -- suppress 'Reloading your config is not supported' message as source does actually reload
    -- (non-package) config
    vim.cmd.echo()
end)
vim.keymap.set('n', '<leader>;', ':execute \'tabnew ~/.config/nvim/ftplugin/\' . &ft . \'.vim\'<cr>')
vim.keymap.set('n', '<leader><leader>.', ':so %<cr>')

-- clipboard
-- copy filename to system clipboard
vim.keymap.set('n', '<leader>5', ':let @+=@%<cr>')
-- copy current register to system clipboard
vim.keymap.set('n', '<leader>\'', '"+')
vim.keymap.set('x', '<leader>\'', '"+')

-- terminal
-- quit, then move to start of line to preserve display of curses-like output
vim.keymap.set('t', '<c-/>', '<c-\\><c-n>0')
vim.keymap.set('n', '<leader>ts', ':25sp | terminal fish<cr>a')
vim.keymap.set('n', '<leader>tv', ':85vsp | terminal fish<cr>a')
vim.keymap.set('n', '<leader>tt', ':tabnew | terminal fish<cr>a')

local terminal_settings_augroup = vim.api.nvim_create_augroup('terminal_settings', {})
vim.api.nvim_create_autocmd('TermOpen', {
    desc = 'Remove line numbers in terminals',
    group = terminal_settings_augroup,
    pattern = 'term://*',
    command = 'setlocal nonumber norelativenumber scrolloff=0'
})

vim.api.nvim_create_autocmd('TermClose', {
    desc = 'Close terminals without pressing the return key',
    group = terminal_settings_augroup,
    pattern = 'term://*',
    callback = function() -- event_args
        vim.fn.call('nvim_input', { '<cr>' })

        -- ignore fzf & coc filetypes as those will close terminal automatically
        -- local expanded_file = vim.fn.expand(event_args.file)
        -- local is_autoclose_file = string.match(expanded_file, 'fzf')
        --     or string.match(expanded_file, 'coc')
        -- if not is_autoclose_file then
        --     vim.fn.call('nvim_input', {'<cr>'})
        -- end
    end
})

-- commands & augroups

vim.api.nvim_create_user_command('Update',
    function()
        vim.cmd.CocUpdate()
        vim.cmd.Lazy('update')
        vim.cmd.TSUpdate()
    end, { desc = 'Run all update commands' })

vim.api.nvim_create_user_command('BuffersDeleteHidden',
    function()
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
    end, { desc = 'Delete all "hidden" / not-shown buffers' }
)

vim.api.nvim_create_user_command('BuffersDeleteUnnamed',
    function()
        local emptyBuffers = {}
        for i = 1, vim.fn.bufnr('$') do
            if vim.fn.buflisted(i) and vim.fn.bufexists(i) and vim.fn.bufname(i) == '' then
                table.insert(emptyBuffers, i)
            end
        end

        if #emptyBuffers > 0 then
            vim.cmd.bdelete(table.concat(emptyBuffers, ' '))
        end
    end, { desc = 'Delete all unnamed buffers' }
)

local onsave_augroup = vim.api.nvim_create_augroup('trim_whitespace_on_bufwrite', {})
vim.api.nvim_create_autocmd('BufWrite', {
    desc = 'Trim trailing whitespace on save',
    group = onsave_augroup,
    pattern = '*',
    command = ':%s/\\s\\+$//e',
})

-- plugins

-- codecompanion
vim.keymap.set({ "n", "v" }, "<leader>n", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>m", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])

-- vim.keymap.set('n', '<leader>ai', ':CodeCompanion<cr>')
-- vim.keymap.set('n', '<leader>ac', ':CodeCompanionChat Toggle<cr>')
-- vim.keymap.set('v', '<leader>ac', ':CodeCompanionChat Toggle<cr>')
-- vim.keymap.set('n', '<leader>am', ':CodeCompanionCmd<cr>')
-- vim.keymap.set('n', '<leader>at', ':CodeCompanionActions<cr>')
-- vim.keymap.set('v', '<leader>at', ':CodeCompanionActions<cr>')

-- delimitmate
vim.g.delimitMate_balance_matchpairs = 1
vim.g.delimitMate_excluded_regions = ''
vim.g.delimitMate_expand_cr = 2
vim.g.delimitMate_expand_inside_quotes = 1
vim.g.delimitMate_expand_space = 1
vim.g.delimitMate_jump_expansion = 1

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

vim.cmd [[
    function! s:build_quickfix_list(lines)
      call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
      copen
      cc
    endfunction

    let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit',
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-q': function('s:build_quickfix_list') }
]]

-- go
vim.g.go_code_completion_enabled = 0
vim.g.go_doc_keywordprg_enabled = 0
vim.g.go_fmt_autosave = 0
vim.g.go_def_mapping_enabled = 0
vim.g.go_term_mode = 'split'
vim.g.go_term_reuse = 1
vim.g.go_term_enabled = 1
vim.g.go_term_close_on_exit = 0
vim.g.go_gopls_enabled = 0

-- hop
local hop = require('hop')
vim.keymap.set('n', 's', function() hop.hint_char2() end)
vim.keymap.set('o', 'z', function()
    hop.hint_char1({ current_line_only = true, inclusive_jump = true })
end)
vim.keymap.set('v', 'z', function()
    hop.hint_char2({ inclusive_jump = true })
end)

-- iswap
vim.keymap.set('n', '<leader>h', ':ISwapNodeWithLeft<cr>')
vim.keymap.set('n', '<leader>l', ':ISwapNodeWithRight<cr>')
vim.keymap.set('n', '<leader>j', ':ISwapNodeWith<cr>')
vim.keymap.set('n', '<leader>k', ':ISwapNode<cr>')

-- linediff
vim.keymap.set('v', '<leader>l', ':Linediff<cr>')

-- nvim-tree
require('nvim-tree').setup({
    view = {
        width = 60,
    },
    renderer = {
        group_empty = true,
    },
    on_attach = function(bufnr)
        local api = require('nvim-tree.api')
        local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, silent = true, nowait = true }
        end
        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set('n', '-', api.tree.toggle, opts('Toggle tree'))
        vim.keymap.set('n', '<c-k>', api.tree.change_root_to_parent, opts('Up'))
        vim.keymap.set('n', '<c-j>', api.tree.change_root_to_node, opts('Down'))
        vim.keymap.del('n', '<c-x>', { buffer = bufnr })
        vim.keymap.set('n', '<c-s>', api.node.open.horizontal, opts('Open: Horizontal Split'))
    end,
})

local nvimtree_augroup = vim.api.nvim_create_augroup('NvimTree', {})
vim.api.nvim_create_autocmd('BufEnter', {
    desc = 'Quit when nvim-tree is the last window',
    group = nvimtree_augroup,
    callback = function()
        local api = require('nvim-tree.api')
        if vim.fn.winnr('$') == 1 and api.tree.is_tree_buf() then
            vim.cmd.q()
        end
    end
})
vim.keymap.set('n', '-', ':NvimTreeToggle<cr>')
vim.keymap.set('n', '<leader>-', ':NvimTreeFindFile<cr>')

-- obsession
vim.keymap.set('n', '<leader>st', ':Obsession<cr>')
vim.keymap.set('n', '<leader>sl', ':source Session.vim<cr>')

-- slime
vim.g.slime_target = 'neovim'
vim.g.slime_no_mappings = 1
vim.keymap.set('n', '<leader>tc', '<plug>SlimeConfig')
vim.keymap.set('n', '<leader>tx', '<plug>SlimeMotionSend')
vim.keymap.set('x', '<leader>tx', '<plug>SlimeRegionSend')
vim.keymap.set('n', '<leader>tl', '<plug>SlimeLineSend')
-- TODO: choose from active terminals b:terminal_job_id

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

local coc_settings = vim.fn.expand('~/.config/nvim/coc-settings.vim')
if vim.fn.filereadable(coc_settings) == 1 then
    vim.cmd.source(coc_settings)
end
local os_settings = vim.fn.expand('~/.config/nvim/init.os.vim')
if vim.fn.filereadable(os_settings) == 1 then
    vim.cmd.source(os_settings)
end
local local_settings = vim.fn.expand('~/.config/nvim/init.local.vim')
if vim.fn.filereadable(local_settings) == 1 then
    vim.cmd.source(local_settings)
end
