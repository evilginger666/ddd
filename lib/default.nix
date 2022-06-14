{ inputs, ... }:
let
  inherit (builtins) mapAttrs attrValues;
  inherit (inputs.nixpkgs.lib) nixosSystem mapAttrs' nameValuePair;
in
{
  importAttrset = path: mapAttrs (_: import) (import path);

  mkSystem =
    { hostname
    , system ? "x86_64-linux"
    , overlays ? { }
    , persistence ? false
    }:
    nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs system hostname persistence;
        homeConfig = inputs.self.outputs.homeConfigurations."p0g@${hostname}".config or { };
      };
      modules = attrValues (import ../modules/nixos) ++ [
        ../nixos/hosts/${hostname}
        {
          networking.hostName = hostname;

          nixpkgs = {
            overlays = attrValues overlays;
            config.allowUnfree = true;
          };
          nix.registry = mapAttrs'
            (n: v:
              nameValuePair n { flake = v; })
            inputs;
        }
      ];
    };

  mkHome =
    { username
    , system ? "x86_64-linux"
    , overlays ? { }
    , persistence ? false
    , desktop ? null
    , colorscheme ? "nord"
    , wallpaper ? null
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit username system;
      extraSpecialArgs = {
        inherit system persistence desktop colorscheme wallpaper inputs;
      };
      homeDirectory = "/home/${username}";
      configuration = ../home-manager;
      extraModules = attrValues (import ../modules/home-manager) ++ [
        # Base configuration
        {
          nixpkgs = {
            overlays = attrValues overlays;
            config.allowUnfree = true;
          };
          programs = {
            home-manager.enable = true;
            git.enable = true;
          };
          systemd.user.startServices = "sd-switch";
        }
      ];
    };
}


