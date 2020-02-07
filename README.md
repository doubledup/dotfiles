# dotfiles
Configuration files managed with [rcm](https://github.com/thoughtbot/rcm).

For machine-local zsh and neovim config, append '.local' to the normal config
name and save it in the same place, eg. use `~/.zshrc.local` for zsh config you
only want on your current machine.
For local NeoVim plugs, use `~/.config/nvim/plugs.local.vim`. These are sourced
at the end of the plug#begin call in the NeoVim init file.

## Linux

To get up and running:

```
git submodule init
git submodule update
rcup
```

If using `feh` to set the background (eg. if using i3), set `$FEHBG_WALLPAPER` in
`~/.zshrc.local`.

### `chsh: PAM authentication failed` when changing shells, eg. to zsh

Mark Linuxbrew's zsh as an allowed login shell:

`echo "$(brew --prefix)"/bin/zsh >> /etc/shells`

### pyenv: zlib not found

Reinstall the python version using `brew`'s zlib:

`CPPFLAGS="-I$(brew --prefix zlib)/include" pyenv install -v <version>`

Note: you might want store the currently isntalled packages from `pip freeze`
before reinstalling Python.

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

## FZF autocomplete & bindings with brew

`"$(brew --prefix)/opt/fzf/install"`

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
