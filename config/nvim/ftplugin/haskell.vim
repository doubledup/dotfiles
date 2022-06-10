nnoremap <leader>,f :tabnew ~/.config/nvim/ftplugin/haskell.vim<cr>
nnoremap <leader>,ff :so ~/.config/nvim/ftplugin/haskell.vim<cr>

nnoremap <leader>x :!stack runghc --cwd "$(dirname %)" "$(basename %)"<cr>
" vnoremap <leader>x :!haskell<cr>
nnoremap <leader>m :!stack build<cr>
" nnoremap <leader>t :!<cr>
" nnoremap <leader>tt :!<c-r>%<cr>
