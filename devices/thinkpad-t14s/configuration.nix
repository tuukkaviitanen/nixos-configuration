# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  # pkgs,
  # pkgs-unstable,
  # inputs,
  ...
}: {
  imports = [
      ./hardware-configuration.nix
      ../../modules/common.nix
      ../../modules/dev.nix
  ];

  # Bootloader.
  boot = {
    # Fix for speakers (but not mic)
    extraModprobeConfig = ''
      options snd-intel-dspcfg dsp_driver=1
    '';
  };

  networking.hostName = "thinkpad-t14s";

  # Device specific shell aliases
  programs.zsh.shellAliases = {
    r = "sudo nixos-rebuild switch --flake ~/System";
    ru = "sudo flake update --flake ~/System && sudo nixos-rebuild switch --flake ~/System --upgrade";
  };

  # This should stay as the NixOS version first installed
  system.stateVersion = "24.11";
}
