# Catppuccin, following the terminal's reported light/dark theme (DEC mode 2031). fish ships the
# theme; it is colour-theme aware (Latte for light, Mocha for dark), so `choose` installs fish's
# own handler on fish_terminal_color_theme. The handler below only picks the matching delta
# feature from gitconfig through DELTA_FEATURES.
if status is-interactive
    fish_config theme choose catppuccin-mocha

    function __catppuccin_delta --on-variable fish_terminal_color_theme
        if test "$fish_terminal_color_theme" = light
            set -gx DELTA_FEATURES catppuccin-latte
        else
            set -gx DELTA_FEATURES catppuccin-mocha
        end
    end
    __catppuccin_delta
end
