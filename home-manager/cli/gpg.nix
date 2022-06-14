{ pkgs, persistence, desktop, lib, ... }: {
  home.packages =
    if desktop != null
    then [ pkgs.pinentry-gnome ]
    else [ pkgs.pinentry-curses ];

  home.persistence = lib.mkIf persistence {
    "/persist/home/p0g".directories = [ ".gnupg" ];
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = if desktop != null then "gnome3" else "curses";
  };

  programs.gpg = {
    enable = true;
  };

}
