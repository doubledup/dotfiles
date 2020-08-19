# dotfiles

Configuration files managed with [rcm](https://github.com/thoughtbot/rcm).

For machine-local fish, zsh and neovim config, append '.local' to the normal
config name and save it in the same place, eg. use `~/.zshrc.local` for zsh
config you only want on your current machine.

## Linux

### rcm

Install [rcm](https://github.com/thoughtbot/rcm) and run `RCRC='./rcrc' rcup
-t linux`.

### pyenv

Install `pyenv`, with
[pyenv-installer](https://github.com/pyenv/pyenv-installer) if necessary.

### Disable Bluetooth on startup

Install TLP and set the following config:

```
$ sudo -e /etc/tlp.conf
DEVICES_TO_DISABLE_ON_STARTUP="bluetooth wwan"
```

Neither of the following worked:

```
$ sudo -e /etc/bluetooth/main.conf
AutoEnable=false
```

```
$ sudo -e /etc/rc.local
rfkill block bluetooth
exit 0
```

### Set default commands (Debian only)

To set a default command (eg. terminal emulator):

```
$ update-alternatives --display x-terminal-emulator
```

### GNOME

#### Terminal display tabs below

```
$ gsettings set org.gnome.Terminal.Legacy.Settings tab-position bottom
```

#### Inactivity

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
- Run these commands:

```
$ brew bundle install
$ RCRC='./rcrc' rcup -t mac
```

- In iTerm2, open General -> Preferences and load config from
  ~/.dotfiles/iterm2.

### Homebrew

#### FZF autocomplete & bindings

`"$(brew --prefix)/opt/fzf/install"`

#### pyenv: zlib not found

Reinstall the python version using `brew`'s zlib:

`CPPFLAGS="-I$(brew --prefix zlib)/include" pyenv install -v <version>`

Note: you might want to store the currently installed packages from `pip freeze`
before reinstalling Python.

### "Smart" quotes

Disable "smart" quotes:

```
$ defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
```

### Locale errors

If you see errors like this:

`Warning: Failed to set locale category LC_NUMERIC to en_ZA.`

add the following line to `~/.zshrc.local` to set all locale categories to US
English:

```
export LC_ALL=en_US.UTF-8
```

## NeoVim

For NeoVim packages:
  - Install [vim-plug](https://github.com/junegunn/vim-plug).
  - Install Python and get the `pynvim` package.

For local NeoVim packages, use `~/.config/nvim/plugs.local.vim`. These are sourced
at the end of the plug#begin call in the NeoVim init file.

## Languages

Install any languages necessary, eg. Ruby with rbenv.

## SSH

Set up SSH keys:

Zsh:

```
$ ssh-keygen -t rsa -b 4096 -C "$(git config --global user.email)"
$ eval "$(ssh-agent -s)"
$ ssh-add ~/.ssh/id_rsa
```

Fish:

```
$ ssh-keygen -t rsa -b 4096 -C (git config --global user.email)
$ eval (ssh-agent -c)
$ ssh-add ~/.ssh/id_rsa
```

## Firefox

To set up Firefox styling, make sure you have a `chrome` folder in your profile
directory.

Linux: `mkdir ~/.mozilla/firefox/<profile name>/chrome`
MacOS: `mkdir ~/Library/Application\ Support/Firefox/Profiles/<profile name>/chrome`

Copy userChrome.css to your profile's `chrome` folder:

Linux: `cp userChrome.css ~/.mozilla/firefox/<profile name>/chrome/userChrome.css`
MacOS: `cp userChrome.css ~/Library/Application\ Support/Firefox/Profiles/<profile name>/chrome/userChrome.css`

In the about:config page, set
toolkit.legacyUserProfileCustomizations.stylesheets to true.

## Error when changing shells

If you get the error `chsh: PAM authentication failed` when changing shells,
make sure that the shell is marked as an allowed login shell in `/etc/shells`:
`echo "$(which zsh)" >> /etc/shells`.
