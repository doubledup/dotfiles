# dotfiles

Configuration files managed with [rcm](https://github.com/thoughtbot/rcm).

## Usage

For Linux:

```sh
git clone https://github.com/doubledup/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install
```

For Mac:

```sh
git clone https://github.com/doubledup/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install
```

For machine-local kitty, fish and neovim config, add '.local' before the file
extension and save it in the same place, eg. use
`~/.config/kitty/kitty.local.conf` for kitty config you only want on your current
machine, or `~/.config/fish/config.local.fish` for NeoVim config.

## Linux/Debian

<!-- TODO: move this to the install script -->
<!-- TODO: try out https://github.com/rbreaves/kinto -->
<!-- TODO: use treesitter for all syntax highlighting -->

### packages

Install packages and set up config:

```sh
./packages/apt-deps
./packages/apt
RCRC="$HOME/.dotfiles/rcrc" rcup -t linux
```

### Disable Bluetooth on startup

Install [tlp](https://linrunner.de/tlp). Then set `DEVICES_TO_DISABLE_ON_STARTUP`:

```sh
echo 'DEVICES_TO_DISABLE_ON_STARTUP="bluetooth wwan"' | sudo tee -a /etc/tlp.conf >/dev/null
```

### Set default commands (eg. terminal emulator)

```sh
sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
```

### GNOME

Run `./gnome_settings` to restore GNOME desktop settings.

#### Extensions

Always show Bluetooth icon in system menu:
[Bluetooth quick connect](https://extensions.gnome.org/extension/1401/bluetooth-quick-connect/)

Speed up shell animations:
[Impatience](https://extensions.gnome.org/extension/277/impatience/)

### Docker

After installing Docker, add yourself to the docker group with
`sudo usermod -aG docker doubledup` and restart.

## MacOS

### Remove packages not in Brewfile

```sh
brew bundle cleanup --force --file packages/Brewfile
```

## Firefox

To enable the custom stylesheet, open the about:config page and set
`toolkit.legacyUserProfileCustomizations.stylesheets` to true.
