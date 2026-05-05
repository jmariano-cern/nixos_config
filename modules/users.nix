# modules/users.nix
{ config, pkgs, lib, ... }:

{
  users.users.youruser = {
    isNormalUser = true;
    createHome   = true;
    home         = "/home/youruser";
    description  = "Your Full Name";
    shell        = pkgs.bash;
    extraGroups  = [ "wheel" "networkmanager" "input" "colord" ];
    openssh.authorizedKeys.keys = [
      # "ssh-ed25519 AAAA... you@host"
    ];
  };

  users.users.begonia = {
    isNormalUser = true;
    home         = "/home/begonia";
    extraGroups  = [ "wheel" "networkmanager" "input" "colord" ];
  };
  
  security.sudo.wheelNeedsPassword = true;
}
