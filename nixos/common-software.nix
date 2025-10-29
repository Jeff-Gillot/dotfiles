
{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
in
{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable network and wifi
  networking.networkmanager.enable = true;

  # Timezone and locales
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_BE.UTF-8";
    LC_IDENTIFICATION = "fr_BE.UTF-8";
    LC_MEASUREMENT = "fr_BE.UTF-8";
    LC_MONETARY = "fr_BE.UTF-8";
    LC_NAME = "fr_BE.UTF-8";
    LC_NUMERIC = "fr_BE.UTF-8";
    LC_PAPER = "fr_BE.UTF-8";
    LC_TELEPHONE = "fr_BE.UTF-8";
    LC_TIME = "fr_BE.UTF-8";
  };

  # Services
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jeff = {
    isNormalUser = true;
    description = "jeff";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  # Predefined/autoconfigured programs
  programs.steam.enable = true;
  programs.hyprland.enable = true;
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = ["git" "gradle"];
    theme = "robbyrussell";
  };

  # Docker
  virtualisation.docker.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    unstable.jetbrains.idea-ultimate
    unstable.jetbrains-toolbox
    gradle
    docker
    stow
    git
    font-awesome
    btop
    mpv
    kdePackages.kate
    temurin-bin
    kitty
    # Hyprland stuff
    unstable.hyprland
    unstable.hypridle
    unstable.hyprlock
    unstable.hyprshot
    unstable.hyprpaper
    unstable.wofi
    unstable.waybar
    unstable.hyprpolkitagent
    unstable.swaynotificationcenter
    unstable.sway-audio-idle-inhibit
    unstable.xdg-desktop-portal
    unstable.xdg-desktop-portal-hyprland
    pavucontrol
    jdk21
    unstable.google-chrome
    unrar
    unar
    jq
    discord
    bambu-studio
  ];

  #   This is to have file association for dolphin in hyprland
  nixpkgs.overlays = [
    (import ./dolphin-overlay.nix)
  ];

  programs.zsh.shellAliases = {
    rebuild = "sudo nixos-rebuild switch -I nixos-config=/home/jeff/dotfiles/nixos/configuration.nix";
  };

  system.stateVersion = "25.05";
}
