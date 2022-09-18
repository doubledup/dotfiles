" web search
nmap <c-/> :call setreg("s", &filetype)<cr>:!bash -c 'open "https://search.brave.com/search?q=<c-r>s+<c-r><c-w>&source=desktop"'<cr>
vmap <c-/> y:call setreg("s", &filetype)<cr>:!bash -c 'open "https://search.brave.com/search?q=<c-r>s+$(echo '" '<c-r>"' "'\| sed '" 's/ /+/g' "')&source=desktop"'<cr>
