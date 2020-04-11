# dotfiles

Configuration files managed with [rcm](https://github.com/thoughtbot/rcm).

For machine-local zsh and neovim config, append '.local' to the normal config
name and save it in the same place, eg. use `~/.zshrc.local` for zsh config you
only want on your current machine.

## Linux

Run these commands:

```
RCRC='./rcrc' rcup -t linux
chsh -s /bin/zsh
```

### feh

If using `feh` to set the background (eg. if using i3), set `$FEHBG_WALLPAPER` in
`~/.zshrc.local`.

## MacOS

- Install [Homebrew](https://brew.sh/).
- Run these commands:

```
brew bundle install
RCRC='./rcrc' rcup -t mac
chsh -s /bin/zsh
```

- In iTerm2, open General -> Preferences and load config from ~/.dotfiles/iterm2.

### Homebrew

#### FZF autocomplete & bindings

`"$(brew --prefix)/opt/fzf/install"`

#### pyenv: zlib not found

Reinstall the python version using `brew`'s zlib:

`CPPFLAGS="-I$(brew --prefix zlib)/include" pyenv install -v <version>`

Note: you might want to store the currently installed packages from `pip freeze`
before reinstalling Python.

### "Smart" quotes

- Disable "smart" quotes:

`defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false`

### Locale errors

If you see errors like this:

`Warning: Failed to set locale category LC_NUMERIC to en_ZA.`

add the following line to `~/.zshrc.local` to set all locale categories to US
English:

`export LC_ALL=en_US.UTF-8`

## NeoVim

- For NeoVim packages:
  - Install [vim-plug](https://github.com/junegunn/vim-plug).
  - Install Python and get the `pynvim` package.

For local NeoVim packages, use `~/.config/nvim/plugs.local.vim`. These are sourced
at the end of the plug#begin call in the NeoVim init file.

## Languages

- Install any languages necessary, eg. Ruby with rbenv.

## SSH

Set up SSH keys:

```
ssh-keygen -t rsa -b 4096 -C "$(git config --global user.email)"
eval "$(ssh-agent -s)"
```

## Firefox

To set up Firefox styling, make sure you have a `chrome` folder in your profile
directory.

Linux: `mkdir ~/.mozilla/firefox/<profile name>/chrome`
MacOS: `mkdir ~/Library/Application\ Support/Firefox/Profiles/<profile name>/chrome`

Copy userChrome.css to your profile's `chrome` folder:

Linux: `cp userChrome.css ~/.mozilla/firefox/<profile name>/chrome/userChrome.css`
MacOS: `cp userChrome.css ~/Library/Application\ Support/Firefox/Profiles/<profile name>/chrome/userChrome.css`

## `chsh: PAM authentication failed` when changing shells

Mark zsh as an allowed login shell:

`echo "$(which zsh)" >> /etc/shells`
