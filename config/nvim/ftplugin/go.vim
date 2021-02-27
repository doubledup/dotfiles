" edit go with tabs at width 4
setlocal noet ts=4 sw=4 sts=4

nnoremap <localleader>ec :tabnew ~/.config/nvim/ftplugin/go.vim<cr>
nnoremap <localleader>er :so ~/.config/nvim/ftplugin/go.vim<cr>

nnoremap <localleader>x :GoRun<cr>
nnoremap <localleader>m :GoBuild<cr>
