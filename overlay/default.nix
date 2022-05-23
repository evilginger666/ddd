{ inputs, ... }: final: prev:

let
  inherit (inputs.nix-colors.lib { pkgs = final; }) gtkThemeFromScheme;
  inherit (inputs.nix-colors) colorSchemes;
  inherit (builtins) mapAttrs;
  inherit (final) fetchFromGitHub;
in
{
  vimPlugins = prev.vimPlugins // {
    vim-numbertoggle = prev.vimPlugins.vim-numbertoggle.overrideAttrs
      (oldAttrs: rec {
        patches = (oldAttrs.patches or [ ])
        ++ [ ./vim-numbertoggle-command-mode.patch ];
      });
    # Enable language fencing
    vim-nix = prev.vimPlugins.vim-nix.overrideAttrs
      (_oldAttrs: rec {
        version = "2022-02-20";
        src = fetchFromGitHub {
          owner = "hqurve";
          repo = "vim-nix";
          rev = "26abd9cb976b5f4da6da02ee81449a959027b958";
          sha256 = "sha256-7TDW6Dgy/H7PRrIvTMpmXO5/3K5F1d4p3rLYon6h6OU=";
        };
      });
  } // import ../pkgs/vim-plugins { pkgs = final; };

  generated-gtk-themes = mapAttrs (_: scheme: gtkThemeFromScheme { inherit scheme; }) colorSchemes;
} // import ../pkgs { pkgs = final; }
