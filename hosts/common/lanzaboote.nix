{ config, lib, pkgs, inputs, ... }:

{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  environment.systemPackages = with pkgs; [
    sbctl
  ];

#  boot.loader.systemd-boot.enable = lib.mkForce false;
#  boot.lanzaboote = {
#    enable = true;
#    pkiBundle = "/etc/secureboot";
#  };
# Temporary bootloader for first install
  boot.initrd.systemd.enable = true;
  boot.initrd.luks.devices."root".device = "/dev/disk/by-label/NIXOS_CRYPT";
  boot.initrd.luks.devices."root".preLVM = true;

boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;
boot.loader.efi.efiSysMountPoint = "/boot";  # your EFI partition

# Lanzaboote disabled for now:
boot.lanzaboote.enable = lib.mkForce false;


  security.tpm2.enable = true;
  security.tpm2.tctiEnvironment = {
    interface = "device";
  };

}
