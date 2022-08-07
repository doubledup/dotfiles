nnoremap <buffer> <leader>. :!ruby %<cr>
vnoremap <buffer> <leader>. :!ruby<cr>
nnoremap <buffer> <leader>m :!rake<cr>
nnoremap <buffer> <leader>t :!bundle exec rake test<cr>
nnoremap <buffer> <leader><leader>t :!bundle exec rake test TEST=<c-r>%<cr>
