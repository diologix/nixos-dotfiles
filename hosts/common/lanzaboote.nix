{ config, lib, pkgs, inputs, ... }:

{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  environment.systemPackages = with pkgs; [
    sbctl
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  security.tpm2.enable = true;
  security.tpm2.tctiEnvironment = "device";

  boot.initrd.systemd.enable = true;
  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-LUKS-UUID";
  boot.initrd.luks.devices."root".preLVM = true;
}
