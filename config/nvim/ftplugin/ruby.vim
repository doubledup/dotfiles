let b:ale_fixers = ['rubocop']

nnoremap <LocalLeader>ec :tabnew ~/.config/nvim/ftplugin/ruby.vim<cr>
nnoremap <LocalLeader>er :so ~/.config/nvim/ftplugin/ruby.vim<cr>

nnoremap <Leader>x :!ruby %<cr>
vnoremap <Leader>x :!ruby<cr>
nnoremap <Leader>m :!rake<cr>
nnoremap <Leader>t :!bundle exec rake test<cr>
nnoremap <Leader>tt :!bundle exec rake test TEST=<c-r>%<cr>
