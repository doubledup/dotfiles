nnoremap <leader>,f :tabnew ~/.config/nvim/ftplugin/javascript.vim<cr>
nnoremap <leader>,ff :so ~/.config/nvim/ftplugin/javascript.vim<cr>

nnoremap <leader>x :!node %<cr>
" vnoremap <leader>x :!node<cr>
" nnoremap <leader>m :!node %<cr>
nnoremap <leader>t :!yarn test<cr>

let b:ale_fixers = ['eslint', 'prettier']
