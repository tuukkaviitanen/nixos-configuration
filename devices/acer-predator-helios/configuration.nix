# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
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

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # boot.kernelPackages = pkgs.linuxPackages_zen;

  services.xserver.videoDrivers = [
    # "modesetting" # Use with offload
    "nvidia"
  ];

  # Failed fixes for external screen being blank
  # boot.kernelParams = ["nvidia-drm.modeset=1"];
  # boot.kernelParams = ["i915.force_probe=46a6"];
  # boot.extraModprobeConfig = ''
  #   options bbswitch load_state=-1 unload_state=1 nvidia-drm
  # '';
  # boot.kernelParams = ["module_blacklist=i915"];
  # boot.extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
  # boot.initrd.kernelModules = ["nvidia" "nvidia-drm" "nvidia-modeset"];
  # boot = {
  #   initrd.kernelModules = ["nvidia" "i915" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
  #   # extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  #   kernelParams = ["nvidia-drm.fbdev=1"];
  # };
  # services.xserver.displayManager.gdm.wayland = false;

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.legacy_535;
    open = false;
    modesetting.enable = true;
    prime = {
      sync.enable = true;
      # offload = {
      #   enable = true;
      #   enableOffloadCmd = true;
      # };
      intelBusId = "PCI:0:2:0"; # Integrated GPU
      nvidiaBusId = "PCI:1:0:0"; # Dedicated GPU
    };
    nvidiaSettings = true;
    powerManagement = {
      enable = false;
      finegrained = false;
    };

    # nvidiaPersistenced = true;

    # forceFullCompositionPipeline = true;
  };

  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
    vulkan-tools
  ];

  # These should stay as the NixOS version first installed on the system
  system.stateVersion = "25.05";
  home-manager.users.tuukka.home.stateVersion = "25.05";
}
