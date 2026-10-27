# Catppuccin, following the terminal's reported light/dark theme (DEC mode 2031). fish ships the
# theme; it is colour-theme aware (Latte for light, Mocha for dark), so `choose` installs fish's
# own handler on fish_terminal_color_theme. A fish without the bundled theme keeps its defaults
# rather than erroring at every start.
if status is-interactive
    if fish_config theme list | string match -q catppuccin-mocha
        fish_config theme choose catppuccin-mocha
    end
end
