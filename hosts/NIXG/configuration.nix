{ config, pkgs, lib, ... }:

{
  networking.hostName = "NIXG";

  imports = [
    ./hardware-configuration.nix
  ];

  # Root filesystem is XFS on LUKS LVM, adjust as needed
  fileSystems."/" = {
    device = "/dev/mapper/vg-root";
    fsType = "xfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/mapper/vg-swap"; }
  ];

  # AMD GPU
  boot.kernelModules = [ "amdgpu" ];
}
