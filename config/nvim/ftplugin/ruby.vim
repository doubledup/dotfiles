let b:ale_fixers = ['rubocop']

nnoremap <Leader>x :!ruby %<cr>
vnoremap <Leader>x :!ruby<cr>

nnoremap <Leader>t :!bundle exec rake test TEST=<c-r>%<cr>
