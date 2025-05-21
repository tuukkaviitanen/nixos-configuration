{
  description = "NixOS System Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    ...
  } @ inputs: {
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
        inherit inputs;
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
