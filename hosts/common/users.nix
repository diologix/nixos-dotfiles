{ config, pkgs, ... }:

{
  users.users.hr = {
    isNormalUser = true;
    description = "hr";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "libvirtd"
      "qemu-libvirtd"
      "docker"
      "input"
    ];
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;
}
