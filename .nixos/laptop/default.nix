{ config, pkgs, ... }:

{
  imports = [
    ../hardware-configuration.nix
    ../common.nix
  ];

  networking.hostName = "jeff_laptop";
}
