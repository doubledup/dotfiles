nnoremap <buffer> <leader>. :!stack runghc --cwd "$(dirname %)" "$(basename %)"<cr>
" vnoremap <buffer> <leader>. :!haskell<cr>
nnoremap <buffer> <leader>m :!stack build<cr>
" nnoremap <buffer> <leader>t :!<cr>
" nnoremap <buffer> <leader><leader>t :!<c-r>%<cr>
