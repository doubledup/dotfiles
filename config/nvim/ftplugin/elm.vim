nnoremap <localleader>c :tabnew ~/.config/nvim/ftplugin/elm.vim<cr>
nnoremap <localleader>cc :so ~/.config/nvim/ftplugin/elm.vim<cr>

nnoremap <localleader>m :!elm make src/Main.elm --output=public/elm.js<cr>
nnoremap <localleader>t :!elm-test<cr>
nnoremap <localleader>tt :!elm-test %<cr>

au BufNewFile,BufRead *.elm setlocal ts=4 sw=4 sts=4

let b:ale_fixers = [ 'elm-format' ]
