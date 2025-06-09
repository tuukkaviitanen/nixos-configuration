# Gaming specific configurations
# Additions to common.nix
{pkgs, ...}: {
  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      # localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    # Allows the usage of `gamemoderun %command%` and `gamescope %command%` in Steam games
    gamemode.enable = true;
  };

  # Installing Proton GE installation running the `protonup` command
  environment.systemPackages = with pkgs; [
    protonup
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
