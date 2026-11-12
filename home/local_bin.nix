{ config, ... }:

{

  home.file."bin" = {
    source = ./bin;
    recursive = true;
  };

  home.activation.makeBinExecutable =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      chmod -R u+x "$HOME/bin"
    '';
  
}
