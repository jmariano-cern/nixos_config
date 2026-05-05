# hosts/work/default.nix
#
# Work machine — programming packages, no Nvidia.
# Build with: sudo nixos-rebuild switch --flake .#work
#
{ config, pkgs, lib, groups, ... }:

{
  networking.hostName = "work";

  environment.systemPackages =
    groups.sysTools
    ++ groups.programming
    ++ groups.desktopUtils
    # Add individual packages specific to this machine below:
    ++ (with pkgs; [
      # slack
      # zoom-us
    ]);

  # Docker daemon — useful on a dev machine
  virtualisation.docker.enable = true;

  # No Nvidia — nvidia.nix is simply not imported here
}
