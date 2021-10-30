nnoremap <localleader>c :tabnew ~/.config/nvim/ftplugin/bash.vim<cr>
nnoremap <localleader>cc :so ~/.config/nvim/ftplugin/bash.vim<cr>

nnoremap <localleader>x :!bash %<cr>
vnoremap <localleader>x :!bash -c '%'<cr>
