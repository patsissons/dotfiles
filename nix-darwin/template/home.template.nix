# home.nix
# customizations based on https://github.com/omerxx/dotfiles/blob/master/nix-darwin/home.nix
# home-manager switch

{ config, pkgs, ... }:

{
  home.username = "machine_username";
  home.homeDirectory = "/Users/machine_username";
  home.stateVersion = "24.05";

  # Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = [
    pkgs.direnv
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".zshrc".source = ~/dotfiles/.zshrc;
    ".config/zshrc".source = ~/dotfiles/zshrc;
    ".config/git".source = ~/dotfiles/git;
    ".config/nix".source = ~/dotfiles/nix;
    ".config/nix-darwin/template".source = ~/dotfiles/nix-darwin/template;
    ".config/tmux".source = ~/dotfiles/tmux;
  };

  home.sessionVariables = {
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    initExtra = ''
      # Add any additional configurations here
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
  };
}
