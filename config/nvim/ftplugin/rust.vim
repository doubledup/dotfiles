nnoremap <buffer> <leader>. :!cd "$(dirname %)" && cargo run<cr>
nnoremap <buffer> <leader>m :!cargo build<cr>
nnoremap <buffer> <leader>ta :!cargo test<cr>
nnoremap <buffer> <leader>t. :!cargo run test TEST=<c-r>%<cr>
