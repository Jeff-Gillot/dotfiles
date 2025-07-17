{ config, lib, pkgs, ... }:

let
  hostname = lib.removeSuffix "\n" (builtins.readFile /etc/hostname);
in
{
  imports = [
    ./common-software.nix
  ] ++ (if hostname == "jeff-desktop" then [
    ./desktop-hardware.nix
    ./desktop-software.nix
  ] else if hostname == "jeff-laptop" then [
    ./laptop-hardware.nix
    ./laptop-software.nix
  ] else [
    builtins.throw "Unknown hostname: ${hostname}"
  ]);
}