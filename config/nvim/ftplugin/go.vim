" edit go with tabs at width 4
au BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4

nnoremap <Leader>x :GoRun<cr>
nnoremap <Leader>m :GoBuild<cr>
