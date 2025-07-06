{
  description = "NixOS System Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    ...
  } @ inputs: let
    globals = {
      username = "tuukka";
      browser = "chromium";
      font = "DepartureMono Nerd Font";
    };
  in {
    nixosConfigurations = {
      thinkpad-t14s = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        # The `specialArgs` parameter passes the
        # non-default nixpkgs instances to other nix modules
        specialArgs = {
          pkgs-unstable = import nixpkgs-unstable {
            # Refer to the `system` parameter from
            # the outer scope recursively
            inherit system;
            # Allow unfree packages from the unstable channel
            config.allowUnfree = true;
          };
          inherit inputs;
          inherit globals;
        };
        modules = [
          {
            # Allow unfree packages from the default channel
            nixpkgs.config.allowUnfree = true;
          }
          ./devices/thinkpad-t14s/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
      acer-predator-helios = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        # The `specialArgs` parameter passes the
        # non-default nixpkgs instances to other nix modules
        specialArgs = {
          pkgs-unstable = import nixpkgs-unstable {
            # Refer to the `system` parameter from
            # the outer scope recursively
            inherit system;
            # Allow unfree packages from the unstable channel
            config.allowUnfree = true;
          };
          inherit inputs;
          inherit globals;
        };
        modules = [
          {
            # Allow unfree packages from the default channel
            nixpkgs.config.allowUnfree = true;
          }
          ./devices/acer-predator-helios/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}
