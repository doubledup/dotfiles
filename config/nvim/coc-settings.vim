" don't unload buffers when leaving them
set hidden

" Already set in main config
" " Some servers have issues with backup files, see #649.
" set nobackup
" set nowritebackup

set updatetime=100

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

let g:coc_global_extensions = [
  \ 'coc-diagnostic',
  \ 'coc-elixir',
  \ 'coc-eslint',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-omnisharp',
  \ 'coc-prettier',
  \ 'coc-rust-analyzer',
  \ 'coc-snippets',
  \ 'coc-solargraph',
  \ 'coc-sql',
  \ 'coc-tsserver',
  \ 'coc-yaml',
  \ ]
  " \ 'coc-fzf-preview',
  " \ 'coc-graphql',
  " \ 'coc-pairs',
  " \ 'coc-tabnine',
  " \ ]

" To move to built-in LSP, need a replacement for
" - linters
" - formatters
" - data formats
" - snippets

call coc#config('eslint.packageManager', 'npm')

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

nmap <localleader>q :CocRestart<cr>

" Refactoring.
nmap <localleader>r <Plug>(coc-refactor)
" Symbol renaming.
nmap <localleader>n <Plug>(coc-rename)

" Format code. (p)rettify
xmap <localleader>p <Plug>(coc-format-selected)
nmap <localleader>p <Plug>(coc-format)

" Apply codeAction to the current buffer.
nmap <localleader>a <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <localleader>f <Plug>(coc-fix-current)
" Applying codeAction to the selected region.
" Example: `<localleader>sip` for current paragraph
xmap <localleader>s <Plug>(coc-codeaction-selected)
nmap <localleader>s <Plug>(coc-codeaction-selected)

" Use c-q for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <c-q> <Plug>(coc-range-select)
xmap <silent> <c-q> <Plug>(coc-range-select)

" use tab to:
" select current autocomplete item, if visible; or
" expand the snippet, if current word is a snippet; or
" increase indentation, if cursor is preceded by whitespace; or
" trigger the completion menu
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" TODO: also use tab to navigate snippets
" let g:coc_snippet_next = '<tab>'
" let g:coc_snippet_prev = '<s-tab>'

" " Make <c-j> auto-select the first completion item and notify coc.nvim to
" " format on enter, <c-j> could be remapped by other vim plugin
" inoremap <silent><expr> <c-j> pumvisible() ? coc#_select_confirm()
"                               \: "\<c-g>u\<cr>\<c-r>=coc#on_enter()\<c-j>"

imap <c-l> <Plug>(coc-snippets-expand)
let g:coc_snippet_next = '<c-j>'
let g:coc_snippet_prev = '<c-k>'

" " Use <c-j> for select text for visual placeholder of snippet.
" vmap <c-j> <Plug>(coc-snippets-select)

" " Use <c-j> for both expand and jump (make expand higher priority.)
" imap <c-j> <Plug>(coc-snippets-expand-jump)

" " Use <leader>x for convert visual selected code to snippet
" xmap <leader>x <Plug>(coc-convert-snippet)

" " Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <localleader>d :<c-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <localleader>e :<c-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <localleader>j :<c-u>CocList commands<cr>
" Show symbol outline for current document.
nnoremap <silent><nowait> <localleader>o :<c-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <localleader>y :<c-u>CocList -I symbols<cr>
" " Do fix and move to next item.
" nnoremap <silent> ]d <Plug>(coc-fix-current)<Plug>(coc-diagnostic-next)
" " Do fix and move to previous item.
" nnoremap <silent> [d <Plug>(coc-fix-current)<Plug>(coc-diagnostic-prev)
" " Resume latest coc list.
" nnoremap <silent><nowait> <localleader>p :<c-u>CocListResume<cr>

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
