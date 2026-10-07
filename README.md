# dotfiles

Packages, configuration and tools.

- Packages managed with [Homebrew](https://brew.sh).
- Configuration files managed with [rcm](https://github.com/thoughtbot/rcm).
- Tools as scripts in [`local/bin/`](./local/bin/) and [`rcignore/`](./rcignore/).

## Setup

<!-- TODO: add manual Bitwarden install due to following mas error: -->
<!-- ==> Installing Bitwarden (2026.7.0) -->
<!-- Install progress cannot be displayedError: Failed to copy receipt for Bitwarden (2026.7.0) from '/var/folders/ws/xz19hb313dd3b_zcnc_3d_dc0000gn/T/TemporaryItems/NSIRD_mas_ydZiZH/1352778147-receipt' to '/Applications/Bitwarden.app/Contents/_MASReceipt/receipt': -->
<!-- Error Domain=NSCocoaErrorDomain Code=513 "You don’t have permission to save the file “_MASReceipt” in the folder “Contents”." UserInfo={NSFilePath=/Applications/Bitwarden.app/Contents/_MASReceipt, NSURL=file:///Applications/Bitwarden.app/Contents/_MASReceipt, NSUnderlyingError=0xba7051f50 {Error Domain=NSPOSIXErrorDomain Code=1 "Operation not permitted"}} -->

Prerequisites (install manually before running setup):

1. [Homebrew](https://brew.sh)
2. [Claude Code](https://claude.ai/download)

Then clone and run setup:

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

Codex config is split between shared defaults in `rcignore/codex/config.toml` and the runtime file
at `~/.codex/config.toml`. Copy or merge shared defaults into the runtime file alongside
machine-specific `[projects.*]` trust settings. The setup script handles the initial copy.

Machine-local nvim config lives in `~/.config/nvim/lua/config/local.lua`

OS-specific config lives in `./tag-{os}/` and follows the same convention as local config, replacing
"local" with "os" in filenames.

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
`toolkit.legacyUserProfileCustomizations.stylesheets` to true. To also remove the remaining sidebar
UI, set `sidebar.revamp` to false.

## MacOS

Run `updateAll` to update everything.

MacOS packages are managed with a global `Brewfile`. This replaces imperative commands like
`brew install` with 2 steps: update the `Brewfile`, then ensure that exactly the packages in the
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

### Biometric sudo auth

Add this line to sudo config opened with `sudo -e /etc/pam.d/sudo`:

```
auth       sufficient     pam_tid.so
```

### Karabiner Bluetooth shell commands

Karabiner `shell_command` mappings that run `blueutil` need Bluetooth permission for Karabiner's
console user helper.

Set up: in System Settings > Privacy & Security > Bluetooth, click `+`, press Cmd+Shift+G, paste
this path, and enable the entry:

`/Library/Application Support/org.pqrs/Karabiner-Elements/Karabiner-Console-User-Server.app`

Then restart the helper:

```sh
launchctl kickstart -k gui/$(id -u)/org.pqrs.service.agent.Karabiner-Console-User-Server
```

Reset: if the mappings still fail (e.g. a Karabiner update changes the helper), remove every
Karabiner entry from that Bluetooth list with `-`, then repeat the setup step.

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

### Default editor

Set Zed as the default text editor:

```sh
# Set Zed for core text and code UTIs (excluding public.html)
duti -s dev.zed.Zed public.plain-text all
duti -s dev.zed.Zed public.text all
duti -s dev.zed.Zed public.source-code all
duti -s dev.zed.Zed net.daringfireball.markdown all

# Set Zed for common file extensions
for ext in txt md markdown js ts py go rs c cpp h hpp css json yaml yml xml sh zsh bash; do
  duti -s dev.zed.Zed $ext all
done
```

Reset to default:

```sh
# Reset UTIs (excluding public.html)
duti -s com.apple.TextEdit public.plain-text all
duti -s com.apple.TextEdit public.text all
duti -s com.apple.TextEdit public.source-code all
duti -s com.apple.TextEdit net.daringfireball.markdown all

# Reset common extensions to TextEdit
for ext in txt md markdown js ts py go rs c cpp h hpp css json yaml yml xml sh zsh bash; do
  duti -s com.apple.TextEdit $ext all
done
```

## Linux/Debian

<!-- TODO: https://github.com/rbreaves/kinto -->

### Set default terminal emulator

```sh
sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
```

### Docker

After installing Docker, add yourself to the docker group with `sudo usermod -aG docker doubledup`
and restart.

### GNOME Extensions

Always show Bluetooth icon in system menu:
[Bluetooth quick connect](https://extensions.gnome.org/extension/1401/bluetooth-quick-connect/)

Speed up shell animations: [Impatience](https://extensions.gnome.org/extension/277/impatience/)
Might be able to get away with setting `GNOME_SHELL_SLOWDOWN_FACTOR=0.5` in `/etc/environment`.
