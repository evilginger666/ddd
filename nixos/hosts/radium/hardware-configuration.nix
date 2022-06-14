{
  imports = [
    ../../common/optional/btrfs-optin-persistence.nix
  ];

  boot = {
    blacklistedKernelModules = [ "nouveau" "nvidia" ];
    extraModprobeConfig = ''
      options iwlwifi power_save=1 disable_11ax=1
    '';

    initrd = {
      enable = true;
      systemd.enable = true;
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "intel_agp" "i915" "kvm-intel"];
    };
  };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/NXEFI";
      fsType = "vfat";
    };
}
