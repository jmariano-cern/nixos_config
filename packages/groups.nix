# packages/groups.nix
#
# Named package groups that host configs can reference.
#
# Each group is just a list of packages. Hosts compose their final package
# set by picking groups and optionally adding individual packages on top.
#
# Usage in a host config:
#
#   { pkgs, groups, ... }: {
#     environment.systemPackages = groups.base
#       ++ groups.programming
#       ++ [ pkgs.someExtraPackage ];
#   }
#
{ config, pkgs, lib, ... }:

# let localSt = pkgs.st.overrideAttrs (old: {
#       src = /home/begonia/st; # change this to something less hardcode-y
#     });
# in

let localTex = pkgs.texliveBasic.withPackages
    (ps: with ps;
      [
        cleveref
      ]
    );
in

{
  # Expose groups as a module argument so host configs can reference them
  # without needing an import path.
  _module.args.groups = {

    # ── Base ─────────────────────────────────────────────────────────────────
    # Installed on every machine (via base.nix, not host configs).
    base = with pkgs; [
      bash
      emacs-nox
      wget
      git
      gnupg
      pulsemixer
      bluetui
      qpwgraph
      pinentry-tty
      xremap
      parted
      nvtopPackages.nvidia
      usbutils
      psmisc # killall
      tree
      btop
      unzip
      zathura
      glow
      # others
      pciutils        # lspci
      lshw
      smartmontools   # disk health
      iotop
      nethogs         # per-process network usage
      ncdu            # disk usage explorer
      duf             # modern df
      freshfetch
    ];

    # ── Media ─────────────────────────────────────────────────────────────────
    # 
    media = with pkgs; [
      mpv
      v4l-utils
      gphoto2
      ffmpeg
      mediainfo
      imv
    ];
    
    # ── Web ─────────────────────────────────────────────────────────────────
    # 
    web = with pkgs; [
      firefox
      qutebrowser
      yt-dlp
      oath-toolkit
      krb5
    ];
    
    # ── Photo ─────────────────────────────────────────────────────────────────
    # 
    photo = with pkgs; [
      unstable.darktable
      geeqie
      rawtherapee
      gimp
      # digikam # VERY BROKEN
      # gthumb # very broken
    ];
    
    # ── Editing ─────────────────────────────────────────────────────────────────
    # 
    editing = with pkgs; [
      unstable.davinci-resolve
      # mkvtoolnix
      # kdePackages.kdenlive
      # obs-studio
    ];
    
    # ── Audio ─────────────────────────────────────────────────────────────────
    # 
    audio = with pkgs; [
      unstable.audacity
      # reaper
    ];
    
    # ── Programming ──────────────────────────────────────────────────────────
    programming = with pkgs; [
      python313
      gnumake
      gcc
      cmake
    ];

    # ── Games ────────────────────────────────────────────────────────────────
    games = with pkgs; [
      steam
      lutris
      # heroic              # Epic / GOG launcher
      # gamemode
      # mangohud            # in-game overlay
      # protonup-qt         # Proton version manager
      # discord
    ];

    # ── Laptop ───────────────────────────────────────────────────────────────
    laptop = with pkgs; [
      batmon
      #powertop
      #tlp                 # power management
      #acpi
      brightnessctl
    ];

    # ── x11 ───────────────────────────────────────────────────────────────
    x11 = with pkgs; [
      # localSt
      xwallpaper
      xsel
      redshift
      alacritty
      xsel
    ];
    
    # ── wayland ───────────────────────────────────────────────────────────────
    wayland = with pkgs; [
      localDwl
      alacritty
      # foot
      wlr-randr
      swaybg
      wl-clipboard
      gammastep
    ];
    
    # ── latex ───────────────────────────────────────────────────────────────
    latex = with pkgs; [
      localTex
    ];
    
    # ── 3d printing ───────────────────────────────────────────────────────────────
    printing_3d = with pkgs; [
      cura-appimage
    ];
    
    # ── 3d modelling ───────────────────────────────────────────────────────────────
    modelling_3d = with pkgs; [
      freecad
      blender
    ];
    
    # ── colorcal ───────────────────────────────────────────────────────────────
    colorcal = with pkgs; [
      argyllcms
      colord
    ];

    # ── physics ───────────────────────────────────────────────────────────────
    physics = with pkgs; [
      root
      python313Packages.qutip
    ];

  };
}
