#!/bin/sh

CONFIG_DIR="${HOME}/.config"
PROVISIONED_DIR="${CONFIG_DIR}/macos/.provisioned"

if [ ! -d "${PROVISIONED_DIR}" ]; then
  echo Provisioning new mac... && \
  mkdir -p "${PROVISIONED_DIR}" || \
  exit 1
fi

DEFAULT_KEYBINDINGS_PATH="${HOME}/Library/KeyBindings/DefaultKeyBinding.dict"
if [ ! -f "${DEFAULT_KEYBINDINGS_PATH}" ]; then
  mkdir -p "${HOME}/Library/KeyBindings" && \
  ln -s "${CONFIG_DIR}/macos/DefaultKeyBinding.dict" "${DEFAULT_KEYBINDINGS_PATH}" || \
  exit 1
fi

# touch id for sudo
sed -e 's/^#auth/auth/' /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local

# macos system settings (requires logout to take effect)
# Auto hide/show
defaults write com.apple.dock autohide -bool true
# Don't rearrange Spaces based on recently used
defaults write com.apple.dock mru-spaces -bool false
# wipe out all default dock apps
defaults write com.apple.dock persistent-apps -array
# Don't show recent apps in dock
defaults write com.apple.dock show-recents -bool false
# Enable the Expose gesture (swipe down with three fingers)
defaults write com.apple.dock showAppExposeGestureEnabled -int 1
# Disable the desktop (Mission Control) gesture (swipe up with three fingers)
defaults write com.apple.dock showDesktopGestureEnabled -int 0
# Disable the Launchpad gesture (pinch with thumb and three fingers)
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0
# Trackpad: disable two finger pinch
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -int 0
defaults -currentHost write NSGlobalDomain com.apple.trackpad.pinchGesture -int 0
# Trackpad: disable trackpad rotate
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -int 0
defaults -currentHost write NSGlobalDomain com.apple.trackpad.rotateGesture -int 0
# Trackpad: 'smart zoom' two finger double tap
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -int 0
defaults -currentHost write NSGlobalDomain com.apple.trackpad.twoFingerDoubleTapGesture -int 0
# Disable swipe between apps (three/four finger swipe left/right)
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerHorizSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0
# Disable the "Are you sure you want to open this application?" dialog.
defaults write com.apple.LaunchServices LSQuarantine -bool false
# Disable "natural" scrolling.
defaults -currentHost write NSGlobalDomain com.apple.swipescrolldirection -bool false
# dark mode
defaults -currentHost write NSGlobalDomain AppleInterfaceStyle Dark
# show all file extensions
defaults -currentHost write NSGlobalDomain AppleShowAllExtensions -bool true
# disable automatic periods
defaults -currentHost write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
# use fn keys normally
defaults -currentHost write NSGlobalDomain com.apple.keyboard.fnState -bool true
# new finder starts in home directory
defaults write com.apple.finder NewWindowTarget PfHm
# search scope is current folder
defaults write com.apple.finder FXDefaultSearchScope SCcf
# preferred view style is list view
defaults write com.apple.finder FXPreferredViewStyle Nlsv
# show path bar at the bottom of finder
defaults write com.apple.finder ShowPathbar -bool true
# swip left or right on magic mouse to go back or forward in browser
defaults -currentHost write NSGlobalDomain AppleEnableMouseSwipeNavigateWithScrolls -int 1
# enable magic mouse right click
defaults write com.apple.AppleMultitouchMouse MouseButtonMode TwoButton
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode TwoButton
# disable magic mouse 2 finger swipe between apps
defaults write com.apple.AppleMultitouchMouse MouseTwoFingerHorizSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseTwoFingerHorizSwipeGesture -int 0

