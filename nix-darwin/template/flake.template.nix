{
  description = "Default nix-darwin system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          # essentials
          pkgs.asdf-vm
          pkgs.bat
          pkgs.curl
          pkgs.direnv
          pkgs.fzf
          pkgs.git
          pkgs.htop
          pkgs.jq
          pkgs.ncdu
          pkgs.ripgrep
          pkgs.stow
          pkgs.tmux
          pkgs.wget
          pkgs.vim

          # non-essentials
          # pkgs._1password
          # pkgs._1password-gui
          # pkgs.arc-browser
          # pkgs.code-cursor
          # pkgs.iterm2
          # pkgs.itsycal
          # pkgs.raycast
          # pkgs.rectangle
          # pkgs.signal-desktop
          # pkgs.vscode
          # pkgs.warp-terminal
        ];
      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # customizations based on https://github.com/omerxx/dotfiles/blob/master/nix-darwin/flake.nix
      security.pam.enableSudoTouchIdAuth = true;
      users.users.machine_username.home = "/Users/machine_username";
      nix.configureBuildUsers = true;
      nix.useDaemon = true;

      # see: https://daiderd.com/nix-darwin/manual/index.html and https://mynixos.com/nix-darwin/options
      system.defaults = {
        CustomSystemPreferences = {
          # don't seem to work...?
          # "com.apple.finder" = {
          #   NewWindowTarget = "PfHm";
          # };
          # "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
          #   TrackpadPinch = 0;
          #   TrackpadRotate = 0;
          #   TrackpadTwoFingerDoubleTapGesture = 0;
          # };
        };
        CustomUserPreferences = {};
        LaunchServices.LSQuarantine = false;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        NSGlobalDomain.AppleShowAllExtensions = true;
        NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
        NSGlobalDomain."com.apple.keyboard.fnState" = true;
        NSGlobalDomain."com.apple.swipescrolldirection" = false;
        dock.autohide = true;
        dock.mru-spaces = false;
        dock.persistent-apps = [
          "/Applications/Arc.app"
          "/Applications/Signal.app"
          "/Applications/Slack.app"
          "/Applications/iTerm.app"
          "/System/Applications/System Settings.app"
        ];
        dock.persistent-others = [
          "/Users/machine_username/Downloads"
        ];
        dock.show-recents = false;
        finder.AppleShowAllExtensions = true;
        finder.FXDefaultSearchScope = "SCcf";
        finder.FXPreferredViewStyle = "Nlsv";
        finder.ShowPathbar = true;
        loginwindow.LoginwindowText = "machine_hostname";
        magicmouse.MouseButtonMode = "TwoButton";
        trackpad.TrackpadThreeFingerTapGesture = 0;
      };

      # Homebrew needs to be installed on its own!
      homebrew.enable = true;
      homebrew.brews = [
        "hashicorp/tap/terraform"
      ];
      homebrew.casks = [
        "1password"
        "1password-cli"
        "arc"
        "cursor"
        "iterm2"
        "itsycal"
        "kap"
        "orbstack"
        "raycast"
        "rectangle"
        "signal"
        "shottr"
        "slack"
        "visual-studio-code"
        "warp"
      ];
      homebrew.taps = [
        "hashicorp/tap"
      ];
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#machine_hostname
    darwinConfigurations."machine_hostname" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        configuration
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."machine_hostname".pkgs;
  };
}
