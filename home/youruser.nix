# home/youruser.nix

{ config, pkgs, lib, ... }:

{
  home = {
    username      = "youruser";
    homeDirectory = "/home/youruser";
    stateVersion  = "25.11";
    #packages = with pkgs; [ gh lazygit direnv ];
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      rm = "rm -i";
      #ll = "ls -alF";
      # ".." = "cd ..";
      # Usage: nixswitch work  (or editing, laptop, ...)
      # nixswitch = "f(){ sudo nixos-rebuild switch --flake ~/.config/nixos#\"$1\"; }; f";
    };
    #initExtra = ''eval "$(direnv hook bash)"'';
    bashrcExtra = ''
  export PATH=$PATH:~/bin
  export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.7z=01;31:*.ace=01;31:*.alz=01;31:*.apk=01;31:*.arc=01;31:*.arj=01;31:*.bz=01;31:*.bz2=01;31:*.cab=01;31:*.cpio=01;31:*.crate=01;31:*.deb=01;31:*.drpm=01;31:*.dwm=01;31:*.dz=01;31:*.ear=01;31:*.egg=01;31:*.esd=01;31:*.gz=01;31:*.jar=01;31:*.lha=01;31:*.lrz=01;31:*.lz=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.lzo=01;31:*.pyz=01;31:*.rar=01;31:*.rpm=01;31:*.rz=01;31:*.sar=01;31:*.swm=01;31:*.t7z=01;31:*.tar=01;31:*.taz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tgz=01;31:*.tlz=01;31:*.txz=01;31:*.tz=01;31:*.tzo=01;31:*.tzst=01;31:*.udeb=01;31:*.war=01;31:*.whl=01;31:*.wim=01;31:*.xz=01;31:*.z=01;31:*.zip=01;31:*.zoo=01;31:*.zst=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.jxl=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:ow=01;33:"        export PATH="$HOME/bin:$PATH"
    '';
  };

  programs.git = {
    enable    = true;
    settings = {
      user = {
        name  = "Your Name";
        email = "you@example.com";
      };
      pull.rebase = true;
    };
  };

  home.file."bin" = {
    source = ./bin;
    recursive = true;
  };
  
  home.file."wallpapers/tree.jpg" = {
    source = ./wallpapers/tree.jpg;
  };
  
  # home.file."upm_backup.tar.bz2" = {
  #   source = ./upm_backup.tar.bz2;
  # };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.magit
    ];
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

 programs.alacritty = {
    enable = true;
    settings.font.size = 12;
  };

 programs.firefox = {
   enable = true;
   
   policies = {
     # Updates & Background Services
     AppAutoUpdate                 = false;
     BackgroundAppUpdate           = false;
     
     # Feature Disabling
     #DisableBuiltinPDFViewer       = true;
     DisableFirefoxStudies         = true;
     DisableFirefoxAccounts        = true;
     DisableFirefoxScreenshots     = true;
     DisableForgetButton           = true;
     DisableMasterPasswordCreation = true;
     DisableProfileImport          = true;
     DisableProfileRefresh         = true;
     DisableSetDesktopBackground   = true;
     DisablePocket                 = true;
     DisableTelemetry              = true;
     DisableFormHistory            = true;
     DisablePasswordReveal         = true;

     # Access Restrictions
     BlockAboutConfig              = false;
     #BlockAboutProfiles            = true;
     #BlockAboutSupport             = true;

     # UI and Behavior
     DisplayMenuBar                = "never";
     DontCheckDefaultBrowser       = true;
     HardwareAcceleration          = true; # ?
     OfferToSaveLogins             = false;
     DefaultDownloadDirectory      = "\$\{home\}/Downloads";

     AutofillAddressEnabled        = false;
     AutofillCreditCardEnabled     = false;
     
     DisplayBookmarksToolbar       = false;
     
     EnableTrackingProtection =  {
       Value                   = true;
       Cryptomining            = true;
       Fingerprinting          = true;
       EmailTracking           = true;
       SuspectedFingerprinting = true;
       Category                = "standard";
       #Exceptions = ["https://example.com"],
       BaselineExceptions      = true;
       ConvenienceExceptions   = true;
     };

     FirefoxSuggest = {
       WebSuggestions       = false;
       SponsoredSuggestions = false;
       ImproveSuggest       = false;
     };

     Homepage = "none";
     HttpsOnlyMode = true;
     NewTabPage = false;
     PasswordManagerEnabled = false;
     PictureInPicture.enabled = true;
     SearchBar = "unified";
     SearchSuggestEnabled = false;
     ShowHomeButton = false;
     
     # Extensions
     ExtensionSettings = let
       moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
     in {
       "*".installation_mode = "blocked";
       
       "uBlock0@raymondhill.net" = {
         install_url       = moz "ublock-origin";
         installation_mode = "force_installed";
         updates_disabled  = true;
       };
       
       "sponsorBlocker@ajay.app" = {
         install_url       = moz "sponsorblock";
         installation_mode = "force_installed";
         updates_disabled  = true;
       };
       
       "Tab-Session-Manager@sienori" = {
         install_url       = moz "tab-session-manager";
         installation_mode = "force_installed";
         updates_disabled  = true;
       };
       
       "jid1-MnnxcxisBPnSXQ@jetpack" = {
         install_url       = moz "privacy-badger17";
         installation_mode = "force_installed";
         updates_disabled  = true;
       };

       "{74145f27-f039-47ce-a470-a662b129930a}" = {
         install_url       = moz "clearurls";
         installation_mode = "force_installed";
         updates_disabled  = true;
       };

       "gdpr@cavi.au.dk" = {
         install_url       = moz "consent-o-matic";
         installation_mode = "force_installed";
         updates_disabled  = true;
       };
       
       "jid1-BoFifL9Vbdl2zQ@jetpack" = {
         install_url       = moz "decentraleyes";
         installation_mode = "force_installed";
         updates_disabled  = true;
       };
       
       "{1018e4d6-728f-4b20-ad56-37578a4de76b}" = {
         install_url       = moz "flagfox";
         installation_mode = "force_installed";
         updates_disabled  = true;
       };
       
       "extension@one-tab.com" = {
         install_url       = moz "onetab";
         installation_mode = "force_installed";
         updates_disabled  = true;
       };       
     };
   };
     
   profiles = {
     alpha = {
       id = 0;
       isDefault = true;
       settings = {
         "browser.startup.homepage" = "https://cern.ch";
       };
     };
     beta = {
       id = 1;
       isDefault = false;
       settings = {
         "browser.startup.homepage" = "https://cern.ch";
       };
     };
     gamma = {
       id = 2;
       isDefault = false;
       settings = {
         "browser.startup.homepage" = "https://cern.ch";
       };
     };
     omega = {
       id = 3;
       isDefault = false;
       settings = {
         "browser.startup.homepage" = "https://cern.ch";
       };
     };
   };
 };

 home.activation.cloneNixosConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
   if [ ! -d $HOME/nixos_config ]; then
     ${pkgs.git}/bin/git clone https://github.com/jmariano-cern/nixos_config $HOME/nixos_config
   fi
 '';
 
 # programs.direnv = {
 #   enable            = true;
 #   nix-direnv.enable = true;
 # };

 # home.activation.cloneNixosConfig = {
 #   after = [ "writeBoundary" ];
 #   data = ''
 #    if [ ! -d $HOME/nixos_config ]; then
 #      ${pkgs.git}/bin/git clone https://github.com/yourusername/nixos-config $HOME/nixos_config
 #    fi
 #  '';
 # };

}
