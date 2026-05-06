# modules/users.nix
{ config, pkgs, lib, ... }:

{
  options.myUsers = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "Which users to enable on this host";
  };

  config = {
    users.users = lib.filterAttrs (n: _: builtins.elem n config.myUsers) {
      begonia = {
        isNormalUser = true;
        createHome   = true;
        home         = "/home/begonia";
        description  = "Your Full Name";
        shell        = pkgs.bash;
        extraGroups  = [ "wheel" "networkmanager" "input" "colord" ];
        openssh.authorizedKeys.keys = [
          # "ssh-ed25519 AAAA... you@host"
        ];
      };

      youruser = {
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

      testuser = {
        isNormalUser = true;
        createHome   = true;
        home         = "/home/testuser";
        description  = "Your Full Name";
        shell        = pkgs.bash;
        extraGroups  = [ "wheel" "networkmanager" "input" "colord" ];
        openssh.authorizedKeys.keys = [
          # "ssh-ed25519 AAAA... you@host"
        ];
      };
    };
    
    security.sudo.wheelNeedsPassword = true;
  };
}
