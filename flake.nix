{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs:
    let
      my-lib = import ./lib { inherit inputs; };
      inherit (builtins) attrValues;
      inherit (my-lib) mkSystem importAttrset;
      inherit (inputs.nixpkgs.lib) genAttrs systems;
      forAllSystems = genAttrs systems.supported.hydra;
    in
    rec {
      overlays = {
        default = import ./overlay { inherit inputs; };
      };

      packages = forAllSystems (system:
        let
          pkgs = import inputs.nixpkgs { inherit system; overlays = attrValues overlays; };
        in
        builtins.removeAttrs pkgs [ "system" ]
      );

      devShells = forAllSystems (system: {
        default = import ./shell.nix { pkgs = packages.${system}; };
      });

      nixosModules = importAttrset ./modules/nixos;
      
      nixosConfigurations = {
        radium = mkSystem {
          inherit overlays;
          hostname = "radium";
          system = "x86_64-linux";
          users = [ "p0g" ];
        };
      };
    };
}
