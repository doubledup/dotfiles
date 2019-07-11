# dotfiles
Dotfiles, tracked with rcm (https://github.com/thoughtbot/rcm)

## MacOS
- Install [Homebrew](https://brew.sh/).
- Run `brew bundle install`.
- Run `git submodule init`.
- Run `rcup`

If you see errors like this:

`Warning: Failed to set locale category LC_NUMERIC to en_ZA.`

add the following line to `~/.zshrc.local` to set all locale categories to US
English:

`export LC_ALL=en_US.UTF-8`
