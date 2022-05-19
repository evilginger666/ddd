{ lib, pkgs, inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
  ];


  boot = {
    consoleLogLevel = 0;
    # Kernel
    initrd.verbose = false;
    kernelPackages = pkgs.linuxPackages;
    plymouth = {
      enable = true;
    };
    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelParams =
      [ "quiet" "udev.log_priority=3" "vt.global_cursor_default=0" ];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_CA.UTF-8";
    };
  };
  time.timeZone = lib.mkDefault "America/Toronto";

  networking.networkmanager.enable = true;

  nix = {
    settings = {
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
    };
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  powerManagement.powertop.enable = true;
  programs = {
    light.enable = true;
    fish = {
      enable = true;
      vendor = {
        completions.enable = true;
        config.enable = true;
        functions.enable = true;
      };
    };
  };


  services = {
    dbus.packages = [ pkgs.gcr ];
    geoclue2.enable = true;
    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "$SHELL -l";
          user = "p0g";
        };
        default_session = initial_session;
      };
    };
    logind = {
      lidSwitch = "suspend";
      lidSwitchExternalPower = "lock";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };


  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
    wlr.enable = true;
  };
}

