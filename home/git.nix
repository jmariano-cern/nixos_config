{ ... }:

{
  programs.git = {
    enable = true;
    package = null;

    settings = {
      user = {
        name  = "Your Name";
        email = "you@example.com";
      };
      pull.rebase = true;
    };
    
  };
}
