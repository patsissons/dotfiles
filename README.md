# dotfiles provisioning

Provision a new machine using the steps below based on the provisioning style. A nix script is available at `nix-install.sh` to one-shot the provisioning process.

## 1-shot install script

_NOTE that you'll need to reboot at least once from a fresh laptop before running this script, or you'll run into a nix issue with FileVault._

```sh
/bin/bash -c "$(curl -fsSL http://nix.pjs.to)"
```

## basic mac provisioning

pick something for `machine_hostname`

```sh
scutil --set LocalHostName machine_hostname
```

## nix-darwin

### Install homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Install nixos

```sh
sh <(curl -L https://nixos.org/nix/install)
```

_NOTE that you'll need to start a new shell or run `$SHELL -l` to activate nix in the shell._

### Clone dotfiles

```sh
nix-shell -p git --run "git clone -b nixos https://github.com/patsissons/dotfiles.git"
```

### Stow dotfiles

```sh
nix-shell -p stow --run "cd ~/dotfiles && ./setup.sh"
```

_NOTE that we are creating `.config/nix-darwin` manually because the nixos installation will refuse to build the flake against a symlink._

### Configure nix-darwin files

The config files are templated currently so we need to replace `machine_hostname` and `machine_username` with approriate values.

```sh
~/dotfiles/nix-darwin/template/config.sh
```

### Install the flake

```sh
# impure because of ~ expansion
nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ~/.config/nix-darwin/flake --impure
```

### Applying changes to the flake

Run these commands if any changes are made to the flake templates.

```sh
~/dotfiles/nix-update.sh
```

### Setup fresh nix-darwin

This is only necessary if creating a new flake for the first time, this is only preserved here for reference purposes and should not really be necessary.

Note that we are provisioning this flake for apple silicon, remove the `-e "s/x86_64-darwin/aarch64-darwin/"` if provisioning for intel silicon.

#### Provision the flake file

```sh
mkdir -p ~/.config/nix-darwin
cd ~/.config/nix-darwin
nix --extra-experimental-features "nix-command flakes" flake init -t nix-darwin
sed -i '' -e "s/simple/$(scutil --get LocalHostName)/" -e "s/x86_64-darwin/aarch64-darwin/" -e "s/Example Darwin system flake/Default nix-darwin system/" flake.nix
```

## stow provisioning

stow provisioning is only necessary when not using nix-darwin (e.g., on an ephemeral remote system). We will otherwise stow the dotfiles as part of the nix-darwin provisioning process.

```sh
cd ~/dotfiles
./setup.sh
```

_NOTE that if `stow` is not available then nothing will be stowed._

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
