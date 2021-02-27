au BufNewFile,BufRead *.elm setlocal ts=4 sw=4 sts=4

nnoremap <localleader>ec :tabnew ~/.config/nvim/ftplugin/elm.vim<cr>
nnoremap <localleader>er :so ~/.config/nvim/ftplugin/elm.vim<cr>

nnoremap <localleader>m :!elm make src/Main.elm --output=public/elm.js<cr>
nnoremap <localleader>t :!elm-test<cr>
nnoremap <localleader>tt :!elm-test %<cr>

let b:ale_fixers = [ 'elm-format' ]
