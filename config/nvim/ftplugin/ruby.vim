nnoremap <leader>,f :tabnew ~/.config/nvim/ftplugin/ruby.vim<cr>
nnoremap <leader>,ff :so ~/.config/nvim/ftplugin/ruby.vim<cr>

nnoremap <leader>. :!ruby %<cr>
vnoremap <leader>. :!ruby<cr>
nnoremap <leader>m :!rake<cr>
nnoremap <leader>t :!bundle exec rake test<cr>
nnoremap <leader>tt :!bundle exec rake test TEST=<c-r>%<cr>
