#!/bin/bash

# Install Homebrew
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.zprofile
  eval "$($(brew --prefix)/bin/brew shellenv)"
fi

brew update
brew upgrade

# Install formulae (CLI packages)
brew install \
  ca-certificates
  gettext
  gh
  gmp
  gnupg
  gnutls
  libassuan
  libevent
  libgcrypt
  libgpg-error
  libidn2
  libksba
  libnghttp2
  libtasn1
  libunistring
  libusb
  nettle
  npth
  openssl@3
  p11-kit
  pinentry
  pyenv
  rbenv
  readline
  unbound

# Install casks (GUI apps)
brew install --cask \
  docker
  google-chrome
  postman
  slack
  visual-studio-code

brew cleanup
