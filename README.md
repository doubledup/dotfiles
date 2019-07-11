# dotfiles
Dotfiles, tracked with rcm (https://github.com/thoughtbot/rcm)

## Linux

### Firefox

To set up Firefox styling, make sure you have a `chrome` folder in your local
settings. NB: you'll need to fill in your profile name.

`mkdir ~/.mozilla/firefox/<profile name>/chrome`

Copy .userChrome.css to your profile's `chrome` folder:

`cp .userChrome.css ~/.mozilla/firefox/<profile name>/chrome/userChrome.css`


## MacOS
- Install [Homebrew](https://brew.sh/).
- Run `brew bundle install`.
- Run `git submodule init`.
- Run `rcup`

### Firefox

To set up Firefox styling, make sure you have a `chrome` folder in your local
settings. NB: you'll need to fill in your profile name.

`mkdir ~/Library/Application\ Support/Firefox/Profiles/<profile name>/chrome`

Copy .userChrome.css to your profile's `chrome` folder:

`cp .userChrome.css ~/Library/Application\ Support/Firefox/Profiles/<profile name>/chrome/userChrome.css`

### Locale errors

If you see errors like this:

`Warning: Failed to set locale category LC_NUMERIC to en_ZA.`

add the following line to `~/.zshrc.local` to set all locale categories to US
English:

`export LC_ALL=en_US.UTF-8`
