{ config, lib, pkgs, inputs, ... }:

{
  # Wayland desktop basics
  programs.hyprland.enable = true; # sets portals etc. [web:18]

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  security.polkit.enable = true;

  # greetd: autologin hr into Hyprland (no DM). [web:17]
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "Hyprland";
        user = "hr";
      };
    };
  };

  # No display manager
  services.xserver.enable = false;

  # Laptop niceties
  services.upower.enable = true;
  services.acpid.enable = true;
  services.tlp.enable = true;
  services.power-profiles-daemon.enable = lib.mkForce false;

  # Nextcloud desktop + Syncthing
  environment.systemPackages = with pkgs; [
    nextcloud-client
    syncthing
    networkmanagerapplet
    blueman
    brightnessctl
    wl-clipboard
    grim slurp
    swaylock-effects
    pavucontrol
  ];

  # Syncthing as user service
  services.syncthing = {
    enable = true;
    user = "hr";
    dataDir = "/home/hr";   # default
    configDir = "/home/hr/.config/syncthing";
  };

  # Nextcloud tray + session persistence typically needs keyring. [web:13]
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
}
