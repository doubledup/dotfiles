nnoremap <localleader>c :tabnew ~/.config/nvim/ftplugin/haskell.vim<cr>
nnoremap <localleader>cc :so ~/.config/nvim/ftplugin/haskell.vim<cr>

nnoremap <localleader>x :!stack runghc --cwd "$(dirname %)" "$(basename %)"<cr>
" vnoremap <localleader>x :!haskell<cr>
nnoremap <localleader>m :!stack build<cr>
" nnoremap <localleader>t :!<cr>
" nnoremap <localleader>tt :!<c-r>%<cr>
