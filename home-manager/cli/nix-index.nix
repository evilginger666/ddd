{ lib, persistence, ... }: {
  programs.nix-index.enable = true;

  home.persistence = lib.mkIf persistence {
    "/persist/home/p0g".directories = [ ".cache/nix-index" ];
  };
}
