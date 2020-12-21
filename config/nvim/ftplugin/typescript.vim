nnoremap <LocalLeader>ec :tabnew ~/.config/nvim/ftplugin/typescript.vim<cr>
nnoremap <LocalLeader>er :so ~/.config/nvim/ftplugin/typescript.vim<cr>

nnoremap <Leader>x :!ts-node --script-mode %<cr>
vnoremap <Leader>x :!ts-node --dir $(dirname %)<cr>
nnoremap <Leader>m :!tsc %<cr>
nnoremap <Leader>t :!yarn test<cr>

let b:ale_fixers = ['eslint', 'prettier']

autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
