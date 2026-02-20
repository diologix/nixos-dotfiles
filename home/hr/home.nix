{ config, pkgs, inputs, ... }:

let
  noctaliaPkg = inputs.noctalia.packages.${pkgs.system}.default;
in
{
  home.username = "hr";
  home.homeDirectory = "/home/hr";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    firefox
    kitty
    nemo-with-extensions
    nextcloud-client
    syncthing
    grim slurp wl-clipboard
    (inputs.noctalia.packages.${pkgs.system}.default or inputs.noctalia.defaultPackage.${pkgs.system})
  ];

  programs.zsh.enable = true;
  programs.git.enable = true;

  # Neovim basic config
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      set number
      set relativenumber
      set mouse=a
      set tabstop=4 shiftwidth=4 expandtab
    '';
  };

  # Hyprland via HM (declarative settings). [web:23][web:26][web:27]
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        ",preferred,auto,auto"
      ];

      exec-once = [
        "nm-applet"
        "blueman-applet"
        "nextcloud"
        "syncthing serve --no-browser"
        "systemctl --user start noctalia-shell.service"
        "systemctl --user start noctalia-shell" 
      ];

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "GDK_BACKEND,wayland,x11"
        "QT_QPA_PLATFORM,wayland;xcb"
      ];

      "$terminal" = "kitty";
      "$mod" = "SUPER";

      bind = [
        "$mod, Return, exec, $terminal"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, E, exec, thunar"
        "$mod, F, togglefloating"
        "$mod, Space, exec, rofi -show drun"
      ];
    };
  };

  # Noctalia Shell via Home Manager. [web:30]

  # Enable user systemd for services (Noctalia, etc.).
  systemd.user.startServices = "sd-switch";
}
