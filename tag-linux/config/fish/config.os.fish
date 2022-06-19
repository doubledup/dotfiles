#!/usr/bin/env fish

set fzf_key_bindings_file /usr/share/fish/vendor_functions.d/fzf_key_bindings.fish
if test -e $fzf_key_bindings_file
  source $fzf_key_bindings_file
  fzf_key_bindings
end
