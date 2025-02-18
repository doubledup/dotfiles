# dotfiles

Configuration files managed with [rcm](https://github.com/thoughtbot/rcm).

## Setup

```sh
git clone https://github.com/doubledup/dotfiles ~/.dotfiles
cd ~/.dotfiles
./rcignore/install
mksshkey
gh auth login --git-protocol ssh --hostname github.com
git remote set-url origin git@github.com:doubledup/dotfiles.git
```

For machine-local kitty, fish and neovim config, add '.local' before the file
extension and save it in the same place, eg. use
`~/.config/kitty/kitty.local.conf` for kitty config you only want on your
current machine, or `~/.config/fish/config.local.fish` for NeoVim config.

### GPG commit signing keys

After generating a GPG key, use it to sign commits by adding this to
`~/.config/fish/config.local.fish`:

```fish
set GIT_SIGNINGKEY <signingkey>
abbr gc 'git commit -v -S$GIT_SIGNINGKEY'
```

This avoids committing a key id as with the global gitconfig variable `user.signingkey`, but still
sets a default for all repositories that you can override, e.g. with `direnv`.

### Firefox

In the `about:config` page:

- To enable the custom stylesheet, set
  `toolkit.legacyUserProfileCustomizations.stylesheets` to true.
- To disable loading tabs on demand, set
  `browser.sessionstore.restore_on_demandbrowser.sessionstore.restore_on_demand`
  to true

## MacOS

Run `updateAll` to update everything, including the Brewfile.

Periodically list explicitly installed packages with `brew leaves` and uninstall unused ones.

To list installed packages not in the Brewfile:

```sh
brew bundle install --cleanup --file ~/.dotfiles/rcignore/Brewfile
```

To ensure only Brewfile packages are installed:

```sh
brew bundle install --cleanup --file ~/.dotfiles/rcignore/Brewfile
```

When pulling updates, first run `rcdn` to remove all known symlinks:

```sh
cd ~/.dotfiles && rcdn -t mac && git pull && RCRC=~/.dotfiles/rcrc rcup -t mac && cd -
```

Detect broken symlinks potentially left behind by incorrect use of rcm:

```sh
find ~ -type l ! -exec test -e {} \; -print | rg -v '/Library/' | rg -v '/.cache/'
```

Verify that the symlinks are unused (e.g. chroots and containers can appear to contain broken
symlinks) and remove them.

## Linux/Debian

<!-- TODO: try out https://github.com/rbreaves/kinto -->

### Set default terminal emulator

```sh
sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
```

### Docker

After installing Docker, add yourself to the docker group with
`sudo usermod -aG docker doubledup` and restart.

### GNOME Extensions

Always show Bluetooth icon in system menu: [Bluetooth quick
connect](https://extensions.gnome.org/extension/1401/bluetooth-quick-connect/)

Speed up shell animations: [Impatience](https://extensions.gnome.org/extension/277/impatience/)
Might be able to get away with setting `GNOME_SHELL_SLOWDOWN_FACTOR=0.5` in `/etc/environment`.
