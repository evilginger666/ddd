{ lib, pkgs, inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.dell-xps-15-9500
    ./hardware-configuration.nix
  ];

  boot = {
    consoleLogLevel = 0;

    initrd.verbose = false;
    
    kernelParams = [ "quiet" "udev.log_level=3" ];
    
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 5;
      };

      efi.canTouchEfiVariables = true;
    };
  };

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
      driSupport = true;
    };
    video.hidpi.enable = true;
  };

  system.stateVersion = "22.05";

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
      dates = "daily";
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
    dconf.enable = true;
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

