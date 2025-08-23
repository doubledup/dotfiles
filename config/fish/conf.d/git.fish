#!/usr/bin/env fish

abbr g git
abbr gst 'git status'
abbr gf 'git fetch'
abbr gz 'git stash'
abbr gp 'git pull'
abbr gu 'git push'
abbr gd 'git diff'
abbr gco 'git checkout'
abbr gc 'git commit -v'
abbr gb 'git branch'
abbr gl 'git log --oneline --decorate --graph'
abbr glp 'git log --patch --decorate --graph'
# avoid conflict with git-spice
abbr gsh 'git show'
abbr gsp 'git show --patch'
abbr ga 'git add'
abbr gr 'git reset'
abbr grb 'git rebase'
abbr gm 'git merge'
abbr gcp 'git cherry-pick'

function glog --description "Interactive git log browser"
    git log --oneline --decorate --graph --color=always | fzf --ansi --preview 'git show --color=always {1}'
end

function gcof --description "Fuzzy git checkout"
    git branch -a | fzf | sed 's/^..//' | awk '{print $1}' | sed 's/remotes\/origin\///' | xargs git checkout
end

function gstf --description "Fuzzy git status - stage files interactively"
    git status --porcelain | fzf -m --preview 'git diff --color=always {2}' | awk '{print $2}' | xargs git add
end

bind \cs 'echo; git status; echo; commandline -f repaint'
bind \cg 'git diff'
