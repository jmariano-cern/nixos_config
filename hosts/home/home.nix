# hosts/editing/default.nix
#
# Editing/production machine — video editing packages + Nvidia drivers.
# Build with: sudo nixos-rebuild switch --flake .#editing
#
{ config, pkgs, lib, groups, ... }:

{
  networking.hostName = "home";

  imports = [
    ../../modules/nvidia.nix   # Pull in Nvidia drivers for this host only
  ];

  environment.systemPackages =
    groups.media
    ++ groups.web
    ++ groups.photo
    ++ groups.editing
    ++ groups.audio
    ++ groups.programming
    ++ groups.x11
    ++ groups.latex
    ++ groups.printing_3d
    ++ groups.modelling_3d
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
