{ modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/NXROOT";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/NXEFI";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-label/NXSWAP"; }
    ];
}
