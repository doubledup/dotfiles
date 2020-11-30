" make existing tabs obvious
set tabstop=8
" but edit with a different tab width
set softtabstop=2
" when indenting with '>'
set shiftwidth=2
" when tab is pressed, expand with spaces
set expandtab
" remove 2 spaces with backspace
set backspace=2
" automatically indent when adding a new line
set autoindent

" show line numbers
set number

" show extra whitespace
set listchars=tab:▷⋅,trail:⋅,nbsp:☺,extends:→,precedes:←
set list

" ignore case unless there are upper-case characters
set ignorecase
set smartcase
" split below and to the right, leaving existing panes where they are
set splitbelow
set splitright
" live on the edge!
set noswapfile
set autoread
" don't wrap long lines
set nowrap
" don't redraw while executing commands & using registers
set lazyredraw
" Highlight current column and line
set cuc cul
" incrementally highlight searches
set incsearch
set hlsearch

" trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" netrw
let g:netrw_liststyle=3 " thin/long/wide/tree
let g:netrw_browse_split=2 " horizontal/vertical/tab/window
let g:netrw_winsize=25 " size as screen %

" quicker line movement
nnoremap <c-j> :m .+1<CR>==
nnoremap <c-k> :m .-2<CR>==
vnoremap <c-j> :m '>+1<CR>gv=gv
vnoremap <c-k> :m '<-2<CR>gv=gv

" disable arrow keys.
" don't be a peasant.
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" search for selected text
vnoremap // y/<c-r>"<cr>

" clear search highlights
nnoremap <esc> :noh<cr>

" exit terminal
" if has('nvim')
"   tnoremap <Esc> <C-\><C-n>
" endif

cnoreabbrev H tab h

" bindings
" leader: general mnemonics
" []: forward/backward
" g: goto

" leader key mappings

" #Packages
" Plug: p
" ALE (lint): l
" Dash/Zeal (doc): d
" Fugitive (version control): v
" FZF: {fbcwrs/*}

" #Other
" Quickfix: q
" Reload file (get changes): g
" Close other windows/tabs: o{wt}
" Editor config/reload: e{cr}
" Copy: y

" Visual
" FZF: r

" filetype leader mappings
" Execute file: x
" Build (make): m
" Test all/single file: t/tt

" localleader mappings
" Edit config/reload: e{cr}

let mapleader = "\<space>"
let maplocalleader = "\<c-space>"

" windows
nnoremap <Leader><c-j> <c-w>J
nnoremap <Leader><c-k> <c-w>K
nnoremap <Leader><c-h> <c-w>H
nnoremap <Leader><c-l> <c-w>L

" tabs
nnoremap <c-l> :tabn<cr>
nnoremap <c-h> :tabp<cr>
nnoremap <Leader><c-l> :tabmove +1<cr>
nnoremap <Leader><c-h> :tabmove -1<cr>

" quickfix
nnoremap <Leader>qc :cc
nnoremap <Leader>qn :cn<cr>
nnoremap <Leader>qp :cp<cr>

" get new file changes from disk
nnoremap <Leader>g :checktime<cr>

" close all other windows / tabs
nnoremap <Leader>ow :on<cr>
nnoremap <Leader>oW :on!<cr>
nnoremap <Leader>ot :tabon<cr>
nnoremap <Leader>oT :tabon!<cr>

" NeoVim config
nnoremap <Leader>ec :tabnew ~/.config/nvim/init.vim<cr>
nnoremap <Leader>er :so ~/.config/nvim/init.vim<cr>

" copy/paste
nnoremap <Leader>y "+y
nnoremap <Leader>yc :let @+=@%<cr>
vnoremap <Leader>y "+y
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>p "+p

" vim-plug / packages
nnoremap <Leader>ku :PlugUpdate<cr>
nnoremap <Leader>kg :PlugUpgrade<cr>
nnoremap <Leader>ki :PlugInstall<cr>
nnoremap <Leader>kc :PlugClean<cr>
nnoremap <Leader>ks :PlugStatus<cr>

