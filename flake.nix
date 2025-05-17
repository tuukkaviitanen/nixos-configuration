{
  description = "NixOS System Flake";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: {
    # nixos is the hostname
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      # The `specialArgs` parameter passes the
      # non-default nixpkgs instances to other nix modules
      specialArgs = {
        pkgs-unstable = import nixpkgs-unstable {
          # Refer to the `system` parameter from
          # the outer scope recursively
          inherit system;
          config.allowUnfree = true;
        };
      };
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
        ./home.nix
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}