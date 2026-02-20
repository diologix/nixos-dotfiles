{config,pkgs,lib,...}:

{

 imports=[./hardware-configuration.nix];

 nix.settings.experimental-features=["nix-command" "flakes"];

 nixpkgs.config.allowUnfree=true;

 networking.hostName="nixos-laptop";

 time.timeZone="Europe/Berlin";

 i18n.defaultLocale="en_US.UTF-8";

 boot.loader.systemd-boot.enable=lib.mkForce false;

 boot.loader.grub.enable=false;

 boot.loader.efi.canTouchEfiVariables=true;

 boot.initrd.systemd.enable=true;

 boot.initrd.luks.devices.cryptroot={
  device="/dev/disk/by-partlabel/luksroot";
 };

 fileSystems."/"={
  device="/dev/mapper/cryptroot";
  fsType="xfs";
 };

 networking.networkmanager.enable=true;

 users.users.hr={
  isNormalUser=true;

  extraGroups=[
   "wheel"
   "networkmanager"
   "libvirtd"
   "kvm"
   "audio"
   "video"
  ];

  shell=pkgs.bashInteractive;
 };

 services.greetd={
  enable=true;

  settings.default_session={
   user="hr";
   command="${pkgs.hyprland}/bin/Hyprland";
  };
 };

 programs.hyprland.enable=true;

 xdg.portal.enable=true;

 xdg.portal.extraPortals=[
  pkgs.xdg-desktop-portal-hyprland
 ];

 environment.sessionVariables={
  NIXOS_OZONE_WL="1";
 };

 services.pipewire={
  enable=true;
  alsa.enable=true;
  pulse.enable=true;
 };

 services.tlp.enable=true;

 services.power-profiles-daemon.enable=true;

 services.fwupd.enable=true;

 services.upower.enable=true;

 hardware.bluetooth.enable=true;

 services.blueman.enable=true;

 security.polkit.enable=true;

 virtualisation.libvirtd={
  enable=true;
  onBoot="start";

  qemu={
   package=pkgs.qemu_kvm;
   ovmf.enable=true;
   swtpm.enable=true;
   runAsRoot=false;
  };
 };

 services.spice-vdagentd.enable=true;

 networking.firewall.trustedInterfaces=["virbr0"];

 boot.kernelModules=[
  "kvm-intel"
 ];

 systemd.services.libvirt-default-network={
  wantedBy=["multi-user.target"];
  after=["libvirtd.service"];
  script=''
   ${pkgs.libvirt}/bin/virsh net-autostart default || true
   ${pkgs.libvirt}/bin/virsh net-start default || true
  '';
  serviceConfig.Type="oneshot";
 };

 services.syncthing={
  enable=true;
  user="hr";
  dataDir="/home/hr";
  configDir="/home/hr/.config/syncthing";
 };

 systemd.user.services.nextcloud-client={
  wantedBy=["graphical-session.target"];
  serviceConfig.ExecStart="${pkgs.nextcloud-client}/bin/nextcloud";
 };

 systemd.user.services.noctalia={
  wantedBy=["graphical-session.target"];
  serviceConfig.ExecStart="${pkgs.writeShellScript "run-noctalia" ''
   exec ${pkgs.callPackage (builtins.fetchGit {
    url="https://github.com/YOURUSER/noctalia.git";
   }) {}}/bin/noctalia
  ''}";
 };

 environment.systemPackages=with pkgs;[
  git vim wget curl
  foot thunar
  wl-clipboard grim slurp
  mako swaylock-effects
  brightnessctl powertop
  virt-manager virt-viewer spice spice-gtk
  swtpm dnsmasq bridge-utils
  nextcloud-client
 ];

 fonts.packages=with pkgs;[
  nerd-fonts.fira-code
 ];

 services.fstrim.enable=true;

 ####################################
 ## LANZABOOTE
 ####################################

 boot.lanzaboote={
  enable=true;
  pkiBundle="/etc/secureboot";
 };

 environment.systemPackages=[
  pkgs.sbctl
 ];

 system.stateVersion="25.11";

}
