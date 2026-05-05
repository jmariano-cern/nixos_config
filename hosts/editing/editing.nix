# hosts/editing/default.nix
#
# Editing/production machine — video editing packages + Nvidia drivers.
# Build with: sudo nixos-rebuild switch --flake .#editing
#
{ config, pkgs, lib, groups, ... }:

{
  networking.hostName = "editing";

  imports = [
    ../../modules/nvidia.nix   # Pull in Nvidia drivers for this host only
  ];

  environment.systemPackages =
    groups.sysTools
    ++ groups.editing
    ++ groups.desktopUtils
    # Add individual packages specific to this machine below:
    ++ (with pkgs; [
      # blender
    ]);

  # Large /tmp on tmpfs is useful for video scratch space
  boot.tmp = {
    useTmpfs   = true;
    tmpfsSize  = "16G";
  };
}
