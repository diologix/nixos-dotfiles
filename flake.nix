{
  description = "NIXG + NIXP NixOS with Hyprland, TPM/LUKS/Lanzaboote, Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11"; # adjust as needed
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, lanzaboote, noctalia, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgsFor = system: import nixpkgs { inherit system; config.allowUnfree = true; };
  in {
    nixosConfigurations = {
      NIXG = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/common/base.nix
          ./hosts/common/users.nix
          ./hosts/common/desktop.nix
          ./hosts/common/virtualisation.nix
          ./hosts/common/lanzaboote.nix

          ./hosts/NIXG/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hr = import ./home/hr/home.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };

      NIXP = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/common/base.nix
          ./hosts/common/users.nix
          ./hosts/common/desktop.nix
          ./hosts/common/virtualisation.nix
          ./hosts/common/lanzaboote.nix

          ./hosts/NIXP/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hr = import ./home/hr/home.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
  };
}
