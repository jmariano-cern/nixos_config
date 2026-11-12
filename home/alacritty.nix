{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;

    # Don't install Alacritty through Home Manager
    package = null;

    #theme = "autumn";
    
    settings = {
      general.import = [
        "${pkgs.alacritty-theme}/share/alacritty-theme/autumn.toml"
      ];
      
      window = {
        opacity = 0.95;
        padding = {
          x = 10;
          y = 10;
        };
      };

      font = {
        size = 8.0;

        normal = {
          family = "Fira Code";
          style = "Regular";
        };
        
        bold = {
          family = "Fira Code";
          style = "Bold";
        };
      };

      scrolling.history = 10000;
    };
  };
}
