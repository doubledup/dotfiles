nnoremap <leader>,f :tabnew ~/.config/nvim/ftplugin/typescript.vim<cr>
nnoremap <leader>,ff :so ~/.config/nvim/ftplugin/typescript.vim<cr>

nnoremap <leader>. :!ts-node -r tsconfig-paths/register %<cr>
vnoremap <leader>. :!bash -c 'ts-node --dir $(dirname %)'<cr>
nnoremap <leader>m :!tsc %<cr>
nnoremap <leader>t :!yarn test<cr>

autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
