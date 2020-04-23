au BufNewFile,BufRead *.elm setlocal ts=4 sw=4 sts=4

nnoremap <LocalLeader>ec :tabnew ~/.config/nvim/ftplugin/elm.vim<cr>
nnoremap <LocalLeader>er :so ~/.config/nvim/ftplugin/elm.vim<cr>

nnoremap <Leader>m :!elm make src/Main.elm --output=public/elm.js<cr>
nnoremap <Leader>t :!elm-test<cr>
nnoremap <Leader>tt :!elm-test %<cr>
