nnoremap <buffer> <leader>. :!node %<cr>
" vnoremap <buffer> <leader>. :!node<cr>
" nnoremap <buffer> <leader>m :!node %<cr>
nnoremap <buffer> <leader>ta :!yarn test<cr>

let b:ale_fixers = ['eslint', 'prettier']
