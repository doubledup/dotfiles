# dotfiles

Configuration files managed with [rcm](https://github.com/thoughtbot/rcm).

For machine-local kitty, fish, zsh and neovim config, append '.local' to the
normal config name and save it in the same place, eg. use `~/.zshrc.local` for
zsh config you only want on your current machine.

## Linux

### rcm

Install [rcm](https://github.com/thoughtbot/rcm) and set up config with
`RCRC='./rcrc' rcup -t linux`.

### Disable Bluetooth on startup

Install [tlp](https://linrunner.de/tlp) and set the following config:

```
sudo -e /etc/tlp.conf
___
DEVICES_TO_DISABLE_ON_STARTUP="bluetooth wwan"
```

### Set default commands (Debian only)

To set a default command (eg. terminal emulator):

```
update-alternatives --display x-terminal-emulator
```

### GNOME

#### Terminal display tabs below

```
gsettings set org.gnome.Terminal.Legacy.Settings tab-position bottom
```

#### Inactivity

On AC, never suspend; on battery, suspend after 15 minutes:

```
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 900
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'suspend'
```

### feh

If using `feh` to set the background (eg. if using i3), set `$FEHBG_WALLPAPER`
in `~/.zshrc.local` or `~/.config/fish/config.fish.local`.

## MacOS

- Install [Homebrew](https://brew.sh/).
- Install packages and set up config:

```
brew bundle install
RCRC='./rcrc' rcup -t mac
```

### iTerm settings

- In iTerm2, open General -> Preferences and load config from
  ~/.dotfiles/iterm2.

### "Smart" quotes

Disable "smart" quotes:

```
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
```

## asdf

Use [asdf](https://asdf-vm.com) to set up languages.

## NeoVim

For NeoVim packages:
  - Install [vim-plug](https://github.com/junegunn/vim-plug).
  - Get the `pynvim` Python package: `python -m pip install pynvim`.

To add NeoVim packages to the current machine only, add them to
`~/.config/nvim/plugs.local.vim`. These are sourced at the end of the
plug#begin call in the NeoVim init file, so a plain
`Plug '<username>/<packagename>'` will work.

## ssh

Set up ssh keys:

Zsh:

```
ssh-keygen -t rsa -b 4096 -C "$(git config --global user.email)"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

Fish:

```
ssh-keygen -t rsa -b 4096 -C (git config --global user.email)
eval (ssh-agent -c)
ssh-add ~/.ssh/id_rsa
```

## Firefox

To set up custom Firefox styling, make sure you have a "chrome" folder in your
profile directory. Then copy userChrome.css to your profile's "chrome" folder:

Linux:

```
mkdir ~/.mozilla/firefox/<profile name>/chrome
cp userChrome.css ~/.mozilla/firefox/<profile name>/chrome/userChrome.css
```

MacOS:

```
mkdir ~/Library/Application\ Support/Firefox/Profiles/<profile name>/chrome
cp userChrome.css ~/Library/Application\ Support/Firefox/Profiles/<profile name>/chrome/userChrome.css
```

In the about:config page, set
toolkit.legacyUserProfileCustomizations.stylesheets to true.

## Troubleshooting

### Error when changing shells

If you get the error `chsh: PAM authentication failed` when changing shells,
make sure that the shell is marked as an allowed login shell in `/etc/shells`:
`echo "$(which zsh)" >> /etc/shells`.

### Homebrew

#### FZF autocomplete & bindings

`"$(brew --prefix)/opt/fzf/install"`

#### pyenv: zlib not found

Reinstall the python version using `brew`'s zlib:

`CPPFLAGS="-I$(brew --prefix zlib)/include" pyenv install -v <version>`

Note: you might want to store the currently installed packages from `pip freeze`
before reinstalling Python.

### MacOS Locale errors

If you see errors like this:

`Warning: Failed to set locale category LC_NUMERIC to en_ZA.`

add the following line to `~/.zshrc.local` to set all locale categories to US
English:

```
export LC_ALL=en_US.UTF-8
```
