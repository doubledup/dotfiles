if [[ $(uname -s) == "Darwin" ]]; then
  # use gnu utils by default
  PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
  PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
  MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"
fi

# Path

## binaries
export PATH="$HOME/.local/bin:$PATH"

## exenv
export PATH="$HOME/.exenv/bin:$PATH"
eval "$(exenv init - --no-rehash)"

## go
export GOPATH="$HOME/code/go"
export PATH="$GOPATH/bin:$PATH"

## nodenv
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init - --no-rehash)"

## pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - --no-rehash)"
export PIPENV_VENV_IN_PROJECT=1

## rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - --no-rehash)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

## rust
export PATH="$HOME/.cargo/bin:$PATH"
