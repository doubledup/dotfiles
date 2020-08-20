# Troubleshooting

## Homebrew

### FZF autocomplete & bindings

`"$(brew --prefix)/opt/fzf/install"`

### pyenv: zlib not found

Reinstall the python version using `brew`'s zlib:

`CPPFLAGS="-I$(brew --prefix zlib)/include" pyenv install -v <version>`

Note: you might want to store the currently installed packages from `pip freeze`
before reinstalling Python.

## Error when changing shells

If you get the error `chsh: PAM authentication failed` when changing shells,
make sure that the shell is marked as an allowed login shell in `/etc/shells`:
`echo "$(which zsh)" >> /etc/shells`.

## MacOS Locale errors

If you see errors like this:

`Warning: Failed to set locale category LC_NUMERIC to en_ZA.`

add the following line to `~/.zshrc.local` to set all locale categories to US
English:

```
export LC_ALL=en_US.UTF-8
```
