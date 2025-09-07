bind \ea 'echo; ls -al; echo; commandline -f repaint'

# Pass previous args to a different command
bind \ek 'commandline -f history-search-backward beginning-of-line kill-word'
# TODO: pass previous last arg to different command
# bind \ek 'commandline -f history-search-backward end-of-line backward-bigword clear-commandline insert space yank beginning-of-line'

bind \eh 'MANWIDTH=(math $COLUMNS - 13) MANPAGER=\'bat --wrap never\' __fish_man_page'
bind \eP btm

function prevd_with_prompt
    prevd
    echo
    commandline -f repaint
end
function nextd_with_prompt
    nextd
    echo
    commandline -f repaint
end
bind alt-\[ prevd_with_prompt
bind alt-\] nextd_with_prompt

function cd_prev --description "Go to previous directory (and repaint)"
    cd -
    echo
    commandline -f repaint
end
bind \e- cd_prev

function fishrc --description "Edit Fish shell config"
    if not test -d ~/.dotfiles
        echo "Dotfiles directory not found"
        return 1
    end
    cd ~/.dotfiles || return 1
    $EDITOR config/fish/config.fish
    cd - >/dev/null
    echo
    commandline -f repaint
end
bind \e, fishrc

function nvimrc --description "Edit NeoVim config"
    if not test -d ~/.dotfiles
        echo "Dotfiles directory not found"
        return 1
    end
    cd ~/.dotfiles || return 1
    $EDITOR config/nvim/init.lua
    cd - >/dev/null
    echo
    commandline -f repaint
end
bind \ev nvimrc

function launch_editor --description "Launch editor on current command"
    commandline -i " $EDITOR "
    commandline -f backward-kill-word beginning-of-line yank execute
end
bind \co launch_editor
