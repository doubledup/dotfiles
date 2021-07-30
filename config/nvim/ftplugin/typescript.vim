nnoremap <localleader>c :tabnew ~/.config/nvim/ftplugin/typescript.vim<cr>
nnoremap <localleader>cc :so ~/.config/nvim/ftplugin/typescript.vim<cr>

nnoremap <localleader>x :!ts-node -r tsconfig-paths/register %<cr>
vnoremap <localleader>x :!bash -c 'ts-node --dir $(dirname %)'<cr>
nnoremap <localleader>m :!tsc %<cr>
nnoremap <localleader>t :!yarn test<cr>

let b:ale_fixers = ['eslint', 'prettier']

autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
