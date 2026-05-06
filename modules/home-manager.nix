# modules/home-manager.nix
{ config, lib, ... }:
{
  home-manager.useGlobalPkgs       = true;
  home-manager.useUserPackages     = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users = lib.genAttrs
    (builtins.filter (user: builtins.pathExists ../home/${user}.nix) config.myUsers)
    (user: {
      imports = [ ../home/${user}.nix ];
    });
}
