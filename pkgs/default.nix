{ pkgs }: {
  preferredplayer = pkgs.callPackage ./preferredplayer { };
  pass-wofi = pkgs.callPackage ./pass-wofi { };
  shellcolord = pkgs.callPackage ./shellcolord { };
  swayfader = pkgs.callPackage ./swayfader { };
  wallpapers = pkgs.callPackage ./wallpapers { };
}

