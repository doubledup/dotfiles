# Format all known file types
format:
    stylua .
    find . -name '*.fish' -exec fish_indent --write {} +
    shfmt --write $(find . -name '*.sh')
    prettier --write '**/*.json' '**/*.md'
