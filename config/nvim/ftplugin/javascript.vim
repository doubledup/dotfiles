nnoremap <localleader>c :tabnew ~/.config/nvim/ftplugin/javascript.vim<cr>
nnoremap <localleader>cc :so ~/.config/nvim/ftplugin/javascript.vim<cr>

nnoremap <localleader>x :!node %<cr>
" vnoremap <localleader>x :!node<cr>
" nnoremap <localleader>m :!node %<cr>
nnoremap <localleader>t :!yarn test<cr>

let b:ale_fixers = ['eslint', 'prettier']
