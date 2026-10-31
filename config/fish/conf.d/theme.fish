# Catppuccin through the terminal's 16-colour palette rather than fish's bundled hex theme. kitty
# stores palette colours by index, so when it switches between catppuccin-latte and
# catppuccin-mocha, scrollback recolours too; 24-bit colours keep the theme they were printed in.
# Roles follow fish's catppuccin theme; Catppuccin accents outside the palette (peach, mauve,
# flamingo) map to the nearest palette colour.
if status is-interactive
    set -g fish_color_normal normal
    set -g fish_color_command blue
    set -g fish_color_param normal
    set -g fish_color_keyword magenta
    set -g fish_color_quote green
    set -g fish_color_redirection magenta
    set -g fish_color_end yellow
    set -g fish_color_comment brblack
    set -g fish_color_error red
    set -g fish_color_gray brblack
    set -g fish_color_selection --background=black
    set -g fish_color_search_match --background=black
    set -g fish_color_option green
    set -g fish_color_operator magenta
    set -g fish_color_escape cyan
    set -g fish_color_autosuggestion brblack
    set -g fish_color_cancel red
    set -g fish_color_cwd yellow
    set -g fish_color_user cyan
    set -g fish_color_host blue
    set -g fish_color_host_remote green
    set -g fish_color_status red
    set -g fish_pager_color_progress brblack
    set -g fish_pager_color_prefix magenta
    set -g fish_pager_color_completion normal
    set -g fish_pager_color_description brblack
end
