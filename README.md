# dotfiles

Configuration files managed with [rcm](https://github.com/thoughtbot/rcm).

## Setup

<!-- TODO: KMonad -->

```sh
git clone https://github.com/doubledup/dotfiles ~/.dotfiles
cd ~/.dotfiles
./rcignore/install
updateAll
```

[`mksshkey`](local/bin/mksshkey) will create an ssh key. To add it to Github,
login via the CLI with `gh auth login --git-protocol ssh -h github.com`.

For machine-local kitty, fish and neovim config, add '.local' before the file
extension and save it in the same place, eg. use
`~/.config/kitty/kitty.local.conf` for kitty config you only want on your
current machine, or `~/.config/fish/config.local.fish` for NeoVim config.

### Firefox

In the `about:config` page:

- To enable the custom stylesheet, set
  `toolkit.legacyUserProfileCustomizations.stylesheets` to true.
- To disable loading tabs on demand, set
  `browser.sessionstore.restore_on_demandbrowser.sessionstore.restore_on_demand`
  to true

## MacOS

Ensure only Brewfile packages are installed:

```sh
brew bundle install --cleanup --file ~/.dotfiles/rcignore/Brewfile
```

### Update Brewfile

Prune explicitly installed packages, listed with:

```sh
brew leaves
```

Overwrite the Brewfile:

```sh
brew bundle dump --file=~/.dotfiles/rcignore/Brewfile --force --brews --taps --casks --mas
```

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
