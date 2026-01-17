{
  description = "Default nix-darwin system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          # essentials
          pkgs.bat
          pkgs.curl
          pkgs.fzf
          pkgs.git
          pkgs.htop
          pkgs.jq
          pkgs.ncdu
          pkgs.tmux
          pkgs.wget
          pkgs.vim

          # non-essentials

          # to try out
          # pkgs.ripgrep
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
      home-manager.backupFileExtension = "backup";
      nix.configureBuildUsers = true;
      nix.useDaemon = true;

      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "Nlsv";
        loginwindow.LoginwindowText = "machine_hostname";
      };

      # Homebrew needs to be installed on its own!
      homebrew.enable = true;
      homebrew.brews = [
        "asdf"
      ];
      homebrew.casks = [
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
        "visual-studio-code"
        "warp"
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
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.machine_username = import ./home.nix;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."machine_hostname".pkgs;
  };
}
