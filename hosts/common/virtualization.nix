{ config, pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
      ovmf.enable = true;
      vhostUserPackages = [ ];
    };
  };

  programs.virt-manager.enable = true;

  boot.kernelModules = [ "kvm" "kvm_intel" "kvm_amd" "tun" ];

  services.qemuGuest.enable = true;
}
