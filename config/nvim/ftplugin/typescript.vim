nnoremap <LocalLeader>ec :tabnew ~/.config/nvim/ftplugin/typescript.vim<cr>
nnoremap <LocalLeader>er :so ~/.config/nvim/ftplugin/typescript.vim<cr>

nnoremap <Leader>x :!ts-node %<cr>
" vnoremap <Leader>x :!tsc<cr>
nnoremap <Leader>m :!tsc %<cr>
nnoremap <Leader>t :!yarn test<cr>

let b:ale_fixers = ['eslint', 'prettier']
