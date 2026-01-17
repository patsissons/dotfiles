{ pkgs ? import <nixpkgs> {} }:

[
  pkgs._1password
  # marked as broken
  # pkgs._1password-gui
  pkgs.arc-browser
  # not available on the requested hostPlatform
  # pkgs.code-cursor
  pkgs.iterm2
  pkgs.itsycal
  pkgs.raycast
  pkgs.rectangle
  # not available on the requested hostPlatform
  # pkgs.signal-desktop
  pkgs.vscode
  pkgs.warp-terminal
]
