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

  networking.hostName = "jeff_desktop";
}
