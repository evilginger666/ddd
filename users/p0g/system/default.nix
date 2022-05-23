{ pkgs, ... }: {
  users.users.p0g = {
    isNormalUser = true;
    shell = pkgs.fish;
    initialPassword= "changeme";
    extraGroups = [ "networkmanager" "audio" "wheel" ];
  };

  security.pam.services.swaylock = { };
}
