{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    impermanence.url = "github:RiscadoA/impermanence";
  };

  outputs = inputs:
    let
      my-lib = import ./lib { inherit inputs; };
      inherit (builtins) attrValues mapAttrs;
      inherit (my-lib) mkSystem mkHome importAttrset;
      inherit (inputs.nixpkgs.lib) genAttrs systems;
      forAllSystems = genAttrs systems.flakeExposed;
    in
    rec {
      overlays = {
        default = import ./overlay { inherit inputs; };
      };

      packages = forAllSystems (system:
        import inputs.nixpkgs { inherit system; overlays = attrValues overlays; }
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
          persistence = true;
        };
      };

      homeConfigurations = {
        "p0g@radium" = mkHome {
          username = "p0g";
          inherit overlays;
          desktop = "sway";
          persistence = true;

          colorscheme = "nord";
        };
      };
    };
}
