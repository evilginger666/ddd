{ pkgs, ... }: {
  users.users.p0g = {
    isNormalUser = true;
    shell = pkgs.fish;
    initialPassword= "changeme";
    extraGroups = [ "networkmanager" "audio" "wheel" "video"];
  };

  security.pam.services.swaylock = { };
}
