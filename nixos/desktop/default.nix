{ config, pkgs, ... }:

{
  imports = [
    ../hardware-configuration.nix
    ../common.nix
  ];

  # Nvidia Stuff
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  programs.zsh.shellAliases = {
    rebuild = "cd -P /etc/nixos && sudo nixos-rebuild switch --flake .#desktop";
  };

  networking.hostName = "jeff-desktop";
}
