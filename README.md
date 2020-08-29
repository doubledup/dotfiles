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
sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
```

### GNOME

```
# Display terminal tabs below:
gsettings set org.gnome.Terminal.Legacy.Settings tab-position bottom

# Show battery percentage in status bar:
gsettings set org.gnome.desktop.interface show-battery-percentage true

# On AC, never suspend; on battery, suspend after 15 minutes:
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 900
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'suspend'

# Disable mouse acceleration
gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'

# Keyboard shortcuts:

gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"

# switch windows
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Super>Tab']"

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"

gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>1']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>2']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>3']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>4']"

gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Alt><Super>f']"
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Alt><Super>h']"

# play/pause and skip forward & back
gsettings set org.gnome.settings-daemon.plugins.media-keys play "['<Shift><Super>p']"
gsettings set org.gnome.settings-daemon.plugins.media-keys next "['<Shift><Super>f']"
gsettings set org.gnome.settings-daemon.plugins.media-keys previous "['<Shift><Super>b']"

gsettings set org.gnome.settings-daemon.plugins.media-keys power "['<Shift><Alt><Super>asciitilde']"

# open appcenter
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Launch appcenter"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "io.elementary.appcenter"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Super>r"

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"

gsettings set ca.desrt.dconf-editor.Bookmarks:/ca/desrt/dconf-editor/ bookmarks "['/org/gnome/desktop/wm/keybindings/', '/org/gnome/settings-daemon/plugins/media-keys/']"
```

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

See [Troubleshooting](Troubleshooting.md) for solutions to issues solved before.
