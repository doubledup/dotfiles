# Draws each tab as a separate bubble with rounded caps. Colors come from the
# active theme at draw time, so the caps follow the OS light/dark switch.
from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_title

LEFT_CAP = ""
RIGHT_CAP = ""


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    tab_fg, tab_bg = screen.cursor.fg, screen.cursor.bg
    bar_bg = as_rgb(int(draw_data.default_bg))

    screen.cursor.fg, screen.cursor.bg = tab_bg, bar_bg
    screen.draw(LEFT_CAP)
    screen.cursor.fg, screen.cursor.bg = tab_fg, tab_bg
    screen.draw(" ")
    # Caps and padding take 4 cells of the tab's budget, plus 1 for the gap
    # after every tab but the last. Kitty sizes each tab from a first pass
    # that measures this drawer, so the reservation must match what is drawn.
    title_budget = max(max_tab_length - 4 - (0 if is_last else 1), 1)
    title_start = screen.cursor.x
    draw_title(draw_data, screen, tab, index, title_budget)
    extra = screen.cursor.x - title_start - title_budget
    if extra > 0:
        screen.cursor.x -= extra + 1
        screen.draw("…")
    screen.draw(" ")
    screen.cursor.fg, screen.cursor.bg = tab_bg, bar_bg
    screen.draw(RIGHT_CAP)
    if not is_last:
        screen.draw(" ")
    return screen.cursor.x
