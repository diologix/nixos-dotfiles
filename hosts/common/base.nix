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
    neovim
    usbutils
    pciutils
    lm_sensors
    fastfetch
    file
    p7zip
  ];

  services.openssh.enable = true;

  hardware.bluetooth.enable = true;

  powerManagement.powertop.enable = true;
  services.tlp.enable = true;

  services.fwupd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "25.11";
}
