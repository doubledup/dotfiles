# dotfiles
Configuration files managed with [rcm](https://github.com/thoughtbot/rcm).

For machine-local zsh and neovim config, append '.local' to the normal config
name and save it in the same place, eg. use `~/.zshrc.local` for zsh config you
only want on your current machine.

## Linux
- Run `git submodule init`.
- Run `git submodule update`.
- Run `rcup`

If using `feh` to set the background (eg. if using i3), set `$FEHBG_WALLPAPER` in
`~/.zshrc.local`.

## MacOS
- Install [Homebrew](https://brew.sh/).
- Run these commands to get up and running:
```
$ brew bundle install
$ git submodule init
$ git submodule update
$ rcup
$ chsh -s /bin/zsh
```
- In iTerm2, open General -> Preferences and load config from ~/.iterm2.
- For Neovim packages:
  - Install [vim-plug](https://github.com/junegunn/vim-plug).
  - Install Python and get the `pynvim` package.
- Install any languages necessary, eg. Ruby with rbenv.
- Set up SSH keys for git:
```
ssh-keygen -t rsa -b 4096 -C "$(git config --global user.email)"
eval "$(ssh-agent -s)"
```

### Bonus points
- Disable "smart" quotes: `defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false`

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
