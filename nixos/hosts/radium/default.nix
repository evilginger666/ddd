{ pkgs, inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
    ../../common/global
    ../../common/optional/p0g-greetd.nix
    ../../common/optional/networkmanager.nix
    ../../common/optional/pipewire.nix
    ../../common/optional/quietboot.nix
    ../../common/optional/systemd-boot.nix
  ];


  environment = {
    homeBinInPath = true;
    localBinInPath = true;
    etc."nixos" = {
      target = "nixos";
      source = "/home/p0g/DDD";
    };
  };

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiIntel
        libvdpau-va-gl
        intel-media-driver
      ];
    };
  };

  powerManagement.powertop.enable = true;
  programs = {
    dconf.enable = true;
    light.enable = true;
  };

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      reflector = true;
      openFirewall = true;
    };
    dbus.packages = [ pkgs.gcr ];
    fail2ban.enable = true;
    fwupd.enable = true;
    fstrim.enable = true;
    logind = {
      lidSwitch = "suspend";
      lidSwitchExternalPower = "lock";
    };
    thermald = {
      enable = true;
    };
  };


  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
    wlr.enable = true;
  };
}
