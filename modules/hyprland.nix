# Work-in-progress Hyprland setup, not in use yet
{
  pkgs,
  globals,
  ...
}: let
  startUpScript = pkgs.pkgs.writeShellScriptBin "start" ''
    waybar &
    dunst
  '';
in {
  programs.hyprland = {
    enable = true;
    # xwayland = true;
  };

  # Set GDM as display manager (login screen)
  services.xserver.displayManager.gdm.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  environment = {
    systemPackages = with pkgs; [
      waybar # Task bar
      swww # Wallpaper
      dunst # Notifications
      libnotify # Notification dependency
      kitty # Terminal emulator
      rofi-wayland # App launcher
    ];
    variables = {NIXOS_OZONE_WL = "1";};
  };

  home-manager.users.${globals.username} = {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      settings = {
        exec-once = ''${startUpScript}/bin/start'';

        bindm = [
          # For starting rofi-wayland?
          "$mainMod, S, exec, rofi, -show drun -show-icons"
        ];

        # Example configs
        # decoration = {
        #   shadow_offset = "0 5";
        #   "col.shadow" = "rgba(00000099)";
        # };

        # "$mod" = "SUPER";

        # bindm = [
        #   # mouse movements
        #   "$mod, mouse:272, movewindow"
        #   "$mod, mouse:273, resizewindow"
        #   "$mod ALT, mouse:272, resizewindow"
        # ];
      };
    };
  };
}
