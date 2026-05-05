# hosts/laptop/default.nix
#
# Personal laptop — games, no Nvidia, laptop power management.
# Build with: sudo nixos-rebuild switch --flake .#laptop
#
{ config, pkgs, lib, groups, ... }:

{
  networking.hostName = "laptop";

  environment.systemPackages =
    groups.sysTools
    ++ groups.games
    ++ groups.desktopUtils
    ++ groups.laptopUtils
    # Add individual packages specific to this machine below:
    ++ (with pkgs; [
      # spotify
    ]);

  # ── Laptop power management ──────────────────────────────────────────────
  services.tlp.enable        = true;
  services.thermald.enable   = true;  # Intel thermal daemon

  # Suspend on lid close
  services.logind.lidSwitch = "suspend";

  # No Nvidia — nvidia.nix is simply not imported here
}
