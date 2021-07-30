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
" highlight column 140
set colorcolumn=140

" trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" " quicker line movement
" nnoremap <c-j> :m .+1<cr>==
" nnoremap <c-k> :m .-2<cr>==
vnoremap <c-j> :m '>+1<cr>gv=gv
vnoremap <c-k> :m '<-2<cr>gv=gv

" terminal remappings
tnoremap <c-q> <C-\><C-n>

nnoremap <c-n> :call setreg("s", &filetype)<cr>:!bash -c 'open "https://duckduckgo.com/?q=<c-r>s+<c-r><c-w>&ia=web"'<cr>
vnoremap <c-n> y:call setreg("s", &filetype)<cr>:!bash -c 'open "https://duckduckgo.com/?q=<c-r>s+$(echo <c-r>" \| sed '"'"'s/ /+/g'"'"')&ia=web"'<cr>

" disable arrow keys.
" don't be a peasant.
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" search for selected text
vnoremap // y/<c-r>"<cr>

" clear search highlights
nnoremap <c-c> :noh<cr>

nnoremap <c-s> :wall<cr>

let mapleader = "\<space>"
let maplocalleader = ","

" tabs
nnoremap <c-l> :tabn<cr>
nnoremap <c-h> :tabp<cr>
nnoremap <Leader><c-l> :tabmove +1<cr>
nnoremap <Leader><c-h> :tabmove -1<cr>

" get new file changes from disk
nnoremap <Leader>d :checktime<cr>

" close all other windows / tabs
nnoremap <Leader>ow :on<cr>
nnoremap <Leader>oW :on!<cr>
nnoremap <Leader>ot :tabon<cr>
nnoremap <Leader>oT :tabon!<cr>

" NeoVim config
nnoremap <Leader>c :tabnew ~/.config/nvim/init.vim<cr>
nnoremap <Leader>cc :so ~/.config/nvim/init.vim<cr>

" copy/paste
nnoremap Y "+y
vnoremap Y "+y
nnoremap P "+p
vnoremap P "+p
nnoremap <Leader>n :let @+=@%<cr>

" vim-plug / packages
nnoremap <Leader>u :PlugUpgrade<cr>:PlugUpdate<cr>:CocUpdate<cr>:CocCommand tabnine.updateTabNine<cr>
nnoremap <Leader>i :PlugInstall<cr>
nnoremap <Leader>l :PlugClean<cr>
nnoremap <Leader>t :PlugStatus<cr>

call plug#begin('~/.local/share/nvim/plugged')

" try next
" tomtom/tcomment_vim
" tpope/vim-sensible

" language / framework / tool integration
" c9s/vikube.vim
" janko-m/vim-test

" new
" jaxbot/semantic-highlight.vim
" ervandew/supertab
" tpope/vim-sleuth

" general

Plug 'tpope/vim-abolish'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'tpope/vim-commentary'

Plug 'raimondi/delimitmate'

Plug 'easymotion/vim-easymotion'
nmap <cr> <Plug>(easymotion-overwin-f)

Plug 'editorconfig/editorconfig-vim'

Plug 'mattn/emmet-vim'
let g:user_emmet_leader_key='<c-\>'

Plug 'tpope/vim-endwise'

Plug 'tpope/vim-fugitive'
nnoremap <Leader>vs :vert Git<cr>
nnoremap <Leader>vd :Gvdiffsplit<cr>
nnoremap <Leader>vb :Git blame<cr>
nnoremap <Leader>vf :Git fetch<cr>
nnoremap <Leader>vp :Git pull<cr>
cnoreabbrev H tab h
nnoremap <Leader>vm :tab Git commit -v<cr>
nnoremap <Leader>vc :Git checkout<space>
nnoremap <Leader>vl :Git clean<space>
nnoremap <Leader>vr :Git reset<space>

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
nnoremap <Leader>f :Files<cr>
nnoremap <Leader>b :Buffers<cr>
nnoremap <Leader>h :History<cr>
nnoremap <Leader>m :Commits<cr>
nnoremap <Leader>w :Windows<cr>
nnoremap <Leader>r :Rg<cr>
nnoremap <Leader>s :Lines<cr>
nnoremap <Leader>/ :BLines<cr>
vnoremap <Leader>/ y:BLines <c-r>"<cr>
nnoremap <Leader>* :BLines <c-r><c-w><cr>
vnoremap <Leader>r y:Rg <c-r>"<cr>

Plug 'airblade/vim-gitgutter'

Plug 'chriskempson/base16-vim'

Plug 'itchyny/lightline.vim'
set noshowmode

