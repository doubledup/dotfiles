# dotfiles

Configuration files managed with [rcm](https://github.com/thoughtbot/rcm).

For machine-local kitty, fish, zsh and neovim config, append '.local' to the
normal config name and save it in the same place, eg. use `~/.zshrc.local` for
zsh config you only want on your current machine.

## Linux

### rcm

Install [rcm](https://github.com/thoughtbot/rcm) and set up config with
`RCRC='./rcrc' rcup -t linux`.

### packages

Install packages from [packages.txt](packages.txt):

```
rg -vN '^\s*#' packages.txt | tr "\n" " " | xargs sudo apt install
```

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
sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
```

### Set hostname

### GNOME

Execute `gnome_settings` to restore GNOME desktop settings.

#### Extensions

Always show Bluetooth icon in system menu:
[Bluetooth quick connect](https://extensions.gnome.org/extension/1401/bluetooth-quick-connect/)

Speed up shell animations:
[Impatience](https://extensions.gnome.org/extension/277/impatience/)

### Pop!_OS

Set power profile: `system76-power profile battery`

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

Before installing Python, see
[Prerequisites](https://github.com/pyenv/pyenv/wiki/Common-build-problems#prerequisites).

## NeoVim

For NeoVim packages:

- Install [vim-plug](https://github.com/junegunn/vim-plug).
- Get the `pynvim` Python package: `python -m pip install pynvim`.

To add NeoVim packages to the current machine only, add them to
`~/.config/nvim/plugs.local.vim`. vim-plug sources these at the end of the
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

See [Troubleshooting](Troubleshooting.md) for solutions to issues solved before.
