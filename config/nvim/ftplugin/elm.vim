nnoremap <leader>,f :tabnew ~/.config/nvim/ftplugin/elm.vim<cr>
nnoremap <leader>,ff :so ~/.config/nvim/ftplugin/elm.vim<cr>

nnoremap <leader>m :!elm make src/Main.elm --output=public/elm.js<cr>
nnoremap <leader>t :!elm-test<cr>
nnoremap <leader>tt :!elm-test %<cr>

let b:ale_fixers = [ 'elm-format' ]
