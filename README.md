# dotfiles

Configuration files managed with [rcm](https://github.com/thoughtbot/rcm).

## Setup

Install and set up config:

```sh
git clone https://github.com/doubledup/dotfiles ~/.dotfiles
cd ~/.dotfiles
./rcignore/setup.sh
```

Create an ssh key for the machine, add it to Github and switch the repo to ssh:

```sh
mksshkey
gh auth login --git-protocol ssh --hostname github.com
git remote set-url origin git@github.com:doubledup/dotfiles.git
```

For machine-local kitty or fish config, add '.local' before the file extension and save it in the
same place. eg. use `~/.config/kitty/kitty.local.conf` for kitty config you only want on your
current machine, or `~/.config/fish/config.local.fish` for fish shell config.

Machine-local nvim config lives in `~/.config/nvim/lua/config/local.lua`

### GPG commit signing keys

After generating a GPG key, use it to sign commits by adding this to
`~/.config/fish/config.local.fish`:

```fish
set GIT_SIGNINGKEY <signingkey>
abbr gc 'git commit -v -S$GIT_SIGNINGKEY'
```

This avoids committing a key id in the global gitconfig variable `user.signingkey`, but still sets a
default for all repositories that you can override, e.g. with `direnv`.

### Firefox

To enable the custom stylesheet, go to the `about:config` page and set
`toolkit.legacyUserProfileCustomizations.stylesheets` to true. To also remove the remaining
sidebar UI, set `sidebar.revamp` to false.

## MacOS

Run `updateAll` to update everything.

MacOS packages are managed with a global `Brewfile`. This replaces imperative commands like `brew
install` with 2 steps: update the `Brewfile`, then ensure that exactly the packages in the
`Brewfile` are installed.

To edit the global `Brewfile`:

- Add a package:

```sh
brew bundle --global add package
```

- Remove unused packages:

```sh
brew bundle --global remove package
```

Then ensure all Brewfile packages, and only those packages, are installed:

```sh
brew bundle --global --cleanup
```

List explicitly installed packages with `brew leaves` or review the `Brewfile`.

### Updates with rcm

When pulling updates, run `rcdn` to remove all known symlinks, then pull updates, then run `rcup`:

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

<!-- TODO: https://github.com/rbreaves/kinto -->

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
