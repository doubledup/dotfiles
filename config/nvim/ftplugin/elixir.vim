nnoremap <LocalLeader>ec :tabnew ~/.config/nvim/ftplugin/elixir.vim<cr>
nnoremap <LocalLeader>er :so ~/.config/nvim/ftplugin/elixir.vim<cr>

nnoremap <Leader>x :!elixir %<cr>
nnoremap <Leader>m :!mix escript.build<cr>
nnoremap <Leader>t :!mix test<cr>
nnoremap <Leader>tt :!mix test %<cr>
