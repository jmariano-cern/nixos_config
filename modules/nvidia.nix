# modules/nvidia.nix
#
# Nvidia driver configuration.
# Import this in a host's default.nix to enable:
#
#   imports = [ ../../modules/nvidia.nix ];
#
{ config, pkgs, lib, ... }:

{
  # Load the proprietary Nvidia driver from the stable channel
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "595.99.02";
      sha256_64bit = "sha256-6HR3lYv3YwcFSTJL1a1slI66btIQ5EAFs+/4SUD24ew=";
      sha256_aarch64 = "sha256-CCqHZTN2KNOZ4yZp2rDcuRJp9pHfRw47k4m4dWnS/2w=";
      openSha256 = "sha256-T36x/jx8yQ8l3LFp1rZIrTfcSwbGy8YSAvXOUSptpb4=";
      settingsSha256 = "sha256-GYCcnxfKPrTCrsmd25sMyzfC5cqJQJx0c31haooyTYM=";
      persistencedSha256 = "sha256-VyKtF/HdHPQrHHK6opSO69M72LmnGZtauuchj9uuje8=";
    };

    # Use the production driver. Switch to `hardware.nvidia.package =
    # config.boot.kernelPackages.nvidiaPackages.beta;` for beta drivers.
    modesetting.enable = true;
    powerManagement.enable = true;   # Set true for laptops with Nvidia
    open = false;                     # Use proprietary kernel module
    nvidiaSettings = true;
  };

  hardware.graphics = {
    enable      = true; # already in base?
    enable32Bit = true;           # Required for Steam / 32-bit games
  };
}
