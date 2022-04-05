nnoremap <localleader>c :tabnew ~/.config/nvim/ftplugin/elm.vim<cr>
nnoremap <localleader>cc :so ~/.config/nvim/ftplugin/elm.vim<cr>

nnoremap <localleader>m :!elm make src/Main.elm --output=public/elm.js<cr>
nnoremap <localleader>t :!elm-test<cr>
nnoremap <localleader>tt :!elm-test %<cr>

" edit elm with tabs at width 4
setlocal noet ts=4 sw=4 sts=4

au BufNewFile,BufRead *.elm setlocal ts=4 sw=4 sts=4

let b:ale_fixers = [ 'elm-format' ]
