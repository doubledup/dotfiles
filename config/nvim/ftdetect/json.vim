augroup ft_jsonc_events
    autocmd!
    autocmd BufRead,BufNewFile coc-settings.json setlocal filetype=jsonc
    autocmd BufRead,BufNewFile tsconfig.json setlocal filetype=jsonc
augroup END
