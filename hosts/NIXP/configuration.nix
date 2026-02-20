{ config, pkgs, lib, ... }:

{
  networking.hostName = "NIXP";

  imports = [
    ./hardware-configuration.nix
  ];

  fileSystems."/" = {
    device = "/dev/mapper/vg-root";
    fsType = "xfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/EFI";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/mapper/vg-swap"; }
  ];

  hardware.graphics.extraPackages = with pkgs; [
    pkgs.intel-media-driver
    pkgs.nvidia-vaapi-driver
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    nvidiaSettings = true;
    open = false;
  };
}
