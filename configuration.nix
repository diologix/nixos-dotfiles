{ config, pkgs, ... }:

{
 imports =
 [
   ./hardware-configuration.nix
 ];

 #################################################
 ## HOST
 #################################################
 networking.hostName = "nixos-laptop";
 time.timeZone = "Europe/Berlin";
 i18n.defaultLocale = "en_US.UTF-8";

 #################################################
 ## BOOT
 #################################################

 boot.loader.systemd-boot.enable = true;
 boot.loader.efi.canTouchEfiVariables = true;
 boot.initrd.systemd.enable = true;

 #################################################
 ## TPM LUKS UNLOCK
 #################################################

 boot.initrd.luks.devices."cryptroot" = {
   device = "/dev/disk/by-partlabel/luksroot";
   preLVM = true;
 };

 #################################################
 ## FILESYSTEM
 #################################################
 fileSystems."/" =
 {
   device = "/dev/mapper/cryptroot";
   fsType = "xfs";
 };

 #################################################
 ## NETWORK
 #################################################
 networking.networkmanager.enable = true;

 #################################################
 ## USER
 #################################################
 users.users.hr = {
   isNormalUser = true;
   extraGroups = [
     "wheel"
     "networkmanager"
     "audio"
     "video"
     "input"
     "wireshark"
     "kvm"
     "libvirt-qemu"
     "libvirt"
     "storage"
   ];
   shell = pkgs.noctalia;
 };

 security.sudo.wheelNeedsPassword = true;

 #################################################
 ## LAPTOP
 #################################################
 services.tlp.enable = true;
 services.power-profiles-daemon.enable = true;
 services.upower.enable = true;
 services.fwupd.enable = true;
 hardware.bluetooth.enable = true;
 services.blueman.enable = true;

 #################################################
 ## AUDIO
 #################################################
 services.pipewire = {
   enable = true;
   alsa.enable = true;
   pulse.enable = true;
 };

 #################################################
 ## HYPRLAND
 #################################################
 programs.hyprland.enable = true;
 services.xserver.enable = true;
 services.xserver.displayManager.startx.enable = true;

 #################################################
 ## AUTOLOGIN TTY1
 #################################################
 services.getty.autologinUser = "hr";
 services.getty.helpLine = "";
 services.getty.greetingLine = "";
 programs.bash.loginShellInit = ''
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
 exec Hyprland
fi
 '';

 #################################################
 ## SYNCTHING
 #################################################
 services.syncthing = {
   enable = true;
   user = "hr";
   dataDir = "/home/hr";
   configDir = "/home/hr/.config/syncthing";
 };

 #################################################
 ## AUTOSTART PROGRAMS
 #################################################

 environment.etc."xdg/autostart/nextcloud.desktop".text = ''
[Desktop Entry]
Type=Application
Exec=${pkgs.nextcloud-client}/bin/nextcloud
Name=Nextcloud
 '';

 environment.etc."xdg/autostart/noctalia.desktop".text = ''
[Desktop Entry]
Type=Application
Exec=${pkgs.noctalia}/bin/noctalia
Name=noctalia
 '';

 #################################################
 ## PORTALS
 #################################################
 xdg.portal = {
   enable = true;
   extraPortals =
     [ pkgs.xdg-desktop-portal-hyprland ];
 };

 #################################################
 ## PACKAGES
 #################################################

 environment.systemPackages = with pkgs; [
   git
   vim
   wget
   curl
   foot
   wl-clipboard
   grim
   slurp
   mako
   swaylock-effects
   brightnessctl
   powertop
   thunar
   nextcloud-client
   noctalia
 ];

 #################################################
 ## FONTS
 #################################################
 fonts.packages = with pkgs; [
   nerd-fonts.fira-code
 ];

 #################################################
 ## WAYLAND
 #################################################
 environment.sessionVariables = {
   NIXOS_OZONE_WL = "1";
 };

#################################################
## KVM / LIBVIRT
#################################################
virtualisation.libvirtd = {
  enable = true;
  qemu = {
    package = pkgs.qemu_kvm;
    runAsRoot = false;
    ovmf.enable = true;   # UEFI VM support
    swtpm.enable = true;  # TPM inside VMs
  };
};

 #################################################
 system.stateVersion = "24.11";
}
