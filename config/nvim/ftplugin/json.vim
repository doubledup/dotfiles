" setlocal syntax=javascript
" set syntax=javascript

" augroup json_syntax_ft
"   au!
"   autocmd BufNewFile,BufRead,BufReadPost *.json set syntax=javascript
" augroup END

" au BufNewFile,BufRead,BufReadPost *.json set syntax=javascript

" nnoremap <Leader>x :echo "found json"<cr>
nnoremap <Leader>n :set syntax=javascript<cr>
