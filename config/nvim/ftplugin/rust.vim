nnoremap <leader>,f :tabnew ~/.config/nvim/ftplugin/rust.vim<cr>
nnoremap <leader>,ff :so ~/.config/nvim/ftplugin/rust.vim<cr>

nnoremap <leader>. :!cd (dirname %) && cargo run<cr>
" vnoremap <leader>. :!cargo run<cr>
nnoremap <leader>m :!cargo build<cr>
nnoremap <leader>t :!cargo test<cr>
nnoremap <leader>tt :!cargo run test TEST=<c-r>%<cr>
nnoremap <leader>k :CocCommand rust-analyzer.openDocs<cr>
