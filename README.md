# dotfiles

Configuration files managed with [rcm](https://github.com/thoughtbot/rcm).

For machine-local kitty, fish, zsh and neovim config, add '.local' to the
normal config name and save it in the same place, eg. use `~/.zshrc.local` for
zsh config you only want on your current machine, or
`~/.config/nvim/init.local.vim` for NeoVim config.

## Linux/Debian

<!-- TODO: try out https://github.com/rbreaves/kinto -->
<!-- TODO: use treesitter for all syntax highlighting -->

### packages

Install packages from [packages/apt](packages/apt):

```sh
./packages/apt
```

### rcm

Bring up config

```sh
RCRC='./rcrc' rcup -t linux
```

### Building software

Some handy packages when compiling things:

```sh
./packages/apt-deps
```

### Disable Bluetooth on startup

Install [tlp](https://linrunner.de/tlp) and add `DEVICES_TO_DISABLE_ON_STARTUP="bluetooth wwan"` on a new line

```sh
sudo -e /etc/tlp.conf
```

### Set default commands

To set a default command (eg. terminal emulator):

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

## MacOS

- Install [Homebrew](https://brew.sh/).
- Install packages and set up config:

```sh
brew bundle install --file packages/Brewfile
RCRC='./rcrc' rcup -t mac
```

### Rosetta

```sh
sudo softwareupdate --install-rosetta
```

With x86 Homebrew installed as `ibrew`, install using the x86 brewfile:

```sh
brew bundle install --file packages/Brewfile-x86
```

### Xcode CLI

```sh
xcode-select --install
```

### Remove packages not in Brewfile

```sh
brew bundle cleanup --force --file packages/Brewfile
```

### iTerm settings

- In iTerm2, open General -> Preferences and load config from
  ~/.dotfiles/iterm2.

### "Smart" quotes

Disable "smart" quotes:

```sh
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
```

## asdf

Use [asdf](https://asdf-vm.com) to set up languages.

Before installing Python, see
[Prerequisites](https://github.com/pyenv/pyenv/wiki/Common-build-problems#prerequisites).

If installing NodeJS, be sure to run `npm config set ignore-scripts true`.

## NeoVim

To add NeoVim packages to the current machine only, add them to
`~/.config/nvim/plugs.local.vim`. vim-plug sources these at the end of the
plug#begin call in the NeoVim init file, so a plain
`Plug '<username>/<packagename>'` will work.

### vim-plug for NeoVim

```sh
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

Install NodeJs for CoC.

## ssh

Set up ssh keys:

Zsh:

```sh
ssh-keygen -t rsa -b 4096 -C "$(git config --global user.email)"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

Fish:

```sh
ssh-keygen -t ed25519 -C (git config --global user.email)
eval (ssh-agent -c)
ssh-add -K ~/.ssh/id_ed25519
gh auth login # possibly also gh ssh-key add
```

## Firefox

To set up custom Firefox styling, make sure you have a "chrome" folder in your
profile directory. Then copy userChrome.css to your profile's "chrome" folder:

Linux:

```sh
mkdir ~/.mozilla/firefox/<profile name>/chrome
cp userChrome.css ~/.mozilla/firefox/<profile name>/chrome/userChrome.css
```

MacOS:

```sh
mkdir ~/Library/Application\ Support/Firefox/Profiles/<profile name>/chrome
cp userChrome.css ~/Library/Application\ Support/Firefox/Profiles/<profile name>/chrome/userChrome.css
```

In the about:config page, set
toolkit.legacyUserProfileCustomizations.stylesheets to true.

See [Troubleshooting](Troubleshooting.md) for solutions to issues solved before.

## Docker

After installing Docker, add yourself to the docker group with
`sudo usermod -aG docker doubledup` and restart.
