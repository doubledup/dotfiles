#!/usr/bin/env fish

function fish_title --description "Set terminal window title"
    set -q argv[1]; or set argv fish
    set command_name (string split ' ' $argv[1])[1]
    echo $command_name:(prompt_pwd | xargs basename)
end