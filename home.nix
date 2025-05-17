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
      shellInit = "fastfetch\n";
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
        # Applications
        brave
        bitwarden-desktop
        discord
        fastfetch
        dconf-editor

        # Gnome extensions
        gnomeExtensions.blur-my-shell
        gnomeExtensions.dash-to-panel  
        gnomeExtensions.search-light

        # VS Code
        (vscode-with-extensions.override {
          vscodeExtensions = with vscode-extensions; [
            bbenoist.nix
            pkief.material-icon-theme
            rust-lang.rust-analyzer
          ];
        })
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

    dconf.settings = {
      "org/gnome/desktop/wm/preferences".button-layout = ":minimize,maximize,close";
      "org/gnome/desktop/interface".show-battery-percentage = true;
      "org/gnome/shell" = {
        # By default, disabled extensions overwrite enabled ones
        disabled-extensions = [];
        # `gnome-extensions list` for a list
        enabled-extensions = [
          "blur-my-shell@aunetx"
          "dash-to-panel@jderose9.github.com"
          "search-light@icedman.github.com"
          "system-monitor@gnome-shell-extensions.gcampax.github.com"
        ];
      };
      "org/gnome/shell/extensions/dash-to-panel" = {
        trans-use-custom-opacity = true;
        trans-panel-opacity = 0.0;
      };
      "org/gnome/shell/extensions/search-light" = {
        shortcut-search = ["<Alt>s"];
      };
    };
  };
}
