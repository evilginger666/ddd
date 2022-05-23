{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = inputs:
    let
      my-lib = import ./lib { inherit inputs; };
      inherit (builtins) attrValues;
      inherit (my-lib) mkHome mkSystem importAttrset;
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
      homeManagerModules = importAttrset ./modules/home-manager;

      nixosConfigurations = {
        radium = mkSystem {
          inherit overlays;
          hostname = "radium";
          system = "x86_64-linux";
          users = [ "p0g" ];
        };
      };

      homeConfigurations = {
        "p0g@radium" = mkHome {
          inherit overlays;
          username = "p0g";
          system = "x86_64-linux";
          hostname = "radium";

          graphical = true;
          colorscheme = "nord";
        };
      };
    };
}
