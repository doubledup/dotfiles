" web search
nmap <c-8> :call setreg("z", &filetype)<cr>:!bash -c 'open "https://search.brave.com/search?q=<c-r>z+<c-r><c-w>&source=desktop"'<cr>
vmap <c-8> y:call setreg("z", &filetype)<cr>:!bash -c 'open "https://search.brave.com/search?q=<c-r>z+$(echo '" '<c-r>"' "'\| sed '" 's/ /+/g' "')&source=desktop"'<cr>

" vmap <c-8> y:call Search(&filetype, <c-r>")<cr>

" function! Search(filetype, term) abort
"     let escaped_term = substitute(iconv(term, 'latin1', 'utf-8'),'[^A-Za-z0-9_.~-]','\="%".printf("%02X",char2nr(submatch(0)))','g')
"     let search_term = substitute(iconv(escaped_term, 'latin1', 'utf-8'),' ','+','g')
"     execute !bash -c 'open "https://search.brave.com/search?q='filetype'+'search_term'&source=desktop"'
" endfunction
