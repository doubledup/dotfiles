# dotfiles
Configuration files managed with [rcm](https://github.com/thoughtbot/rcm).

For machine-local zsh and neovim config, append '.local' to the normal config
name and save it in the same place, eg. use `~/.zshrc.local` for zsh config you
only want on your current machine.

## Linux
- Run `git submodule init`.
- Run `rcup`

If using `feh` to set the background (eg. if using i3), set `$FEHBG_WALLPAPER` in
`~/.zshrc.local`.

## MacOS
- Install [Homebrew](https://brew.sh/).
- Run `brew bundle install`.
- Run `git submodule init`.
- Run `rcup`

## Firefox
To set up Firefox styling, make sure you have a `chrome` folder in your profile
directory.

Linux: `mkdir ~/.mozilla/firefox/<profile name>/chrome`
MacOS: `mkdir ~/Library/Application\ Support/Firefox/Profiles/<profile name>/chrome`

Copy .userChrome.css to your profile's `chrome` folder:

Linux: `cp .userChrome.css ~/.mozilla/firefox/<profile name>/chrome/userChrome.css`
MacOS: `cp .userChrome.css ~/Library/Application\ Support/Firefox/Profiles/<profile name>/chrome/userChrome.css`

### Locale errors
If you see errors like this:

`Warning: Failed to set locale category LC_NUMERIC to en_ZA.`

add the following line to `~/.zshrc.local` to set all locale categories to US
English:

`export LC_ALL=en_US.UTF-8`
