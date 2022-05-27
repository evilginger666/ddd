{ modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

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
