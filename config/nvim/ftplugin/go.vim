nnoremap <leader>,f :tabnew ~/.config/nvim/ftplugin/go.vim<cr>
nnoremap <leader>,ff :so ~/.config/nvim/ftplugin/go.vim<cr>

" edit go with tabs at width 4
setlocal noet ts=4 sts=4 sw=0

nnoremap <leader>x :GoRun<cr>
nnoremap <leader>m :GoBuild<cr>
