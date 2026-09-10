# modules/base.nix
# Settings and packages that apply to every machine.
{ config, pkgs, lib, groups, ... }:

{
  ################################
  ##
  ##  NIX
  ##
  ################################
  
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store   = true;
    };
    gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  ################################
  ##
  ##  GRAPHICS
  ##
  ################################

  hardware.graphics.enable = true;
  
  ################################
  ##
  ##  BLUETOOTH
  ##
  ################################
  
  hardware.bluetooth.enable = true;
  
  ################################
  ##
  ##  UDEV
  ##
  ################################
  
  # udev rules for spyder x color checker + uinput
  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="input", TAG+="uaccess"

    # for argyllcms

    # Skip all this to speed things up if it'a not a usb add.
    ACTION!="add", GOTO="argyll_rules_end"
    SUBSYSTEM!="usb", GOTO="argyll_rules_end"

    # Spyder X
    ATTRS{idVendor}=="085c", ATTRS{idProduct}=="0a00", ENV{COLORD_SENSOR_KIND}="spyderX" ENV{COLORD_SENSOR_CAPS}="lcd crt ambient"
    # Spyder X2
    ATTRS{idVendor}=="085c", ATTRS{idProduct}=="0a0a", ENV{COLORD_SENSOR_KIND}="spyderX2" ENV{COLORD_SENSOR_CAPS}="lcd crt ambient"

    # Is a color calibration device. 70-uaccess.rules may use this to set TAG+="uaccess",
    # but there is no way to know if this is the case from here.
    # May also be used by other rules to avoid claiming this device.
    ENV{COLORD_SENSOR_KIND}=="*?", ENV{COLOR_MEASUREMENT_DEVICE}="1"

    # Set ID_VENDOR and ID_MODEL acording to VID and PID
    # usb_id and/or usb-db might be needed on older systems
    ENV{COLORD_SENSOR_KIND}=="*?", ENV{ID_MODEL}=="", IMPORT{builtin}="usb_id"
    ENV{COLORD_SENSOR_KIND}=="*?", ENV{ID_MODEL_FROM_DATABASE}=="", IMPORT{builtin}="hwdb --subsystem=usb"

    # (Except that this stuffs up on Slackware 14.1 because
    #  ConsoleKit/database is present even when ACL is not enabled).
    # Some recent systems no longer use ConsoleKit or ACL_MANAGE - acl is done by systemd ?
    # TEST=="/var/run/ConsoleKit/database", ENV{COLOR_MEASUREMENT_DEVICE}=="*?", ENV{ACL_MANAGE}="1"
    ENV{COLOR_MEASUREMENT_DEVICE}=="*?", ENV{ACL_MANAGE}="1"

    # In any case, make color instruments accessible to members of the colord group,
    # which the user may have to add to the system and add themselves to if ACL isn't present.
    ENV{COLOR_MEASUREMENT_DEVICE}=="*?", MODE="660", GROUP="colord"

    LABEL="argyll_rules_end"
  '';

  ################################
  ##
  ##  BOOT
  ##
  ################################
  
  # uefi boot + systemd
  boot.loader = {
    systemd-boot.enable      = true;
    efi.canTouchEfiVariables = true;
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #                      webcam         xremap
  boot.kernelModules = [ "v4l2loopback" "uinput" ];
  # needed for webcam
  boot.extraModulePackages = [ pkgs.linuxPackages_latest.v4l2loopback ];
  
  # Hostname is set per-host in hosts/<name>/default.nix
  networking.networkmanager.enable = true;

  ################################
  ##
  ##  LOCALE 
  ##
  ################################
  
  time.timeZone     = "Europe/Zurich";   # Override per-host if needed
  i18n.defaultLocale = "en_US.UTF-8";
  
  ################################
  ##
  ##  TERMINAL
  ##
  ################################

  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty. # X11 only???
  };
  
  ################################
  ##
  ##  KEYBOARD
  ##
  ################################
  
  # for sudoless xremap
  hardware.uinput.enable = true;
  services.xserver.xkb.layout = "us"; # can be before xserver enable?
  services.xserver.xkb.options = "caps:return";

  ################################
  ##
  ##  FONTS
  ##
  ################################
  
  fonts.packages = with pkgs; [
    fira-code
  ];
  
  fonts.fontconfig = {
    defaultFonts.monospace = [ "fira-code" ];
  };
  
  ################################
  ##
  ##  AUDIO
  ##
  ################################

  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };
  
  ################################
  ##
  ##  GROUPS
  ##
  ################################

  users.groups.colord = {};
  
  ################################
  ##
  ##  GROUPS
  ##
  ################################

  programs.firefox = {
    #enable = true;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      #DisablePocket = true;
      SearchBar = "unified";

      Preferences = {
        # Privacy settings
        #"extensions.pocket.enabled" = lock-false;
        # "browser.newtabpage.pinned" = lock-empty-string;
        # "browser.topsites.contile.enabled" = lock-false;
        # "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        # "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        # "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
      };

      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
        #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        #   installation_mode = "force_installed";
        # };
        # "jid1-MnnxcxisBPnSXQ@jetpack" = {
        #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
        #   installation_mode = "force_installed";
        # };
        # "extension@tabliss.io" = {
        #   install_url = "https://addons.mozilla.org/firefox/downloads/file/3940751/tabliss-2.6.0.xpi";
        #   installation_mode = "force_installed";
        # };
      };
    };
  };

  ################################
  ##
  ##  WM
  ##
  ################################

  # display manager
  services.displayManager.ly.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # turn off screensave (x11 only)
  environment.extraInit = ''
    xset s off -dpms
  ''; 

  # dwm
  services.xserver.windowManager.dwm.enable = true;
  # use local dwm repo
  services.xserver.windowManager.dwm.package = pkgs.dwm.overrideAttrs {
    #src = /home/begonia/dwm;
    src = pkgs.fetchFromGitHub {
      owner = "jmariano-cern";
      repo  = "dwm";
      rev   = "fd83cd1d405c3735b1f3013d1455b978349cb26f";  # branch name, tag, or commit hash
      hash  = "sha256-F8lVvsUiiFH0SVaXu2WHl4uDQ09J5Pj90u1TP7MZPxo=";  # use nix flake prefetch github:<owner>/<repo>/<commit-hash>
    };
  };

  # # dwm
  # services.xserver.windowManager.dwl.enable = true;
  # # use local dwm repo
  # services.xserver.windowManager.dwl.package = pkgs.dwm.overrideAttrs {
  #   #src = /home/begonia/dwm;
  #   src = pkgs.fetchFromGitHub {
  #     owner = "jmariano-cern";
  #     repo  = "dwm";
  #     rev   = "fd83cd1d405c3735b1f3013d1455b978349cb26f";  # branch name, tag, or commit hash
  #     hash  = "sha256-F8lVvsUiiFH0SVaXu2WHl4uDQ09J5Pj90u1TP7MZPxo=";  # use nix flake prefetch github:<owner>/<repo>/<commit-hash>
  #   };
  # };

  # why ?
  # # ── Shared terminal emulator ──────────────────────────────────────────────
  # # Installed system-wide so it is available before home-manager activates.
  # environment.systemPackages = groups.base ++ (with pkgs; [
  #   alacritty     # shared terminal — change once to change everywhere
  # ]);

  # automatically use base pacakages for all systems
  environment.systemPackages = groups.base;
  
  # DO NOT CHANGE
  # system.stateVersion = "25.05";
}
