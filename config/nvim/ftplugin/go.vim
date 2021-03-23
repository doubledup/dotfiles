nnoremap <localleader>c :tabnew ~/.config/nvim/ftplugin/go.vim<cr>
nnoremap <localleader>cc :so ~/.config/nvim/ftplugin/go.vim<cr>

" edit go with tabs at width 4
setlocal noet ts=4 sw=4 sts=4

nnoremap <localleader>x :GoRun<cr>
nnoremap <localleader>m :GoBuild<cr>
