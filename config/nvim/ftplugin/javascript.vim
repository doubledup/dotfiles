nnoremap <leader>,f :tabnew ~/.config/nvim/ftplugin/javascript.vim<cr>
nnoremap <leader>,ff :so ~/.config/nvim/ftplugin/javascript.vim<cr>

nnoremap <leader>. :!node %<cr>
" vnoremap <leader>. :!node<cr>
" nnoremap <leader>m :!node %<cr>
nnoremap <leader>t :!yarn test<cr>

let b:ale_fixers = ['eslint', 'prettier']
