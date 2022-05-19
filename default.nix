{ pkgs }: {
  modules = import ./modules/nixos;
} 

  // (import ./pkgs { inherit pkgs; })

