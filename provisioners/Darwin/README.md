# MacOS Provisioning

New machine provisioning steps

## Factory reset

1. `System Settings` → `General` → `Transfer or Reset` → `Erase All Content and Settings…`
2. _Enter password_
3. `Continue`
4. _Enter apple password_ and perform MFA to sign out of apple cloud resources
5. `Erase All Content & Settings`

## Fresh installation setup

1. Connect to wifi
2. Choose language
3. Choose country
4. `Set up with iPhone or iPad` (this will auto-onboard to the apple account)
5. (_on phone_) `Continue` on `Setup Up New Mac` drawer
6. (_on phone_) scan the _globe_ on the new mac
    - ⚠️ keep the phone next to the mac for the next few steps
7. `Not Now` on `Accessibility`
8. `Continue` on `Data & Privacy`
9. `Continue` after typing in the local account password
    - Ignore the icon selection, it will be replaced with your apple account icon
    - Keep `Allow computer account password to be reset with your Apple Account` checked
10. `Agree` to the T&C's
11. `Continue` for `Find My`
12. `Continue` to keep the default settings (these were synced from iCloud)
13. `Skip` on `Apple Intelligence`
14. `Continue` to setup `Touch ID` (set up 1 finger, to speed up some of the next steps)
15. `Set Up Later` on `Apple Pay`
16. (_on phone_) `Done` on the drawer, setup is complete 🍾
17. `Get Started` on screen
18. open `Terminal` and start the [provisioning process](/README.md#provisioning)

## Post provisioning setup

First run the script to start up the core apps

```sh
open -a 1Password
open -a Arc
open -a Ghostty
open -a Itsycal
open -a OrbStack
open -a Raycast
open -a Rectangle
open -a Shottr
open -a Signal
```

### Itsycal

1. `Allow Full Access`

### Ghostty

1. `Ignore` the configuration error
2. `Check for Updates…`
3. `Install Update`
4. `Install and Relaunch`
5. `Check Automatically` (for updates, but don't auto-install)

### 1Password

1. `Sign In`
2. Select the family vault
3. _Enter password_
4. `Continue` after Enabling `Unlock using Touch ID`
5. Open settings
    1. `Developer` enable `Integrate with 1Password CLI`
    2. `Developer` click `Set up the SSH Agent`
        1. `Use Key Names`
        2. `Edit Automatically`
        3. `Open SSH URLs with` select `Ghostty`

### Arc

1. `Sign in` using 1Password for credentials
2. `Next` for the recovery card (already saved in 1Password)
3. Open settings
4. Enable `Sync Sidebar`
5. `Close` for the recovery card
6. `Make Arc your default` → `Use "Arc"`

### OrbStack

1. `Install Helper`
2. `Next`
3. `Docker`

### Raycast

1. `Start setup`
2. `Continue`
3. `Continue`
4. `Install All`
5. `Maybe later`
6. `Continue`
7. `Grant Access` for all 3 items
8. `Continue`
9. `Continue`

### Rectangle

- `Disable in macOS` for conflict (then `OK`)

### Signal

- Scan code

### shottr

1. `Run at Startup`
2. `Setup Hotkeys`

### SSH

```sh
mkdir -p "${HOME}/.ssh" && \
op read "op://Private/vs5xeriwbzwale436zyhsy657u/private key" > "${HOME}/.ssh/id_ed25519"
```

## MacOS defaults

### Dock

- `com.apple.dock persistent-apps`: List of persistent apps in the dock
- `com.apple.dock autohide`: Enable autohide (`true`)
- `com.apple.dock mru-spaces`: Disable rearrange by most recently used (`false`)
- `com.apple.dock show-recents`: Disable show recent apps (`false`)
- `com.apple.dock showAppExposeGestureEnabled`: Enable expose gesture, swipe down with three fingers (`1`)
- `com.apple.dock showDesktopGestureEnabled`: Disable desktop (Mission Control) gesture, swipe up with three fingers (`0`)
- `com.apple.dock showLaunchpadGestureEnabled`: Disable launchpad gesture, pinch with thumb and three fingers (`0`)

### Mouse & Trackpad

- `com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch`: Disable two finger pinch (`0`)
  - `NSGlobalDomain com.apple.trackpad.pinchGesture` (`0`)
- `com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate`: Disable trackpad rotate (`0`)
  - `NSGlobalDomain com.apple.trackpad.rotateGesture` (`0`)
- `com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture`: Disable trackpad _smart zoom_ two finger double tap (`0`)
  - `NSGlobalDomain com.apple.trackpad.twoFingerDoubleTapGesture` (`0`)
- `com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture`: Disable 4-finger swipe between apps (`0`)
- `com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture`: Disable 3-finger swipe between apps (`0`)
- `com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerHorizSwipeGesture`: Disable bluetooth 4-finger swipe between apps (`0`)
- `com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture`: Disable bluetooth 3-finger swipe between apps (`0`)
- `com.apple.AppleMultitouchMouse MouseButtonMode`: Enable magic mouse right click (`TwoButton`)
- `com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode`: Enable bluetooth mouse right click (`TwoButton`)
- `com.apple.AppleMultitouchMouse MouseTwoFingerHorizSwipeGesture`: Disable magic mouse 2 finger swipe between apps (`0`)
- `com.apple.driver.AppleBluetoothMultitouch.mouse MouseTwoFingerHorizSwipeGesture`: Disable bluetooth mouse 2 finger swipe between apps (`0`)
- `NSGlobalDomain com.apple.swipescrolldirection`: Disable _natural_ scrolling (`false`)
- `NSGlobalDomain AppleEnableMouseSwipeNavigateWithScrolls`: Swipe left or right on magic mouse to go back or forward in browser (`1`)

### Keyboard

- `NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled`: Disable automatic periods (`false`)
- `NSGlobalDomain com.apple.keyboard.fnState`: Use fn keys normally (`true`)

### Other

- `com.apple.LaunchServices LSQuarantine`: Disable the "Are you sure you want to open this application?" dialog (`false`)
- `NSGlobalDomain AppleInterfaceStyle`: Enable dark mode (`Dark`)
- `NSGlobalDomain AppleShowAllExtensions`: Show all file extensions (`true`)
- `com.apple.finder NewWindowTarget`: New finder starts in home directory (`PfHm`)
- `com.apple.finder FXDefaultSearchScope`: Search scope is current folder (`SCcf`)
- `com.apple.finder FXPreferredViewStyle`: Preferred view style is list view (`Nlsv`)
- `com.apple.finder ShowPathbar`: Show path bar at the bottom of finder (`true`)
- `com.apple.desktopservices DSDontWriteNetworkStores`: Don't create `.DS_Store` files in network shares (`true`)
- `com.apple.WindowManager StandardHideWidgets`: Hide widgets (`true`)

## Notes

- add to `/etc/nfs.conf`: `nfs.client.mount.options = vers=4`
- add Ghostty to `Settings` → `Privacy & Security` → `Full Disk Access` & `Developer Tools`
- Restore Arc extensions
- Initial app opening still not quite working right
