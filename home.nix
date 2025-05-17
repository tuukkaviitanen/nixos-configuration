{   inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ... }:

{

  # Use global Nix package configurations (including unfree packages)
  home-manager.useGlobalPkgs = true;

  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        r = "sudo nixos-rebuild switch";
        ru = "sudo nix-channel --update && sudo nixos-rebuild switch --upgrade";
      };
      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
	        "git"
          "docker"
        ];
      };
    };
    dconf.enable = true; # Enables dconf configuration in home.nix
    direnv.enable = true;
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tuukka = {
    isNormalUser = true;
    description = "Tuukka Viitanen";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  users.defaultUserShell = pkgs.zsh;

  home-manager.users.tuukka = { pkgs, ... }: {
    home = {
      packages = with pkgs; [
        fastfetch
      ];
      # The state version is required and should stay at the version you
      # originally installed.
      stateVersion = "24.11";
    };
  
    programs = {
      git = {
          enable = true;
          userName  = "tuukkaviitanen";
          userEmail = "tuukka.viitanen@gmail.com";
      };
    };

    dconf.settings."org/gnome/desktop/wm/preferences".button-layout = ":minimize,maximize,close";
  };
}
