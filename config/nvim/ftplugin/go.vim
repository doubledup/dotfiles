" edit go with tabs at width 4
au BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4

nnoremap <LocalLeader>ec :tabnew ~/.config/nvim/ftplugin/go.vim<cr>
nnoremap <LocalLeader>er :so ~/.config/nvim/ftplugin/go.vim<cr>

nnoremap <Leader>x :GoRun<cr>
nnoremap <Leader>m :GoBuild<cr>
