" edit go with tabs at width 4
au BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4

nnoremap <Leader>ob :GoBuild<cr>
nnoremap <Leader>od :GoDoc<cr>
nnoremap <Leader>of :GoFmt<cr>
nnoremap <Leader>or :GoRun<cr>
