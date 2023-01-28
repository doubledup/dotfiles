set hidden " don't unload buffers when leaving them
set nobackup nowritebackup " some servers have issues with backup files, see https://github.com/neoclide/coc.nvim/issues/649
set cmdheight=2 " give more space for displaying messages
set updatetime=300 " having longer updatetime (default is 4000ms) leads to noticeable delays
set shortmess+=c " don't pass messages to |ins-completion-menu|
set signcolumn=yes " always show the signcolumn, otherwise it would shifts the text each time diagnostics appear

hi CocMenuSel ctermbg=237 guibg=#13354A " Fix color of selected item in completion menu

let g:coc_node_path = '~/.asdf/shims/node'
let g:coc_disable_transparent_cursor = 1
let g:coc_max_treeview_width = 50

let g:coc_global_extensions = [
    \ 'coc-diagnostic',
    \ 'coc-eslint',
    \ 'coc-go',
    \ 'coc-html',
    \ 'coc-json',
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

" highlight the symbol and its references when holding the cursor
augroup highlight
  autocmd!
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

augroup coc
    autocmd!
    " setup formatexpr
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

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

" use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<cr>
function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('definitionHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

" format selected code
xmap = <Plug>(coc-format-selected)
" nmap = <Plug>(coc-format-selected)
nmap = <Plug>(coc-format)

imap <c-l> <Plug>(coc-snippets-expand)
let g:coc_snippet_next = '<c-j>'
let g:coc_snippet_prev = '<c-k>'

" use c-q for selecting ranges
" requires 'textDocument/selectionRange' support from the language server
nmap <silent> <c-q> <Plug>(coc-range-select)
xmap <silent> <c-q> <Plug>(coc-range-select)

" remap <C-e> and <C-y> to scroll floating windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  let scrollLength = 15
  nnoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? coc#float#scroll(1, scrollLength) : "\<C-e>"
  nnoremap <silent><nowait><expr> <C-y> coc#float#has_scroll() ? coc#float#scroll(0, scrollLength) : "\<C-y>"
  inoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1, scrollLength)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-y> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0, scrollLength)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? coc#float#scroll(1, scrollLength) : "\<C-e>"
  vnoremap <silent><nowait><expr> <C-y> coc#float#has_scroll() ? coc#float#scroll(0, scrollLength) : "\<C-y>"
endif

" map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" code & diagnostic navigation
" replace spell checker
nmap <silent> [s <Plug>(coc-diagnostic-prev)
nmap <silent> ]s <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>n <Plug>(coc-rename)
nmap <leader>r <Plug>(coc-refactor)

" apply codeAction to the current buffer
nmap <leader>a <Plug>(coc-codeaction)

" " mappings for CoCList
nnoremap <silent><nowait> <leader>e :<c-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <leader><leader>x :<c-u>CocList extensions<cr>
nnoremap <silent><nowait> <c-;> :<c-u>CocList commands<cr>

" show symbol outline for current document
nnoremap <silent><nowait> <leader>o  :call ToggleOutline()<cr>
function! ToggleOutline() abort
  let winid = coc#window#find('cocViewId', 'OUTLINE')
  if winid == -1
    call CocActionAsync('showOutline', 1)
  else
    call coc#window#close(winid)
  endif
endfunction

" automatically close outline when it's the last window
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

" add `:Format` command to format the current buffer
command! -nargs=0 Format :call CocAction('format')

" add `:Fold` command to fold the current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" add `:OrganizeImports` command to organize imports of the current buffer
command! -nargs=0 OrganizeImports :call CocAction('runCommand', 'editor.action.organizeImport')

" " apply codeAction to the selected region
" " example: `<leader>aap` for current paragraph
" xmap <leader>a <Plug>(coc-codeaction-selected)
" nmap <leader>a <Plug>(coc-codeaction-selected)

" " apply AutoFix to problem on the current line
" nmap <leader>x  <Plug>(coc-fix-current)
" " apply AutoFix to problem on the current line
" nmap <leader>f <Plug>(coc-fix-current)

" " run the Code Lens action on the current line
" nmap <leader>cl  <Plug>(coc-codelens-action)

" " add (Neo)Vim's native statusline support
" " NOTE: Please see `:h coc-status` for integrations with external plugins that
" " provide custom statusline: lightline.vim, vim-airline
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" " search workspace symbols
" nnoremap <silent><nowait> <leader>s :<c-u>CocList -I symbols<cr>
" " do default action for next item
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<cr>
" " do default action for previous item
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<cr>
" " resume latest coc list
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<cr>

" " use <c-j> for select text for visual placeholder of snippet
" vmap <c-j> <Plug>(coc-snippets-select)

" " use <c-j> for both expand and jump (make expand higher priority.)
" imap <c-j> <Plug>(coc-snippets-expand-jump)

" " use <leader>x for convert visual selected code to snippet
" xmap <leader>x <Plug>(coc-convert-snippet)

" " NeoVim-only mapping for visual mode scroll
" " useful on signatureHelp after jump placeholder of snippet expansion
" if has('nvim')
"   vnoremap <nowait><expr> <c-f> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 1) : "\<c-f>"
"   vnoremap <nowait><expr> <c-b> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 1) : "\<c-b>"
" endif
