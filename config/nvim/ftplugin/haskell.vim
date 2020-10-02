nnoremap <LocalLeader>ec :tabnew ~/.config/nvim/ftplugin/haskell.vim<cr>
nnoremap <LocalLeader>er :so ~/.config/nvim/ftplugin/haskell.vim<cr>


nnoremap <Leader>x :!stack runghc --cwd "$(dirname %)" "$(basename %)"<cr>
" vnoremap <Leader>x :!haskell<cr>
nnoremap <Leader>m :!stack build<cr>
" nnoremap <Leader>t :!<cr>
" nnoremap <Leader>tt :!<c-r>%<cr>
