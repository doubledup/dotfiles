let b:ale_fixers = ['elm-format']

nnoremap <Leader>m :! elm make src/Main.elm --output=public/elm.js<cr>
nnoremap <Leader>t :ElmTest<cr>
