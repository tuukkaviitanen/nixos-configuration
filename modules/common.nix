# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  globals,
  ...
}: {
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
  # Required for Proton VPN to work
  networking.firewall.checkReversePath = false;

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fi";
    variant = "winkeys";
  };

  # Configure console keymap
  console.keyMap = "fi";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  fonts.packages = [pkgs.nerd-fonts.departure-mono];

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
    # jack.enable = true;
    # package = pkgs-unstable.pipewire;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  environment = {
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
      shellInit = "
      export SSH_AUTH_SOCK=/home/${globals.username}/.bitwarden-ssh-agent.sock
      fastfetch
      ";
      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
        ];
      };
    };
    direnv.enable = true;
  };

  users.users.${globals.username} = {
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
    users.${globals.username} = {
      home = {
        packages = with pkgs; [
          # Applications
          bitwarden-desktop
          discord
          fastfetch
          alejandra # Nix formatter
          nixd # Nix language server
          protonmail-desktop
          protonvpn-gui
          zip
          unzip
        ];
      };

      # Home Manager programs
      programs = {
        git = {
          enable = true;
          userName = "tuukkaviitanen";
          userEmail = "tuukka.viitanen@gmail.com";
          signing = {
            format = "ssh";
            signByDefault = true;
            key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKcUj2ZvUr6h9rB9/1kruE2o7qlEhDlFHnMqZ0y3tgEl";
          };
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
              editor = {
                formatOnSave = true;
                fontFamily = globals.font;
              };
              "[javascript]" = {
                editor.defaultFormatter = "esbenp.prettier-vscode";
              };
              "[typescript]" = {
                editor.defaultFormatter = "esbenp.prettier-vscode";
              };
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
          package = pkgs.${globals.browser};
          extensions = [
            "eokjikchkppnkdipbiggnmlkahcdkikp" # Color picker - geco
            "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
          ];
        };
      };

      # Progressive Web Apps (PWAs)
      xdg.desktopEntries = {
        youtube-music = {
          name = "Youtube Music";
          exec = "${globals.browser-executable} --app=https://music.youtube.com";
          settings = {
            StartupWMClass = "music.youtube.com";
          };
          icon = pkgs.fetchurl {
            url = "https://music.youtube.com/img/favicon_144.png";
            hash = "sha256-EeHjawpnPC0RgpdCUJRpeVk8inVqRIUdD0UpcowaRwk=";
          };
        };
        whatsapp = {
          name = "Whatsapp";
          exec = "${globals.browser-executable} --app=https://web.whatsapp.com";
          settings = {
            StartupWMClass = "web.whatsapp.com";
          };
          icon = pkgs.fetchurl {
            url = "https://static.whatsapp.net/rsrc.php/v4/yP/r/rYZqPCBaG70.png";
            hash = "sha256-OJlYGrz+2bQLcgi7vKi9v+OullWYDb9V8E3snLMwnyc=";
          };
        };
      };
    };
  };
}
