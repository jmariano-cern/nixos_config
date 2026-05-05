# hosts/editing/default.nix
#
# Editing/production machine — video editing packages + Nvidia drivers.
# Build with: sudo nixos-rebuild switch --flake .#editing
#
{ config, pkgs, lib, groups, ... }:

{
  networking.hostName = "laptop";

  environment.systemPackages =
    groups.x11
    ++ groups.web
    ++ groups.media
    ++ groups.colorcal
    # Add individual packages specific to this machine below:
    ++ (with pkgs; [
      # blender
    ]);

  # Large /tmp on tmpfs is useful for video scratch space
  # boot.tmp = {
  #   useTmpfs   = true;
  #   tmpfsSize  = "16G";
  # };

  # DO NOT CHANGE
  system.stateVersion = "25.05";
}
