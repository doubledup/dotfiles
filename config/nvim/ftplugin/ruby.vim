nnoremap <localleader>c :tabnew ~/.config/nvim/ftplugin/ruby.vim<cr>
nnoremap <localleader>cc :so ~/.config/nvim/ftplugin/ruby.vim<cr>

nnoremap <localleader>x :!ruby %<cr>
vnoremap <localleader>x :!ruby<cr>
nnoremap <localleader>m :!rake<cr>
nnoremap <localleader>t :!bundle exec rake test<cr>
nnoremap <localleader>tt :!bundle exec rake test TEST=<c-r>%<cr>

let b:ale_fixers = [ 'rubocop' ]
