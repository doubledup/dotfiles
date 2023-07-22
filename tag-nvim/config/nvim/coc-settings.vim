set nobackup nowritebackup " some servers have issues with backup files, see https://github.com/neoclide/coc.nvim/issues/649
set signcolumn=yes " always show the signcolumn, otherwise it would shifts the text each time diagnostics appear
set shortmess+=c " don't pass messages to |ins-completion-menu|

let g:coc_global_extensions = [
    \ 'coc-diagnostic',
    \ 'coc-eslint',
    \ 'coc-go',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-lua',
    \ 'coc-rust-analyzer',
    \ 'coc-sh',
    \ 'coc-solidity',
    \ 'coc-snippets',
    \ 'coc-sql',
    \ 'coc-tsserver',
    \ 'coc-yaml',
    \ ]
    " \ 'coc-fzf-preview',
    " \ 'coc-ltex',
    " \ 'coc-prettier',
    " \ 'coc-pyright',
    " \ 'coc-solargraph',

" let g:coc_node_path = '~/.asdf/shims/node'
" let g:coc_max_treeview_width = 50

" use <c-space> to trigger completion
" TODO: also trigger diagnostic popups
inoremap <silent><expr> <c-space> coc#refresh()

" use control-c to:
" exit autocomplete menu, if visible; or
" exit insert mode
" TODO: also cancel diagnostic popups
inoremap <silent><expr><c-c>
    \ coc#pum#visible() ? coc#pum#cancel() :
    \ "<esc>"

" use tab to:
" select current autocomplete item, if visible; or
" expand the snippet, if current word is a snippet; or
" increase indentation, if cursor is preceded by whitespace; or
" trigger the completion menu
inoremap <silent><expr> <tab>
    \ coc#pum#visible() ? coc#_select_confirm() :
    \ coc#expandableOrJumpable() ? "\<c-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<cr>" :
    \ <SID>SpaceBeforeCursor() ? "\<tab>" :
    \ coc#refresh()
let g:coc_snippet_next = '<tab>'

" use shift-tab to:
" select current autocomplete item, if visible; or
" backspace, if cursor is preceded by whitespace; or
" nothing
inoremap <expr><s-tab>
    \ coc#pum#visible() ? coc#_select_confirm() :
    \ <SID>SpaceBeforeCursor() ? "\<c-h>" :
    \ ""
let g:coc_snippet_prev = '<s-tab>'

function! s:SpaceBeforeCursor() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" force snippet expansion
imap <c-l> <Plug>(coc-snippets-expand)

" diagnostic navigation (replace spell checker)
nmap <silent> [s <Plug>(coc-diagnostic-prev)
nmap <silent> ]s <Plug>(coc-diagnostic-next)

" code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<cr>
function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('definitionHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

" highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')
" augroup highlight
"   autocmd!
"   autocmd CursorHold * silent call CocActionAsync('highlight')
" augroup END

" rename symbol
nmap <leader>an <Plug>(coc-rename)

" format selected code
" LSP support for formatting selections seems spotty at best
" xmap <leader>= <Plug>(coc-format-selected)
" nmap <leader>= <Plug>(coc-format-selected)
" format current buffer
nmap <leader>= <Plug>(coc-format)

augroup coc
    autocmd!
    " setup formatexpr for gq<motion>
    " autocmd FileType go,html,javascript,json,lua,rust,sh,solidity,sql,typescript,yaml setl formatexpr=CocAction('formatSelected')
    " show signature help on completion
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" apply code action to the current file
" nmap <leader>a <Plug>(coc-codeaction)
" apply code action to the current buffer
" nmap <leader>a <Plug>(coc-codeaction-source)
" apply codeAction to the selected region, eg. `<leader>aap` for current paragraph
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)
" apply code action to the cursor position
nmap <leader>a. <Plug>(coc-codeaction-cursor)

" apply AutoFix to problem on the current line
nmap <leader>ax <Plug>(coc-fix-current)

" refactor current symbol
nmap <silent> <leader>ar <Plug>(coc-refactor)
" refactor selection
" nmap <silent> <leader>r <Plug>(coc-refactor-selected)
" xmap <silent> <leader>r <Plug>(coc-refactor-selected)

" run code lens on current line
" nmap <leader>al <Plug>(coc-codelens-action)

" function and class text objects
" requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" scroll floating windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  let scrollLength = 10
  nnoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? coc#float#scroll(1, scrollLength) : scrollLength .. "\<C-e>"
  nnoremap <silent><nowait><expr> <C-y> coc#float#has_scroll() ? coc#float#scroll(0, scrollLength) : scrollLength .. "\<C-y>"
  inoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1, scrollLength)\<cr>" : scrollLength .. "\<Right>"
  inoremap <silent><nowait><expr> <C-y> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0, scrollLength)\<cr>" : scrollLength .. "\<Left>"
  vnoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? coc#float#scroll(1, scrollLength) : scrollLength .. "\<C-e>"
  vnoremap <silent><nowait><expr> <C-y> coc#float#has_scroll() ? coc#float#scroll(0, scrollLength) : scrollLength .. "\<C-y>"
endif

" use c-q for selecting ranges
" requires 'textDocument/selectionRange' support from the language server
nmap <silent> <c-q> <Plug>(coc-range-select)
xmap <silent> <c-q> <Plug>(coc-range-select)

" add `:Fold` command to fold the current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" add `:OrganizeImports` command to organize imports of the current buffer
" command! -nargs=0 OrganizeImports :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" mappings for CocList
" show diagnostics in current buffer
nnoremap <silent><nowait> <leader>e :<c-u>CocList diagnostics<cr>
" manage extensions
nnoremap <silent><nowait> <leader><leader>x :<c-u>CocList extensions<cr>
" search LSP commands
nnoremap <silent><nowait> <c-;> :<c-u>CocList commands<cr>
" search document outline
nnoremap <silent><nowait> <space>ao  :<C-u>CocList outline<cr>
" search workspace symbols
nnoremap <silent><nowait> <leader>ay :<c-u>CocList -I symbols<cr>
" do default action for next item
" nnoremap <silent><nowait> <space>aj  :<c-u>CocNext<cr>
" do default action for previous item
" nnoremap <silent><nowait> <space>ak  :<c-u>CocPrev<cr>
" resume latest coc list
" nnoremap <silent><nowait> <leader>ae :<C-u>CocListResume<cr>

" convert visual selection to snippet
xmap <leader>as <Plug>(coc-convert-snippet)

" show symbol outline for current document
nnoremap <silent><nowait> <leader>o :call ToggleOutline()<cr>
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
