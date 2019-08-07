au BufNewFile,BufRead *.elm setlocal ts=4 sw=4 sts=4
let b:ale_fixers = ['elm-format']

nnoremap <LocalLeader>ec :tabnew ~/.config/nvim/ftplugin/elm.vim<cr>

nnoremap <LocalLeader>m :!elm make src/Main.elm --output=public/elm.js<cr>
nnoremap <LocalLeader>t :!elm-test<cr>
nnoremap <LocalLeader>tt :!elm-test %<cr>
