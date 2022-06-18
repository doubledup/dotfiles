nnoremap <leader>c :tabnew ~/.config/nvim/ftplugin/bash.vim<cr>
nnoremap <leader>cc :so ~/.config/nvim/ftplugin/bash.vim<cr>

nnoremap <leader>. :!bash %<cr>
vnoremap <leader>. :!bash -c '%'<cr>
