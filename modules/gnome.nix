{
  pkgs,
  pkgs-unstable,
  globals,
  ...
}: {
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment = {
    gnome = {
      excludePackages = [pkgs.geary];
    };
  };

  home-manager = {
    users.${globals.username} = {
      home = {
        packages = with pkgs-unstable; [
          gnomeExtensions.blur-my-shell
          gnomeExtensions.dash-to-panel
          gnomeExtensions.search-light
          gnomeExtensions.forge
          gnomeExtensions.system-monitor
          gnomeExtensions.workspace-indicator
          # gnomeExtensions.arcmenu

          dconf-editor
        ];
      };

      dconf = {
        enable = true;
        settings = {
          "org/gnome/desktop/wm/preferences".button-layout = ":minimize,maximize,close";
          "org/gnome/desktop/wm/keybindings".minimize = [];
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
              # "arcmenu@arcmenu.com"
            ];
          };
          "org/gnome/shell/extensions/dash-to-panel" = {
            trans-use-custom-opacity = true;
            trans-panel-opacity = 0.0;
            panel-element-positions = ''
              {"CMN-0x00000000":[{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]}
            '';
          };
          "org/gnome/mutter" = {
            overlay-key = ""; # Disables the Activity view from opening with the Super-key
          };
          "org/gnome/shell/extensions/search-light" = {
            shortcut-search = ["Super_L"];
          };
          # Removes lock screen shortcut from <Super>l, as it conflicts with forge
          "org/gnome/settings-daemon/plugins/media-keys" = {
            screensaver = [];
          };
          "org/gnome/desktop/background" = let
            wallpaper = pkgs.fetchurl {
              url = "https://backiee.com/static/wallpapers/1920x1080/364837.jpg";
              hash = "sha256-vvyOrLh1LkJ0pgkjfdIPgYFDEvSA74pbAobmh7A0EA8=";
            };
          in {
            picture-uri = "file://${wallpaper}";
            picture-uri-dark = "file://${wallpaper}";
            primary-color = "#ff4268";
            secondary-color = "#000000";
          };
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            accent-color = "red";
            show-battery-percentage = true;
            font-name = "${globals.font} 11";
            document-font-name = "${globals.font} 11";
            monospace-font-name = "${globals.font} 11";
          };
          # Arc menu config with NixOs logo
          # "org/gnome/shell/extensions/arcmenu" = {
          #   distro-icon = 22;
          #   menu-button-icon = "Distro_Icon";
          #   custom-menu-button-icon-size = 40.0;
          #   menu-button-fg-color = pkgs.lib.gvariant.mkTuple [
          #     true
          #     "rgb(53,132,228)"
          #   ];
          # };
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