# setup dock apps
# based on https://github.com/LnL7/nix-darwin/blob/bd7d1e3912d40f799c5c0f7e5820ec950f1e0b3d/modules/system/defaults/dock.nix#L126-L150
# doesn't seem to work, so disabling
# for app in Arc iTerm Signal; do
#   defaults write com.apple.dock persistent-apps -array-add "{ tile-data = { file-data = { _CFURLString = 'file:///Applications/${app}.app/'; _CFURLStringType = 0; }; }; }"
# done
# # add system settings at the end
# defaults write com.apple.dock persistent-apps -array-add "{ tile-data = { file-data = { _CFURLString = 'file:///System/Applications/System%20Settings.app/'; _CFURLStringType = 0; }; }; }"
# kill the dock so changes apply (it will restart automatically)
killall Dock

# set login window text
# sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText -string "machine_hostname"

if [ ! -f /opt/homebrew/bin/brew ]; then
  echo Installing Homebrew... && \
  export NONINTERACTIVE=1 && \
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
  eval "$(/opt/homebrew/bin/brew shellenv)" && \
  xargs brew tap < "${CONFIG_DIR}/macos/homebrew/taps.txt" && \
  xargs brew install < "${CONFIG_DIR}/macos/homebrew/formulae.txt" && \
  xargs brew install --cask < "${CONFIG_DIR}/macos/homebrew/casks.txt" || \
  exit 1
fi

# disabling macos nix package installation for now, some are broken and all are dumped into `~/.nix-profile/Applications` and aren't really detected by the operating system. it's probably best to just use brew instead.
# export NIXPKGS_ALLOW_UNFREE=1 && \
# nix-env --install --file "${DOTFILES_DIR}/nix/.config/nix/pkgs/macos.nix" --impure || \
# exit 1

if [ -d "/Applications/1Password.app" -a ! -f "${PROVISIONED_DIR}/1password" ]; then
  open -a 1Password && \
  date > "${PROVISIONED_DIR}/1password" && \
  echo 1Password provisioned at $(cat "${PROVISIONED_DIR}/1password") || \
  exit 1
fi

if [ -d "/Applications/Arc.app" -a ! -f "${PROVISIONED_DIR}/arc" ]; then
  open -a Arc && \
  date > "${PROVISIONED_DIR}/arc" && \
  echo Arc provisioned at $(cat "${PROVISIONED_DIR}/arc") || \
  exit 1
fi

if [ -d "/Applications/Itsycal.app" -a ! -f "${PROVISIONED_DIR}/itsycal" ]; then
  open -a Itsycal && \
  date > "${PROVISIONED_DIR}/itsycal" && \
  echo Itsycal provisioned at $(cat "${PROVISIONED_DIR}/itsycal") || \
  exit 1
fi

if [ -d "/Applications/Raycast.app" -a ! -f "${PROVISIONED_DIR}/raycast" ]; then
  open -a Raycast && \
  date > "${PROVISIONED_DIR}/raycast" && \
  echo Raycast provisioned at $(cat "${PROVISIONED_DIR}/raycast") || \
  exit 1
fi

if [ -d "/Applications/Rectangle.app" -a ! -f "${PROVISIONED_DIR}/rectangle" ]; then
  open -a Rectangle && \
  date > "${PROVISIONED_DIR}/rectangle" && \
  echo Rectangle provisioned at $(cat "${PROVISIONED_DIR}/rectangle") || \
  exit 1
fi

if [ -d "/Applications/Shottr.app" -a ! -f "${PROVISIONED_DIR}/shottr" ]; then
  open -a Shottr && \
  date > "${PROVISIONED_DIR}/shottr" && \
  echo Shottr provisioned at $(cat "${PROVISIONED_DIR}/shottr") || \
  exit 1
fi

# this one is slower so we'll run it at the end
if [ -d "/Applications/Kap.app" -a ! -f "${PROVISIONED_DIR}/kap" ]; then
  softwareupdate --install-rosetta --agree-to-license && \
  open -a Kap && \
  date > "${PROVISIONED_DIR}/kap" && \
  echo Kap provisioned at $(cat "${PROVISIONED_DIR}/kap") || \
  exit 1
fi
