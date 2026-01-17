#!/bin/bash

# Provision OS
OS_NAME="$(uname)" && \
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/patsissons/dotfiles/refs/heads/main/provisioners/${OS_NAME}/provision.sh)" || \
echo "⚠️ No provision script for OS: ${OS_NAME}"
