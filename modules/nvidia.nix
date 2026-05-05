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
    # Use the production driver. Switch to `hardware.nvidia.package =
    # config.boot.kernelPackages.nvidiaPackages.beta;` for beta drivers.
    modesetting.enable = true;
    #powerManagement.enable = false;   # Set true for laptops with Nvidia
    open = false;                     # Use proprietary kernel module
    nvidiaSettings = true;
  };

  hardware.graphics = {
    enable      = true; # already in base?
    enable32Bit = true;           # Required for Steam / 32-bit games
  };
}
