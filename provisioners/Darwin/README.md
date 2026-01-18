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
open -a Cursor
open -a Kap
```

### Itsycal

1. `Allow Full Access`

### Ghostty

_NOTE_ sometimes ghostty will not open after install, you can run `xattr -d com.apple.quarantine /Applications/Ghostty.app` to fix this

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
7. `General` tab
    1. _enable_ `Automatically update my Arc`
8. Extensions
    1. `1Password Beta`
    2. `Designer Tools`
    3. `GraphQL Network Inspector`
    4. `React Developer Tools`
    5. `uBlock Origin` ([URL](https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm))
9. `Profiles`
    1. `Archive tabs after`: `30 days`
    2. create `Empty` and assign to `Anon` space
    3. create `Bison` and assign to `Bison` space
10. `Max`
    1. _enable_ `Tidy Tabs`
    2. _enable_ `5-Second Previews`
11. `Advanced`
    1. _enable_ `Show full URL when Toolbar is enabled`
    2. _disable_ `Enable Shared Quotes when highlighting text`
    3. _disable_ `Enable Picture in Picture when you leave a video tab`
    4. _disable_ `Allow websites to get your theme data`
    5. _disable_ `Enable Boosts on websites you visit`
12. `https://accounts.google.com/` → `Sign in` using 1Password for credentials
13. Switch to `Bison` profile
    1. Add `1Password Beta` extension
    3. `https://accounts.google.com/` → `Sign in` using 1Password for credentials


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

1. `Disable in macOS` for conflict (then `OK`)
2. Open settings
3. `General` tab
4. `Import` button → import the [RectangleConfig.json](/rectangle/.config/rectangle/RectangleConfig.json) file (`~/.config/rectangle/RectangleConfig.json`)

### Signal

1. Scan code from mobile app

### shottr

Shottr unfortunately does not support saving and restoring the settings, so we need to set them up manually.

1. `mkdir -p "${HOME}/Pictures/screenshots"`
2. `Run at Startup`
3. `Setup Hotkeys`
    1. `Fullscreen screenshot`: `cmd+option+6`
    2. `Area screenshot`: `cmd+option+5`
    3. `Repeat area screenshot`: `cmd+option+shift+5`
    4. `Any window screenshot`: `cmd+option+4`
4. `General` tab
    1. `Screenshots folder`: `~/Pictures/screenshots`
    2. `Save format`: `PNG`
    3. `After Area Crop, show`: `Thumbnail`
    4. `Hide preview thumbnail`: `Manually (close button)`
5. `Advanced` tab
    1. `Diagnostics information`: _disable_ `Allow collection`

### SSH

```sh
mkdir -p "${HOME}/.ssh" && \
op read "op://Private/vs5xeriwbzwale436zyhsy657u/private key" > "${HOME}/.ssh/id_ed25519"
```

### Finder

1. Connect to NFS server (`cmd+k`)
2. `nfs://nas/mnt/volume1`
3. `Connect`
4. Connect to SMB server (`Network` tab)
5. Open `Network/truenas`
6. `Connect`
7. _credentials in 1Password_

### System Settings

#### About

1. `Name`: _computer-name_

#### Keyboard

1. `Text Replacements…`
2. _delete_ `omw`
3. Add `...` → `…`

#### Lcck Screen

1. `Turn display off on battery when inactive`: `10 minutes`
2. `Turn display off on power adapter when inactive`: `30 minutes`

#### Privacy & Security

1. `Full Disk Access` → `+` → `Cursor`
2. `Full Disk Access` → `+` → `Ghostty`
3. `Developer Tools` → `+` → `Cursor`
4. `Developer Tools` → `+` → `Ghostty`

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

- Rectangle doesn't seem to stick the startup at login setting, I had to manually add it in `System Settings` → `General` → `Login Items`

### Other apps to consider

- `balenaEtcher` for flashing USB drives
- `ChatGPT`
- `VLC`
