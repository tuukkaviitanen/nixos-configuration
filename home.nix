{pkgs, ...}: {
  # Use global Nix package configurations (including unfree packages)
  home-manager.useGlobalPkgs = true;

  # NixOS programs
  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        r = "sudo nixos-rebuild switch";
        ru = "sudo nix flake update && sudo nixos-rebuild switch --upgrade";
        gc = "nix-collect-garbage --delete-old && sudo nix-collect-garbage --delete-old && sudo /run/current-system/bin/switch-to-configuration boot";
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
    extraGroups = ["networkmanager" "wheel" "docker"];
  };

  users.defaultUserShell = pkgs.zsh;

  home-manager = {
    # Backing up dotfiles automatically before replacing them,
    # as it otherwise needs to be done manually to avoid build errors
    backupFileExtension = "backup";
    users.tuukka = {pkgs, ...}: {
      home = {
        packages = with pkgs; [
          # Applications
          brave
          bitwarden-desktop
          discord
          fastfetch
          dconf-editor
          alejandra
          nixd

          # Gnome extensions
          gnomeExtensions.blur-my-shell
          gnomeExtensions.dash-to-panel
          gnomeExtensions.search-light
          gnomeExtensions.forge
          gnomeExtensions.system-monitor
          gnomeExtensions.workspace-indicator
          gnomeExtensions.arcmenu
        ];
        # The state version is required and should stay at the version you
        # originally installed.
        stateVersion = "24.11";
      };

      # Home Manager programs
      programs = {
        git = {
          enable = true;
          userName = "tuukkaviitanen";
          userEmail = "tuukka.viitanen@gmail.com";
        };
        vscode = {
          enable = true;
          mutableExtensionsDir = false;
          profiles.default = {
            enableUpdateCheck = false;
            extensions = with pkgs.vscode-extensions; [
              pkief.material-icon-theme
              rust-lang.rust-analyzer
              jnoortheen.nix-ide
              ms-azuretools.vscode-docker
              esbenp.prettier-vscode
              dbaeumer.vscode-eslint
              golang.go
              streetsidesoftware.code-spell-checker
              tamasfe.even-better-toml
              waderyan.gitblame
              mhutchie.git-graph
              prisma.prisma
              redhat.vscode-yaml
              humao.rest-client
              # vscodevim.vim # If I someday have energy to learn Vim
            ];
            userSettings = {
              workbench.iconTheme = "material-icon-theme";
              nix = {
                serverPath = "nixd";
                enableLanguageServer = true;
                serverSettings = {
                  nixd = {
                    formatting.command = ["alejandra"];
                    options.nixos.expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.nixos.options";
                  };
                };
              };
            };
          };
        };
        # If I want to switch to chromium
        # chromium = {
        #   enable = true;
        #   extensions = [
        #     "eokjikchkppnkdipbiggnmlkahcdkikp" # Color picker - geco
        #     "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
        #     "fmkadmapgofadopljbjfkapdkoienihi" # React dev tools
        #   ];
        # };
      };

      dconf.settings = {
        "org/gnome/desktop/wm/preferences".button-layout = ":minimize,maximize,close";
        "org/gnome/desktop/wm/keybindings".minimize = [];
        "org/gnome/desktop/interface".show-battery-percentage = true;
        "org/gnome/shell" = {
          # By default, disabled extensions overwrite enabled ones
          disable-user-extensions = false;
          disabled-extensions = [];
          # `gnome-extensions list` for a list
          enabled-extensions = [
            "blur-my-shell@aunetx"
            "dash-to-panel@jderose9.github.com"
            "search-light@icedman.github.com"
            "system-monitor@gnome-shell-extensions.gcampax.github.com"
            "forge@jmmaranan.com"
            "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
            "arcmenu@arcmenu.com"
          ];
        };
        "org/gnome/shell/extensions/dash-to-panel" = {
          trans-use-custom-opacity = true;
          trans-panel-opacity = 0.0;
          panel-element-positions = ''
            {"CMN-0x00000000":[{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]}
          '';
        };
        "org/gnome/shell/extensions/search-light" = {
          shortcut-search = ["<Alt>s"];
        };
        # Removes lock screen shortcut from <Super>l, as it conflicts with forge
        "org/gnome/settings-daemon/plugins/media-keys" = {
          screensaver = [];
        };
        "org/gnome/desktop/background" = {
          picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/amber-l.jxl";
          picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/amber-d.jxl";
          primary-color = "#ff7800";
          secondary-color = "#000000";
        };
        "org/gnome/shell/extensions/arcmenu" = {
          distro-icon = 22;
          menu-button-icon = "Distro_Icon";
          custom-menu-button-icon-size = 40.0;
          menu-button-fg-color = pkgs.lib.gvariant.mkTuple [
            true
            "rgb(53,132,228)"
          ];
        };
      };

      # https://nix-community.github.io/home-manager/options.xhtml#opt-gtk.enable
      gtk = {
        enable = true;
        cursorTheme = {
          # https://github.com/ful1e5/Bibata_Cursor
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
        };
      };
    };
  };
}
