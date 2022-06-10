nnoremap <leader>,f :tabnew ~/.config/nvim/ftplugin/rust.vim<cr>
nnoremap <leader>,ff :so ~/.config/nvim/ftplugin/rust.vim<cr>

" edit rust with tabs at width 4
setlocal noet ts=4 sts=0 sw=4

nnoremap <leader>. :!cd (dirname %) && cargo run<cr>
" vnoremap <leader>x :!cargo run<cr>
nnoremap <leader>m :!cargo build<cr>
nnoremap <leader>t :!cargo test<cr>
nnoremap <leader>tt :!cargo run test TEST=<c-r>%<cr>
nnoremap <leader>k :CocCommand rust-analyzer.openDocs<cr>
