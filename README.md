# dotfiles

We can both bootstrap an existing system with these dotfiles, as well as provision a brand new system. Provisioning a brand new system will bootstrap the system once provisioned.

## Boostrapping

Bootstrapping assumes the system is already provisioned and has the appropriate tools needed to perform the bootstrap. These steps can be run on any system, they are no OS-specific. These steps are also idempotent, they can be run many times and always produce the same outcome.

### 1-liner bootstrapping script

When using the 1-liner script, all further steps below can be ignored.

```sh
/bin/bash -c "$(curl -fsSL http://bootstrap.dotfiles.pjs.to)"
```

or

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/patsissons/dotfiles/refs/heads/main/bootstrap.sh)"
```

## Provisioning

Provisioning assumes the system has been fully reset and is completely untouched. These steps should not necessarily be run more than once, though many will not cause any issues running more than once.

### Setup the hostname

### 1-liner provisioning script

When using the 1-liner script, all further steps below can be ignored.

```sh
PROVISION_HOSTNAME=machine_name.machine_hostname /bin/bash -c "$(curl -fsSL http://provision.dotfiles.pjs.to)"
```

or

```sh
PROVISION_HOSTNAME=machine_name.machine_hostname /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/patsissons/dotfiles/refs/heads/main/provision.sh)"
```

## Helpers

### Git

```sh
# unshallow the dotfiles repo
git fetch --unshallow && \
git remote set-branches origin '*'
```

### Homebrew

```sh
# save installed packages
brew leaves > leaves.txt
```

```sh
# restore installed packages
xargs brew install < leaves.txt
```

### Cursor

```sh
# save extensions list
cursor --list-extensions > "${HOME}/.dotfiles/cursor/.cursor/extensions.txt"
```

```sh
# restore extensions from a list
while read extension_id; do cursor --install-extension "$extension_id"; done < "${HOME}/.cursor/extensions.txt"
```
