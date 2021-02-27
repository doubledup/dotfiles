nnoremap <localleader>ec :tabnew ~/.config/nvim/ftplugin/haskell.vim<cr>
nnoremap <localleader>er :so ~/.config/nvim/ftplugin/haskell.vim<cr>


nnoremap <localleader>x :!stack runghc --cwd "$(dirname %)" "$(basename %)"<cr>
" vnoremap <localleader>x :!haskell<cr>
nnoremap <localleader>m :!stack build<cr>
" nnoremap <localleader>t :!<cr>
" nnoremap <localleader>tt :!<c-r>%<cr>
