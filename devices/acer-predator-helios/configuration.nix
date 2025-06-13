# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  # pkgs-unstable,
  globals,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/gaming.nix
    ../../modules/gnome.nix
  ];

  networking.hostName = "acer-predator-helios";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # boot.kernelPackages = pkgs.linuxPackages_zen;

  services.xserver.videoDrivers = [
    "modesetting" # Use with offload
    "nvidia"
  ];

  # Failed fixes for external screen being blank
  # boot.kernelParams = ["nvidia-drm.modeset=1"];
  # boot.kernelParams = ["i915.force_probe=46a6"];
  # boot.extraModprobeConfig = ''
  #   options bbswitch load_state=-1 unload_state=1 nvidia-drm
  # '';
  # boot.kernelParams = ["module_blacklist=nvidia_uvm"];
  # boot.extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
  # boot.initrd.kernelModules = ["nvidia" "nvidia-drm" "nvidia-modeset"];
  # boot = {
  #   initrd.kernelModules = ["nvidia" "i915" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
  #   # extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  #   kernelParams = ["nvidia-drm.fbdev=1"];
  # };
  # services.xserver.displayManager.gdm.wayland = false;

  # nixpkgs.config.nvidia.acceptLicense = true;

  hardware.nvidia = {
    # Newer drivers break the dedicated GPU
    # Older drivers don't recognize external monitors at all
    package = config.boot.kernelPackages.nvidiaPackages.legacy_535;
    open = false;
    modesetting.enable = true;
    prime = {
      # sync.enable = true;
      # Dedicated GPU requires OFFLOAD to work
      # nvidia-offload %command% needs to be set to steam games
      offload = {
        enable = true;
        # enableOffloadCmd = true; # Not needed as the env variables are always enabled
      };
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

  environment = {
    variables = {
      # Always enable nvidia offload
      __NV_PRIME_RENDER_OFFLOAD = 1;
      __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __VK_LAYER_NV_optimus = "NVIDIA_only";
    };
    systemPackages = with pkgs; [
      nvtopPackages.nvidia
      vulkan-tools
    ];
  };

  # These should stay as the NixOS version first installed on the system
  system.stateVersion = "25.05";
  home-manager.users.${globals.username}.home.stateVersion = "25.05";
}
