# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  # pkgs,
  # pkgs-unstable,
  # inputs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/gaming.nix
  ];

  networking.hostName = "acer-predator-helios";

  services.xserver.videoDrivers = ["nvidia"];

  # Failed fixes for external screen being blank
  # boot.kernelParams = ["nvidia-drm.modeset=1"];
  # boot.kernelParams = ["i915.force_probe=46a6"];
  # boot.extraModprobeConfig = ''
  #   options bbswitch load_state=-1 unload_state=1 nvidia-drm
  # '';
  # boot.kernelParams = ["module_blacklist=i915"];
  # boot.extraModulePackages = [config.boot.kernelPackages.nvidia_x11];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    open = true;
    modesetting.enable = true;
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0"; # Integrated GPU
      nvidiaBusId = "PCI:1:0:0"; # Dedicated GPU
    };
    nvidiaSettings = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    # forceFullCompositionPipeline = true;
  };

  # These should stay as the NixOS version first installed on the system
  system.stateVersion = "25.05";
  home-manager.users.tuukka.home.stateVersion = "25.05";
}
