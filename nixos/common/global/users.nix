{ pkgs, config, lib, homeConfig, ... }:
let
  inherit (lib) mkIf mkDefault;
  hasSway = homeConfig.wayland.windowManager.sway.enable or false;
  hasGammastepGeoclue =
    (homeConfig.services.gammastep.enable or false) &&
    (homeConfig.services.gammastep.provider == "geoclue2");
in
{
  users.mutableUsers = false;
  users.users.p0g = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ]
    ++ (if config.hardware.i2c.enable then [ "i2c" ] else [ ]);

    password = "changeme";
  };

  services.geoclue2.enable = mkDefault hasGammastepGeoclue;
  security.pam.services.swaylock = mkIf hasSway { };
}