call plug#begin('~/.local/share/nvim/plugged')

" try next
" tomtom/tcomment_vim
" tpope/vim-sensible

" alternatives
" valloric/youcompleteme
" autozimu/languageclient-neovim

" language / framework / tool integration
" tpope/vim-rails
" pangloss/vim-javascript
" c9s/vikube.vim
" janko-m/vim-test

" new
" jaxbot/semantic-highlight.vim
" ervandew/supertab
" tpope/vim-sleuth

" general

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Plug 'w0rp/ale'
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_fix_on_save = 0
" let g:ale_fixers = {
" \   '*': ['remove_trailing_lines', 'trim_whitespace'],
" \}
" nnoremap <Leader>ld :ALEDetail<cr>
" nnoremap <Leader>lf :ALEFix<cr>
" nnoremap <Leader>ln :ALENextWrap<cr>
" nnoremap <Leader>lp :ALEPreviousWrap<cr>
" nnoremap <Leader>li :ALEInfo<cr>

Plug 'chriskempson/base16-vim'

" Plug 'omnisharp/omnisharp-vim'

Plug 'tpope/vim-commentary'

" deoplete
" if has('nvim')
"   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"   Plug 'Shougo/deoplete.nvim'
"   Plug 'roxma/nvim-yarp'
"   Plug 'roxma/vim-hug-neovim-rpc'
" endif
" let g:deoplete#enable_at_startup = 1
" Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }

Plug 'raimondi/delimitmate'

Plug 'easymotion/vim-easymotion'
nmap <cr> <Plug>(easymotion-overwin-f)

Plug 'mattn/emmet-vim'

Plug 'tpope/vim-endwise'

Plug 'tpope/vim-fugitive'
nnoremap <Leader>vs :Git<cr>
nnoremap <Leader>vd :Gvdiffsplit<cr>
nnoremap <Leader>vb :Git blame<cr>
nnoremap <Leader>vf :Git fetch<cr>
nnoremap <Leader>vp :Git pull<cr>
nnoremap <Leader>vm :tab Git commit -v<cr>
nnoremap <Leader>vc :Git checkout<space>
nnoremap <Leader>vl :Git clean<space>
nnoremap <Leader>vr :Git reset<space>

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
let g:fzf_layout = { 'up': '80%' }
nnoremap <Leader>f :Files<cr>
nnoremap <Leader>b :Buffers<cr>
nnoremap <Leader>h :History<cr>
nnoremap <Leader>c :Commits<cr>
nnoremap <Leader>w :Windows<cr>
nnoremap <Leader>r :Rg<cr>
nnoremap <Leader>s :Lines<cr>
nnoremap <Leader>/ :BLines<cr>
nnoremap <Leader>* :BLines <c-r><c-w><cr>
vnoremap <Leader>r y:Rg <c-r>"<cr>

Plug 'airblade/vim-gitgutter'
set updatetime=100

Plug 'fatih/vim-go', {'for': 'go'}

" Plug 'ludovicchabant/vim-gutentags'

Plug 'itchyny/lightline.vim'
set noshowmode

