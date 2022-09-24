" don't unload buffers when leaving them
set hidden

" Some servers have issues with backup files, see https://github.com/neoclide/coc.nvim/issues/649.
" Already set in main config
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Fix color of selected item in completion menu
hi CocMenuSel ctermbg=237 guibg=#13354A

let g:coc_node_path = '~/.asdf/shims/node'

" use tab to:
" select current autocomplete item, if visible; or
" expand the snippet, if current word is a snippet; or
" increase indentation, if cursor is preceded by whitespace; or
" trigger the completion menu
inoremap <silent><expr> <tab>
      \ coc#pum#visible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<c-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<cr>" :
      \ <SID>check_back_space() ? "\<tab>" :
      \ coc#refresh()
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" TODO: also use tab to navigate snippets
" let g:coc_snippet_next = '<tab>'
" let g:coc_snippet_prev = '<s-tab>'
" TODO: prevent popups on snippet expansion

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" " Make <c-j> auto-select the first completion item and notify coc.nvim to
" " format on enter, <c-j> could be remapped by other vim plugin
" inoremap <silent><expr> <c-j> pumvisible() ? coc#_select_confirm()
"                               \: "\<c-g>u\<cr>\<c-r>=coc#on_enter()\<c-j>"

" code & diagnostic navigation
" replace spell checker
nmap <silent> [s <Plug>(coc-diagnostic-prev)
nmap <silent> ]s <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<cr>
function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('definitionHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>n <Plug>(coc-rename)

" Format selected code
xmap = <Plug>(coc-format-selected)
" nmap = <Plug>(coc-format-selected)
nmap = <Plug>(coc-format)

augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" " Applying codeAction to the selected region.
" " Example: `<leader>aap` for current paragraph
" xmap <leader>a <Plug>(coc-codeaction-selected)
" nmap <leader>a <Plug>(coc-codeaction-selected)

" Apply codeAction to the current buffer.
" Remap keys for applying codeAction to the current buffer.
nmap <leader>a <Plug>(coc-codeaction)

" Apply AutoFix to problem on the current line.
nmap <leader>x  <Plug>(coc-fix-current)
" " Apply AutoFix to problem on the current line.
" nmap <leader>f <Plug>(coc-fix-current)

" " Run the Code Lens action on the current line.
" nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-e> and <C-y> to scroll floating windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  let scrollLength = 15
  nnoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? coc#float#scroll(1, scrollLength) : "\<C-e>"
  nnoremap <silent><nowait><expr> <C-y> coc#float#has_scroll() ? coc#float#scroll(0, scrollLength) : "\<C-y>"
  inoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1, scrollLength)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-y> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0, scrollLength)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? coc#float#scroll(1, scrollLength) : "\<C-e>"
  vnoremap <silent><nowait><expr> <C-y> coc#float#has_scroll() ? coc#float#scroll(0, scrollLength) : "\<C-y>"
endif

" Use c-q for selecting ranges.
" Requires 'textDocument/selectionRange' support from the language server.
nmap <silent> <c-q> <Plug>(coc-range-select)
xmap <silent> <c-q> <Plug>(coc-range-select)

" Add `:Format` command to format the current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold the current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OrganizeImports` command to organize imports of the current buffer.
command! -nargs=0 OrganizeImports :call CocAction('runCommand', 'editor.action.organizeImport')

" " Add (Neo)Vim's native statusline support.
" " NOTE: Please see `:h coc-status` for integrations with external plugins that
" " provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" " Mappings for CoCList
" Show all diagnostics.
" TODO: show diagnostics inline
nnoremap <silent><nowait> <leader>d :<c-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <leader><leader>x :<c-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <leader>c :<c-u>CocList commands<cr>

let g:coc_max_treeview_width = 50

" Show symbol outline for current document.
nnoremap <silent><nowait> <leader>o  :call ToggleOutline()<cr>
function! ToggleOutline() abort
  let winid = coc#window#find('cocViewId', 'OUTLINE')
  if winid == -1
    call CocActionAsync('showOutline', 1)
  else
    call coc#window#close(winid)
  endif
endfunction

" Automatically close outline when it's the last window
autocmd BufEnter * call CheckOutline()
function! CheckOutline() abort
  if &filetype ==# 'coctree' && winnr('$') == 1
    if tabpagenr('$') != 1
      close
    else
      bdelete
    endif
  endif
endfunction

" " Search workspace symbols.
" nnoremap <silent><nowait> <leader>s :<c-u>CocList -I symbols<cr>
" " Do default action for next item.
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<cr>
" " Do default action for previous item.
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<cr>
" " Resume latest coc list.
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<cr>

" ___

" To move to built-in LSP, need a replacement for
" - linters
" - formatters
" - data formats
" - snippets
" - go to type definition
" - refactor
" - selecting ranges
" - outline
" - function & class text objects

" Don't hide the cursor
let g:coc_disable_transparent_cursor = 1

" Refactoring.
nmap <leader>r <Plug>(coc-refactor)

imap <c-l> <Plug>(coc-snippets-expand)
let g:coc_snippet_next = '<c-j>'
let g:coc_snippet_prev = '<c-k>'

let g:coc_global_extensions = [
    \ 'coc-diagnostic',
    \ 'coc-eslint',
    \ 'coc-go',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-ltex',
    \ 'coc-lua',
    \ 'coc-prettier',
    \ 'coc-rust-analyzer',
    \ 'coc-solidity',
    \ 'coc-snippets',
    \ 'coc-sql',
    \ 'coc-tsserver',
    \ 'coc-yaml',
    \ ]
    " \ 'coc-fzf-preview',
    " \ 'coc-ltex',
    " \ 'coc-pyright',
    " \ 'coc-solargraph',
    " \ 'coc-tabnine',

" ___

" " Use <c-j> for select text for visual placeholder of snippet.
" vmap <c-j> <Plug>(coc-snippets-select)

" " Use <c-j> for both expand and jump (make expand higher priority.)
" imap <c-j> <Plug>(coc-snippets-expand-jump)

" " Use <leader>x for convert visual selected code to snippet
" xmap <leader>x <Plug>(coc-convert-snippet)

" " NeoVim-only mapping for visual mode scroll
" " Useful on signatureHelp after jump placeholder of snippet expansion
" if has('nvim')
"   vnoremap <nowait><expr> <c-f> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 1) : "\<c-f>"
"   vnoremap <nowait><expr> <c-b> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 1) : "\<c-b>"
" endif
