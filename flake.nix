{
 description="Senior Laptop Lanzaboote";
 inputs={
  nixpkgs.url="github:NixOS/nixpkgs/nixos-24.11";

  lanzaboote.url="github:nix-community/lanzaboote";
  lanzaboote.inputs.nixpkgs.follows="nixpkgs";
 };

 outputs={self,nixpkgs,lanzaboote,...}:

 let
  system="x86_64-linux";
 in{

  nixosConfigurations.nixos-laptop=
   nixpkgs.lib.nixosSystem{
    inherit system;
    modules=[
     ./configuration.nix
     lanzaboote.nixosModules.lanzaboote
    ];

   };

 };
}
