au BufNewFile,BufRead *.elm setlocal ts=4 sw=4 sts=4
let b:ale_fixers = ['elm-format']

nnoremap <Leader>m :!elm make src/Main.elm --output=public/elm.js<cr>
nnoremap <Leader>t :!elm-test<cr>
nnoremap <Leader>tt :!elm-test %<cr>
