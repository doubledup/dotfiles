nnoremap <LocalLeader>ec :tabnew ~/.config/nvim/ftplugin/typescript.vim<cr>
nnoremap <LocalLeader>er :so ~/.config/nvim/ftplugin/typescript.vim<cr>

nnoremap <Leader>x :!export TSFILE=% && tsc "$TSFILE" && node "${TSFILE\%.ts}.js"<cr>
" vnoremap <Leader>x :!tsc<cr>
nnoremap <Leader>m :!tsc %<cr>
nnoremap <Leader>t :!yarn test<cr>
