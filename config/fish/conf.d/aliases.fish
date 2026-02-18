abbr :q exit
abbr --position command - 'cd -'
abbr --position command cdtemp 'cd (mktemp -d)'

function multicd --description "Multi-level cd function for .. abbreviations"
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.\.+$' --function multicd

# bat
abbr bat! 'bat --pager "less $LESS -n" --style=default'

# claude
abbr c claude

# codex
abbr x codex

# homebrew
abbr b brew
abbr bb brew bundle
abbr ba brew bundle add
abbr br brew bundle remove
abbr bf brew info
abbr bs brew search
abbr bi brew install
abbr bu brew uninstall
# avoid conflicts with Bitwarden CLI
abbr bwh brew which-formula

# just (execute)
abbr e just

# kitty
alias icat='kitty +kitten icat --align=left'
abbr kssh 'kitty +kitten ssh'

# ls
alias ls='ls -Fh --color=auto'
alias sl='sl -Fa | lolcat'
abbr l ls
abbr la 'ls -al'
abbr ll 'ls -l'

# rust
abbr cg cargo
