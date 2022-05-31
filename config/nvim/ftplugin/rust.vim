nnoremap <localleader>c :tabnew ~/.config/nvim/ftplugin/rust.vim<cr>
nnoremap <localleader>cc :so ~/.config/nvim/ftplugin/rust.vim<cr>

nnoremap <localleader>x :!cd (dirname %) && cargo run<cr>
" vnoremap <localleader>x :!cargo run<cr>
nnoremap <localleader>m :!cargo build<cr>
nnoremap <localleader>t :!cargo test<cr>
nnoremap <localleader>tt :!cargo run test TEST=<c-r>%<cr>
