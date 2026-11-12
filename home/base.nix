# home/youruser.nix

{ config, pkgs, lib, ... }:

{
  home = {
    # username      = "youruser";
    # homeDirectory = "/home/youruser";
    stateVersion  = "25.11";
    #packages = with pkgs; [ gh lazygit direnv ];
  };

  imports = [
    ./alacritty.nix
    ./bash.nix
    ./git.nix
    ./emacs.nix
    ./gpg-agent.nix
    ./firefox.nix
    ./local_bin.nix
  ];
  
  # home.file."wallpapers/tree.jpg" = {
  #   source = ./wallpapers/tree.jpg;
  # };
  
  # home.file."upm_backup.tar.bz2" = {
  #   source = ./upm_backup.tar.bz2;
  # };

 # home.activation.cloneNixosConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
 #   if [ ! -d $HOME/nixos_config ]; then
 #     ${pkgs.git}/bin/git clone https://github.com/jmariano-cern/nixos_config $HOME/nixos_config
 #   fi
 # '';
 
 # programs.direnv = {
 #   enable            = true;
 #   nix-direnv.enable = true;
 # };

}
