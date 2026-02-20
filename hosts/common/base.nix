{ config, lib, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.hostName = lib.mkDefault "nixos";

  networking.networkmanager.enable = true;

  console.keyMap = "de";

  services.printing.enable = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    htop
    usbutils
    pciutils
    lm_sensors
    fastfetch
    file
    p7zip
    brightnessctl
    pavucontrol
  ] ++ [
    (pkgs.writeScriptBin "rebuild" ''
      #!/usr/bin/env bash
      cd /home/hr/nixos-dotfiles || { echo "Config dir not found"; exit 1; }
      sudo nixos-rebuild switch --flake .#$(hostname | sed 's/[^A-Z]*//g')
    '')
  ];

  # Global shell alias
  environment.shellAliases.rebuild = "rebuild";

  services.openssh.enable = true;

  programs.zsh.enable = true;

  hardware.bluetooth.enable = true;

  powerManagement.powertop.enable = true;
  services.tlp.enable = true;

  services.fwupd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "25.11";
}

