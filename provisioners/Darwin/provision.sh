#!/bin/bash

DOTFILES_DIR="${HOME}/.dotfiles"
TARGET_DIR="${HOME}"
CONFIG_DIR="${TARGET_DIR}/.config"
MACOS_CONFIG_DIR="${CONFIG_DIR}/macos"

echo Provisioning MacOS…

# NOTE: this will install command line tools for Xcode, which is somewhat slow
echo Installing Homebrew… && \
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
eval "$(/opt/homebrew/bin/brew shellenv)"

# exit immediately if anything doesn't succeed, and print out all commands executed
set -ex

echo Installing Homebrew essential tools… && \
brew install git stow

# Bootstrap dotfiles
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/patsissons/dotfiles/refs/heads/main/bootstrap.sh)"

# stow macos specific config
echo Stowing macos specific dotfiles… && \
stow -v --dir "${DOTFILES_DIR}" --target "${TARGET_DIR}" \
  --stow cursor \
  --stow ghostty \
  --stow macos \
  --stow rectangle

if [ -n "${PROVISION_HOSTNAME}" ]; then
  echo Setting hostname… && \
  PROVISION_LOCAL_HOSTNAME="${PROVISION_HOSTNAME%%.*}" && \
  echo scutil --set LocalHostName "${PROVISION_LOCAL_HOSTNAME}" && \
  echo scutil --set HostName "${PROVISION_HOSTNAME}"
fi

# Setup some handy keybindings
echo Installing default key bindings… && \
mkdir -p "${HOME}/Library/KeyBindings" && \
ln -s "${MACOS_CONFIG_DIR}/DefaultKeyBinding.dict" "${HOME}/Library/KeyBindings/DefaultKeyBinding.dict"

echo Initializing Touch ID for sudo… && \
sed -e 's/^#auth/auth/' /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local

echo Forcing nfs v4… && \
echo "nfs.client.mount.options = vers=4" | sudo tee -a /etc/nfs.conf

# Set login window text
# sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText -string "$(hostname -s)"

# some packages come with macos already: jq, vim, zsh
echo Installing Homebrew tools… && \
NONINTERACTIVE=1 brew install asdf bat btop dua-cli dust fzf gpg htop just mise ncdu ripgrep starship tmux tree uv wget zoxide zsh-autosuggestions
# brew tap hashicorp/tap
# brew install hashicorp/tap/terraform

echo Initializing asdf tools… && \
asdf plugin add nodejs && \
asdf plugin add pnpm && \
asdf plugin add yarn && \
asdf set -u nodejs latest && \
asdf set -u pnpm latest && \
asdf set -u yarn latest && \
NONINTERACTIVE=1 asdf install

echo Installing Homebrew apps… && \
NONINTERACTIVE=1 brew install --cask 1password 1password-cli arc cursor ghostty itsycal kap font-jetbrains-mono-nerd-font orbstack raycast rectangle signal shottr

echo Installing rosetta… && \
NONINTERACTIVE=1 softwareupdate --install-rosetta --agree-to-license

echo Initializing system settings… && \
defaults delete com.apple.dock persistent-apps && \
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Arc.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>" && \
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Ghostty.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>" && \
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Cursor.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>" && \
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Signal.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>" && \
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System/Applications/System Settings.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>" && \
defaults write com.apple.dock autohide -bool true && \
defaults write com.apple.dock mru-spaces -bool false && \
defaults write com.apple.dock show-recents -bool false && \
defaults write com.apple.dock showAppExposeGestureEnabled -int 1 && \
defaults write com.apple.dock showDesktopGestureEnabled -int 0 && \
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0 && \
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -int 0 && \
defaults -currentHost write NSGlobalDomain com.apple.trackpad.pinchGesture -int 0 && \
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -int 0 && \
defaults -currentHost write NSGlobalDomain com.apple.trackpad.rotateGesture -int 0 && \
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -int 0 && \
defaults -currentHost write NSGlobalDomain com.apple.trackpad.twoFingerDoubleTapGesture -int 0 && \
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 0 && \
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0 && \
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerHorizSwipeGesture -int 0 && \
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0 && \
defaults write com.apple.AppleMultitouchMouse MouseButtonMode TwoButton && \
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode TwoButton && \
defaults write com.apple.AppleMultitouchMouse MouseTwoFingerHorizSwipeGesture -int 0 && \
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseTwoFingerHorizSwipeGesture -int 0 && \
defaults -currentHost write NSGlobalDomain com.apple.swipescrolldirection -bool false && \
defaults -currentHost write NSGlobalDomain AppleEnableMouseSwipeNavigateWithScrolls -int 1 && \
defaults -currentHost write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false && \
defaults -currentHost write NSGlobalDomain com.apple.keyboard.fnState -bool true && \
defaults write com.apple.LaunchServices LSQuarantine -bool false && \
defaults -currentHost write NSGlobalDomain AppleInterfaceStyle Dark && \
defaults -currentHost write NSGlobalDomain AppleShowAllExtensions -bool true && \
defaults write com.apple.finder NewWindowTarget PfHm && \
defaults write com.apple.finder FXDefaultSearchScope SCcf && \
defaults write com.apple.finder FXPreferredViewStyle Nlsv && \
defaults write com.apple.finder ShowPathbar -bool true && \
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true && \
defaults write com.apple.WindowManager StandardHideWidgets -bool true && \
killall Dock && \
sleep 5

set +ex && \
echo -e "\n\n🍾🍾🍾 DONE 🎉🎉🎉\n\nRemember to reboot for some settings to take effect."
