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
    ../../modules/gaming.nix
  ];

  networking.hostName = "acer-predator-helios";

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    prime = {
      sync.enable = true;

      # integrated
      intelBusId = "PCI:0:2:0";

      # dedicated
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # These should stay as the NixOS version first installed on the system
  system.stateVersion = "25.05";
  home-manager.users.tuukka.home.stateVersion = "25.05";
}
