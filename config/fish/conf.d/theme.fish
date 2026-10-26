# Tokyo Night, following the terminal's reported light/dark theme. fish sets
# fish_terminal_color_theme at the first prompt and on every change (DEC mode 2031),
# so the handler covers both. The palettes are upstream's own fish scripts, vendored
# verbatim into themes/ (`just tokyonight-vendor`) and sourced directly: they set only
# the roles upstream defines, so fish's defaults for cwd, status, and user stand.
# DELTA_FEATURES picks the matching delta variant from gitconfig.
if status is-interactive
    function __tokyonight_theme --on-variable fish_terminal_color_theme
        if test "$fish_terminal_color_theme" = light
            source $__fish_config_dir/themes/tokyonight_day.fish
            set -gx DELTA_FEATURES tokyonight-day
        else
            source $__fish_config_dir/themes/tokyonight_moon.fish
            set -gx DELTA_FEATURES tokyonight-moon
        end
    end
    __tokyonight_theme
end
