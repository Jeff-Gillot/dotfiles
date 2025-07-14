{ config, pkgs, ... }:

{
  imports = [
    ../hardware-configuration.nix
    ../common.nix
  ];

  programs.zsh.shellAliases = {
    rebuild = "cd -P /etc/nixos && sudo nixos-rebuild switch --flake .#laptop";
  };

  networking.hostName = "jeff-laptop";
}
