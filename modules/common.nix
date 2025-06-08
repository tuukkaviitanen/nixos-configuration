# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  ...
}: {
  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Don't wait for the network to come online during boot and save ~5 seconds
  # Enabling this would be necessary if network is needed during the boot process
  systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fi_FI.UTF-8";
    LC_IDENTIFICATION = "fi_FI.UTF-8";
    LC_MEASUREMENT = "fi_FI.UTF-8";
    LC_MONETARY = "fi_FI.UTF-8";
    LC_NAME = "fi_FI.UTF-8";
    LC_NUMERIC = "fi_FI.UTF-8";
    LC_PAPER = "fi_FI.UTF-8";
    LC_TELEPHONE = "fi_FI.UTF-8";
    LC_TIME = "fi_FI.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fi";
    variant = "winkeys";
  };

  # Configure console keymap
  console.keyMap = "fi";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    # package = pkgs-unstable.pipewire;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  environment = {
    gnome = {
      excludePackages = [pkgs.geary];
    };
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    # systemPackages = with pkgs; [
    # ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # NixOS programs
  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      # Common shell aliases
      shellAliases = {
        r = "sudo nixos-rebuild switch --flake ~/System";
        ru = "sudo nix flake update --flake ~/System && sudo nixos-rebuild switch --flake ~/System --upgrade";
        gc = "nix-collect-garbage --delete-old && sudo nix-collect-garbage --delete-old && sudo /run/current-system/bin/switch-to-configuration boot";
      };
      shellInit = "fastfetch\n";
      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
        ];
      };
    };
    dconf.enable = true; # Enables dconf configuration with home manager
    direnv.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tuukka = {
    isNormalUser = true;
    description = "Tuukka Viitanen";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };

  # Use global Nix package configurations (including unfree packages)
  home-manager.useGlobalPkgs = true;

  home-manager = {
    # Backing up dotfiles automatically before replacing them,
    # as it otherwise needs to be done manually to avoid build errors
    backupFileExtension = "backup";
    users.tuukka = {
      home = {
        packages = with pkgs; [
          # Applications
          bitwarden-desktop
          discord
          fastfetch
          dconf-editor
          alejandra # Nix formatter
          nixd # Nix language server

          # Gnome extensions
          gnomeExtensions.blur-my-shell
          gnomeExtensions.dash-to-panel
          gnomeExtensions.search-light
          gnomeExtensions.forge
          gnomeExtensions.system-monitor
          gnomeExtensions.workspace-indicator
          gnomeExtensions.arcmenu
        ];
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
              jnoortheen.nix-ide
              streetsidesoftware.code-spell-checker
            ];
            userSettings = {
              workbench.iconTheme = "material-icon-theme";
              editor.formatOnSave = true;
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
        chromium = {
          enable = true;
          package = pkgs.brave;
          extensions = [
            "eokjikchkppnkdipbiggnmlkahcdkikp" # Color picker - geco
            "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
          ];
        };
      };

      dconf.settings = {
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
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          show-battery-percentage = true;
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
