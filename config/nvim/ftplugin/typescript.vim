nnoremap <localleader>ec :tabnew ~/.config/nvim/ftplugin/typescript.vim<cr>
nnoremap <localleader>er :so ~/.config/nvim/ftplugin/typescript.vim<cr>

nnoremap <localleader>x :!ts-node --script-mode %<cr>
vnoremap <localleader>x :!ts-node --dir $(dirname %)<cr>
nnoremap <localleader>m :!tsc %<cr>
nnoremap <localleader>t :!yarn test<cr>

let b:ale_fixers = ['eslint', 'prettier']

autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
