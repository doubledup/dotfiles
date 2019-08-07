let b:ale_fixers = ['rubocop']

nnoremap <LocalLeader>ec :tabnew ~/.config/nvim/ftplugin/ruby.vim<cr>

nnoremap <LocalLeader>x :!ruby %<cr>
vnoremap <LocalLeader>x :!ruby<cr>

nnoremap <LocalLeader>t :!bundle exec rake test TEST=<c-r>%<cr>
