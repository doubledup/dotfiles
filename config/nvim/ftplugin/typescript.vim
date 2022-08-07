nnoremap <buffer> <leader>. :!ts-node -r tsconfig-paths/register %<cr>
vnoremap <buffer> <leader>. :!bash -c 'ts-node --dir $(dirname %)'<cr>
nnoremap <buffer> <leader>m :!tsc %<cr>
nnoremap <buffer> <leader>t :!yarn test<cr>

autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
