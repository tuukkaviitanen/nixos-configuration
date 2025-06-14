{
  pkgs,
  inputs,
  ...
}: {
  home-manager.sharedModules = [inputs.plasma-manager.homeManagerModules.plasma-manager];

  services = {
    desktopManager.plasma6.enable = true;

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # kdePackages.discover # Optional: Install if you use Flatpak or fwupd firmware update sevice
    kdePackages.kcalc # Calculator
    kdePackages.kcharselect # Tool to select and copy special characters from all installed fonts
    kdePackages.kcolorchooser # A small utility to select a color
    kdePackages.kolourpaint # Easy-to-use paint program
    kdePackages.ksystemlog # KDE SystemLog Application
    kdePackages.sddm-kcm # Configuration module for SDDM
    kdiff3 # Compares and merges 2 or 3 files or directories
    # kdePackages.isoimagewriter # Optional: Program to write hybrid ISO files onto USB disks
    # kdePackages.partitionmanager # Optional Manage the disk devices, partitions and file systems on your computer
    hardinfo2 # System information and benchmarks for Linux systems
    haruna # Open source video player built with Qt/QML and libmpv
    wayland-utils # Wayland utilities
    wl-clipboard # Command-line copy/paste utilities for Wayland
  ];

  home-manager.users.tuukka = {
    programs = {
      plasma = {
        enable = true;
        workspace = {
          # Set the global Plasma theme to Breeze Dark
          lookAndFeel = "org.kde.breezedark.desktop";

          # Optionally, set a dark icon theme
          # You might need to install the icon theme package first, e.g., pkgs.papirus-icon-theme
          # iconTheme = "Papirus-Dark"; # Or "breeze-dark" or other dark icon themes
        };
      };
    };
  };
}
