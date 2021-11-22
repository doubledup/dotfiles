nnoremap <localleader>c :tabnew ~/.config/nvim/ftplugin/elixir.vim<cr>
nnoremap <localleader>cc :so ~/.config/nvim/ftplugin/elixir.vim<cr>

nnoremap <localleader>x :!elixir %<cr>
" nnoremap <localleader>m :!mix escript.build<cr>
nnoremap <localleader>m :!mix compile<cr>
nnoremap <localleader>t :!mix test<cr>
nnoremap <localleader>tt :!mix test %<cr>
