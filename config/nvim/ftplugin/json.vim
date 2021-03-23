nnoremap <localleader>c :tabnew ~/.config/nvim/ftplugin/json.vim<cr>
nnoremap <localleader>cc :so ~/.config/nvim/ftplugin/json.vim<cr>

" setlocal syntax=javascript
" set syntax=javascript

" augroup json_syntax_ft
"   au!
"   autocmd BufNewFile,BufRead,BufReadPost *.json set syntax=javascript
" augroup END

" au BufNewFile,BufRead,BufReadPost *.json set syntax=javascript

" nnoremap <localleader>x :echo "found json"<cr>
nnoremap <localleader>n :set syntax=javascript<cr>
