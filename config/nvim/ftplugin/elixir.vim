nnoremap <localleader>ec :tabnew ~/.config/nvim/ftplugin/elixir.vim<cr>
nnoremap <localleader>er :so ~/.config/nvim/ftplugin/elixir.vim<cr>

nnoremap <localleader>x :!elixir %<cr>
nnoremap <localleader>m :!mix escript.build<cr>
nnoremap <localleader>t :!mix test<cr>
nnoremap <localleader>tt :!mix test %<cr>
