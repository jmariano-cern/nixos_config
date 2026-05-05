# home/hosts/home.nix

{ config, pkgs, ... }:
{
  home.file.".xprofile" = {
    text = ''#!/run/current-system/sw/bin/bash

xrandr --output DP-2 --mode 3840x2160 --pos 0x0 --output HDMI-1 --mode 2560x1440 --pos 3840x0 --output HDMI-0 --mode 1920x1080 --rotate right --pos 6400x0
xwallpaper --output HDMI-0 --zoom ~/wallpapers/tree.jpg
xwallpaper --output HDMI-1 --zoom ~/wallpapers/tree.jpg
xwallpaper --output DP-2 --zoom wallpapers/tree.jpg
dispwin -d 1 ~/monitor_calibration/profile_HDMI-0.icc
dispwin -d 2 ~/monitor_calibration/profile_DP-2.icc
dispwin -d 3 ~/monitor_calibration/profile_HDMI-1.icc'';
  };
}
