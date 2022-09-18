nnoremap <buffer> <leader>m :!elm make src/Main.elm --output=public/elm.js<cr>
nnoremap <buffer> <leader>ta :!elm-test<cr>
nnoremap <buffer> <leader>t. :!elm-test %<cr>

let b:ale_fixers = [ 'elm-format' ]