let g:lightline = {
      \ 'colorscheme': 'jellybeans',
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

Plug 'tpope/vim-surround'

Plug 'lervag/vimtex'
let g:tex_flavor = 'latex'

Plug 'tpope/vim-unimpaired'

Plug 'preservim/nerdtree'
let NERDTreeWinSize=60
nnoremap - :NERDTreeToggle<cr>
nnoremap _ :NERDTreeFind<cr>

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
colorscheme base16-gruvbox-dark-medium

" CoC settings

" don't unload buffers when leaving them
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

set updatetime=100

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" code & diagnostic navigation
nmap <silent> [e <Plug>(coc-diagnostic-prev)
nmap <silent> ]e <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" use K to show documentation
nnoremap <silent> K :call <sid>show_documentation()<cr>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <localleader>n <Plug>(coc-rename)

" Refactoring.
nmap <localleader>r <Plug>(coc-refactor)

" Formatting selected code.
xmap <localleader>f <Plug>(coc-format-selected)
nmap <localleader>f <Plug>(coc-format-selected)
nmap <localleader>f <Plug>(coc-format)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Apply codeAction to the current buffer.
nmap <localleader>a <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <localleader>l <Plug>(coc-fix-current)
" Applying codeAction to the selected region.
" Example: `<localleader>sip` for current paragraph
xmap <localleader>s <Plug>(coc-codeaction-selected)
nmap <localleader>s <Plug>(coc-codeaction-selected)

let g:coc_global_extensions = [
  \ 'coc-eslint',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-omnisharp',
  \ 'coc-snippets',
  \ 'coc-solargraph',
  \ 'coc-sql',
  \ 'coc-tabnine',
  \ 'coc-tsserver',
  \ ]
"   " \ 'coc-diagnostic',
"   " \ 'coc-fzf-preview',
"   " \ 'coc-graphql',
"   " \ 'coc-pairs',
"   " \ 'coc-prettier',
  " \ ]

call coc#config('eslint.packageManager', 'npm')

" Use c-q for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <c-q> <Plug>(coc-range-select)
xmap <silent> <c-q> <Plug>(coc-range-select)

" Make <c-j> auto-select the first completion item and notify coc.nvim to
" format on enter, <c-j> could be remapped by other vim plugin
inoremap <silent><expr> <c-j> pumvisible() ? coc#_select_confirm()
                              \: "\<c-g>u\<cr>\<c-r>=coc#on_enter()\<c-j>"

" " Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <localleader>d :<c-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <localleader>e :<c-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <c-k> :<c-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <localleader>o :<c-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <localleader>y :<c-u>CocList -I symbols<cr>
" " Do default action for next item.
" nnoremap <silent><nowait> <localleader>j :<c-u>CocNext<cr>
" " Do default action for previous item.
" nnoremap <silent><nowait> <leader>k :<c-u>CocPrev<cr>
" " Resume latest coc list.
" nnoremap <silent><nowait> <localleader>p :<c-u>CocListResume<cr>

" Use <c-n> to jump to the next placeholder
let g:coc_snippet_next = '<c-n>'
" Use <c-p> to jump to the previous placeholder
let g:coc_snippet_prev = '<c-p>'

" " Use <c-l> for trigger snippet expand.
" imap <c-l> <Plug>(coc-snippets-expand)

" " Use <c-j> for select text for visual placeholder of snippet.
" vmap <c-j> <Plug>(coc-snippets-select)

" " Use <c-j> for both expand and jump (make expand higher priority.)
" imap <c-j> <Plug>(coc-snippets-expand-jump)

" " Use <leader>x for convert visual selected code to snippet
" xmap <leader>x <Plug>(coc-convert-snippet)

" ___

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

" " Remap <c-f> and <c-b> for scroll float windows/popups.
" " Note coc#float#scroll works on neovim >= 0.4.0 or vim >= 8.2.0750
" nnoremap <nowait><expr> <c-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<c-f>"
" nnoremap <nowait><expr> <c-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<c-b>"
" inoremap <nowait><expr> <c-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
" inoremap <nowait><expr> <c-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

" " NeoVim-only mapping for visual mode scroll
" " Useful on signatureHelp after jump placeholder of snippet expansion
" if has('nvim')
"   vnoremap <nowait><expr> <c-f> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 1) : "\<c-f>"
"   vnoremap <nowait><expr> <c-b> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 1) : "\<c-b>"
" endif

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

if !empty(glob("~/.config/nvim/init.os.vim"))
  source ~/.config/nvim/init.os.vim
endif
if !empty(glob("~/.config/nvim/init.local.vim"))
  source ~/.config/nvim/init.local.vim
endif
