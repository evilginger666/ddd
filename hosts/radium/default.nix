{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    blacklistedKernelModules = lib.mkDefault [ "nouveau" "nvidia" ];
    consoleLogLevel = 0;

    extraModprobeConfig = ''
      options iwlwifi power_save=1 disable_11ax=1
    '';

    initrd = {
      enable = true;
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "intel_agp" "i915" ];
      systemd.enable = true;
      verbose = false;
    };

    kernelModules = [ "kvm-intel" ];

    # Kernel
    kernelPackages = pkgs.linuxPackages;

    kernelParams = [ "quiet" "rd.udev.log_level=3" "acpi_rev_override=1" "fbcon=nodefer" "mem_sleep_default=deep"];

    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };

    plymouth = {
      enable = true;
      theme = "jijicat";
      themePackages = [ pkgs.kitty-plymouth ];
    };
  };

  environment = {
    homeBinInPath = true;
    localBinInPath = true;
    etc."nixos" = {
      target = "nixos";
      source = "/home/p0g/DDD";
    };
    variables = {
      VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
    };
  };

  hardware = {
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiIntel
        libvdpau-va-gl
        intel-media-driver
      ];
    };
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_CA.UTF-8";
    };
  };

  networking.networkmanager.enable = true;

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';
    gc = {
      automatic = true;
      dates = "daily";
    };
    settings = {
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
    };
  };

  powerManagement.powertop.enable = true;
  programs = {
    dconf.enable = true;
    fish = {
      enable = true;
      vendor = {
        completions.enable = true;
        config.enable = true;
        functions.enable = true;
      };
    };
    light.enable = true;
  };

  security.rtkit.enable = true;
  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      reflector = true;
      openFirewall = true;
    };
    fail2ban.enable = true;
    fwupd.enable = true;
    geoclue2 = {
      enable = true;
    };
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
    fstrim.enable = true;
    logind = {
      lidSwitch = "suspend";
      lidSwitchExternalPower = "lock";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    thermald = {
      enable = true;
    };
  };

  system.stateVersion = "22.05";

  time.timeZone = lib.mkDefault "America/Toronto";

  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
    wlr.enable = true;
  };
}
