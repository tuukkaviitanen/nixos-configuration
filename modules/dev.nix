# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  # pkgs-unstable,
  inputs,
  ...
}: {
  environment = {
    sessionVariables = {
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    };
  };

  virtualisation.docker.enable = true;

  users.users.tuukka = {
    extraGroups = ["docker"];
  };

  # NixOS programs
  programs.zsh.ohMyZsh.plugins = ["docker"];
}