let g:lightline = {
      \ 'colorscheme': 'Tomorrow_Night',
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

Plug 'andrewradev/linediff.vim'

Plug 'nelstrom/vim-markdown-folding'
set nocompatible
if has("autocmd")
  filetype plugin indent on
endif

Plug 'aklt/plantuml-syntax'

Plug 'sheerun/vim-polyglot'

Plug 'tpope/vim-repeat'

Plug 'honza/vim-snippets'
Plug 'sirver/ultisnips'

Plug 'tpope/vim-surround'

Plug 'lervag/vimtex'
let g:tex_flavor = 'latex'

Plug 'tpope/vim-unimpaired'

" Plug 'Shougo/vimproc.vim', {'do' : 'make'}
" Plug 'quramy/tsuquyomi'

" Plug 'pangloss/vim-javascript', {'for': 'js'}
" Plug 'leafgarland/typescript-vim', {'for': 'ts'}
" Plug 'MaxMEllon/vim-jsx-pretty'
" Plug 'peitalin/vim-jsx-typescript', {'for': 'ts'}
" Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
" Plug 'jparise/vim-graphql'

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

" set background=dark
set termguicolors
colorscheme base16-gruvbox-dark-pale

if !empty(glob("~/.config/nvim/init.vim.os"))
  source ~/.config/nvim/init.vim.os
endif
if !empty(glob("~/.config/nvim/init.vim.local"))
  source ~/.config/nvim/init.vim.local
endif

" CoC bindings

let g:coc_global_extensions = [
  \ 'coc-eslint',
  \ 'coc-json',
  \ 'coc-tabnine',
  \ 'coc-tsserver',
  \ ]
"   " \ 'coc-snippets',
"   " \ 'coc-pairs',
"   " \ 'coc-prettier',
"   " \ 'coc-fzf-preview',
  " \ ]

call coc#config('eslint.packageManager', 'npm')

" set nobackup
" set nowritebackup
set updatetime=200
" set cmdheight=2
" set signcolumn=number
nmap <silent> [e <Plug>(coc-diagnostic-prev)
nmap <silent> ]e <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" autocmd CursorHold * silent call CocActionAsync('highlight')

" Refactoring.
nmap <leader>lr <Plug>(coc-refactor)

" Formatting selected code.
" xmap <leader>lf  <Plug>(coc-format-selected)
" nmap <leader>lf  <Plug>(coc-format-selected)
" nmap <leader>lf  <Plug>(coc-format)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
" xmap <leader>la  <Plug>(coc-codeaction-selected)
" nmap <leader>la  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>la  <Plug>(coc-codeaction)
" " Apply AutoFix to problem on the current line.
nmap <leader>lf  <Plug>(coc-eslint-autofix)

" " Map function and class text objects
" " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
" xmap if <Plug>(coc-funcobj-i)
" omap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap af <Plug>(coc-funcobj-a)
" xmap ic <Plug>(coc-classobj-i)
" omap ic <Plug>(coc-classobj-i)
" xmap ac <Plug>(coc-classobj-a)
" omap ac <Plug>(coc-classobj-a)

" " Remap <C-f> and <C-b> for scroll float windows/popups.
" " Note coc#float#scroll works on neovim >= 0.4.0 or vim >= 8.2.0750
" nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
" nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
" inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

" " NeoVim-only mapping for visual mode scroll
" " Useful on signatureHelp after jump placeholder of snippet expansion
" if has('nvim')
"   vnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 1) : "\<C-f>"
"   vnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 1) : "\<C-b>"
" endif

" " Use CTRL-S for selections ranges.
" " Requires 'textDocument/selectionRange' support of language server.
" nmap <silent> <C-s> <Plug>(coc-range-select)
" xmap <silent> <C-s> <Plug>(coc-range-select)

" " Add `:Format` command to format current buffer.
" command! -nargs=0 Format :call CocAction('format')

" " Add `:Fold` command to fold current buffer.
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" " Add `:OR` command for organize imports of the current buffer.
" command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" " Add (Neo)Vim's native statusline support.
" " NOTE: Please see `:h coc-status` for integrations with external plugins that
" " provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" " Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <leader>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions.
" nnoremap <silent><nowait> <leader>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <c-p>  :<C-u>CocList commands<cr>
" " Find symbol of current document.
" nnoremap <silent><nowait> <leader>o  :<C-u>CocList outline<cr>
" " Search workspace symbols.
" nnoremap <silent><nowait> <leader>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item.
" nnoremap <silent><nowait> <leader>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent><nowait> <leader>k  :<C-u>CocPrev<CR>
" " Resume latest coc list.
" nnoremap <silent><nowait> <leader>p  :<C-u>CocListResume<CR>
