nnoremap <leader>,f :tabnew ~/.config/nvim/ftplugin/elm.vim<cr>
nnoremap <leader>,ff :so ~/.config/nvim/ftplugin/elm.vim<cr>

nnoremap <leader>m :!elm make src/Main.elm --output=public/elm.js<cr>
nnoremap <leader>t :!elm-test<cr>
nnoremap <leader>tt :!elm-test %<cr>

" edit elm with tabs at width 4
setlocal noet ts=4 sw=4 sts=4

au BufNewFile,BufRead *.elm setlocal ts=4 sw=4 sts=4

let b:ale_fixers = [ 'elm-format' ]
