nnoremap <leader>,f :tabnew ~/.config/nvim/ftplugin/elixir.vim<cr>
nnoremap <leader>,ff :so ~/.config/nvim/ftplugin/elixir.vim<cr>

nnoremap <leader>. :!elixir %<cr>
" nnoremap <leader>m :!mix escript.build<cr>
nnoremap <leader>m :!mix compile<cr>
nnoremap <leader>t :!mix test<cr>
nnoremap <leader>tt :!mix test %<cr>
