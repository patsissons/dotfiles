# dotfiles provisioning

Provision a new machine using the steps below based on the provisioning style.

## basic mac provisioning

pick something for `machine_hostname`

```sh
scutil --set LocalHostName machine_hostname
```

## 1-shot install script

_NOTE that you'll need to reboot at least once from a fresh laptop before running this script, or you'll run into a nix issue with FileVault._

```sh
/bin/bash -c "$(curl -fsSL http://dotfiles.pjs.to)"
```

This script should fully provision a new machine, the remaining steps below can be skipped when using the script.

## Install homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Install nix

```sh
sh <(curl -L https://nixos.org/nix/install) && \
$SHELL -l
```

## Clone dotfiles

```sh
nix-shell -p git --run "git clone -b nixos https://github.com/patsissons/dotfiles.git \"${HOME}/.dotfiles\""
```

## Install nix essential packages

```sh
nix-env --install --file "${HOME}/.dotfiles/nix/.config/nix/pkgs/essential.nix" && \
$SHELL -l
```

## Stow dotfiles

```sh
stow -v --dir "${HOME}/.dotfiles" --target --target "${HOME} \
  --stow git \
  --stow nix \
  --stow tmux \
  --stow vim \
  --stow zshrc
```

## macos specific

### Stow dotfiles

```sh
stow -v --dir "${HOME}/.dotfiles" --target "${HOME}" --stow macos
```

### Bootstrap apps

```sh
~/.config/macos/bootstrap.sh
```

_NOTE: this script will be somewhat interactive, at the very least to request sudo access for installations._

## Homebrew setup

If managing homebrew manually, these commands help migrate to a new machine.

### save installed packages

```sh
brew leaves > leaves.txt
```

### restore installed packages

```sh
xargs brew install < leaves.txt
```
