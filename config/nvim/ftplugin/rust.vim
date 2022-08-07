nnoremap <buffer> <leader>. :!cd "$(dirname %)" && cargo run<cr>
" vnoremap <leader>. :!cargo run<cr>
nnoremap <buffer> <leader>m :!cargo build<cr>
nnoremap <buffer> <leader>t :!cargo test<cr>
nnoremap <buffer> <leader><leader>t :!cargo run test TEST=<c-r>%<cr>
nnoremap <buffer> <leader>K :CocCommand rust-analyzer.openDocs<cr>
