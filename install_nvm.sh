#!/bin/bash

# Define NVM version to install
NVM_VERSION="v0.40.3"

# Install NVM
echo "Installing NVM $NVM_VERSION..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash

# Add NVM to shell profile if not already added
NVM_INIT='export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'

if ! grep -q 'NVM_DIR' ~/.zshrc; then
  echo "$NVM_INIT" >> ~/.zshrc
fi

if ! grep -q 'NVM_DIR' ~/.bashrc; then
  echo "$NVM_INIT" >> ~/.bashrc
fi
